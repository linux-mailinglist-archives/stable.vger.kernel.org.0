Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDC55A05C2
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiHYBfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbiHYBe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4FA255B5;
        Wed, 24 Aug 2022 18:34:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 069C661AD2;
        Thu, 25 Aug 2022 01:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42547C433C1;
        Thu, 25 Aug 2022 01:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391293;
        bh=EisjEDTgu0/HL3m181AoTpLyerrWC2kWxzRVdWPQn30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xy5zTpg0jfXvP+9lG3ctxKEj6cWVquThIn6anjC9vzDOroDQV1vDmTl6FuASZYqCL
         vRMPd4eM5GAjTGiN1Cjsu/j4R26DyFnfRQc73XFiu5FmYaQsyfcCG+vRaCo4OTdVFs
         Cvr0QKjfbgI8rKciDz0j9/MNJPONI1h8sEJ0459FZl//KlRspiu8+piGiVGJx8S4gB
         zQ59VQtQDQ6gMxdvmrxQYQjSWZ1mWk7kSrX5BukTBftnTUEZnyllAZTkbMF3Jd09Zk
         ccYhc/J/d0K7HypQbUf/N8K/jecynoS+3KxlqrfSX7h/xO85GcHTqph+Te3no1WVaK
         1/qsoEFSeNprA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Ma <hanghong.ma@amd.com>, Anthony Koo <Anthony.Koo@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, HaoPing.Liu@amd.com, Aric.Cyr@amd.com,
        Angus.Wang@amd.com, Bing.Guo@amd.com, lv.ruyi@zte.com.cn,
        felipe.clark@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 08/38] drm/amd/display: Fix HDMI VSIF V3 incorrect issue
Date:   Wed, 24 Aug 2022 21:33:31 -0400
Message-Id: <20220825013401.22096-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Ma <hanghong.ma@amd.com>

[ Upstream commit 0591183699fceeafb4c4141072d47775de83ecfb ]

[Why]
Reported from customer the checksum in AMD VSIF V3 is incorrect and
causing blank screen issue.

[How]
Fix the packet length issue on AMD HDMI VSIF V3.

Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Leo Ma <hanghong.ma@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/modules/freesync/freesync.c   | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index 03fa63d56fa6..948151e73573 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -615,10 +615,6 @@ static void build_vrr_infopacket_data_v1(const struct mod_vrr_params *vrr,
 	 * Note: We should never go above the field rate of the mode timing set.
 	 */
 	infopacket->sb[8] = (unsigned char)((vrr->max_refresh_in_uhz + 500000) / 1000000);
-
-	/* FreeSync HDR */
-	infopacket->sb[9] = 0;
-	infopacket->sb[10] = 0;
 }
 
 static void build_vrr_infopacket_data_v3(const struct mod_vrr_params *vrr,
@@ -686,10 +682,6 @@ static void build_vrr_infopacket_data_v3(const struct mod_vrr_params *vrr,
 
 	/* PB16 : Reserved bits 7:1, FixedRate bit 0 */
 	infopacket->sb[16] = (vrr->state == VRR_STATE_ACTIVE_FIXED) ? 1 : 0;
-
-	//FreeSync HDR
-	infopacket->sb[9] = 0;
-	infopacket->sb[10] = 0;
 }
 
 static void build_vrr_infopacket_fs2_data(enum color_transfer_func app_tf,
@@ -774,8 +766,7 @@ static void build_vrr_infopacket_header_v2(enum signal_type signal,
 		/* HB2  = [Bits 7:5 = 0] [Bits 4:0 = Length = 0x09] */
 		infopacket->hb2 = 0x09;
 
-		*payload_size = 0x0A;
-
+		*payload_size = 0x09;
 	} else if (dc_is_dp_signal(signal)) {
 
 		/* HEADER */
@@ -824,9 +815,9 @@ static void build_vrr_infopacket_header_v3(enum signal_type signal,
 		infopacket->hb1 = version;
 
 		/* HB2  = [Bits 7:5 = 0] [Bits 4:0 = Length] */
-		*payload_size = 0x10;
-		infopacket->hb2 = *payload_size - 1; //-1 for checksum
+		infopacket->hb2 = 0x10;
 
+		*payload_size = 0x10;
 	} else if (dc_is_dp_signal(signal)) {
 
 		/* HEADER */
-- 
2.35.1

