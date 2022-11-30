Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4B963DEA9
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiK3Sjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiK3Sj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:39:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A3B9702A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:39:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F7F061D61
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B75AC433C1;
        Wed, 30 Nov 2022 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833562;
        bh=gF8aaP9WpcIBEagXhF9SJqQyp67+oR/CbMheHWlgdik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVgGuqvxSuNOTzqlCTt3r7H4vMi4232/sOB71osRIshfeCAl0RtM9F+EY6/JWdi8Y
         RVssL2WZDhW5GDDV/LTsvdXzE58mUjDh9fcC4+PuB4aPmMDNQl3VXTa5gE7alAMcfa
         KI0HzdaFKLAgUQ2WYdNlByHY0rPpw8n3yXGOaIF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Kemnade <andreas@kemnade.info>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/206] regulator: twl6030: re-add TWL6032_SUBCLASS
Date:   Wed, 30 Nov 2022 19:22:46 +0100
Message-Id: <20221130180535.944068022@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 3d6c982b26db94cc21bc9f7784f63e8286b7be62 ]

In former times, info->feature was populated via the parent driver
by pdata/regulator_init_data->driver_data for all regulators when
USB_PRODUCT_ID_LSB indicates a TWL6032.
Today, the information is not set, so re-add it at the regulator
definitions.

Fixes: 25d82337705e2 ("regulator: twl: make driver DT only")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20221120221208.3093727-2-andreas@kemnade.info
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/twl6030-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/twl6030-regulator.c b/drivers/regulator/twl6030-regulator.c
index 430265c404d6..7c7e3648ea4b 100644
--- a/drivers/regulator/twl6030-regulator.c
+++ b/drivers/regulator/twl6030-regulator.c
@@ -530,6 +530,7 @@ static const struct twlreg_info TWL6030_INFO_##label = { \
 #define TWL6032_ADJUSTABLE_LDO(label, offset) \
 static const struct twlreg_info TWL6032_INFO_##label = { \
 	.base = offset, \
+	.features = TWL6032_SUBCLASS, \
 	.desc = { \
 		.name = #label, \
 		.id = TWL6032_REG_##label, \
@@ -562,6 +563,7 @@ static const struct twlreg_info TWLFIXED_INFO_##label = { \
 #define TWL6032_ADJUSTABLE_SMPS(label, offset) \
 static const struct twlreg_info TWLSMPS_INFO_##label = { \
 	.base = offset, \
+	.features = TWL6032_SUBCLASS, \
 	.desc = { \
 		.name = #label, \
 		.id = TWL6032_REG_##label, \
-- 
2.35.1



