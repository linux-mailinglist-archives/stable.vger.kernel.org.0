Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547145FD1F0
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiJMA5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiJMA43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:56:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E621BD119;
        Wed, 12 Oct 2022 17:53:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC7C0616E0;
        Thu, 13 Oct 2022 00:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEFCC4347C;
        Thu, 13 Oct 2022 00:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620790;
        bh=ksRKJY5TQUMx/Q1CSvNcnmyPvkMbckLSJ11m16BwXMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yo79oo7vuqiO+YbIAT9zsZL+svnonnCNL6p7/4nh7shAS9usoFB+ZhU6lTg6tmlN8
         gEblXpHJtN79VoSHkCWyLzWtBTJMuvKZffckl8JJ/g1QQ4R5R9HM3L8eA98Fj5+7yY
         8T9kOtcQrQg46GxD8iVcBciAyp6tSvDU7pC39g5djLYFWV2BW4UJ4WN2YBRqSwADf8
         IUC9b0cuvL7BSSKUSlqsBdV3C1z4LcnbrKl5MB/eLKUm0NQnUB0sUGejrZ4N/Xc9S6
         Y1QZoWifduDjqBRTydmDdfOhrpM4X8eSPHH2RS6RZJq6QJrzAmlphJxuvgjvdv4tvZ
         RXcURX1g6GZRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, Michael.Hennerich@analog.com,
        sre@kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/19] power: supply: adp5061: fix out-of-bounds read in adp5061_get_chg_type()
Date:   Wed, 12 Oct 2022 20:26:03 -0400
Message-Id: <20221013002623.1895576-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002623.1895576-1-sashal@kernel.org>
References: <20221013002623.1895576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 9d47e01b9d807808224347935562f7043a358054 ]

ADP5061_CHG_STATUS_1_CHG_STATUS is masked with 0x07, which means a length
of 8, but adp5061_chg_type array size is 4, may end up reading 4 elements
beyond the end of the adp5061_chg_type[] array.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/adp5061.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/adp5061.c b/drivers/power/supply/adp5061.c
index 939fd3d8fb1a..1ad044330599 100644
--- a/drivers/power/supply/adp5061.c
+++ b/drivers/power/supply/adp5061.c
@@ -428,11 +428,11 @@ static int adp5061_get_chg_type(struct adp5061_state *st,
 	if (ret < 0)
 		return ret;
 
-	chg_type = adp5061_chg_type[ADP5061_CHG_STATUS_1_CHG_STATUS(status1)];
-	if (chg_type > ADP5061_CHG_FAST_CV)
+	chg_type = ADP5061_CHG_STATUS_1_CHG_STATUS(status1);
+	if (chg_type >= ARRAY_SIZE(adp5061_chg_type))
 		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
 	else
-		val->intval = chg_type;
+		val->intval = adp5061_chg_type[chg_type];
 
 	return ret;
 }
-- 
2.35.1

