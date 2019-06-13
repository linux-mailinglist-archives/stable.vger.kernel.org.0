Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B614441CF
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391565AbfFMQQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731148AbfFMIlO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:41:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5225921479;
        Thu, 13 Jun 2019 08:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415273;
        bh=ca8hpd4iCLHcAhRM0DE9ZQQoexWnVF4x/YufQSM3HeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlYBAZlE7dPaQOvgb+aabNGv74RQXfQvndRZ9eM+nsuSws7mocZq9GcdfPyIPPrFA
         cNCYDwUv73PLBSXTY7Ua9VFv51Zi5mv7tSQknYU3GGnz9w/EK3/hlwj1wndWDCGvfK
         4dVZM2ghfL4l4FEcXAgEUaT1LoXInkysM4jBSoek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/118] nvmem: sunxi_sid: Support SID on A83T and H5
Date:   Thu, 13 Jun 2019 10:33:23 +0200
Message-Id: <20190613075647.617270423@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit da75b8909756160b8e785104ba421a20b756c975 ]

The device tree binding already lists compatible strings for these two
SoCs. They don't have the defect as seen on the H3, and the size and
register layout is the same as the A64. Furthermore, the driver does
not include nvmem cell definitions.

Add support for these two compatible strings, re-using the config for
the A64.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/sunxi_sid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvmem/sunxi_sid.c b/drivers/nvmem/sunxi_sid.c
index d020f89248fd..69f8e972e29c 100644
--- a/drivers/nvmem/sunxi_sid.c
+++ b/drivers/nvmem/sunxi_sid.c
@@ -235,8 +235,10 @@ static const struct sunxi_sid_cfg sun50i_a64_cfg = {
 static const struct of_device_id sunxi_sid_of_match[] = {
 	{ .compatible = "allwinner,sun4i-a10-sid", .data = &sun4i_a10_cfg },
 	{ .compatible = "allwinner,sun7i-a20-sid", .data = &sun7i_a20_cfg },
+	{ .compatible = "allwinner,sun8i-a83t-sid", .data = &sun50i_a64_cfg },
 	{ .compatible = "allwinner,sun8i-h3-sid", .data = &sun8i_h3_cfg },
 	{ .compatible = "allwinner,sun50i-a64-sid", .data = &sun50i_a64_cfg },
+	{ .compatible = "allwinner,sun50i-h5-sid", .data = &sun50i_a64_cfg },
 	{/* sentinel */},
 };
 MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);
-- 
2.20.1



