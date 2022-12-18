Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB0765029E
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiLRQtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiLRQrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:47:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180C7193F0;
        Sun, 18 Dec 2022 08:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F83AB803F1;
        Sun, 18 Dec 2022 16:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F082C433D2;
        Sun, 18 Dec 2022 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380254;
        bh=xFRUKXf8zJ06rIVt1mya4gNo6gCbDNxsXQS9kxIiydU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrDLImXX/oj1CMSzvHIk4aQv7CNDSH39EAmlEzvEO/3IAgjOwotwNfo+7HWHlKZuX
         2zIvgPNZiIzc1HL1styt9+dROOtvfo36DE6jWIfvdpuRD23SIIhmJTT2r3RGM4ZxEg
         N8tIBjiHtxRJragj6HCnDivO1F9i09xJ2tTDvNeo3nU2Dvs0dF0VLUi7PqsCHaHVhc
         KvlbuswwRyMe+2/2EzhQMsRhMi02Gf3/OT2euNEj0DmE+gCga+LZDbFWDR2K+vfr5k
         6L131ommZP2Ws9XGBTlaKOFMzF2nzisiRiUmAH5UHMcOgWsBIo0mJhOznVYsmLXWRU
         NCO3KtKGnV8EQ==
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
        daniel@ffwll.ch, Charlene.Liu@amd.com, sancchen@amd.com,
        jaehyun.chung@amd.com, tales.aparecida@gmail.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 24/39] drm/amd/display: fix array index out of bound error in bios parser
Date:   Sun, 18 Dec 2022 11:15:44 -0500
Message-Id: <20221218161559.932604-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
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
index 29d64e7e304f..930d2b7d3448 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -352,6 +352,7 @@ static enum bp_result get_gpio_i2c_info(
 	uint32_t count = 0;
 	unsigned int table_index = 0;
 	bool find_valid = false;
+	struct atom_gpio_pin_assignment *pin;
 
 	if (!info)
 		return BP_RESULT_BADINPUT;
@@ -379,20 +380,17 @@ static enum bp_result get_gpio_i2c_info(
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

