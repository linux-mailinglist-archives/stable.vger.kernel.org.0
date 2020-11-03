Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77C42A5850
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbgKCUrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbgKCUra (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1661822404;
        Tue,  3 Nov 2020 20:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436449;
        bh=nH+Hai5haiaq1AHiyM7qvEhL+2pWHuukL45l/ygcukw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jy4ND1Pqp90bm7Hpj27Z2TzcCs+9Y5f2S0UrKMdp0u6SUju1k85YWsBK10rLvfX4S
         bzglcYDTWp2EVueEqX+i9tf5WXgE7CV/yxNNNyDigReRmUgUi7mSzxwlyyNs8rPGRb
         tygNTKEYDUFnj4GBAxi7lKTQrrLkgy35lDDmT9+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.9 254/391] vt: keyboard, simplify vt_kdgkbsent
Date:   Tue,  3 Nov 2020 21:35:05 +0100
Message-Id: <20201103203404.161112322@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
@@ -1995,9 +1995,7 @@ out:
 int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 {
 	struct kbsentry *kbs;
-	char *p;
 	u_char *q;
-	u_char __user *up;
 	int sz, fnw_sz;
 	int delta;
 	char *first_free, *fj, *fnw;
@@ -2023,23 +2021,15 @@ int vt_do_kdgkb_ioctl(int cmd, struct kb
 	i = array_index_nospec(kbs->kb_func, MAX_NR_FUNC);
 
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


