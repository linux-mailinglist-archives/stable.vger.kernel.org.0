Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD43657CB5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiL1PfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbiL1PfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:35:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04B016498
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:35:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BE316155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98222C433EF;
        Wed, 28 Dec 2022 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241714;
        bh=lzdtBuIRzXVyB+L7p9CVTHNHZPbhrXxAzXIExjUgUi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmbwCrijTmmH55+2EW9y92B2B66p4QtqrIYQC/UewgVV47a7GC2zXEKl6Q+STi8Zp
         2rXvPk1EFbd+GwvNmbMKwqr+khbCycUGQDNN0mXOoeoBUsrdR7/S/pBOgvvpaZV7KC
         WhM3uwcWjx7t34sL+G45l3LOdLF8fLE/muejRiCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0280/1146] drm/msm/dsi: Use DIV_ROUND_UP instead of conditional increment on modulo
Date:   Wed, 28 Dec 2022 15:30:19 +0100
Message-Id: <20221228144337.743087255@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 1e8196103bd02a396b45c8f6188541634a47fce2 ]

This exact same math is used to compute bytes_in_slice above in
dsi_update_dsc_timing(), also used to fill slice_chunk_size.

Fixes: b9080324d6ca ("drm/msm/dsi: add support for dsc data")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/508935/
Link: https://lore.kernel.org/r/20221026182824.876933-4-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index d94832504d0f..88c8aa5c6b80 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1807,9 +1807,7 @@ static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 	 * params are calculated
 	 */
 	groups_per_line = DIV_ROUND_UP(dsc->slice_width, 3);
-	dsc->slice_chunk_size = dsc->slice_width * dsc->bits_per_pixel / 8;
-	if ((dsc->slice_width * dsc->bits_per_pixel) % 8)
-		dsc->slice_chunk_size++;
+	dsc->slice_chunk_size = DIV_ROUND_UP(dsc->slice_width * dsc->bits_per_pixel, 8);
 
 	/* rbs-min */
 	min_rate_buffer_size =  dsc->rc_model_size - dsc->initial_offset +
-- 
2.35.1



