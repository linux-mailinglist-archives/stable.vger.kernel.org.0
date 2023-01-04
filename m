Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A7D65D784
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbjADPsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239561AbjADPs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:48:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DAE395C5
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:48:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84EB161777
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823BBC433EF;
        Wed,  4 Jan 2023 15:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672847305;
        bh=XoaXby3ub5TwDaIP8syIsqvRy+V+ys5ze0YETlenllc=;
        h=Subject:To:Cc:From:Date:From;
        b=u8VTMbIh+YSKpThn69vf7OIirejJoPDs2xWBx8Ahj17yl8Rxmzl0AM4z1oQy9WYHS
         4PHl7iJIlNdFJYSrIhl5URl+JeUBCw9IJHnO750pvFEij3Zk8I9OazVw7RdbwAMYU/
         pTa0nHhwhXXtAoo6jwfHAN9wAYvAd/L5H+NUKdDg=
Subject: FAILED: patch "[PATCH] drm/amd/pm: enable GPO dynamic control support for SMU13.0.7" failed to apply to 6.0-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:48:21 +0100
Message-ID: <167284730112678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

62b9f835a6c6 ("drm/amd/pm: enable GPO dynamic control support for SMU13.0.7")
a60254d25e48 ("drm/amd/pm: enable runpm support over BACO for SMU13.0.7")
ba2f09960e75 ("drm/amd/pm: fulfill SMU13.0.7 cstate control interface")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 62b9f835a6c60171845642afec4ce4b44865f10f Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Fri, 2 Dec 2022 14:03:45 +0800
Subject: [PATCH] drm/amd/pm: enable GPO dynamic control support for SMU13.0.7

To better support UMD pstate profilings, the GPO feature needs
to be switched on/off accordingly.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index c270f94a1b86..ab1c004606be 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -123,6 +123,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_7_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(SetMGpuFanBoostLimitRpm,	PPSMC_MSG_SetMGpuFanBoostLimitRpm,     0),
 	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
 	MSG_MAP(ArmD3,				PPSMC_MSG_ArmD3,                       0),
+	MSG_MAP(AllowGpo,			PPSMC_MSG_SetGpoAllow,           0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_clk_map[SMU_CLK_COUNT] = {
@@ -1690,6 +1691,7 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_7_set_mp1_state,
 	.set_df_cstate = smu_v13_0_7_set_df_cstate,
+	.gpo_control = smu_v13_0_gpo_control,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)

