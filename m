Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBFF551C6C
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345289AbiFTNaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346932AbiFTN3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:29:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD36245BC;
        Mon, 20 Jun 2022 06:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AE12B811C4;
        Mon, 20 Jun 2022 13:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67DEC3411B;
        Mon, 20 Jun 2022 13:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730386;
        bh=fYqEYfMpMmnw3A/eQFnbEnCAsansYVE/WSANxNzwF+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5RJgDCSrnqc9PNj4Rx9M6IxcHm+1q9pxVLlFtopE0pxoCoXoxTlKK52sGYKL67ww
         Z18b0btTh/JFWrCV/i6jSqSB6PkinuAlOe5dOzIcuNuriXjdPZZ85eSZH0Dq39s9ml
         Xn8UfXT+XVWIKKGQDUHrI5c6LL+Ikpj9c5uYvtrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Sherry Wang <YAO.WANG1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/106] drm/amd/display: Read Golden Settings Table from VBIOS
Date:   Mon, 20 Jun 2022 14:50:26 +0200
Message-Id: <20220620124724.604637952@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
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
index b0892443fbd5..c7c27a605f15 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dio_link_encoder.c
@@ -168,9 +168,7 @@ void enc31_hw_init(struct link_encoder *enc)
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



