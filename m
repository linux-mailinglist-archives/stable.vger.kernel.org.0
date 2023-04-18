Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB25F6E64A2
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjDRMvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjDRMvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:51:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5834716DEC
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A960C63421
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED39C4339C;
        Tue, 18 Apr 2023 12:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822246;
        bh=aR1XZuGzzHdJ7T6DKAe/O9zZFsR7b7IpXFZ3VXf0y5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKswjp2H7SDN7p45kBex0G5zqFh729f/hXcYFWeyV141MEhEvX9WiBhW1THz7bevE
         /6j84bCUFNWl0H6Vt3zUjuCcUxkCoa7uy1J0WFQu4qiQGYa0S5a4B9P684vgyLGltB
         D/4EeE+lrI22jWrDqQ9uxFfelj1vpGraTJKJ/+T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Chris Morgan <macromorgan@hotmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 078/139] power: supply: rk817: Fix unsigned comparison with less than zero
Date:   Tue, 18 Apr 2023 14:22:23 +0200
Message-Id: <20230418120316.778530328@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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



