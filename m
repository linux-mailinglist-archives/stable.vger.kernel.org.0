Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C96D6CC3A6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjC1O4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbjC1O4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E3CD33A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:56:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 974F3617E5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8343C433D2;
        Tue, 28 Mar 2023 14:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015361;
        bh=XbwN+S4KYNpS5LdLYhLJPSHq8DBwjVmLhxw6O7R1Rxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqui/8YjKmEET+jhSI/pJXrziOXzQRaC7yR/6AdmhODxKOrYOHFwrnXd+SpnGDZ2s
         1dk9a0LVfp2TD92y1ktMfnXbpFqKR5h/0ueGKbU1PP/csyKnG/Nv2GmKiR7tUIR2k/
         +0jMGtPa/5iic7FJxITMSwpgZ3UO+Uuu681dwCMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Cruise Hung <Cruise.Hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/224] drm/amd/display: Fix DP MST sinks removal issue
Date:   Tue, 28 Mar 2023 16:40:09 +0200
Message-Id: <20230328142617.811427477@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cruise Hung <Cruise.Hung@amd.com>

[ Upstream commit cbd6c1b17d3b42b7935526a86ad5f66838767d03 ]

[Why]
In USB4 DP tunneling, it's possible to have this scenario that
the path becomes unavailable and CM tears down the path a little bit late.
So, in this case, the HPD is high but fails to read any DPCD register.
That causes the link connection type to be set to sst.
And not all sinks are removed behind the MST branch.

[How]
Restore the link connection type if it fails to read DPCD register.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Cruise Hung <Cruise.Hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cbd6c1b17d3b42b7935526a86ad5f66838767d03)
Modified for stable backport as a lot of the code in this file was moved
in 6.3 to drivers/gpu/drm/amd/display/dc/link/link_detection.c.
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 328c5e33cc66b..bf7fcd268cb47 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1016,6 +1016,7 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 	struct dc_sink *prev_sink = NULL;
 	struct dpcd_caps prev_dpcd_caps;
 	enum dc_connection_type new_connection_type = dc_connection_none;
+	enum dc_connection_type pre_connection_type = link->type;
 	const uint32_t post_oui_delay = 30; // 30ms
 
 	DC_LOGGER_INIT(link->ctx->logger);
@@ -1118,6 +1119,8 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 			}
 
 			if (!detect_dp(link, &sink_caps, reason)) {
+				link->type = pre_connection_type;
+
 				if (prev_sink)
 					dc_sink_release(prev_sink);
 				return false;
@@ -1349,6 +1352,8 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 	bool is_delegated_to_mst_top_mgr = false;
 	enum dc_connection_type pre_link_type = link->type;
 
+	DC_LOGGER_INIT(link->ctx->logger);
+
 	is_local_sink_detect_success = detect_link_and_local_sink(link, reason);
 
 	if (is_local_sink_detect_success && link->local_sink)
@@ -1359,6 +1364,10 @@ bool dc_link_detect(struct dc_link *link, enum dc_detect_reason reason)
 			link->dpcd_caps.is_mst_capable)
 		is_delegated_to_mst_top_mgr = discover_dp_mst_topology(link, reason);
 
+	DC_LOG_DC("%s: link_index=%d is_local_sink_detect_success=%d pre_link_type=%d link_type=%d\n", __func__,
+		 link->link_index, is_local_sink_detect_success, pre_link_type, link->type);
+
+
 	if (is_local_sink_detect_success &&
 			pre_link_type == dc_connection_mst_branch &&
 			link->type != dc_connection_mst_branch)
-- 
2.39.2



