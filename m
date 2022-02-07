Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973344ABB6F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357643AbiBGL2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383471AbiBGLWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:22:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A616C043188;
        Mon,  7 Feb 2022 03:22:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AA046126D;
        Mon,  7 Feb 2022 11:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6828BC004E1;
        Mon,  7 Feb 2022 11:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232955;
        bh=i9zk4AcF9jXF72YBlRloYKPoP25ixnHr83HDUf618Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MS1VHRim+fI0z8xgLjeJq2Q9ns1Z3nVkv2lGvrLEmsrewiMpIhRhv0RlaiMw8rdna
         G/froI2xql0Ec47+HBuHpIMeajgcMrz8OSnoMj6RIF5PGwc0nIjX176q8BzLeE8dvk
         SaFANGB2obaO63ao/TBcoHlZBmglsCbeAW2M0vs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.10 44/74] drm/i915/overlay: Prevent divide by zero bugs in scaling
Date:   Mon,  7 Feb 2022 12:06:42 +0100
Message-Id: <20220207103758.663881010@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 90a3d22ff02b196d5884e111f39271a1d4ee8e3e upstream.

Smatch detected a divide by zero bug in check_overlay_scaling().

    drivers/gpu/drm/i915/display/intel_overlay.c:976 check_overlay_scaling()
    error: potential divide by zero bug '/ rec->dst_height'.
    drivers/gpu/drm/i915/display/intel_overlay.c:980 check_overlay_scaling()
    error: potential divide by zero bug '/ rec->dst_width'.

Prevent this by ensuring that the dst height and width are non-zero.

Fixes: 02e792fbaadb ("drm/i915: implement drmmode overlay support v4")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220124122409.GA31673@kili
(cherry picked from commit cf5b64f7f10b28bebb9b7c9d25e7aee5cbe43918)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_overlay.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -932,6 +932,9 @@ static int check_overlay_dst(struct inte
 	const struct intel_crtc_state *pipe_config =
 		overlay->crtc->config;
 
+	if (rec->dst_height == 0 || rec->dst_width == 0)
+		return -EINVAL;
+
 	if (rec->dst_x < pipe_config->pipe_src_w &&
 	    rec->dst_x + rec->dst_width <= pipe_config->pipe_src_w &&
 	    rec->dst_y < pipe_config->pipe_src_h &&


