Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156DF35696A
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350948AbhDGKYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234666AbhDGKYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:24:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 494C36124B;
        Wed,  7 Apr 2021 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617791030;
        bh=RHMlrWdzfqav97k3xdI2ncIfUKhHVobU2cn2BD0748g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOxoC4bLrmmz/avenRRD8eLEp/ASDnZc/3ilejqKvImG52IDpKx491L9EriEOqUoJ
         cx5+8xQ+zV3KtUgSqAdiYO45cXDgLgjv0ozvflq1OwwIrLS+m8YunZWisRXL21o6+j
         uNnhsPVp+FcFiobspeXYsnU/Kv1pOcX6zK4XybY+LG9l/UdL9dvegBtr5+jJaok90I
         F13Q5mY2iStsl6qCoETowB5+1sk9yz5GXhMGpFAzJpvkHAnArnyKCnxI7cmm1a2T93
         neSj71hEpZtyDHcxvD2db6qnCywCyvTgbg6e0dL1a2dzSs5wYv4/P+387xqMvRMDDj
         nnJX5Fu5N87yg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lU5Lb-0008RE-1S; Wed, 07 Apr 2021 12:23:43 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 05/16] staging: greybus: uart: fix TIOCSSERIAL jiffies conversions
Date:   Wed,  7 Apr 2021 12:23:23 +0200
Message-Id: <20210407102334.32361-6-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210407102334.32361-1-johan@kernel.org>
References: <20210407102334.32361-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The port close_delay and closing_wait parameters set by TIOCSSERIAL are
specified in jiffies and not milliseconds.

Add the missing conversions so that TIOCSSERIAL works as expected also
when HZ is not 1000.

Fixes: e68453ed28c5 ("greybus: uart-gb: now builds, more framework added")
Cc: stable@vger.kernel.org	# 4.9
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/staging/greybus/uart.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 607378bfebb7..29846dc1e1bf 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -614,10 +614,12 @@ static int get_serial_info(struct tty_struct *tty,
 	ss->line = gb_tty->minor;
 	ss->xmit_fifo_size = 16;
 	ss->baud_base = 9600;
-	ss->close_delay = gb_tty->port.close_delay / 10;
+	ss->close_delay = jiffies_to_msecs(gb_tty->port.close_delay) / 10;
 	ss->closing_wait =
 		gb_tty->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-		ASYNC_CLOSING_WAIT_NONE : gb_tty->port.closing_wait / 10;
+		ASYNC_CLOSING_WAIT_NONE :
+		jiffies_to_msecs(gb_tty->port.closing_wait) / 10;
+
 	return 0;
 }
 
@@ -629,9 +631,10 @@ static int set_serial_info(struct tty_struct *tty,
 	unsigned int close_delay;
 	int retval = 0;
 
-	close_delay = ss->close_delay * 10;
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	closing_wait = ss->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			ASYNC_CLOSING_WAIT_NONE : ss->closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE :
+			msecs_to_jiffies(ss->closing_wait * 10);
 
 	mutex_lock(&gb_tty->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {
-- 
2.26.3

