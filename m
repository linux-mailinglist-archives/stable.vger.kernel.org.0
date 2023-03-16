Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653FC6BD0C1
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 14:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCPNZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 09:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCPNZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 09:25:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76750212B0;
        Thu, 16 Mar 2023 06:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678973106; x=1710509106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sSrP2H0F2QdS2sJv68twXcd58hArlvzYGfTg+emznYc=;
  b=h88A3BpLN3cLbrf+5Zt4yC9YHyko9dZZTZyqA387FOoa6X/u5oSt10pH
   iH1PDvRMx9YXGBWC+UmLRZFGV4XA70uKGWB3aEl6v03oSPwGrkhkZwD2v
   FV2356ZWlo2eK5gOUrm+marQOxBIIjm6t1eloam+RObwZ+zSIIEX/xSaG
   t3ARBWYRDu9Dc8I+KTiIox6LUIwjclwH+q/evxIG6ka8GMVyJVoTVuRyq
   U3hTbqEJZ4K07A2tHTrWKraqP8R/rYTHZunxKqZzMBdzrIfe2P0VChdu8
   OdFU5MlRuXitMeZsbsChEJoOxPeEDr9ba5zsNCISe/E2+6HlaF0PGABdL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="338003202"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="338003202"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 06:25:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="710109134"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="710109134"
Received: from trybicki-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.63.119])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 06:25:04 -0700
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] tty: Prevent writing chars during tcsetattr TCSADRAIN/FLUSH
Date:   Thu, 16 Mar 2023 15:24:51 +0200
Message-Id: <20230316132452.76478-2-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230316132452.76478-1-ilpo.jarvinen@linux.intel.com>
References: <20230316132452.76478-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If userspace races tcsetattr() with a write, the drained condition
might not be guaranteed by the kernel. There is a race window after
checking Tx is empty before tty_set_termios() takes termios_rwsem for
write. During that race window, more characters can be queued by a
racing writer.

Any ongoing transmission might produce garbage during HW's
->set_termios() call. The intent of TCSADRAIN/FLUSH seems to be
preventing such a character corruption. If those flags are set, take
tty's write lock to stop any writer before performing the lower layer
Tx empty check and wait for the pending characters to be sent (if any).

The initial wait for all-writers-done must be placed outside of tty's
write lock to avoid deadlock which makes it impossible to use
tty_wait_until_sent(). The write lock is retried if a racing write is
detected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/tty/tty.h       |  2 ++
 drivers/tty/tty_io.c    |  4 ++--
 drivers/tty/tty_ioctl.c | 45 ++++++++++++++++++++++++++++++-----------
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/tty.h b/drivers/tty/tty.h
index f45cd683c02e..1e0d80e98d26 100644
--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -62,6 +62,8 @@ int __tty_check_change(struct tty_struct *tty, int sig);
 int tty_check_change(struct tty_struct *tty);
 void __stop_tty(struct tty_struct *tty);
 void __start_tty(struct tty_struct *tty);
+void tty_write_unlock(struct tty_struct *tty);
+int tty_write_lock(struct tty_struct *tty, int ndelay);
 void tty_vhangup_session(struct tty_struct *tty);
 void tty_open_proc_set_tty(struct file *filp, struct tty_struct *tty);
 int tty_signal_session_leader(struct tty_struct *tty, int exit_session);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 766750e355ac..cfb3da0dee47 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -933,13 +933,13 @@ static ssize_t tty_read(struct kiocb *iocb, struct iov_iter *to)
 	return i;
 }
 
-static void tty_write_unlock(struct tty_struct *tty)
+void tty_write_unlock(struct tty_struct *tty)
 {
 	mutex_unlock(&tty->atomic_write_lock);
 	wake_up_interruptible_poll(&tty->write_wait, EPOLLOUT);
 }
 
-static int tty_write_lock(struct tty_struct *tty, int ndelay)
+int tty_write_lock(struct tty_struct *tty, int ndelay)
 {
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
 		if (ndelay)
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 12983ce4e43e..a13e3797c477 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -500,21 +500,42 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 	tmp_termios.c_ispeed = tty_termios_input_baud_rate(&tmp_termios);
 	tmp_termios.c_ospeed = tty_termios_baud_rate(&tmp_termios);
 
-	ld = tty_ldisc_ref(tty);
+	if (opt & (TERMIOS_FLUSH|TERMIOS_WAIT)) {
+retry_write_wait:
+		retval = wait_event_interruptible(tty->write_wait, !tty_chars_in_buffer(tty));
+		if (retval < 0)
+			return retval;
 
-	if (ld != NULL) {
-		if ((opt & TERMIOS_FLUSH) && ld->ops->flush_buffer)
-			ld->ops->flush_buffer(tty);
-		tty_ldisc_deref(ld);
-	}
+		if (tty_write_lock(tty, 0) < 0)
+			goto retry_write_wait;
 
-	if (opt & TERMIOS_WAIT) {
-		tty_wait_until_sent(tty, 0);
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-	}
+		/* Racing writer? */
+		if (tty_chars_in_buffer(tty)) {
+			tty_write_unlock(tty);
+			goto retry_write_wait;
+		}
 
-	tty_set_termios(tty, &tmp_termios);
+		ld = tty_ldisc_ref(tty);
+		if (ld != NULL) {
+			if ((opt & TERMIOS_FLUSH) && ld->ops->flush_buffer)
+				ld->ops->flush_buffer(tty);
+			tty_ldisc_deref(ld);
+		}
+
+		if ((opt & TERMIOS_WAIT) && tty->ops->wait_until_sent) {
+			tty->ops->wait_until_sent(tty, 0);
+			if (signal_pending(current)) {
+				tty_write_unlock(tty);
+				return -ERESTARTSYS;
+			}
+		}
+
+		tty_set_termios(tty, &tmp_termios);
+
+		tty_write_unlock(tty);
+	} else {
+		tty_set_termios(tty, &tmp_termios);
+	}
 
 	/* FIXME: Arguably if tmp_termios == tty->termios AND the
 	   actual requested termios was not tmp_termios then we may
-- 
2.30.2

