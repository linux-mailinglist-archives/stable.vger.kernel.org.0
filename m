Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C6C505123
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbiDRMbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238966AbiDRMac (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:30:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36DA24F07;
        Mon, 18 Apr 2022 05:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 700CCB80EDC;
        Mon, 18 Apr 2022 12:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89B7C385A1;
        Mon, 18 Apr 2022 12:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284631;
        bh=okAbp2v/Y4eqFaui4seYNyJOzyps1nqQznQq5s+nF1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljHpefv4PrYqWCTYfQ2T0gHD2/ee6K/mSsCTDhkj4mlNK8mbG8jrxvLT72ADLcISJ
         DBhIwJlbwxPm4tlm0aQ9v0pKFnZ+//wcWx/NUQb1Qw/k0tyXfNLr4fAnah141OdLbV
         Q6izd0OekOeMaIH4WU1lCM4JC3Rq2A8tyr6CDJug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Park <Chris.Park@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 137/219] drm/amd/display: Update VTEM Infopacket definition
Date:   Mon, 18 Apr 2022 14:11:46 +0200
Message-Id: <20220418121210.728543143@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo (Hanghong) Ma <hanghong.ma@amd.com>

[ Upstream commit c9fbf6435162ed5fb7201d1d4adf6585c6a8c327 ]

[Why & How]
The latest HDMI SPEC has updated the VTEM packet structure,
so change the VTEM Infopacket defined in the driver side to align
with the SPEC.

Reviewed-by: Chris Park <Chris.Park@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Leo (Hanghong) Ma <hanghong.ma@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/modules/info_packet/info_packet.c    | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index 57f198de5e2c..4e075b01d48b 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -100,7 +100,8 @@ enum vsc_packet_revision {
 //PB7 = MD0
 #define MASK_VTEM_MD0__VRR_EN         0x01
 #define MASK_VTEM_MD0__M_CONST        0x02
-#define MASK_VTEM_MD0__RESERVED2      0x0C
+#define MASK_VTEM_MD0__QMS_EN         0x04
+#define MASK_VTEM_MD0__RESERVED2      0x08
 #define MASK_VTEM_MD0__FVA_FACTOR_M1  0xF0
 
 //MD1
@@ -109,7 +110,7 @@ enum vsc_packet_revision {
 //MD2
 #define MASK_VTEM_MD2__BASE_REFRESH_RATE_98  0x03
 #define MASK_VTEM_MD2__RB                    0x04
-#define MASK_VTEM_MD2__RESERVED3             0xF8
+#define MASK_VTEM_MD2__NEXT_TFR              0xF8
 
 //MD3
 #define MASK_VTEM_MD3__BASE_REFRESH_RATE_07  0xFF
-- 
2.35.1



