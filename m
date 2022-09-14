Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4045B845B
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiINJLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiINJKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C2D474DF;
        Wed, 14 Sep 2022 02:04:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 877E8619FA;
        Wed, 14 Sep 2022 09:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFD5C433D7;
        Wed, 14 Sep 2022 09:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146291;
        bh=2YZt6lz7tU1V8iW8HrYMLHuVmrN2pRWPTF9rV2BqSZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sungpkZRVrDiq8M+ZfBtkOvqFLSfAEfW5zhkhK1KCgPtDvRnxz7Ta7UYOxEqKE1SP
         +DcuDkL7h5shfHzyL37us6VCRg5sPiaDZf7hMtBqXyECoYxyc982gPRUtF19hDZWfw
         jisGQwEzehKnVBXlc0kDjI2qHBM+z7u8V4TC4ZB+p/eduwEL1zouMXz/1OnqmzJ/vS
         OLcnBwpFX621FYYvRSu1MkQsGS+yvLIhKUuEoRfA8GdlRDPQK/pEPvrnfYIUIcGfMH
         QLIFtsh7A9jf17HPOF5on6CuwzAebC+tZZLAOWhCF8wquJQVVnYrZ9kB0QynuaA7Vd
         KyfLLJOW6oZcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaolei Wang <xiaolei.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 4.19 2/9] regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()
Date:   Wed, 14 Sep 2022 05:04:36 -0400
Message-Id: <20220914090445.471489-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090445.471489-1-sashal@kernel.org>
References: <20220914090445.471489-1-sashal@kernel.org>
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
index 8b1940110561a..b1d73a6c7809e 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -710,7 +710,7 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		((pfuze_chip->chip_id == PFUZE3000) ? "3000" : "3001"))));
 
 	memcpy(pfuze_chip->regulator_descs, pfuze_chip->pfuze_regulators,
-		sizeof(pfuze_chip->regulator_descs));
+		regulator_num * sizeof(struct pfuze_regulator));
 
 	ret = pfuze_parse_regulators_dt(pfuze_chip);
 	if (ret)
-- 
2.35.1

