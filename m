Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CBC65838E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbiL1Qsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbiL1QsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:48:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B267C1A061
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:43:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52377B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0BAC433D2;
        Wed, 28 Dec 2022 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245822;
        bh=PgHIFLQWykNcvhfe3hMDbewZPgLYAPZ6EwtqGZ1sCkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjinSAIhvQ9QASLOZi3pxaeIVf6wbSC3KX6hCEqGKa/OfUDG2bS+GovxQigk1S0mV
         VlOXVhYgw6g1FvHUVs+glbL+cnqlzOFekNrTkffyqiDnp2YMQzB2VFj0i1DaAwgZKf
         Yk/LKEBqXynRo844eZk+L1ybmB1xw/ogwYWgBBW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rui Zhang <zr.zhang@vivo.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0964/1073] regulator: core: fix use_count leakage when handling boot-on
Date:   Wed, 28 Dec 2022 15:42:32 +0100
Message-Id: <20221228144354.230955969@linuxfoundation.org>
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

From: Rui Zhang <zr.zhang@vivo.com>

[ Upstream commit 0591b14ce0398125439c759f889647369aa616a0 ]

I found a use_count leakage towards supply regulator of rdev with
boot-on option.

┌───────────────────┐           ┌───────────────────┐
│  regulator_dev A  │           │  regulator_dev B  │
│     (boot-on)     │           │     (boot-on)     │
│    use_count=0    │◀──supply──│    use_count=1    │
│                   │           │                   │
└───────────────────┘           └───────────────────┘

In case of rdev(A) configured with `regulator-boot-on', the use_count
of supplying regulator(B) will increment inside
regulator_enable(rdev->supply).

Thus, B will acts like always-on, and further balanced
regulator_enable/disable cannot actually disable it anymore.

However, B was also configured with `regulator-boot-on', we wish it
could be disabled afterwards.

Signed-off-by: Rui Zhang <zr.zhang@vivo.com>
Link: https://lore.kernel.org/r/20221201033806.2567812-1-zr.zhang@vivo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4a93154bb574..1c1710d367d3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1578,7 +1578,13 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		if (rdev->supply_name && !rdev->supply)
 			return -EPROBE_DEFER;
 
-		if (rdev->supply) {
+		/* If supplying regulator has already been enabled,
+		 * it's not intended to have use_count increment
+		 * when rdev is only boot-on.
+		 */
+		if (rdev->supply &&
+		    (rdev->constraints->always_on ||
+		     !regulator_is_enabled(rdev->supply))) {
 			ret = regulator_enable(rdev->supply);
 			if (ret < 0) {
 				_regulator_put(rdev->supply);
-- 
2.35.1



