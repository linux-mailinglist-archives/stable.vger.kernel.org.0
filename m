Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381EC5B844E
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiINJJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiINJIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:08:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABABD79ECE;
        Wed, 14 Sep 2022 02:04:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 84589CE1101;
        Wed, 14 Sep 2022 09:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FC6C433D7;
        Wed, 14 Sep 2022 09:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146253;
        bh=YDVy9tBHpLFp869px3Jz1U1vwmMkEuxizv0X52HH23I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFgM57QYMR0QCtJkJIcj+MELSfeoduMaO91glqYD6TuzIjFTbL+kdwDXhMpQKdG5S
         Bbj/CvNPL4TAq3Ax0bXL9XmmTjVMXTh3H/R37WAWkrwqaF3Qf7KLsmNfhMJyw49hJM
         xvE9zIlHlekB4RL9s0ggT8VBrzdWcx6TIV1TLGdBK7iyBI/3T8pYNlxsSyN+vGicjK
         Xft74SgnBq/d5JIeXbETmjY9CqLGhvWH3/2OgvX9MT0HDYr5T0eNy2YMhgm31X8NZh
         DyhMTP8PwlvtmH/9beLDbhmwaAnbFWghc0dMqAHMyRo1fhELo4GHk/QPVeDdEioG2Y
         UWzAXFf65lBLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaolei Wang <xiaolei.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 5.4 02/12] regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()
Date:   Wed, 14 Sep 2022 05:03:55 -0400
Message-Id: <20220914090407.471328-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090407.471328-1-sashal@kernel.org>
References: <20220914090407.471328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 78e1e867f44e6bdc72c0e6a2609a3407642fb30b ]

The pfuze_chip::regulator_descs is an array of size
PFUZE100_MAX_REGULATOR, the pfuze_chip::pfuze_regulators
is the pointer to the real regulators of a specific device.
The number of real regulator is supposed to be less than
the PFUZE100_MAX_REGULATOR, so we should use the size of
'regulator_num * sizeof(struct pfuze_regulator)' in memcpy().
This fixes the out of bounds access bug reported by KASAN.

Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Link: https://lore.kernel.org/r/20220825111922.1368055-1-xiaolei.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pfuze100-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index f873d97100e28..13609942d45c0 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -788,7 +788,7 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		((pfuze_chip->chip_id == PFUZE3000) ? "3000" : "3001"))));
 
 	memcpy(pfuze_chip->regulator_descs, pfuze_chip->pfuze_regulators,
-		sizeof(pfuze_chip->regulator_descs));
+		regulator_num * sizeof(struct pfuze_regulator));
 
 	ret = pfuze_parse_regulators_dt(pfuze_chip);
 	if (ret)
-- 
2.35.1

