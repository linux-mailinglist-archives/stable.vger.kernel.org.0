Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A066B505102
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiDRMac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240047AbiDRM3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6960E20BDC;
        Mon, 18 Apr 2022 05:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECA4660F0C;
        Mon, 18 Apr 2022 12:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DAFC385A8;
        Mon, 18 Apr 2022 12:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284587;
        bh=FFtHTLViO7Kk3k4dRDhJk2ARFMqmxQ2ReCqBcHvNwIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuR3qDYveLGD9v7nr+gRJD6QtyuJshU2KmvtTXCLF3ZUMYVE1zsiyR+zvZFjpoqhh
         0f0AHGXERA3m5R0RnOQpOLykXR6Y7IQNtHn2juYQLkbEKMxZbxeLNG+xcqdEo3IpJG
         kGFDMeylCBAAOMZpiLyezM7kKJEKWY7HGZcQO4ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenjing Liu <Wenjing.Liu@amd.com>,
        Alex Hung <alex.hung@amd.com>, Chris Park <Chris.Park@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 162/219] drm/amd/display: Correct Slice reset calculation
Date:   Mon, 18 Apr 2022 14:12:11 +0200
Message-Id: <20220418121211.417970399@linuxfoundation.org>
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

From: Chris Park <Chris.Park@amd.com>

[ Upstream commit 862a876c3a6372f2fa9d0c6510f1976ac94fc857 ]

[Why]
Once DSC slice cannot fit pixel clock, we incorrectly
reset min slices to 0 and allow max slice to operate,
even when max slice itself cannot fit the pixel clock
properly.

[How]
Change the sequence such that we correctly determine
DSC is not possible when both min slices and max
slices cannot fit pixel clock per slice.

Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Chris Park <Chris.Park@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
index 9c74564cbd8d..8973d3a38f9c 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
@@ -864,11 +864,11 @@ static bool setup_dsc_config(
 		min_slices_h = inc_num_slices(dsc_common_caps.slice_caps, min_slices_h);
 	}
 
+	is_dsc_possible = (min_slices_h <= max_slices_h);
+
 	if (pic_width % min_slices_h != 0)
 		min_slices_h = 0; // DSC TODO: Maybe try increasing the number of slices first?
 
-	is_dsc_possible = (min_slices_h <= max_slices_h);
-
 	if (min_slices_h == 0 && max_slices_h == 0)
 		is_dsc_possible = false;
 
-- 
2.35.1



