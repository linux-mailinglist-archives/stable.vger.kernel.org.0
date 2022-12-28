Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA63F6581C3
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiL1Qbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiL1Qb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4401A3B5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:27:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C66EB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892FCC433EF;
        Wed, 28 Dec 2022 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244840;
        bh=uMPZJZriCIwf8DxTQjTugYFL0BWpn/O0UZhlxTTMv64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xcFqAELUYb24TUGH0plWzrKqa3wcr5r7ig0A/hMPo1xXEi40wnmFs4EKx0meZ9+r8
         yOxEX1GP342c5190/gh68l8gKvbhbxQXcL0MeOeT52N0dodOpdRVRUQ7aCUiM7cc5k
         t1z3Taw1JwxaFqB0DRaJQgODxy5He1+fOEKf1CP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yushan Zhou <katrinzhou@tencent.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0783/1073] rtc: rzn1: Check return value in rzn1_rtc_probe
Date:   Wed, 28 Dec 2022 15:39:31 +0100
Message-Id: <20221228144349.277241441@linuxfoundation.org>
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

From: Yushan Zhou <katrinzhou@tencent.com>

[ Upstream commit 9800f24f7bd5b99fb4fc4ce981427102e2e15a1c ]

The rzn1_rtc_probe() function utilizes devm_pm_runtime_enable()
but wasn't checking the return value. Fix it by adding missing
check.

Fixes: deeb4b5393e1 ("rtc: rzn1: Add new RTC driver")

Signed-off-by: Yushan Zhou <katrinzhou@tencent.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20221107092544.3721053-1-zys.zljxml@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rzn1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rzn1.c b/drivers/rtc/rtc-rzn1.c
index ac788799c8e3..0d36bc50197c 100644
--- a/drivers/rtc/rtc-rzn1.c
+++ b/drivers/rtc/rtc-rzn1.c
@@ -355,7 +355,9 @@ static int rzn1_rtc_probe(struct platform_device *pdev)
 	set_bit(RTC_FEATURE_ALARM_RES_MINUTE, rtc->rtcdev->features);
 	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, rtc->rtcdev->features);
 
-	devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret < 0)
+		return ret;
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
-- 
2.35.1



