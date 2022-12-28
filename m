Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429B5657C84
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiL1Pdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiL1PdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B44415FE9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A3E8B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D5FC433D2;
        Wed, 28 Dec 2022 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241594;
        bh=72Wh5J16EpVtZQMTyye0rh1CNnnfej2Qm+l0VhW9Oa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uw2vUXu0PdeaBQsGW6UUKpdS1HB9KZuBD2JDdhT8RyCgpiSBxSEN3eDKC6R9J9rib
         W8+iv/+OwazMM98BNn9cSramqZtsuZdZTzJc2rR7LM2GpgoqwUIGClQ1LoeES5SDFC
         6sTLzJ9oz+iGpgtXbQ8RCDw2yK4uX2qAJkqliPaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jacky Bai <ping.bai@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 500/731] thermal/drivers/imx8mm_thermal: Validate temperature range
Date:   Wed, 28 Dec 2022 15:40:07 +0100
Message-Id: <20221228144311.041052589@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit d37edc7370273306d8747097fafa62436c1cfe16 ]

Check against the upper temperature limit (125 degrees C) before
consider the temperature valid.

Fixes: 5eed800a6811 ("thermal: imx8mm: Add support for i.MX8MM thermal monitoring unit")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Link: https://lore.kernel.org/r/20221014073507.1594844-1-marcus.folkesson@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx8mm_thermal.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/imx8mm_thermal.c b/drivers/thermal/imx8mm_thermal.c
index af666bd9e8d4..c5cd873c6e01 100644
--- a/drivers/thermal/imx8mm_thermal.c
+++ b/drivers/thermal/imx8mm_thermal.c
@@ -65,8 +65,14 @@ static int imx8mm_tmu_get_temp(void *data, int *temp)
 	u32 val;
 
 	val = readl_relaxed(tmu->base + TRITSR) & TRITSR_TEMP0_VAL_MASK;
+
+	/*
+	 * Do not validate against the V bit (bit 31) due to errata
+	 * ERR051272: TMU: Bit 31 of registers TMU_TSCR/TMU_TRITSR/TMU_TRATSR invalid
+	 */
+
 	*temp = val * 1000;
-	if (*temp < VER1_TEMP_LOW_LIMIT)
+	if (*temp < VER1_TEMP_LOW_LIMIT || *temp > VER2_TEMP_HIGH_LIMIT)
 		return -EAGAIN;
 
 	return 0;
-- 
2.35.1



