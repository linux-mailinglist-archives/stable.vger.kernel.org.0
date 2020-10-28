Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FDF29D6B3
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbgJ1WRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731589AbgJ1WRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3A3F24735;
        Wed, 28 Oct 2020 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603888906;
        bh=HpHXGfQ/NrqF+O5uHqaq7ANAiD3lIN5bPX+OZQwGWOw=;
        h=Subject:To:From:Date:From;
        b=V54s1174TaNxYKmXX4I1hy3yWaHZhakat1KXaIryR7meLQUMYLcGlhnT3KaiKbnw3
         d+9gbStMqWe28em7YpZKp3WkxBdXNAa1Se4syUVD8Gxi5HD8MRf8eK87h0Yi9DtoyN
         G0/rE3HXU7nHVUKbhAYH7GpUjWC7CCukeXrwjxYw=
Subject: patch "vt: keyboard, extend func_buf_lock to readers" added to tty-linus
To:     jslaby@suse.cz, gregkh@linuxfoundation.org, stable@vger.kernel.org,
        yuanmingbuaa@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Oct 2020 13:42:30 +0100
Message-ID: <160388895048113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vt: keyboard, extend func_buf_lock to readers

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 82e61c3909db51d91b9d3e2071557b6435018b80 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Mon, 19 Oct 2020 10:55:17 +0200
Subject: vt: keyboard, extend func_buf_lock to readers

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

Cc: <stable@vger.kernel.org>
Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20201019085517.10176-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
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
2.29.1


