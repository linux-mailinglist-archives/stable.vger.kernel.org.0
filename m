Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2588B37C48A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhELPbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235381AbhELP1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:27:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38C8761446;
        Wed, 12 May 2021 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832361;
        bh=NWQ2ZrJ51WyVNuGa+OIxwz2+/Aj3VfECMiM2H4SgGgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tozJDuGvfCN56+NA/evPVOaq/jvGd93cxuZPH3d5198wLS04122O2ZoFbkdDydwD+
         6nPexMDz3g10ULOJfT5V3txrfEPjDMNT+ONLMA40ZLZZ4k63d+bz6vmVJWWqg1U2IQ
         M6k+sLN++liXgoe8jruiqV2l6Ya5iDHaEpRfwpps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/530] tty: Remove dead termiox code
Date:   Wed, 12 May 2021 16:45:57 +0200
Message-Id: <20210512144827.956315973@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit e0efb3168d34dc8c8c72718672b8902e40efff8f ]

set_termiox() and the TCGETX handler bail out with -EINVAL immediately
if ->termiox is NULL, but there are no code paths that can set
->termiox to a non-NULL pointer; and no such code paths seem to have
existed since the termiox mechanism was introduced back in
commit 1d65b4a088de ("tty: Add termiox") in v2.6.28.
Similarly, no driver actually implements .set_termiox; and it looks like
no driver ever has.

Delete this dead code; but leave the definition of struct termiox in the
UAPI headers intact.

Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20201203020331.2394754-1-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_ioctl.c    | 61 ++------------------------------------
 include/linux/tty.h        |  1 -
 include/linux/tty_driver.h |  9 ------
 3 files changed, 2 insertions(+), 69 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index e18f318586ab..4de1c6ddb8ff 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -443,51 +443,6 @@ static int get_termio(struct tty_struct *tty, struct termio __user *termio)
 	return 0;
 }
 
-
-#ifdef TCGETX
-
-/**
- *	set_termiox	-	set termiox fields if possible
- *	@tty: terminal
- *	@arg: termiox structure from user
- *	@opt: option flags for ioctl type
- *
- *	Implement the device calling points for the SYS5 termiox ioctl
- *	interface in Linux
- */
-
-static int set_termiox(struct tty_struct *tty, void __user *arg, int opt)
-{
-	struct termiox tnew;
-	struct tty_ldisc *ld;
-
-	if (tty->termiox == NULL)
-		return -EINVAL;
-	if (copy_from_user(&tnew, arg, sizeof(struct termiox)))
-		return -EFAULT;
-
-	ld = tty_ldisc_ref(tty);
-	if (ld != NULL) {
-		if ((opt & TERMIOS_FLUSH) && ld->ops->flush_buffer)
-			ld->ops->flush_buffer(tty);
-		tty_ldisc_deref(ld);
-	}
-	if (opt & TERMIOS_WAIT) {
-		tty_wait_until_sent(tty, 0);
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-	}
-
-	down_write(&tty->termios_rwsem);
-	if (tty->ops->set_termiox)
-		tty->ops->set_termiox(tty, &tnew);
-	up_write(&tty->termios_rwsem);
-	return 0;
-}
-
-#endif
-
-
 #ifdef TIOCGETP
 /*
  * These are deprecated, but there is limited support..
@@ -815,23 +770,11 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		return ret;
 #endif
 #ifdef TCGETX
-	case TCGETX: {
-		struct termiox ktermx;
-		if (real_tty->termiox == NULL)
-			return -EINVAL;
-		down_read(&real_tty->termios_rwsem);
-		memcpy(&ktermx, real_tty->termiox, sizeof(struct termiox));
-		up_read(&real_tty->termios_rwsem);
-		if (copy_to_user(p, &ktermx, sizeof(struct termiox)))
-			ret = -EFAULT;
-		return ret;
-	}
+	case TCGETX:
 	case TCSETX:
-		return set_termiox(real_tty, p, 0);
 	case TCSETXW:
-		return set_termiox(real_tty, p, TERMIOS_WAIT);
 	case TCSETXF:
-		return set_termiox(real_tty, p, TERMIOS_FLUSH);
+		return -EINVAL;
 #endif		
 	case TIOCGSOFTCAR:
 		copy_termios(real_tty, &kterm);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index bc8caac390fc..5972f43b9d5a 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -303,7 +303,6 @@ struct tty_struct {
 	spinlock_t flow_lock;
 	/* Termios values are protected by the termios rwsem */
 	struct ktermios termios, termios_locked;
-	struct termiox *termiox;	/* May be NULL for unsupported */
 	char name[64];
 	struct pid *pgrp;		/* Protected by ctrl lock */
 	/*
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 7186d77f431e..2f719b471d52 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -224,14 +224,6 @@
  *	line). See tty_do_resize() if you need to wrap the standard method
  *	in your own logic - the usual case.
  *
- * void (*set_termiox)(struct tty_struct *tty, struct termiox *new);
- *
- *	Called when the device receives a termiox based ioctl. Passes down
- *	the requested data from user space. This method will not be invoked
- *	unless the tty also has a valid tty->termiox pointer.
- *
- *	Optional: Called under the termios lock
- *
  * int (*get_icount)(struct tty_struct *tty, struct serial_icounter *icount);
  *
  *	Called when the device receives a TIOCGICOUNT ioctl. Passed a kernel
@@ -285,7 +277,6 @@ struct tty_operations {
 	int (*tiocmset)(struct tty_struct *tty,
 			unsigned int set, unsigned int clear);
 	int (*resize)(struct tty_struct *tty, struct winsize *ws);
-	int (*set_termiox)(struct tty_struct *tty, struct termiox *tnew);
 	int (*get_icount)(struct tty_struct *tty,
 				struct serial_icounter_struct *icount);
 	int  (*get_serial)(struct tty_struct *tty, struct serial_struct *p);
-- 
2.30.2



