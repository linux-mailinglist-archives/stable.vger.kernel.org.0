Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698F062149
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbfGHPO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:14:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbfGHPO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:14:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6865D214C6;
        Mon,  8 Jul 2019 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598895;
        bh=wCVyoJVrCGjaHqF9vGVuonpAoeKlGm1R0XOa321y7M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5BqSmL3B1oC1+lCjpQyqSWl/XJwP1BuSVgYOdsGt8rIaIxBeKVdQEyOOCjAiV+aR
         nr9d1Q0Ekgx3Udb68lN2iXQIhn/QE9rd8Bm/ulWYMtTI/UTvP4DeZ8R+VrchPVLFw3
         5llbtu+WbMWR4XjOXLb10cfB1tYJ4aXXL8WfQpYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 01/73] fs/binfmt_flat.c: make load_flat_shared_library() work
Date:   Mon,  8 Jul 2019 17:12:11 +0200
Message-Id: <20190708150516.969813037@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 867bfa4a5fcee66f2b25639acae718e8b28b25a5 upstream.

load_flat_shared_library() is broken: It only calls load_flat_file() if
prepare_binprm() returns zero, but prepare_binprm() returns the number of
bytes read - so this only happens if the file is empty.

Instead, call into load_flat_file() if the number of bytes read is
non-negative. (Even if the number of bytes is zero - in that case,
load_flat_file() will see nullbytes and return a nice -ENOEXEC.)

In addition, remove the code related to bprm creds and stop using
prepare_binprm() - this code is loading a library, not a main executable,
and it only actually uses the members "buf", "file" and "filename" of the
linux_binprm struct. Instead, call kernel_read() directly.

Link: http://lkml.kernel.org/r/20190524201817.16509-1-jannh@google.com
Fixes: 287980e49ffc ("remove lots of IS_ERR_VALUE abuses")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/binfmt_flat.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -808,9 +808,14 @@ err:
 
 static int load_flat_shared_library(int id, struct lib_info *libs)
 {
+	/*
+	 * This is a fake bprm struct; only the members "buf", "file" and
+	 * "filename" are actually used.
+	 */
 	struct linux_binprm bprm;
 	int res;
 	char buf[16];
+	loff_t pos = 0;
 
 	memset(&bprm, 0, sizeof(bprm));
 
@@ -824,25 +829,10 @@ static int load_flat_shared_library(int
 	if (IS_ERR(bprm.file))
 		return res;
 
-	bprm.cred = prepare_exec_creds();
-	res = -ENOMEM;
-	if (!bprm.cred)
-		goto out;
-
-	/* We don't really care about recalculating credentials at this point
-	 * as we're past the point of no return and are dealing with shared
-	 * libraries.
-	 */
-	bprm.cred_prepared = 1;
-
-	res = prepare_binprm(&bprm);
-
-	if (!IS_ERR_VALUE(res))
+	res = kernel_read(bprm.file, pos, bprm.buf, BINPRM_BUF_SIZE);
+	if (res >= 0)
 		res = load_flat_file(&bprm, libs, id, NULL);
 
-	abort_creds(bprm.cred);
-
-out:
 	allow_write_access(bprm.file);
 	fput(bprm.file);
 


