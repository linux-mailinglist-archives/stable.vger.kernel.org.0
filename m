Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593F32E685D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731843AbgL1QfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729983AbgL1NCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC66122A84;
        Mon, 28 Dec 2020 13:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160488;
        bh=nC/iBTq0QSCs/EILL/SEj0NV8zZLZTO1hUte7u7+n3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9IVEqvsv92Mvo4Ad7YIHupr2qpoBt6r5bnga9b+Rgk2foeiSJw49rRqN70Jqf8IC
         YpM/u2etM+kBBdRFHJ1aKls5A8WURO71pLLPE0ahrm9bmUDZe3s0F46m0cMDSYIBKF
         BmVtCqnmU8AFVvQL/QVhJaK3v689wGb3yU9Vmi30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jander <david@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/175] Input: ads7846 - fix integer overflow on Rt calculation
Date:   Mon, 28 Dec 2020 13:48:42 +0100
Message-Id: <20201228124856.595791689@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 1ce3ecbe37f89..9fa7ae12df80a 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -785,10 +785,11 @@ static void ads7846_report_state(struct ads7846 *ts)
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



