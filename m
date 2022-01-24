Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3BE49A257
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365688AbiAXXv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382761AbiAXWjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F52C055A86;
        Mon, 24 Jan 2022 13:03:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9154612E9;
        Mon, 24 Jan 2022 21:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D81C340E5;
        Mon, 24 Jan 2022 21:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058202;
        bh=m3XBgkr5Z/eZ+k0EKJIVJa2TImDNP6ACO8ML6NlEFfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gl8ToutV+KciDEVy05OELQXOpXczPqncKGipM0z3OsLWJyswe8OVtYWVRtJj7UbW1
         iOtgtkBslhbpxEdps0UTmfbALmYp4bsjcmILp3WxqnJkTfl6WRgxy43uCFqclpALko
         xxF1E/C97nGUZDpcefnBVuqaP8hDLDCPsXKMYQ2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Gerber <Paul.Gerber@tq-group.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0212/1039] thermal/drivers/imx8mm: Enable ADC when enabling monitor
Date:   Mon, 24 Jan 2022 19:33:21 +0100
Message-Id: <20220124184132.463403607@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



