Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230992A5481
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388934AbgKCVLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:11:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388929AbgKCVLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:11:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E354B205ED;
        Tue,  3 Nov 2020 21:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437910;
        bh=4wtCFZ77tCguYW9Fce8f1taCn22d1ZNwbf2hVTgyuxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1c5+gw2bNYMjz22KpHUFXHd4g/TdpoPqA0zxQ7e9fhnNVQ58dI6XuIjaWwv065AFI
         BIRdA4iNK/EMSk40rASalcMA5xA61osKgEuUCZCPFlZs7ErVr/QvAi5+YEfb1ljwFv
         d7lieTv2dKgznccOzyNFIKt+DSKchqf6j16nHVBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.14 084/125] vt: keyboard, simplify vt_kdgkbsent
Date:   Tue,  3 Nov 2020 21:37:41 +0100
Message-Id: <20201103203209.065999657@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
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


