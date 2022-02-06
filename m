Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FA14AAF3B
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 13:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbiBFMro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 07:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiBFMro (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 07:47:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CE7C06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 04:47:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 217BEB80E06
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 12:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A62AC340E9;
        Sun,  6 Feb 2022 12:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644151660;
        bh=54apPhE67SpHDuJzJsuGj2UuWckdhvBUN9F2lvy7+f0=;
        h=Subject:To:Cc:From:Date:From;
        b=tHcaNIoBJFOTw6ZmbAgGezxDwHQFYXHYQzC4P1l2NJIFbOL6M/2zY1zSo2RjoBpur
         MZkL6F5MQ8+ILhd+sutd3sU63NokMRj2QbrvCKvsW+4EqYn3bBrmN+qaUlWm1JlTKZ
         +o6nFS2lIxxw+v6hby91vHe+2sqD3AshmJrG6eEg=
Subject: FAILED: patch "[PATCH] drm/i915/overlay: Prevent divide by zero bugs in scaling" failed to apply to 4.9-stable tree
To:     dan.carpenter@oracle.com, tvrtko.ursulin@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 06 Feb 2022 13:47:37 +0100
Message-ID: <1644151657102170@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 90a3d22ff02b196d5884e111f39271a1d4ee8e3e Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 24 Jan 2022 15:24:09 +0300
Subject: [PATCH] drm/i915/overlay: Prevent divide by zero bugs in scaling
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/intel_overlay.c b/drivers/gpu/drm/i915/display/intel_overlay.c
index 1a376e9a1ff3..d610e48cab94 100644
--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -959,6 +959,9 @@ static int check_overlay_dst(struct intel_overlay *overlay,
 	const struct intel_crtc_state *pipe_config =
 		overlay->crtc->config;
 
+	if (rec->dst_height == 0 || rec->dst_width == 0)
+		return -EINVAL;
+
 	if (rec->dst_x < pipe_config->pipe_src_w &&
 	    rec->dst_x + rec->dst_width <= pipe_config->pipe_src_w &&
 	    rec->dst_y < pipe_config->pipe_src_h &&

