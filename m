Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62168420C59
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhJDNE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234968AbhJDNDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D7061A78;
        Mon,  4 Oct 2021 12:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352389;
        bh=PZphukInpo/nFI1X+TcSefwgh7kD0/GTSYOYSCK0vsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqnE8mk6eKy3P0n3Co+jvrQc0U/RwF6cviaPwa5xqifsB/dofmmp98Qc/fKSwu2J6
         FGtWldjKDcEsTSMZjuwZOBF/32H6RRT7bOv80XpCSEnw8Mc/BTDzVlqLYXjmx8G1W7
         v/34Tvc3HZ41pElQ3gBSc0Pk6VaKtTTQt1lXJmME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/75] net: 6pack: Fix tx timeout and slot time
Date:   Mon,  4 Oct 2021 14:52:10 +0200
Message-Id: <20211004125032.688577623@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 3c0d2a46c0141913dc6fd126c57d0615677d946e ]

tx timeout and slot time are currently specified in units of HZ.  On
Alpha, HZ is defined as 1024.  When building alpha:allmodconfig, this
results in the following error message.

  drivers/net/hamradio/6pack.c: In function 'sixpack_open':
  drivers/net/hamradio/6pack.c:71:41: error:
  	unsigned conversion from 'int' to 'unsigned char'
  	changes value from '256' to '0'

In the 6PACK protocol, tx timeout is specified in units of 10 ms and
transmitted over the wire:

    https://www.linux-ax25.org/wiki/6PACK

Defining a value dependent on HZ doesn't really make sense, and
presumably comes from the (very historical) situation where HZ was
originally 100.

Note that the SIXP_SLOTTIME use explicitly is about 10ms granularity:

        mod_timer(&sp->tx_t, jiffies + ((when + 1) * HZ) / 100);

and the SIXP_TXDELAY walue is sent as a byte over the wire.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 231eaef29266..7e430300818e 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -68,9 +68,9 @@
 #define SIXP_DAMA_OFF		0
 
 /* default level 2 parameters */
-#define SIXP_TXDELAY			(HZ/4)	/* in 1 s */
+#define SIXP_TXDELAY			25	/* 250 ms */
 #define SIXP_PERSIST			50	/* in 256ths */
-#define SIXP_SLOTTIME			(HZ/10)	/* in 1 s */
+#define SIXP_SLOTTIME			10	/* 100 ms */
 #define SIXP_INIT_RESYNC_TIMEOUT	(3*HZ/2) /* in 1 s */
 #define SIXP_RESYNC_TIMEOUT		5*HZ	/* in 1 s */
 
-- 
2.33.0



