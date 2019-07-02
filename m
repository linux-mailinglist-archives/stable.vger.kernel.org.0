Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B609F5CAA9
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfGBIG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbfGBIGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01AD021848;
        Tue,  2 Jul 2019 08:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054784;
        bh=Egxd7GBmipUcSfGsZsrwiyABLjDIQUu5RtV2kIjuesA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGAXu3921YcYsK0YwqWhl/olphYHcgRr8rInpw1knzs70PFZXpSFFnjsT2hJnJx6O
         /xKXuKBa5/NXIOIhUR7HSVBELQd7eIlgjGMml/WupDpK4BsBtFUnXMWKKm9aaEZbiA
         n+kkIZmLp3U1ArJMVEoeR4onyZqbofulWczPdXvw=
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
Subject: [PATCH 4.19 34/72] fs/binfmt_flat.c: make load_flat_shared_library() work
Date:   Tue,  2 Jul 2019 10:01:35 +0200
Message-Id: <20190702080126.419217249@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
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
 fs/binfmt_flat.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -856,9 +856,14 @@ err:
 
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
 
@@ -872,25 +877,11 @@ static int load_flat_shared_library(int
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
-	bprm.called_set_creds = 1;
-
-	res = prepare_binprm(&bprm);
+	res = kernel_read(bprm.file, bprm.buf, BINPRM_BUF_SIZE, &pos);
 
-	if (!res)
+	if (res >= 0)
 		res = load_flat_file(&bprm, libs, id, NULL);
 
-	abort_creds(bprm.cred);
-
-out:
 	allow_write_access(bprm.file);
 	fput(bprm.file);
 


