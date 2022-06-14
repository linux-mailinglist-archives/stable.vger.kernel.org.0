Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9442E54A401
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240014AbiFNCFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244914AbiFNCEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B0B33E3D;
        Mon, 13 Jun 2022 19:04:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4320460B6B;
        Tue, 14 Jun 2022 02:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5249BC341C4;
        Tue, 14 Jun 2022 02:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172290;
        bh=O2vdw0HEg897hRd43A10FqgazzP4XDA4R8BDuGWT6UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjtxfI79stA0/34f8nrm1ec2ce/y9tf7F2Ti7kLT2YcmOg8f4FrulStZKIo6FOB2I
         ROmPuorOLUxYM9CvQB2yRs0+OZkI0ZDflGurvfojeREoA58Pdy+Q49KdjlAy4ToEJx
         CQoPk4wdA28iIUjQd+vCO3ara1QjWG7HwlX81eB0rcHgeMMMeucVhYTbxlyBIVJQYN
         3n2MVFBsEfmFXncNkQdQS1uaddNvLpzXU2ptZoNREsIU+LBgfIy/Xug7XAYOMlVpGM
         5pM4DKz3iiI3DMfjeFtl5Il2GLztOsu3eOf2xF12fVNiEuVuyL5M4FYiPvOLg5yWJV
         SkGWFBTat3Z4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Wang <YAO.WANG1@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        airlied@linux.ie, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 04/47] drm/amd/display: Read Golden Settings Table from VBIOS
Date:   Mon, 13 Jun 2022 22:03:57 -0400
Message-Id: <20220614020441.1098348-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Wang <YAO.WANG1@amd.com>

[ Upstream commit 4b81dd2cc6f4f4e8cea0ed6ee8d5193a8ae14a72 ]

[Why]
Dmub read AUX_DPHY_RX_CONTROL0 from Golden Setting Table,
but driver will set it to default value 0x103d1110, which
causes issue in some case

[How]
Remove the driver code, use the value set by dmub in
dp_aux_init

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Sherry Wang <YAO.WANG1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
index d94fd1010deb..8b12b4111c88 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
@@ -230,9 +230,7 @@ static void enc31_hw_init(struct link_encoder *enc)
 	AUX_RX_PHASE_DETECT_LEN,  [21,20] = 0x3 default is 3
 	AUX_RX_DETECTION_THRESHOLD [30:28] = 1
 */
-	AUX_REG_WRITE(AUX_DPHY_RX_CONTROL0, 0x103d1110);
-
-	AUX_REG_WRITE(AUX_DPHY_TX_CONTROL, 0x21c7a);
+	// dmub will read AUX_DPHY_RX_CONTROL0/AUX_DPHY_TX_CONTROL from vbios table in dp_aux_init
 
 	//AUX_DPHY_TX_REF_CONTROL'AUX_TX_REF_DIV HW default is 0x32;
 	// Set AUX_TX_REF_DIV Divider to generate 2 MHz reference from refclk
-- 
2.35.1

