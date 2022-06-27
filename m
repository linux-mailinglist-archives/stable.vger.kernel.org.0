Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBEE55C2F6
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbiF0LiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236175AbiF0Lgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C7B1024;
        Mon, 27 Jun 2022 04:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5265360C24;
        Mon, 27 Jun 2022 11:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61359C3411D;
        Mon, 27 Jun 2022 11:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329527;
        bh=qkzfQ32P8g1iyhktAofgtqx+i7q6bGkAGLqGcHXT5xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAFPRraJ8JYp4JRPros0Tho9jVW2WshQbfSExX0jjDrHRSafRtsUGU8GAt8x38WWn
         J8Fz8+xZtYqw3uRaBqZX2e737r/BFMNX9uOhNIHKZYWQfnvrgkX7I7k62LRAAC4TFr
         6m05IA1molT7t3hl44r29TbkBlxHBQD9AtvIJWUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 028/135] drm/i915: Implement w/a 22010492432 for adl-s
Date:   Mon, 27 Jun 2022 13:20:35 +0200
Message-Id: <20220627111938.977418858@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 13bd259b64bb58ae130923ada42ebc19bf3f2fa2 upstream.

adl-s needs the combo PLL DCO fraction w/a as well.
Gets us slightly more accurate clock out of the PLL.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220613201439.23341-1-ville.syrjala@linux.intel.com
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit d36bdd77b9e6aa7f5cb7b0f11ebbab8e5febf10b)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -2434,7 +2434,7 @@ static void icl_wrpll_params_populate(st
 }
 
 /*
- * Display WA #22010492432: ehl, tgl, adl-p
+ * Display WA #22010492432: ehl, tgl, adl-s, adl-p
  * Program half of the nominal DCO divider fraction value.
  */
 static bool
@@ -2442,7 +2442,7 @@ ehl_combo_pll_div_frac_wa_needed(struct
 {
 	return ((IS_PLATFORM(i915, INTEL_ELKHARTLAKE) &&
 		 IS_JSL_EHL_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
-		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_P(i915)) &&
+		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) &&
 		 i915->dpll.ref_clks.nssc == 38400;
 }
 


