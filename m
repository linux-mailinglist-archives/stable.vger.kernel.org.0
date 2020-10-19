Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96B42923FD
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 10:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgJSIzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 04:55:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:34708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729287AbgJSIzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 04:55:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0B91AAC7D;
        Mon, 19 Oct 2020 08:55:18 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] vt: keyboard, simplify vt_kdgkbsent
Date:   Mon, 19 Oct 2020 10:55:16 +0200
Message-Id: <20201019085517.10176-1-jslaby@suse.cz>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use 'strlen' of the string, add one for NUL terminator and simply do
'copy_to_user' instead of the explicit 'for' loop. This makes the
KDGKBSENT case more compact.

The only thing we need to take care about is NULL 'func_table[i]'. Use
an empty string in that case.

The original check for overflow could never trigger as the func_buf
strings are always shorter or equal to 'struct kbsentry's.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: <stable@vger.kernel.org>
---

[v2] Removed the need for "reorder user buffer handling in
vt_do_kdgkb_ioctl" patch.

 drivers/tty/vt/keyboard.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 0db53b5b3acf..7bfa95c3252c 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1995,9 +1995,7 @@ int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
 int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 {
 	struct kbsentry *kbs;
-	char *p;
 	u_char *q;
-	u_char __user *up;
 	int sz, fnw_sz;
 	int delta;
 	char *first_free, *fj, *fnw;
@@ -2023,23 +2021,15 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
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
-- 
2.28.0

