Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD914CF839
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiCGJwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbiCGJrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:47:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5274C6AA59;
        Mon,  7 Mar 2022 01:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB5761219;
        Mon,  7 Mar 2022 09:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B1DC340E9;
        Mon,  7 Mar 2022 09:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646138;
        bh=yLNvOCnrY8BBkqzrp6HJjWd3ox03xdVhDxX54gJfAfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFiMhgBcJ/leopTrhNPi5ywsumBQkZKWC5NYsmL5U8EQiomR5sPKTYCoMso83ktrX
         PKHkIUyC2wqlxEVj78y68YRm/hZyMU+XzOi7J6K82pJzRbt+N7zWUDfiUE/jsviPcg
         JcLNv55I85ayIQ/9Wp+i8rlTMA+EyKgUCF5TUe8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 146/262] drm/amd/display: Reduce dmesg error to a debug print
Date:   Mon,  7 Mar 2022 10:18:10 +0100
Message-Id: <20220307091706.565462317@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo (Hanghong) Ma <hanghong.ma@amd.com>

commit 1d925758ba1a5d2716a847903e2fd04efcbd9862 upstream.

[Why & How]
Dmesg errors are found on dcn3.1 during reset test, but it's not
a really failure. So reduce it to a debug print.

Signed-off-by: Leo (Hanghong) Ma <hanghong.ma@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |    4 +++-
 drivers/gpu/drm/amd/display/include/logger_types.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -3650,7 +3650,9 @@ bool dp_retrieve_lttpr_cap(struct dc_lin
 				lttpr_dpcd_data,
 				sizeof(lttpr_dpcd_data));
 		if (status != DC_OK) {
-			dm_error("%s: Read LTTPR caps data failed.\n", __func__);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+			DC_LOG_DP2("%s: Read LTTPR caps data failed.\n", __func__);
+#endif
 			return false;
 		}
 
--- a/drivers/gpu/drm/amd/display/include/logger_types.h
+++ b/drivers/gpu/drm/amd/display/include/logger_types.h
@@ -72,6 +72,9 @@
 #define DC_LOG_DSC(...) DRM_DEBUG_KMS(__VA_ARGS__)
 #define DC_LOG_SMU(...) pr_debug("[SMU_MSG]:"__VA_ARGS__)
 #define DC_LOG_DWB(...) DRM_DEBUG_KMS(__VA_ARGS__)
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+#define DC_LOG_DP2(...) DRM_DEBUG_KMS(__VA_ARGS__)
+#endif
 
 struct dal_logger;
 


