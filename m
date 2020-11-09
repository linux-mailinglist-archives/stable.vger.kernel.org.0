Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5462ABCA3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387563AbgKINjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:56346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730214AbgKINCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:02:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2B8C206C0;
        Mon,  9 Nov 2020 13:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926962;
        bh=xMr9dHfNtZwniZZGy4gtv6Achb7XpqmYAwvv0IN8EpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2mcOflE5Y6fQxiPrm4hbVrZvnge6wtCGVgh2XI5C5itgjsqtR94QTK8P9XuV/TmC
         sc7UMJkjGFpVw0d5HiAdmEGNDwYnb84LmlekDIzy9t5At21jzH8ict8P183fkiOAE6
         C/TIWxfxBR3mSz9TN71s0p+v975FVpTqvDi8RDKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.9 064/117] vt: keyboard, extend func_buf_lock to readers
Date:   Mon,  9 Nov 2020 13:54:50 +0100
Message-Id: <20201109125028.705398678@linuxfoundation.org>
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

commit 82e61c3909db51d91b9d3e2071557b6435018b80 upstream.

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
 drivers/tty/vt/keyboard.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -712,8 +712,13 @@ static void k_fn(struct vc_data *vc, uns
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
@@ -1959,7 +1964,7 @@ out:
 #undef s
 #undef v
 
-/* FIXME: This one needs untangling and locking */
+/* FIXME: This one needs untangling */
 int vt_do_kdgkb_ioctl(int cmd, struct kbsentry __user *user_kdgkb, int perm)
 {
 	struct kbsentry *kbs;
@@ -1991,10 +1996,14 @@ int vt_do_kdgkb_ioctl(int cmd, struct kb
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


