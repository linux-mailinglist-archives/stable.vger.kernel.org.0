Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99696577FA
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiL1Oo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiL1OoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:44:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABDB1180C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:44:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E42C61546
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DD8C433D2;
        Wed, 28 Dec 2022 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238655;
        bh=+SGHovUhicUyzRVSYbhREA5wQ7waYV9MqGbs67oe5og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8gG2JW+EbA+DE+HRtj2LThzKGYL+T1DJCeQJBVLhwx4cWnviPAO9go6zgoayZynw
         jvrtZ3WWD0x79Bcq3Eh7ls+MY8JN1txGV/qFve0MJ4syug97OVjfDNi2YU3xq1AJMg
         0f9UzDAov8At6EIiT8JgJu0Wc/uWsjof89ihS/5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jun Lei <Jun.Lei@amd.com>,
        Agustin Gutierrez <agustin.gutierrez@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 001/731] drm/amd/display: Manually adjust strobe for DCN303
Date:   Wed, 28 Dec 2022 15:31:48 +0100
Message-Id: <20221228144256.582212708@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Martin Leung <Martin.Leung@amd.com>

commit a9a1ac44074ff8cab7d519277f93341e14557f83 upstream.

why:
DCN303's 4 channel SOC BB causes problems at strobe

how:
workaround to manually adjust strobe calculation using FCLK
restrict.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c
@@ -1344,6 +1344,20 @@ void dcn303_update_bw_bounding_box(struc
 			dcn3_03_soc.clock_limits[i].phyclk_d18_mhz = dcn3_03_soc.clock_limits[0].phyclk_d18_mhz;
 			dcn3_03_soc.clock_limits[i].dscclk_mhz = dcn3_03_soc.clock_limits[0].dscclk_mhz;
 		}
+
+		// WA: patch strobe modes to compensate for DCN303 BW issue
+		if (dcn3_03_soc.num_chans <= 4) {
+			for (i = 0; i < dcn3_03_soc.num_states; i++) {
+				if (dcn3_03_soc.clock_limits[i].dram_speed_mts > 1700)
+					break;
+
+				if (dcn3_03_soc.clock_limits[i].dram_speed_mts >= 1500) {
+					dcn3_03_soc.clock_limits[i].dcfclk_mhz = 100;
+					dcn3_03_soc.clock_limits[i].fabricclk_mhz = 100;
+				}
+			}
+		}
+
 		/* re-init DML with updated bb */
 		dml_init_instance(&dc->dml, &dcn3_03_soc, &dcn3_03_ip, DML_PROJECT_DCN30);
 		if (dc->current_state)


