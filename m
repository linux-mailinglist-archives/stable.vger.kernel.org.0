Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33F337C697
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbhELPw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237137AbhELPs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC50D619A2;
        Wed, 12 May 2021 15:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833088;
        bh=zf439LZoVaaedLklw7NY5O8s9xXGqywC7kPioFttdcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZoM91ejngpck6tUjq4O3JPyUlJSRjUPhNQcwo9982cBxys1Ak7ctqeN6ofRZ9I3+
         MHq7u2OEy4Iow6UbtYd6E2F+Z+7eWx2L/WyVsT1YTnR2yQAjS9aLBHAXkP3I8X88FV
         xLEzUgSs/vC7WftnmE+MyeALBY/k6ACQUouDRHg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 013/601] tty: moxa: fix TIOCSSERIAL permission check
Date:   Wed, 12 May 2021 16:41:30 +0200
Message-Id: <20210512144828.255484696@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit dc8c8437658667be9b11ec25c4b5482ed2becdaa upstream.

Changing the port close delay or type are privileged operations so make
sure to return -EPERM if a regular user tries to change them.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-12-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/moxa.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -2050,6 +2050,7 @@ static int moxa_set_serial_info(struct t
 		struct serial_struct *ss)
 {
 	struct moxa_port *info = tty->driver_data;
+	unsigned int close_delay;
 
 	if (tty->index == MAX_PORTS)
 		return -EINVAL;
@@ -2061,19 +2062,24 @@ static int moxa_set_serial_info(struct t
 			ss->baud_base != 921600)
 		return -EPERM;
 
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
+
 	mutex_lock(&info->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {
-		if (((ss->flags & ~ASYNC_USR_MASK) !=
+		if (close_delay != info->port.close_delay ||
+		    ss->type != info->type ||
+		    ((ss->flags & ~ASYNC_USR_MASK) !=
 		     (info->port.flags & ~ASYNC_USR_MASK))) {
 			mutex_unlock(&info->port.mutex);
 			return -EPERM;
 		}
-	}
-	info->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
+	} else {
+		info->port.close_delay = close_delay;
 
-	MoxaSetFifo(info, ss->type == PORT_16550A);
+		MoxaSetFifo(info, ss->type == PORT_16550A);
 
-	info->type = ss->type;
+		info->type = ss->type;
+	}
 	mutex_unlock(&info->port.mutex);
 	return 0;
 }


