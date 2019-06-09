Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4433A796
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbfFIQvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731867AbfFIQvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:51:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E3C205ED;
        Sun,  9 Jun 2019 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099069;
        bh=lCNu8BKryD8vOBp4qR99NS0l/tYhJ1ueCg69ARnyyCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCPGvOVuXc36JWFGKKCphXtx5L/CdgWKcTvRqtShzeYGhyAG93wGnt8suiHEXeM86
         ueQGNEa85ktSpwcyOkjxsILClLBPNz//oxw8J3tT4E9Kcx3QBdFA0qxxsB+6Z1RQPN
         OddYdI9IfSo1z4ppKchJoXQ1YNEJuxmNCYTDauwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Yaro Slav <yaro330@gmail.com>
Subject: [PATCH 4.14 18/35] pstore/ram: Run without kernel crash dump region
Date:   Sun,  9 Jun 2019 18:42:24 +0200
Message-Id: <20190609164126.562533917@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 8880fa32c557600f5f624084152668ed3c2ea51e upstream.

The ram pstore backend has always had the crash dumper frontend enabled
unconditionally. However, it was possible to effectively disable it
by setting a record_size=0. All the machinery would run (storing dumps
to the temporary crash buffer), but 0 bytes would ultimately get stored
due to there being no przs allocated for dumps. Commit 89d328f637b9
("pstore/ram: Correctly calculate usable PRZ bytes"), however, assumed
that there would always be at least one allocated dprz for calculating
the size of the temporary crash buffer. This was, of course, not the
case when record_size=0, and would lead to a NULL deref trying to find
the dprz buffer size:

BUG: unable to handle kernel NULL pointer dereference at (null)
...
IP: ramoops_probe+0x285/0x37e (fs/pstore/ram.c:808)

        cxt->pstore.bufsize = cxt->dprzs[0]->buffer_size;

Instead, we need to only enable the frontends based on the success of the
prz initialization and only take the needed actions when those zones are
available. (This also fixes a possible error in detecting if the ftrace
frontend should be enabled.)

Reported-and-tested-by: Yaro Slav <yaro330@gmail.com>
Fixes: 89d328f637b9 ("pstore/ram: Correctly calculate usable PRZ bytes")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/platform.c |    3 ++-
 fs/pstore/ram.c      |   36 +++++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 14 deletions(-)

--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -702,7 +702,8 @@ int pstore_register(struct pstore_info *
 		return -EINVAL;
 	}
 
-	allocate_buf_for_compression();
+	if (psi->flags & PSTORE_FLAGS_DMESG)
+		allocate_buf_for_compression();
 
 	if (pstore_is_mounted())
 		pstore_get_records(0);
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -801,26 +801,36 @@ static int ramoops_probe(struct platform
 
 	cxt->pstore.data = cxt;
 	/*
-	 * Since bufsize is only used for dmesg crash dumps, it
-	 * must match the size of the dprz record (after PRZ header
-	 * and ECC bytes have been accounted for).
+	 * Prepare frontend flags based on which areas are initialized.
+	 * For ramoops_init_przs() cases, the "max count" variable tells
+	 * if there are regions present. For ramoops_init_prz() cases,
+	 * the single region size is how to check.
 	 */
-	cxt->pstore.bufsize = cxt->dprzs[0]->buffer_size;
-	cxt->pstore.buf = kzalloc(cxt->pstore.bufsize, GFP_KERNEL);
-	if (!cxt->pstore.buf) {
-		pr_err("cannot allocate pstore crash dump buffer\n");
-		err = -ENOMEM;
-		goto fail_clear;
-	}
-
-	cxt->pstore.flags = PSTORE_FLAGS_DMESG;
+	cxt->pstore.flags = 0;
+	if (cxt->max_dump_cnt)
+		cxt->pstore.flags |= PSTORE_FLAGS_DMESG;
 	if (cxt->console_size)
 		cxt->pstore.flags |= PSTORE_FLAGS_CONSOLE;
-	if (cxt->ftrace_size)
+	if (cxt->max_ftrace_cnt)
 		cxt->pstore.flags |= PSTORE_FLAGS_FTRACE;
 	if (cxt->pmsg_size)
 		cxt->pstore.flags |= PSTORE_FLAGS_PMSG;
 
+	/*
+	 * Since bufsize is only used for dmesg crash dumps, it
+	 * must match the size of the dprz record (after PRZ header
+	 * and ECC bytes have been accounted for).
+	 */
+	if (cxt->pstore.flags & PSTORE_FLAGS_DMESG) {
+		cxt->pstore.bufsize = cxt->dprzs[0]->buffer_size;
+		cxt->pstore.buf = kzalloc(cxt->pstore.bufsize, GFP_KERNEL);
+		if (!cxt->pstore.buf) {
+			pr_err("cannot allocate pstore crash dump buffer\n");
+			err = -ENOMEM;
+			goto fail_clear;
+		}
+	}
+
 	err = pstore_register(&cxt->pstore);
 	if (err) {
 		pr_err("registering with pstore failed\n");


