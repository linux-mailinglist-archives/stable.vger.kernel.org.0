Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495F7451094
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbhKOSuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:50:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242981AbhKOSsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3FF163398;
        Mon, 15 Nov 2021 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999679;
        bh=gErPLzbTr0Y0NQ/81u8uZdxaswuViq9lAs1D/Y59Qt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qO6KM2/neQisZg9yHqTfMw0VEY5lH3kwmULGDXP9Z23rjWuXKbj8dGQZCifREvIl6
         Y2orGi5sOK3xfuMqazlwOw15ZSov7qFbnKq934lqFnaAyi4nXyXSNqnO0EdeakLW87
         62MnjhZ75Do0deyNiCSjnUpWN6xP8u6YeH+FGr/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 383/849] media: imx258: Fix getting clock frequency
Date:   Mon, 15 Nov 2021 17:57:46 +0100
Message-Id: <20211115165433.204693820@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit d170b0ea1760989fe8ac053bef83e61f3bf87992 ]

Obtain the clock frequency by reading the clock-frequency property if
there's no clock.

Fixes: 9fda25332c4b ("media: i2c: imx258: get clock from device properties and enable it via runtime PM")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx258.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index 81cdf37216ca7..c249507aa2dbc 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -1260,18 +1260,18 @@ static int imx258_probe(struct i2c_client *client)
 		return -ENOMEM;
 
 	imx258->clk = devm_clk_get_optional(&client->dev, NULL);
+	if (IS_ERR(imx258->clk))
+		return dev_err_probe(&client->dev, PTR_ERR(imx258->clk),
+				     "error getting clock\n");
 	if (!imx258->clk) {
 		dev_dbg(&client->dev,
 			"no clock provided, using clock-frequency property\n");
 
 		device_property_read_u32(&client->dev, "clock-frequency", &val);
-		if (val != IMX258_INPUT_CLOCK_FREQ)
-			return -EINVAL;
-	} else if (IS_ERR(imx258->clk)) {
-		return dev_err_probe(&client->dev, PTR_ERR(imx258->clk),
-				     "error getting clock\n");
+	} else {
+		val = clk_get_rate(imx258->clk);
 	}
-	if (clk_get_rate(imx258->clk) != IMX258_INPUT_CLOCK_FREQ) {
+	if (val != IMX258_INPUT_CLOCK_FREQ) {
 		dev_err(&client->dev, "input clock frequency not supported\n");
 		return -EINVAL;
 	}
-- 
2.33.0



