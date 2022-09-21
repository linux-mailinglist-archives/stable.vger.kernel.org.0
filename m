Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B99E5C02F7
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiIUP5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiIUP44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:56:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5F19FAA4;
        Wed, 21 Sep 2022 08:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C2E5B830BC;
        Wed, 21 Sep 2022 15:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6046C433D7;
        Wed, 21 Sep 2022 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775420;
        bh=zBQxvedSZUovFjtcv41m8uKjwpkUHyDD8F8y2WLphzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBbjpbVOjDaTBZkiL7ZCo+0Udhy+uLcQVThqWwlxIR1+a6fokVd6YI8f6PkladiEK
         5amopRcfbSitDsTaoLNgZFudqtGDr4V8HASYtcYrcZrBCU5k+lPZyNQN1L0zpCBs2a
         hSXDHU0/s9hijPRZWP3wBfLd5w9146yty+jYo7vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaolei Wang <xiaolei.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/45] regulator: pfuze100: Fix the global-out-of-bounds access in pfuze100_regulator_probe()
Date:   Wed, 21 Sep 2022 17:46:19 +0200
Message-Id: <20220921153647.853857884@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
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
index aa55cfca9e40..a9a0bd918d1e 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -763,7 +763,7 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		((pfuze_chip->chip_id == PFUZE3000) ? "3000" : "3001"))));
 
 	memcpy(pfuze_chip->regulator_descs, pfuze_chip->pfuze_regulators,
-		sizeof(pfuze_chip->regulator_descs));
+		regulator_num * sizeof(struct pfuze_regulator));
 
 	ret = pfuze_parse_regulators_dt(pfuze_chip);
 	if (ret)
-- 
2.35.1



