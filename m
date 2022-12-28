Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F1A6581E3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiL1QcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiL1Qbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77CA1CFF4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64DE961577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A4BC433F0;
        Wed, 28 Dec 2022 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244895;
        bh=hRW9FyDOEip1L7nZFeWu0VklpZ7h7VisU1wMe/hu+5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJIAMLB5Dlb8Hl6v7r7mV+9ZsDYJF3Q32mwLmTOA+6M3N4Z129eEUJTAAXrmUqDlH
         DpnYSOaSB/+onfH/wHqQfpiBJ/zqr/7wWtStexvt7l+J3RDb0a4uVMrfNb8LcmtoiK
         las/hciK3RLJMfaWlxuGYdaa/7yAKR8EmeIVCbTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jacky Bai <ping.bai@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0749/1146] thermal/drivers/imx8mm_thermal: Validate temperature range
Date:   Wed, 28 Dec 2022 15:38:08 +0100
Message-Id: <20221228144350.490526676@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index e2c2673025a7..258d988b266d 100644
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



