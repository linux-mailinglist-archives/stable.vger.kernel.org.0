Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41D73D29CA
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhGVQGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234944AbhGVQFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7D7361976;
        Thu, 22 Jul 2021 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972358;
        bh=Ba38WJGVqGtC8P5d4zPWnHTztyf1aMSimuHwSDGgzEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7w4+7jVKnu/bqCIToLz3l6GRCdSndWRmMeGxUfRQgfYUhd7uMTTEFVVEkvUiREV4
         2c4fuLdO4988hqp7rxs0fyzHvv0VeXvwOh7mGq3w7YtKQ+O4wNRP3dEzcP4aohDTv+
         3kCb1T+jF+VCgpR57owJHo90ogHDpS5DO9KE5g+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jacky Bai <ping.bai@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 084/156] thermal/drivers/imx_sc: Add missing of_node_put for loop iteration
Date:   Thu, 22 Jul 2021 18:30:59 +0200
Message-Id: <20210722155631.106287973@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 3da97620e8d60da4a7eaae46e03e0a494780642d ]

Early exits from for_each_available_child_of_node() should decrement the
node reference counter.  Reported by Coccinelle:

  drivers/thermal/imx_sc_thermal.c:93:1-33: WARNING:
    Function "for_each_available_child_of_node" should have of_node_put() before return around line 97.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210614192230.19248-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx_sc_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/imx_sc_thermal.c b/drivers/thermal/imx_sc_thermal.c
index b01d28eca7ee..8d76dbfde6a9 100644
--- a/drivers/thermal/imx_sc_thermal.c
+++ b/drivers/thermal/imx_sc_thermal.c
@@ -93,6 +93,7 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 	for_each_available_child_of_node(np, child) {
 		sensor = devm_kzalloc(&pdev->dev, sizeof(*sensor), GFP_KERNEL);
 		if (!sensor) {
+			of_node_put(child);
 			of_node_put(sensor_np);
 			return -ENOMEM;
 		}
@@ -104,6 +105,7 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"failed to get valid sensor resource id: %d\n",
 				ret);
+			of_node_put(child);
 			break;
 		}
 
@@ -114,6 +116,7 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 		if (IS_ERR(sensor->tzd)) {
 			dev_err(&pdev->dev, "failed to register thermal zone\n");
 			ret = PTR_ERR(sensor->tzd);
+			of_node_put(child);
 			break;
 		}
 
-- 
2.30.2



