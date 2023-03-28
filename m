Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6796CC539
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbjC1PMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbjC1PMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A05CCA16
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 362DF6177C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43862C4339B;
        Tue, 28 Mar 2023 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016328;
        bh=2Beohv/Ise8l7rERofP6leh2ccQxnhi7kMJ1uFFlQlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvWxwm8Akn2iwBneRfJ2uQ1QnOxGEXqSDXUT1dvVsYfi2j6dKrjYGOa8ot8JB/HeV
         KUKpH/FzIpsmuND1EExqQf8lsDemcjTfvoLnGbfDBESBNF/PzHJzH7z6zxV+3BiVBB
         YqIIpYblNuarX42z6L4TfSVJqZCulnhWLInAgO9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lee Shawn C <shawn.c.lee@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 133/146] drm/i915: Preserve crtc_state->inherited during state clearing
Date:   Tue, 28 Mar 2023 16:43:42 +0200
Message-Id: <20230328142608.216734321@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 3a84f2c6c9558c554a90ec26ad25df92fc5e05b7 upstream.

intel_crtc_prepare_cleared_state() is unintentionally losing
the "inherited" flag. This will happen if intel_initial_commit()
is forced to go through the full modeset calculations for
whatever reason.

Afterwards the first real commit from userspace will not get
forced to the full modeset path, and thus eg. audio state may
not get recomputed properly. So if the monitor was already
enabled during boot audio will not work until userspace itself
does an explicit full modeset.

Cc: stable@vger.kernel.org
Tested-by: Lee Shawn C <shawn.c.lee@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230223152048.20878-1-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
(cherry picked from commit 2553bacaf953b48c59357f5a622282bc0c45adae)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -7824,6 +7824,7 @@ intel_crtc_prepare_cleared_state(struct
 	 * only fields that are know to not cause problems are preserved. */
 
 	saved_state->uapi = crtc_state->uapi;
+	saved_state->inherited = crtc_state->inherited;
 	saved_state->scaler_state = crtc_state->scaler_state;
 	saved_state->shared_dpll = crtc_state->shared_dpll;
 	saved_state->dpll_hw_state = crtc_state->dpll_hw_state;


