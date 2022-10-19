Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE2F604236
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbiJSK4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiJSK4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:56:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C942B76756;
        Wed, 19 Oct 2022 03:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41D96B824C1;
        Wed, 19 Oct 2022 09:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C18C433D7;
        Wed, 19 Oct 2022 09:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170666;
        bh=pP8jj1BLaAqsUYAH8uUEPMkH+VEo8jVb7LcvIKD0S1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCprGu7Ba2xwEjihypSobcR9TNEKpi8lspjLhQqW5xNj7ShbK5+2o1IxaKXQrb9ZZ
         MvJJ/soMtByPPiZa/YGucilwDQnUwoqEI/f3uJ2i7AA6B0ypJTR7MLXhqPw6QdSVRz
         00CLQJQRCdo1F96LcUJXxYJYyXCOn3NGIrdYYDBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        sunliming <sunliming@kylinos.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 740/862] drm/amd/display: Fix variable dereferenced before check
Date:   Wed, 19 Oct 2022 10:33:47 +0200
Message-Id: <20221019083322.652970141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: sunliming <sunliming@kylinos.cn>

[ Upstream commit 45a92f45f4578ff89da7dc5ef50bab4ef870f3b7 ]

Fixes the following smatch warning:

drivers/gpu/drm/amd/amdgpu/../display/dc/dc_dmub_srv.c:311 dc_dmub_srv_p_state_delegate()
warn: variable dereferenced before check 'dc' (see line 309)

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: sunliming <sunliming@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 76c05ff12e95..755c4f9de6da 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -323,11 +323,13 @@ bool dc_dmub_srv_p_state_delegate(struct dc *dc, bool should_manage_pstate, stru
 	struct dmub_cmd_fw_assisted_mclk_switch_config *config_data = &cmd.fw_assisted_mclk_switch.config_data;
 	int i = 0;
 	int ramp_up_num_steps = 1; // TODO: Ramp is currently disabled. Reenable it.
-	uint8_t visual_confirm_enabled = dc->debug.visual_confirm == VISUAL_CONFIRM_FAMS;
+	uint8_t visual_confirm_enabled;
 
 	if (dc == NULL)
 		return false;
 
+	visual_confirm_enabled = dc->debug.visual_confirm == VISUAL_CONFIRM_FAMS;
+
 	// Format command.
 	cmd.fw_assisted_mclk_switch.header.type = DMUB_CMD__FW_ASSISTED_MCLK_SWITCH;
 	cmd.fw_assisted_mclk_switch.header.sub_type = DMUB_CMD__FAMS_SETUP_FW_CTRL;
-- 
2.35.1



