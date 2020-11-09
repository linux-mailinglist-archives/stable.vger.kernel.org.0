Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E19C2ABCC9
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbgKINjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730353AbgKINCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:02:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB28E20684;
        Mon,  9 Nov 2020 13:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926959;
        bh=4wtCFZ77tCguYW9Fce8f1taCn22d1ZNwbf2hVTgyuxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXdMLDYSnzGCedhx2QRExtI81889h1ZS0mWo90pwt69i7dfX9DeO8D93SKD7dU/wU
         2F3pE37G9r2ArD7lG2zzA04878rDtTsSnMeTcqhlEXq5SJp6atce2w2rDMnXuPKuCC
         Ha1xWUVKD9e1/sxdzElJC071fqn2FXJ0muUp98zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.9 063/117] vt: keyboard, simplify vt_kdgkbsent
Date:   Mon,  9 Nov 2020 13:54:49 +0100
Message-Id: <20201109125028.656979062@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 6ca03f90527e499dd5e32d6522909e2ad390896b upstream.

Use 'strlen' of the string, add one for NUL terminator and simply do
'copy_to_user' instead of the explicit 'for' loop. This makes the
KDGKBSENT case more compact.

The only thing we need to take care about is NULL 'func_table[i]'. Use
an empty string in that case.

The original check for overflow could never trigger as the func_buf
strings are always shorter or equal to 'struct kbsentry's.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20201019085517.10176-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/keyboard.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1963,9 +1963,7 @@ out:
 int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 {
 	struct kbsentry *kbs;
-	char *p;
 	u_char *q;
-	u_char __user *up;
 	int sz, fnw_sz;
 	int delta;
 	char *first_free, *fj, *fnw;
@@ -1991,23 +1989,15 @@ int vt_do_kdgkb_ioctl(int cmd, struct kb
 	i = kbs->kb_func;
 
 	switch (cmd) {
-	case KDGKBSENT:
-		sz = sizeof(kbs->kb_string) - 1; /* sz should have been
-						  a struct member */
-		up = user_kdgkb->kb_string;
-		p = func_table[i];
-		if(p)
-			for ( ; *p && sz; p++, sz--)
-				if (put_user(*p, up++)) {
-					ret = -EFAULT;
-					goto reterr;
-				}
-		if (put_user('\0', up)) {
-			ret = -EFAULT;
-			goto reterr;
-		}
-		kfree(kbs);
-		return ((p && *p) ? -EOVERFLOW : 0);
+	case KDGKBSENT: {
+		/* size should have been a struct member */
+		unsigned char *from = func_table[i] ? : "";
+
+		ret = copy_to_user(user_kdgkb->kb_string, from,
+				strlen(from) + 1) ? -EFAULT : 0;
+
+		goto reterr;
+	}
 	case KDSKBSENT:
 		if (!perm) {
 			ret = -EPERM;


