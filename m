Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118FC4999D1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456095AbiAXVhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377826AbiAXV3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:29:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D228EC0AD194;
        Mon, 24 Jan 2022 12:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53E3CB81229;
        Mon, 24 Jan 2022 20:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE95C340E5;
        Mon, 24 Jan 2022 20:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055555;
        bh=m3XBgkr5Z/eZ+k0EKJIVJa2TImDNP6ACO8ML6NlEFfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bM/I6KqEuK879SFWOOtXkxPEezHsXY+6MDIY8pEk0b0OCFCUGOgLkMds4JEXRq0jh
         7lUvLgXeb+Tx2RYYf/ZEmn3wvEHTVqQLo5JLVHXtsfD1ZPBsLUlD1JD39LB+obNMOn
         kl8lhqLkTgdgpo8C59gpfNFU81ZL2po5UtQpwzxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Gerber <Paul.Gerber@tq-group.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/846] thermal/drivers/imx8mm: Enable ADC when enabling monitor
Date:   Mon, 24 Jan 2022 19:34:59 +0100
Message-Id: <20220124184107.256945987@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Gerber <Paul.Gerber@tq-group.com>

[ Upstream commit 3de89d8842a2b5d3dd22ebf97dd561ae0a330948 ]

The i.MX 8MP has a ADC_PD bit in the TMU_TER register that controls the
operating mode of the ADC:
* 0 means normal operating mode
* 1 means power down mode

When enabling/disabling the TMU, the ADC operating mode must be set
accordingly.

i.MX 8M Mini & Nano are lacking this bit.

Signed-off-by: Paul Gerber <Paul.Gerber@tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Fixes: 2b8f1f0337c5 ("thermal: imx8mm: Add i.MX8MP support")
Link: https://lore.kernel.org/r/20211122114225.196280-1-alexander.stein@ew.tq-group.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx8mm_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/imx8mm_thermal.c b/drivers/thermal/imx8mm_thermal.c
index 7442e013738f8..af666bd9e8d4d 100644
--- a/drivers/thermal/imx8mm_thermal.c
+++ b/drivers/thermal/imx8mm_thermal.c
@@ -21,6 +21,7 @@
 #define TPS			0x4
 #define TRITSR			0x20	/* TMU immediate temp */
 
+#define TER_ADC_PD		BIT(30)
 #define TER_EN			BIT(31)
 #define TRITSR_TEMP0_VAL_MASK	0xff
 #define TRITSR_TEMP1_VAL_MASK	0xff0000
@@ -113,6 +114,8 @@ static void imx8mm_tmu_enable(struct imx8mm_tmu *tmu, bool enable)
 
 	val = readl_relaxed(tmu->base + TER);
 	val = enable ? (val | TER_EN) : (val & ~TER_EN);
+	if (tmu->socdata->version == TMU_VER2)
+		val = enable ? (val & ~TER_ADC_PD) : (val | TER_ADC_PD);
 	writel_relaxed(val, tmu->base + TER);
 }
 
-- 
2.34.1



