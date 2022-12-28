Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B88658127
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiL1QZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiL1QY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6A119C20
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD3461576
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D11CC433D2;
        Wed, 28 Dec 2022 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244513;
        bh=72Wh5J16EpVtZQMTyye0rh1CNnnfej2Qm+l0VhW9Oa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lWoQGhgUp+1+H1dSIAs8itZQhJhs30cScK/Y52u82XdU3Zp0js8ehGZOOfkQGHBx
         gNEgVcaTxvWPIHB6P3owftsbWV0jI8cGOp/TIpHVUDH+OHuyQWK2sSkPcu9Nta19b3
         rqopABrYl5hg9pcXYQ5xulF33/hM+QX1gaiRx3/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jacky Bai <ping.bai@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0725/1073] thermal/drivers/imx8mm_thermal: Validate temperature range
Date:   Wed, 28 Dec 2022 15:38:33 +0100
Message-Id: <20221228144347.717810329@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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



