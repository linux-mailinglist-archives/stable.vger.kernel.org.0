Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4016B18F48E
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 13:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgCWM2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 08:28:46 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:58507 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727380AbgCWM2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 08:28:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A713E47B;
        Mon, 23 Mar 2020 08:28:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 08:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sUIWwt
        5+bYJTVnrik0IYT4pw32soVwXxVETbhmzrYws=; b=3UgJIJbGEagktCjTPL2nkQ
        KLFcN57OslTqtKk8k45ctwc5kDk1IE+oLUfPiU4LD0tmej42kM+O7bJfl1/qlyyf
        WYjtSG5lSidZbOMvA2b6QdpLF/3CwcE6FcWa9fB5d1EEQylhiwALPVzWwjRvpiHJ
        QVSh5d0mwZl88g02i7kDF+rX2US+A3a56VH9uko1btzooPazYRAH6yrMUMky5YUA
        Aqh+j8bCbvGTlFX7xZW8tVfSGEx9COA5g0xFtEXDr3Ku6P9YYdluK5FDS3EX/7ye
        +y6S1B2P+yMIfLxIecGL35UkN+mLEetMj3Ik0dexE0MUf8iU8SgrANID4VAS2EuA
        ==
X-ME-Sender: <xms:fat4XiwKH_02pArm_GDzFNRCrNmktN0uDqDIyWrOXJsVgjfxbXLfKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgnecukf
    hppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fat4XuaVAnJfmhzPyBdaMxJQEEOLJW9EoBK7vHlHxtZhzX3fdecaKA>
    <xmx:fat4XkmEcc40JHAUjuHkXJMIpG8bTs9_OUP7VzDT-QzXFD0DTVRcwA>
    <xmx:fat4XsmA3Kd27oJS71VahGjTwGRDTExGG9lezuG2ctvy0GaKdXwL9w>
    <xmx:fat4Xu1x93R9-4lGoSD-f70t-gbU0Dqy-lA3yExCZas7Obzjt56bXQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2C0E30626D3;
        Mon, 23 Mar 2020 08:28:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: cdc-acm: fix rounding error in TIOCSSERIAL" failed to apply to 4.4-stable tree
To:     anthony.mallet@laas.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 13:28:42 +0100
Message-ID: <1584966522231166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b401f8c4f492cbf74f3f59c9141e5be3071071bb Mon Sep 17 00:00:00 2001
From: Anthony Mallet <anthony.mallet@laas.fr>
Date: Thu, 12 Mar 2020 14:31:01 +0100
Subject: [PATCH] USB: cdc-acm: fix rounding error in TIOCSSERIAL

By default, tty_port_init() initializes those parameters to a multiple
of HZ. For instance in line 69 of tty_port.c:
   port->close_delay = (50 * HZ) / 100;
https://github.com/torvalds/linux/blob/master/drivers/tty/tty_port.c#L69

With e.g. CONFIG_HZ = 250 (as this is the case for Ubuntu 18.04
linux-image-4.15.0-37-generic), the default setting for close_delay is
thus 125.

When ioctl(fd, TIOCGSERIAL, &s) is executed, the setting returned in
user space is '12' (125/10). When ioctl(fd, TIOCSSERIAL, &s) is then
executed with the same setting '12', the value is interpreted as '120'
which is different from the current setting and a EPERM error may be
raised by set_serial_info() if !CAP_SYS_ADMIN.
https://github.com/torvalds/linux/blob/master/drivers/usb/class/cdc-acm.c#L919

Fixes: ba2d8ce9db0a6 ("cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)")
Signed-off-by: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200312133101.7096-2-anthony.mallet@laas.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index da619176deca..47f09a6ce7bd 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -907,6 +907,7 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 {
 	struct acm *acm = tty->driver_data;
 	unsigned int closing_wait, close_delay;
+	unsigned int old_closing_wait, old_close_delay;
 	int retval = 0;
 
 	close_delay = msecs_to_jiffies(ss->close_delay * 10);
@@ -914,18 +915,24 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 			ASYNC_CLOSING_WAIT_NONE :
 			msecs_to_jiffies(ss->closing_wait * 10);
 
+	/* we must redo the rounding here, so that the values match */
+	old_close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
+	old_closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
+				ASYNC_CLOSING_WAIT_NONE :
+				jiffies_to_msecs(acm->port.closing_wait) / 10;
+
 	mutex_lock(&acm->port.mutex);
 
-	if (!capable(CAP_SYS_ADMIN)) {
-		if ((close_delay != acm->port.close_delay) ||
-		    (closing_wait != acm->port.closing_wait))
+	if ((ss->close_delay != old_close_delay) ||
+            (ss->closing_wait != old_closing_wait)) {
+		if (!capable(CAP_SYS_ADMIN))
 			retval = -EPERM;
-		else
-			retval = -EOPNOTSUPP;
-	} else {
-		acm->port.close_delay  = close_delay;
-		acm->port.closing_wait = closing_wait;
-	}
+		else {
+			acm->port.close_delay  = close_delay;
+			acm->port.closing_wait = closing_wait;
+		}
+	} else
+		retval = -EOPNOTSUPP;
 
 	mutex_unlock(&acm->port.mutex);
 	return retval;

