Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBBF541A68
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379634AbiFGVcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380857AbiFGVbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:31:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1B322BAE9;
        Tue,  7 Jun 2022 12:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 265756159D;
        Tue,  7 Jun 2022 19:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA9DC385A5;
        Tue,  7 Jun 2022 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628611;
        bh=ccEUHQQy2f2V9AzPwFK1n2OW3NKEul9X0Jjqw9iaasc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBe/bxuLKvu1TFLkSQzFUoN9ub1Rb4iSzOfoi1fRuGIe724lBcoJFumTw1Xb7PEOU
         4QKoo84HSNCW346V3/Xl7rtJudCGVnzfqAmruzFWuGyFQ3NX6GGFsDMUhnIeaWoRua
         wVO73FladzqKLdPhm8p+smofQyDh8CtgJy7m3Qzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 392/879] regulator: core: Fix enable_count imbalance with EXCLUSIVE_GET
Date:   Tue,  7 Jun 2022 18:58:30 +0200
Message-Id: <20220607165014.243054831@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit c3e3ca05dae37f8f74bb80358efd540911cbc2c8 ]

Since the introduction of regulator->enable_count, a driver that did
an exclusive get on an already-enabled regulator would end up with
enable_count initialized to 0 but rdev->use_count initialized to 1.
With that starting point the regulator is effectively stuck enabled,
because if the driver attempted to disable it it would fail the
enable_count underflow check in _regulator_handle_consumer_disable().

The EXCLUSIVE_GET path in _regulator_get() now initializes
enable_count along with rdev->use_count so that the regulator can be
disabled without underflowing the former.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 5451781dadf85 ("regulator: core: Only count load for enabled consumers")
Link: https://lore.kernel.org/r/20220505043152.12933-1-zev@bewilderbeest.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d2553970a67b..c4d844ffad7a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2133,10 +2133,13 @@ struct regulator *_regulator_get(struct device *dev, const char *id,
 		rdev->exclusive = 1;
 
 		ret = _regulator_is_enabled(rdev);
-		if (ret > 0)
+		if (ret > 0) {
 			rdev->use_count = 1;
-		else
+			regulator->enable_count = 1;
+		} else {
 			rdev->use_count = 0;
+			regulator->enable_count = 0;
+		}
 	}
 
 	link = device_link_add(dev, &rdev->dev, DL_FLAG_STATELESS);
-- 
2.35.1



