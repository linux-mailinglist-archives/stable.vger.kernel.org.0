Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555C5551967
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiFTMxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241345AbiFTMxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:53:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823FBDEE;
        Mon, 20 Jun 2022 05:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F65CB811A2;
        Mon, 20 Jun 2022 12:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B82C3411B;
        Mon, 20 Jun 2022 12:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729581;
        bh=pKqvNCdZg3v1ahitohlcLAY3SfAkUAhwKbCU6xelYlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faanviX1/uLAtjAxmT2fS/7N6fGIPLM/Z52mQhuGWVwi18i5eMhK+89SAN/fT1d1/
         fCiMPr1cbnpDY0tN/ZJf3l5swnqAywGzPrdIffvAeQsQEqfnhscFokHzAqDQkwVZ4g
         lhBsnSZZNXe1K8Ls55+8EyikWmA84q7comM6PeyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stylon Wang <stylon.wang@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.18 001/141] Revert "drm/amd/display: Fix DCN3 B0 DP Alt Mapping"
Date:   Mon, 20 Jun 2022 14:48:59 +0200
Message-Id: <20220620124729.555038849@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Stylon Wang <stylon.wang@amd.com>

commit 1039188806d4cfdf9c412bb4ddb51b4d8cd15478 upstream.

This reverts commit 4b7786d87fb3adf3e534c4f1e4f824d8700b786b.

Commit 4b7786d87fb3 ("drm/amd/display: Fix DCN3 B0 DP Alt Mapping")
is causing 2nd USB-C display not lighting up.
Phy id remapping is done differently than is assumed in this
patch.

Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1392,12 +1392,6 @@ static struct stream_encoder *dcn31_stre
 		return NULL;
 	}
 
-	if (ctx->asic_id.chip_family == FAMILY_YELLOW_CARP &&
-			ctx->asic_id.hw_internal_rev == YELLOW_CARP_B0) {
-		if ((eng_id == ENGINE_ID_DIGC) || (eng_id == ENGINE_ID_DIGD))
-			eng_id = eng_id + 3; // For B0 only. C->F, D->G.
-	}
-
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios,
 					eng_id, vpg, afmt,
 					&stream_enc_regs[eng_id],


