Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD29F6E64CE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjDRMwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbjDRMwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22EB118E9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57D816344A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6683FC4339B;
        Tue, 18 Apr 2023 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822338;
        bh=5K+7JddlZrFYjRS2PhmvsYrGA2j2H6kx3Hz5/jx7L/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6fCJSWhX3Hz1QNVSVnFfRzjR0AXZqbtRpXPnwSotha/UW5LRIIV5veAhtaV/tD5g
         BdfVdBKpLxz35BLRYDhjHHuyaAqi0xpY5k4n376uqLPQqa0BcuaPkS3dhUKux31dM2
         h+7bMsEkAEdF9QBX1OB/P5Vw/OXUldMoY9dl2tMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 113/139] drm/amd/pm: correct the pcie link state check for SMU13
Date:   Tue, 18 Apr 2023 14:22:58 +0200
Message-Id: <20230418120318.010994754@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit b9a24d8bd51e2db425602fa82d7f4c06aa3db852 upstream.

Update the driver implementations to fit those data exposed
by PMFW.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h         |    6 ++++++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    4 ++--
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -61,6 +61,12 @@
 #define CTF_OFFSET_HOTSPOT		5
 #define CTF_OFFSET_MEM			5
 
+static const int pmfw_decoded_link_speed[5] = {1, 2, 3, 4, 5};
+static const int pmfw_decoded_link_width[7] = {0, 1, 2, 4, 8, 12, 16};
+
+#define DECODE_GEN_SPEED(gen_speed_idx)		(pmfw_decoded_link_speed[gen_speed_idx])
+#define DECODE_LANE_WIDTH(lane_width_idx)	(pmfw_decoded_link_width[lane_width_idx])
+
 struct smu_13_0_max_sustainable_clocks {
 	uint32_t display_clock;
 	uint32_t phy_clock;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1125,8 +1125,8 @@ static int smu_v13_0_0_print_clk_levels(
 					(pcie_table->pcie_lane[i] == 5) ? "x12" :
 					(pcie_table->pcie_lane[i] == 6) ? "x16" : "",
 					pcie_table->clk_freq[i],
-					((gen_speed - 1) == pcie_table->pcie_gen[i]) &&
-					(lane_width == link_width[pcie_table->pcie_lane[i]]) ?
+					(gen_speed == DECODE_GEN_SPEED(pcie_table->pcie_gen[i])) &&
+					(lane_width == DECODE_LANE_WIDTH(link_width[pcie_table->pcie_lane[i]])) ?
 					"*" : "");
 		break;
 
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1074,8 +1074,8 @@ static int smu_v13_0_7_print_clk_levels(
 					(pcie_table->pcie_lane[i] == 5) ? "x12" :
 					(pcie_table->pcie_lane[i] == 6) ? "x16" : "",
 					pcie_table->clk_freq[i],
-					(gen_speed == pcie_table->pcie_gen[i]) &&
-					(lane_width == pcie_table->pcie_lane[i]) ?
+					(gen_speed == DECODE_GEN_SPEED(pcie_table->pcie_gen[i])) &&
+					(lane_width == DECODE_LANE_WIDTH(pcie_table->pcie_lane[i])) ?
 					"*" : "");
 		break;
 


