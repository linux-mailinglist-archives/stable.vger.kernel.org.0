Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53002923FB
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 10:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgJSIzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 04:55:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:34728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbgJSIzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 04:55:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 47DFBAC19;
        Mon, 19 Oct 2020 08:55:18 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minh Yuan <yuanmingbuaa@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 2/2] vt: keyboard, extend func_buf_lock to readers
Date:   Mon, 19 Oct 2020 10:55:17 +0200
Message-Id: <20201019085517.10176-2-jslaby@suse.cz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201019085517.10176-1-jslaby@suse.cz>
References: <20201019085517.10176-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Both read-side users of func_table/func_buf need locking. Without that,
one can easily confuse the code by repeatedly setting altering strings
like:
while (1)
	for (a = 0; a < 2; a++) {
		struct kbsentry kbs = {};
		strcpy((char *)kbs.kb_string, a ? ".\n" : "88888\n");
		ioctl(fd, KDSKBSENT, &kbs);
	}

When that program runs, one can get unexpected output by holding F1
(note the unxpected period on the last line):
.
88888
.8888

So protect all accesses to 'func_table' (and func_buf) by preexisting
'func_buf_lock'.

It is easy in 'k_fn' handler as 'puts_queue' is expected not to sleep.
On the other hand, KDGKBSENT needs a local (atomic) copy of the string
because copy_to_user can sleep. Use already allocated, but unused
'kbs->kb_string' for that purpose.

Note that the program above needs at least CAP_SYS_TTY_CONFIG.

This depends on the previous patch and on the func_buf_lock lock added
in commit 46ca3f735f34 (tty/vt: fix write/write race in ioctl(KDSKBSENT)
handler) in 5.2.

Likely fixes CVE-2020-25656.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
Cc: <stable@vger.kernel.org>
---

[v2]
 - Removed the need for "reorder user buffer handling in
   vt_do_kdgkb_ioctl" patch.
 - given the above, use kbs->kb_string instead of another kmalloc.

 drivers/tty/vt/keyboard.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 7bfa95c3252c..78acc270e39a 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -743,8 +743,13 @@ static void k_fn(struct vc_data *vc, unsigned char value, char up_flag)
 		return;
 
 	if ((unsigned)value < ARRAY_SIZE(func_table)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&func_buf_lock, flags);
 		if (func_table[value])
 			puts_queue(vc, func_table[value]);
+		spin_unlock_irqrestore(&func_buf_lock, flags);
+
 	} else
 		pr_err("k_fn called with value=%d\n", value);
 }
@@ -1991,7 +1996,7 @@ int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
 #undef s
 #undef v
 
-/* FIXME: This one needs untangling and locking */
+/* FIXME: This one needs untangling */
 int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 {
 	struct kbsentry *kbs;
@@ -2023,10 +2028,14 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 	switch (cmd) {
 	case KDGKBSENT: {
 		/* size should have been a struct member */
-		unsigned char *from = func_table[i] ? : "";
+		ssize_t len = sizeof(user_kdgkb->kb_string);
+
+		spin_lock_irqsave(&func_buf_lock, flags);
+		len = strlcpy(kbs->kb_string, func_table[i] ? : "", len);
+		spin_unlock_irqrestore(&func_buf_lock, flags);
 
-		ret = copy_to_user(user_kdgkb->kb_string, from,
-				strlen(from) + 1) ? -EFAULT : 0;
+		ret = copy_to_user(user_kdgkb->kb_string, kbs->kb_string,
+				len + 1) ? -EFAULT : 0;
 
 		goto reterr;
 	}
-- 
2.28.0

