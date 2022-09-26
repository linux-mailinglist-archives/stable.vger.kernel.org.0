Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFB45EA507
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbiIZL42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239230AbiIZLyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB91580B9;
        Mon, 26 Sep 2022 03:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46E9360A4D;
        Mon, 26 Sep 2022 10:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F1CC433C1;
        Mon, 26 Sep 2022 10:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189427;
        bh=n/jQe5Kdc5RRzX8YMydVC81lOY8DOiPwkvEUwB32+O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kfob+XuBY3WNO0epn8TcFkas86m3awDJYrdemIcVHgrEo0KbB6xKXkmcLnQlx+Qbl
         EN9dlK5BYTeKeeCCBE5CFJZlKCeDYTKUuJssml4LdHRbydvAOzupVhj/wVBKNrtlJj
         UPm8l1PSLUrHz7571YwBCfzWnyZRttDRpdeL+fMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Mika Kahola <mika.kahola@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>
Subject: [PATCH 5.19 167/207] drm/i915/display: Fix handling of enable_psr parameter
Date:   Mon, 26 Sep 2022 12:12:36 +0200
Message-Id: <20220926100814.131449678@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Roberto de Souza <jose.souza@intel.com>

commit 5c57c099f442acab13129c9e15ad2a0c31151c98 upstream.

Commit 3cf050762534 ("drm/i915/bios: Split VBT data into per-panel vs.
global parts") cause PSR to be disabled when enable_psr has the
default value and there is at least one DP port that do not supports
PSR.

That was happening because intel_psr_init() is called for every DP
port and then enable_psr is globaly set to 0 based on the PSR support
of the DP port.

Here dropping the enable_psr overwritten and using the VBT PSR value
when enable_psr is set as default.

Fixes: 3cf050762534 ("drm/i915/bios: Split VBT data into per-panel vs. global parts")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Cc: Mika Kahola <mika.kahola@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220608203344.513082-1-jose.souza@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -86,10 +86,13 @@
 
 static bool psr_global_enabled(struct intel_dp *intel_dp)
 {
+	struct intel_connector *connector = intel_dp->attached_connector;
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 
 	switch (intel_dp->psr.debug & I915_PSR_DEBUG_MODE_MASK) {
 	case I915_PSR_DEBUG_DEFAULT:
+		if (i915->params.enable_psr == -1)
+			return connector->panel.vbt.psr.enable;
 		return i915->params.enable_psr;
 	case I915_PSR_DEBUG_DISABLE:
 		return false;
@@ -2371,10 +2374,6 @@ void intel_psr_init(struct intel_dp *int
 
 	intel_dp->psr.source_support = true;
 
-	if (dev_priv->params.enable_psr == -1)
-		if (!connector->panel.vbt.psr.enable)
-			dev_priv->params.enable_psr = 0;
-
 	/* Set link_standby x link_off defaults */
 	if (DISPLAY_VER(dev_priv) < 12)
 		/* For new platforms up to TGL let's respect VBT back again */


