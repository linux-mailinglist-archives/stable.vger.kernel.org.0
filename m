Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DCE37C10F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhELO4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232051AbhELOzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:55:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83A696142F;
        Wed, 12 May 2021 14:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831251;
        bh=2gSRLXaVDBQshsMRvFEar/UUoLG+FxVnZ6XIX9/FjwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSXexO6FgXxKq4vhL7kUcFvryyk8eVXaU4nd03KP/paKymlrUqPglUGFXQlVmNdrh
         z3j75kUJC/yugUpP7t7WvvSw8LXsJMEZSJ2m2g60EnnyJnql3FzoH4tJDSHt59EgsQ
         tlerzODqLl3KSD1oz6osYCjbGRl1TqNig2ScDvss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 009/244] staging: greybus: uart: fix TIOCSSERIAL jiffies conversions
Date:   Wed, 12 May 2021 16:46:20 +0200
Message-Id: <20210512144743.341599881@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b71e571adaa58be4fd289abebc8997e05b4c6b40 upstream.

The port close_delay and closing_wait parameters set by TIOCSSERIAL are
specified in jiffies and not milliseconds.

Add the missing conversions so that TIOCSSERIAL works as expected also
when HZ is not 1000.

Fixes: e68453ed28c5 ("greybus: uart-gb: now builds, more framework added")
Cc: stable@vger.kernel.org	# 4.9
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-6-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/uart.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -625,10 +625,12 @@ static int get_serial_info(struct tty_st
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
 
@@ -640,9 +642,10 @@ static int set_serial_info(struct tty_st
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


