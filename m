Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D859C676FE0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjAVP0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjAVP0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1125722DC6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFCC0B80B1A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24389C433D2;
        Sun, 22 Jan 2023 15:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401169;
        bh=TU9mK3jIfXmZx+C+CH2HmKLHYYCvjJYKDOJSkpnl4CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hY/N634A6fWyitRDik2qjwleOOf+6u3Sf+AXo2pHJj3oH3UkYKnh5qC7I7h3NgwV2
         sOQUqdqMdc795cew0tfvHUOQ3NxDD4O1R1/8Rh1P4ptFqbg8mkeL04vTK5rJPU1bwS
         kSFGW8AnW0K7bCX/dqxRlfB/qwzN16NjLb2wPEok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sasa Dragic <sasa.dragic@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 137/193] drm/i915: re-disable RC6p on Sandy Bridge
Date:   Sun, 22 Jan 2023 16:04:26 +0100
Message-Id: <20230122150252.625049817@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Sasa Dragic <sasa.dragic@gmail.com>

commit 67b0b4ed259e425b7eed09da75b42c80682ca003 upstream.

RC6p on Sandy Bridge got re-enabled over time, causing visual glitches
and GPU hangs.

Disabled originally in commit 1c8ecf80fdee ("drm/i915: do not enable
RC6p on Sandy Bridge").

Signed-off-by: Sasa Dragic <sasa.dragic@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221219172927.9603-2-sasa.dragic@gmail.com
Fixes: fb6db0f5bf1d ("drm/i915: Remove unsafe i915.enable_rc6")
Fixes: 13c5a577b342 ("drm/i915/gt: Select the deepest available parking mode for rc6")
Cc: stable@vger.kernel.org
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 0c8a6e9ea232c221976a0670256bd861408d9917)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -423,7 +423,8 @@ static const struct intel_device_info il
 	.has_coherent_ggtt = true, \
 	.has_llc = 1, \
 	.has_rc6 = 1, \
-	.has_rc6p = 1, \
+	/* snb does support rc6p, but enabling it causes various issues */ \
+	.has_rc6p = 0, \
 	.has_rps = true, \
 	.dma_mask_size = 40, \
 	.__runtime.ppgtt_type = INTEL_PPGTT_ALIASING, \


