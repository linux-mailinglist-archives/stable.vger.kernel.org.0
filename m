Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540114F313D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245319AbiDEIy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240916AbiDEIci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CEB8CD8F;
        Tue,  5 Apr 2022 01:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D8FB81BBF;
        Tue,  5 Apr 2022 08:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2A9C385A5;
        Tue,  5 Apr 2022 08:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147113;
        bh=VW8l/UtEnR6m5WabQpjetu0YZ6sC6cMLC6TVrw8WDW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnQpbOEgxkABy6G3Qxt6l0gKnY6VKp4Wa3HC/ewU/q660lA8bvVhTs8UiGqPvQt51
         2t0b3HMX4yWZHFUdjFDLi4VvnBGEStpkDRpuESgcAxGzDxo3hoi4U/2gl7037fqAMP
         99/9u2Md6sLeEm9q4BI1Gy360N0K7c8aEpp04A+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.17 0968/1126] drm/i915: Fix PSF GV point mask when SAGV is not possible
Date:   Tue,  5 Apr 2022 09:28:35 +0200
Message-Id: <20220405070435.917503095@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 3ef8b5e19ead5a79600ea55f9549658281415893 upstream.

Don't just mask off all the PSF GV points when SAGV gets disabled.
This should in fact cause the Pcode to reject the request since
at least one PSF point must remain enabled at all times.

Cc: stable@vger.kernel.org
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: 192fbfb76744 ("drm/i915: Implement PSF GV point support")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220309164948.10671-7-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit 0fed4ddd18f064d2359b430c6e83ee60dd1f49b1)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_bw.c
+++ b/drivers/gpu/drm/i915/display/intel_bw.c
@@ -966,7 +966,8 @@ int intel_bw_atomic_check(struct intel_a
 	 * cause.
 	 */
 	if (!intel_can_enable_sagv(dev_priv, new_bw_state)) {
-		allowed_points = BIT(max_bw_point);
+		allowed_points &= ADLS_PSF_PT_MASK;
+		allowed_points |= BIT(max_bw_point);
 		drm_dbg_kms(&dev_priv->drm, "No SAGV, using single QGV point %d\n",
 			    max_bw_point);
 	}


