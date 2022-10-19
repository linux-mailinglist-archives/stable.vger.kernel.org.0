Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCB56043F7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJSLyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiJSLyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:54:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99461ACA9C;
        Wed, 19 Oct 2022 04:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82F1CB823C7;
        Wed, 19 Oct 2022 08:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AFCC433C1;
        Wed, 19 Oct 2022 08:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169674;
        bh=5e45WF3i7O41wGeR2QW8m9+kfKMJUdRm0h/2qvoug8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLjD4X9Xb3L/iM/dfhhxw8rAi+C4hCPW+H82f0BC8gIh6rzceqNE4rN2+U6/1MAtf
         6wGvr2ZaJGoX0E8CejNbd55z+1e7zh9NBBSLa8NuF32sXaONWmPQXm9YGWYCBHv9Rr
         qJu0MkYyRWKGFNja/nqEszQFBMsmQFvYMt9Y+SJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 365/862] drm/i915/dg2: Bump up CDCLK for DG2
Date:   Wed, 19 Oct 2022 10:27:32 +0200
Message-Id: <20221019083306.134079514@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

[ Upstream commit 859161b952a453b86362f168fadef72a8ba31a05 ]

We seem to need this W/A same way as for TGL, in order
to fix some of the underruns, which we currently have and
those not related to PSR.

Signed-off-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220614123049.16183-2-stanislav.lisovskiy@intel.com
Stable-dep-of: 4234ea300512 ("drm/i915/display: avoid warnings when registering dual panel backlight")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
index 6e80162632dd..86a22c3766e5 100644
--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2300,7 +2300,7 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
 		min_cdclk = max(min_cdclk, (int)crtc_state->pixel_rate);
 
 	/*
-	 * HACK. Currently for TGL platforms we calculate
+	 * HACK. Currently for TGL/DG2 platforms we calculate
 	 * min_cdclk initially based on pixel_rate divided
 	 * by 2, accounting for also plane requirements,
 	 * however in some cases the lowest possible CDCLK
@@ -2308,7 +2308,7 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
 	 * Explicitly stating here that this seems to be currently
 	 * rather a Hack, than final solution.
 	 */
-	if (IS_TIGERLAKE(dev_priv)) {
+	if (IS_TIGERLAKE(dev_priv) || IS_DG2(dev_priv)) {
 		/*
 		 * Clamp to max_cdclk_freq in case pixel rate is higher,
 		 * in order not to break an 8K, but still leave W/A at place.
-- 
2.35.1



