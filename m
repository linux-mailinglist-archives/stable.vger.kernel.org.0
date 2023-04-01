Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76086D2C8C
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjDABlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjDABlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:41:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2281D861;
        Fri, 31 Mar 2023 18:41:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCEA62CE0;
        Sat,  1 Apr 2023 01:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5774BC4339E;
        Sat,  1 Apr 2023 01:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313294;
        bh=aR1XZuGzzHdJ7T6DKAe/O9zZFsR7b7IpXFZ3VXf0y5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/hvPxal5v+6+c/iRbc+1AMfMY7oFkptB2TZYl+V+seUbsAjSTpSFR4QpE3gyZehh
         eDd1eT7UOHiP8HvBoNFQcHGaznC5iiGKjnXkII0E92B4YoWpAJ4YgQBbkkvn8Zi3ZJ
         yxxJzIwxvBC1AafY0V99jIgqZGp59LR34TAjbh055NCdveFtKR8bn3WZNpP5mRQOxZ
         JFchehckl4nI69PP6Ey2s2+C4M0TMZCsb67Rk8c4DHFLoYjUPWpzRhspud5bfKHvUi
         TyFUGDd983wJq0wG1IpEuOQF7//QP72G7P3HiFZJVMo4bSzj+Cb43ufA+lIVtbHV5W
         vHYENLuor7y9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Chris Morgan <macromorgan@hotmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, sre@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 04/25] power: supply: rk817: Fix unsigned comparison with less than zero
Date:   Fri, 31 Mar 2023 21:41:02 -0400
Message-Id: <20230401014126.3356410-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 3268a4d9b0b85a4382e93bdf7be5400a73db74c5 ]

The tmp is defined as u32 type, which results in invalid processing of
tmp<0 in function rk817_read_or_set_full_charge_on_boot(). Therefore,
drop the comparison.

drivers/power/supply/rk817_charger.c:828 rk817_read_or_set_full_charge_on_boot() warn: unsigned 'tmp' is never less than zero.
drivers/power/supply/rk817_charger.c:788 rk817_read_or_set_full_charge_on_boot() warn: unsigned 'tmp' is never less than zero.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3444
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rk817_charger.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/power/supply/rk817_charger.c b/drivers/power/supply/rk817_charger.c
index 4f9c1c4179165..36f807b5ec442 100644
--- a/drivers/power/supply/rk817_charger.c
+++ b/drivers/power/supply/rk817_charger.c
@@ -785,8 +785,6 @@ rk817_read_or_set_full_charge_on_boot(struct rk817_charger *charger,
 		regmap_bulk_read(rk808->regmap, RK817_GAS_GAUGE_Q_PRES_H3,
 				 bulk_reg, 4);
 		tmp = get_unaligned_be32(bulk_reg);
-		if (tmp < 0)
-			tmp = 0;
 		boot_charge_mah = ADC_TO_CHARGE_UAH(tmp,
 						    charger->res_div) / 1000;
 		/*
@@ -825,8 +823,6 @@ rk817_read_or_set_full_charge_on_boot(struct rk817_charger *charger,
 	regmap_bulk_read(rk808->regmap, RK817_GAS_GAUGE_Q_PRES_H3,
 			 bulk_reg, 4);
 	tmp = get_unaligned_be32(bulk_reg);
-	if (tmp < 0)
-		tmp = 0;
 	boot_charge_mah = ADC_TO_CHARGE_UAH(tmp, charger->res_div) / 1000;
 	regmap_bulk_read(rk808->regmap, RK817_GAS_GAUGE_OCV_VOL_H,
 			 bulk_reg, 2);
-- 
2.39.2

