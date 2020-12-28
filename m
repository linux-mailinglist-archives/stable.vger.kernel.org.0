Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353FA2E6754
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgL1QXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731859AbgL1NLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:11:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BC3922AEC;
        Mon, 28 Dec 2020 13:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161094;
        bh=m7W4TKN+pz1FPn3U3CcLtI0In9PRR9pUBl7A3UEoAOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+oLlLmWOOGDnLhTSzFK7+seC2NHptnPtnzkZB+RzUHeqA3GgymwJx4IYjDaDBFpy
         EH0WKfDVqqwppqSE380SUkhPrn/3VAEllww+9K+R1U7KWj7Uhw/s/YutHl0+0xXn+L
         QhBFLZW3V0MgpUjLstw8vdGHqY45xxUZnn/SqKNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jander <david@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/242] Input: ads7846 - fix integer overflow on Rt calculation
Date:   Mon, 28 Dec 2020 13:48:23 +0100
Message-Id: <20201228124909.514419706@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 820830ec918f6c3dcd77a54a1c6198ab57407916 ]

In some rare cases the 32 bit Rt value will overflow if z2 and x is max,
z1 is minimal value and x_plate_ohms is relatively high (for example 800
ohm). This would happen on some screen age with low pressure.

There are two possible fixes:
- make Rt 64bit
- reorder calculation to avoid overflow

The second variant seems to be preferable, since 64 bit calculation on
32 bit system is a bit more expensive.

Fixes: ffa458c1bd9b6f653008d450f337602f3d52a646 ("spi: ads7846 driver")
Co-developed-by: David Jander <david@protonic.nl>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20201113112240.1360-1-o.rempel@pengutronix.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 0fbad337e45a3..7ce0eedaa0e5e 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -801,10 +801,11 @@ static void ads7846_report_state(struct ads7846 *ts)
 		/* compute touch pressure resistance using equation #2 */
 		Rt = z2;
 		Rt -= z1;
-		Rt *= x;
 		Rt *= ts->x_plate_ohms;
+		Rt = DIV_ROUND_CLOSEST(Rt, 16);
+		Rt *= x;
 		Rt /= z1;
-		Rt = (Rt + 2047) >> 12;
+		Rt = DIV_ROUND_CLOSEST(Rt, 256);
 	} else {
 		Rt = 0;
 	}
-- 
2.27.0



