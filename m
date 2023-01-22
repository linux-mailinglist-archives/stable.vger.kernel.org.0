Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733D1676F50
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjAVPUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjAVPUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE71E21954
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA8CB80B11
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29C9C433D2;
        Sun, 22 Jan 2023 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400802;
        bh=ICVkj3mEfWpJ905MfHl3h2x+idY6wwkIXMcQob2u9BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEU+UHyB71+p68+Eg+XTl42V6blMSWMcD1r0+21GnircZDNMThF6pWABCW4kcw270
         +I+IKzg3I3vsMS2YHyb5F1DjHxerHDE7CabzpDZgjqjFoOOVNJy/RmT0XnC2kM/t1y
         SJzE+7U9JFEBUKUrA1IqFNjgAuRocwmeFfTTRqQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Melissa Wen <mwen@igalia.com>,
        Joshua Ashton <joshua@froggi.es>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 097/117] drm/amd/display: Calculate output_color_space after pixel encoding adjustment
Date:   Sun, 22 Jan 2023 16:04:47 +0100
Message-Id: <20230122150236.865084441@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Ashton <joshua@froggi.es>

commit 79601b894849cb6f6d6122e6590f1887ac4a66b3 upstream.

Code in get_output_color_space depends on knowing the pixel encoding to
determine whether to pick between eg. COLOR_SPACE_SRGB or
COLOR_SPACE_YCBCR709 for transparent RGB -> YCbCr 4:4:4 in the driver.

v2: Fixed patch being accidentally based on a personal feature branch, oops!

Fixes: ea117312ea9f ("drm/amd/display: Reduce HDMI pixel encoding if max clock is exceeded")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Joshua Ashton <joshua@froggi.es>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5855,8 +5855,6 @@ static void fill_stream_properties_from_
 
 	timing_out->aspect_ratio = get_aspect_ratio(mode_in);
 
-	stream->output_color_space = get_output_color_space(timing_out);
-
 	stream->out_transfer_func->type = TF_TYPE_PREDEFINED;
 	stream->out_transfer_func->tf = TRANSFER_FUNCTION_SRGB;
 	if (stream->signal == SIGNAL_TYPE_HDMI_TYPE_A) {
@@ -5867,6 +5865,8 @@ static void fill_stream_properties_from_
 			adjust_colour_depth_from_display_info(timing_out, info);
 		}
 	}
+
+	stream->output_color_space = get_output_color_space(timing_out);
 }
 
 static void fill_audio_info(struct audio_info *audio_info,


