Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3235FD24C
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiJMBMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiJMBMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:12:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7264820F6D;
        Wed, 12 Oct 2022 18:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 825EBB81CE0;
        Thu, 13 Oct 2022 00:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5C1C43470;
        Thu, 13 Oct 2022 00:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620531;
        bh=PyVuP224LTfOgKeY7PGhWDcswJIc+RIZ/ujbhn1tRm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Apuzfq2o3dVGAL/h9ff872ADhhoXCXnopvUAR3BHZCxNdZAl9GNp+otd4UdDY9vrB
         TiFfLifCP8117RMNzsdogxQTPMasontqmFqKSp8Q4VnsjB9r2kxn7VV9ZXeU3nU7zZ
         CI+P0SczssHSjOuuj5Gp/Y415i/stl4Q03klY/5CjI6L5jYbJOclJORyIhoCFGQVYG
         bzMmG2qC82hJ3ys/WSB8SbR30FG9iEhbEQVKtBvTjDvpwdfeM+WwWboUPKzGSKXdAo
         3dMxoBuGjHoF0uwyN+ItMakv50Fa6/ZzADhgERJ0/SkcyGyedbkZvvyY4xJoV0v+R4
         eP9LMxiSc2ubQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, Michael.Hennerich@analog.com,
        sre@kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/47] power: supply: adp5061: fix out-of-bounds read in adp5061_get_chg_type()
Date:   Wed, 12 Oct 2022 20:20:48 -0400
Message-Id: <20221013002124.1894077-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
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
index 003557043ab3..daee1161c305 100644
--- a/drivers/power/supply/adp5061.c
+++ b/drivers/power/supply/adp5061.c
@@ -427,11 +427,11 @@ static int adp5061_get_chg_type(struct adp5061_state *st,
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

