Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B768650158
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiLRQ2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiLRQ1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:27:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D46614024;
        Sun, 18 Dec 2022 08:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAFF8B803F1;
        Sun, 18 Dec 2022 16:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C42C433EF;
        Sun, 18 Dec 2022 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379815;
        bh=qf0oSLV4E6w5ebS0SOBfjay3IS6Hh2aOO/vzy9pPhyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eULV2OSP48Msm9GF9K3Mv26Rnbtaf5cIFxp+yWb1UXW7MMCf3FXVn7XGeFM2v6TeP
         6R1oPO5FYr5bi8HthmB9qTD6btNoxMDsmxzY9roW2skClteiuAYqxgu749DgpNccqa
         yisWybk/SDV08napnxWzH8B8qpu8Pe+mxAiSHjxdY/ECnTQyFlSW7E2NvNba1f0Jd9
         KmmyPryM48qHz4DOBoqnMPRsYRjz/kc42ah02+OpO3G5qRoNacdGVIS04s8mAhNKvP
         wzyY4/xSIRa5gzWZbFQEmmm6QA6FBQ9KYugO/0JqlQz+mwWLwJNelFlyuAYpru1xnb
         Ik9AjH7J5k35Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Charlene.Liu@amd.com, jerry.zuo@amd.com,
        sancchen@amd.com, jaehyun.chung@amd.com, tales.aparecida@gmail.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 40/73] drm/amd/display: fix array index out of bound error in bios parser
Date:   Sun, 18 Dec 2022 11:07:08 -0500
Message-Id: <20221218160741.927862-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 4fc1ba4aa589ca267468ad23fedef37562227d32 ]

[Why&How]
Firmware headers dictate that gpio_pin array only has a size of 8. The
count returned from vbios however is greater than 8.

Fix this by not using array indexing but incrementing the pointer since
gpio_pin definition in atomfirmware.h is hardcoded to size 8

Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/bios/bios_parser2.c   | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index de3a1f3fd4f1..c98cd7c5b9f7 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -487,6 +487,7 @@ static enum bp_result get_gpio_i2c_info(
 	uint32_t count = 0;
 	unsigned int table_index = 0;
 	bool find_valid = false;
+	struct atom_gpio_pin_assignment *pin;
 
 	if (!info)
 		return BP_RESULT_BADINPUT;
@@ -514,20 +515,17 @@ static enum bp_result get_gpio_i2c_info(
 			- sizeof(struct atom_common_table_header))
 				/ sizeof(struct atom_gpio_pin_assignment);
 
+	pin = (struct atom_gpio_pin_assignment *) header->gpio_pin;
+
 	for (table_index = 0; table_index < count; table_index++) {
-		if (((record->i2c_id & I2C_HW_CAP) == (
-		header->gpio_pin[table_index].gpio_id &
-						I2C_HW_CAP)) &&
-		((record->i2c_id & I2C_HW_ENGINE_ID_MASK)  ==
-		(header->gpio_pin[table_index].gpio_id &
-					I2C_HW_ENGINE_ID_MASK)) &&
-		((record->i2c_id & I2C_HW_LANE_MUX) ==
-		(header->gpio_pin[table_index].gpio_id &
-						I2C_HW_LANE_MUX))) {
+		if (((record->i2c_id & I2C_HW_CAP) 				== (pin->gpio_id & I2C_HW_CAP)) &&
+		    ((record->i2c_id & I2C_HW_ENGINE_ID_MASK)	== (pin->gpio_id & I2C_HW_ENGINE_ID_MASK)) &&
+		    ((record->i2c_id & I2C_HW_LANE_MUX) 		== (pin->gpio_id & I2C_HW_LANE_MUX))) {
 			/* still valid */
 			find_valid = true;
 			break;
 		}
+		pin = (struct atom_gpio_pin_assignment *)((uint8_t *)pin + sizeof(struct atom_gpio_pin_assignment));
 	}
 
 	/* If we don't find the entry that we are looking for then
-- 
2.35.1

