Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF635419C9B
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhI0Ra2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237762AbhI0R2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22EB061440;
        Mon, 27 Sep 2021 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763044;
        bh=5Jslq9+iulpOsN/N8aZfjjmg6vIsKvj3Nl29SUYKWmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzNX4R6KbSzSATFi9LiD60TdxgbOoOmldInnl0muDLxgQXzf4p9DmsPuIW4uOi8Hk
         4yDrplrpwQdXamxOmGb5oZIMawS+Zhxb7czuxnX86hXhfjKw0aXFPykIHLZm22FV/j
         MXDtx6J/CR1feTTj6I08wDS9rOWWkaemthFA9jeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 146/162] net: 6pack: Fix tx timeout and slot time
Date:   Mon, 27 Sep 2021 19:03:12 +0200
Message-Id: <20210927170238.493966371@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
index 8fe8887d506a..6192244b304a 100644
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



