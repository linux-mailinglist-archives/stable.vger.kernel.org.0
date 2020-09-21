Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568B0272F2B
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgIUQpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbgIUQpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A45920874;
        Mon, 21 Sep 2020 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706743;
        bh=sZ0X34q0lCuHz7JePqUQnYkx562+2UZhjKzVlNe39q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzNbnxzREGDPxX+6aF0/M10GWjYMggfTSqNnHVWlPjcPgP2cEgsYgIWAhgNnI8Nxx
         l9yP+MKnHMvAvDdxbjnEH1V1i9Vo34PjjdynSLhqby/zU4jE3sGGkqihyVh50J4Vno
         Z8Q90F/mhCrQiQWNfaoPMqcPEyQglusBiDAUjS6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 076/118] i2c: mediatek: Fix generic definitions for bus frequency
Date:   Mon, 21 Sep 2020 18:28:08 +0200
Message-Id: <20200921162039.861373792@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qii Wang <qii.wang@mediatek.com>

[ Upstream commit ff6f3aff46beb3c29e0802cffcc559e1756c4814 ]

The max frequency of mediatek i2c controller driver is
I2C_MAX_HIGH_SPEED_MODE_FREQ, not I2C_MAX_FAST_MODE_PLUS_FREQ.
Fix it.

Fixes: 90224e6468e1 ("i2c: drivers: Use generic definitions for bus frequencies")
Reviewed-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index deef69e569062..b099139cbb91e 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -658,8 +658,8 @@ static int mtk_i2c_calculate_speed(struct mtk_i2c *i2c, unsigned int clk_src,
 	unsigned int cnt_mul;
 	int ret = -EINVAL;
 
-	if (target_speed > I2C_MAX_FAST_MODE_PLUS_FREQ)
-		target_speed = I2C_MAX_FAST_MODE_PLUS_FREQ;
+	if (target_speed > I2C_MAX_HIGH_SPEED_MODE_FREQ)
+		target_speed = I2C_MAX_HIGH_SPEED_MODE_FREQ;
 
 	max_step_cnt = mtk_i2c_max_step_cnt(target_speed);
 	base_step_cnt = max_step_cnt;
-- 
2.25.1



