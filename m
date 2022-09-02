Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6338F5AB06C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbiIBMxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237955AbiIBMwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:52:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED2DC6E8C;
        Fri,  2 Sep 2022 05:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4256FB82AE0;
        Fri,  2 Sep 2022 12:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866E2C433C1;
        Fri,  2 Sep 2022 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122182;
        bh=oDWp68Ak99AvOvb/+yh5XbIXaQUzblhv9yQDlBb2sfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CuJhO4Mga/O3aGm+TPV9n1DJgzWXmIuGfdU7Bo88MFKYqXnnCAHVScbooteZEgG6
         H0cqlUPba7JxUJ3MKpxoq1bmeH+C6i8FKR5koDrPQTOlrP4js2UCi9Fh0EsD6NVLFS
         pPShsY/DJWK/uHeqptaJGBeO7Ja0T3r8/Tsgy4pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Leo Ma <hanghong.ma@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 39/72] drm/amd/display: Fix HDMI VSIF V3 incorrect issue
Date:   Fri,  2 Sep 2022 14:19:15 +0200
Message-Id: <20220902121406.061356332@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 03fa63d56fa65..948151e735739 100644
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



