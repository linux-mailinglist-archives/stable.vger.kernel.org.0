Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D183A190FCC
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgCXNXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbgCXNXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:23:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CEFE208CA;
        Tue, 24 Mar 2020 13:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056193;
        bh=6gexxwiQdA9Su+qvuekL8GGkNoASq2gcrDkAT0Kh84Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFpeLfBv6X2rRzdNmta/oYXfPGojxmJW0Sv1PdWIoIzHYO4qOMZtqFLqKTAfoTmD2
         tdp4gzfRLTO9G+3RQqzWqGEXNydlp8WkwT4rl0LfuD7aL+doY1aQqKTTNsFZtsw9+g
         exkmdsJvqBOmbouVLTVyyvHqUhGQIHajRCMoJBQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Mallet <anthony.mallet@laas.fr>
Subject: [PATCH 5.5 052/119] USB: cdc-acm: fix rounding error in TIOCSSERIAL
Date:   Tue, 24 Mar 2020 14:10:37 +0100
Message-Id: <20200324130813.453959024@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Mallet <anthony.mallet@laas.fr>

commit b401f8c4f492cbf74f3f59c9141e5be3071071bb upstream.

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

---
 drivers/usb/class/cdc-acm.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -907,6 +907,7 @@ static int set_serial_info(struct tty_st
 {
 	struct acm *acm = tty->driver_data;
 	unsigned int closing_wait, close_delay;
+	unsigned int old_closing_wait, old_close_delay;
 	int retval = 0;
 
 	close_delay = msecs_to_jiffies(ss->close_delay * 10);
@@ -914,18 +915,24 @@ static int set_serial_info(struct tty_st
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


