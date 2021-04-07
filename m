Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D063569D8
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351191AbhDGKkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351160AbhDGKkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8188613CC;
        Wed,  7 Apr 2021 10:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617791990;
        bh=/LsrTsDvaxEKnXy0LT20rdMUD9DDD2wpF9Goo5KPCRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZtUsTpWeUtqPSVHR7nUoi2rOaSAVz6lOVZ9e5A2SmpwX2Nbkf3HM/tjsfPzkgKDk
         n5HnZ7gw+l/GqcZHJ0PT/0OjNOWvoM3It155Yzc1tYnE0EEz0mvxW7TMu4xlL1m3BJ
         ZO+ZM4fIsTdI3yk4zDu13HWwEMz9iwYDG5jiUlMH47YVncMuqTcnowpjB7nRe3ggOt
         Hjfnxf6OERqLCVdUw7i6x767UGCQ8mY5xfZy88ghrjguEFIZ1txpLS0t+FUc/NHXgU
         bh7qaqG5O4wjPPoh2o5vFct+xNxDBehsCq+zJHvEwjotCis4xTNAaSl7ZVYNX5FYdI
         s9PpkkMb+KK6A==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lU5b5-0000FF-Ig; Wed, 07 Apr 2021 12:39:43 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 15/24] USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions
Date:   Wed,  7 Apr 2021 12:39:16 +0200
Message-Id: <20210407103925.829-16-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210407103925.829-1-johan@kernel.org>
References: <20210407103925.829-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The port close_delay and closing_wait parameters set by TIOCSSERIAL are
specified in jiffies and not milliseconds.

Add the missing conversions so that the TIOCSSERIAL works as expected
also when HZ is not 1000.

Fixes: 02303f73373a ("usb-wwan: implement TIOCGSERIAL and TIOCSSERIAL to avoid blocking close(2)")
Cc: stable@vger.kernel.org      # 2.6.38
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/usb_wwan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 46d46a4f99c9..4e9c994a972a 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -140,10 +140,10 @@ int usb_wwan_get_serial_info(struct tty_struct *tty,
 	ss->line            = port->minor;
 	ss->port            = port->port_number;
 	ss->baud_base       = tty_get_baud_rate(port->port.tty);
-	ss->close_delay	    = port->port.close_delay / 10;
+	ss->close_delay	    = jiffies_to_msecs(port->port.close_delay) / 10;
 	ss->closing_wait    = port->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				 ASYNC_CLOSING_WAIT_NONE :
-				 port->port.closing_wait / 10;
+				 jiffies_to_msecs(port->port.closing_wait) / 10;
 	return 0;
 }
 EXPORT_SYMBOL(usb_wwan_get_serial_info);
@@ -155,9 +155,10 @@ int usb_wwan_set_serial_info(struct tty_struct *tty,
 	unsigned int closing_wait, close_delay;
 	int retval = 0;
 
-	close_delay = ss->close_delay * 10;
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	closing_wait = ss->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			ASYNC_CLOSING_WAIT_NONE : ss->closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE :
+			msecs_to_jiffies(ss->closing_wait * 10);
 
 	mutex_lock(&port->port.mutex);
 
-- 
2.26.3

