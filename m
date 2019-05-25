Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5402A720
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 23:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfEYVnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 17:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbfEYVnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 17:43:16 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1976A20856;
        Sat, 25 May 2019 21:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558820595;
        bh=ZMezQ1LU1w7Q98XJnBelSToQ2Ab95XvMeM9H5S6qDZY=;
        h=Date:From:To:Subject:From;
        b=eGgCLIJnM5A+assQzeh+pox50Qot6xOAwzLXhBQ2bDkHjK+tEMupAVAyt4JCKPB0n
         gKFqYL4RBA90hG6gy2zcPNsjEZ/n3SFjzL4qdYnJFEGF604AyNZy9+R6xTiWx8NWAW
         pgvtaz+F3T9iJgaAPFKA/6qFuWONyW5GsZt01UAk=
Date:   Sat, 25 May 2019 14:43:14 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, geert@linux-m68k.org, jannh@google.com,
        keescook@chromium.org, linux@armlinux.org.uk,
        mm-commits@vger.kernel.org, nicolas.pitre@linaro.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  + binfmt_flat-make-load_flat_shared_library-work.patch
 added to -mm tree
Message-ID: <20190525214314.U95hphCxp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: fs/binfmt_flat.c: make load_flat_shared_library() work
has been added to the -mm tree.  Its filename is
     binfmt_flat-make-load_flat_shared_library-work.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/binfmt_flat-make-load_flat_shared_library-work.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_flat-make-load_flat_shared_library-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: fs/binfmt_flat.c: make load_flat_shared_library() work

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/fs/binfmt_flat.c~binfmt_flat-make-load_flat_shared_library-work
+++ a/fs/binfmt_flat.c
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
 
_

Patches currently in -mm which might be from jannh@google.com are

binfmt_flat-make-load_flat_shared_library-work.patch

