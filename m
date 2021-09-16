Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E525E40DAD0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 15:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239952AbhIPNNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 09:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239581AbhIPNNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 09:13:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F2F60EB2;
        Thu, 16 Sep 2021 13:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631797911;
        bh=aFKapFh3ZtU1QMLP6PC03j8gOWqnOxuOWgQPsJMiQBs=;
        h=Subject:To:Cc:From:Date:From;
        b=G85dzptu9ZneHFabGhegl76jfYX6OrXeF5MNzDNK94gAzvmpveRKXxrvVQnE+VQON
         DdVBvgJ/mnjxvArxM/PmWuH6Wn852vJBBYFR8/eu91AhRKJ9Om0gsjJ+padCiIHXj7
         CZ7z1tYQOEsjo492ls41eJVZgk7qtny/gaJ0m+7k=
Subject: FAILED: patch "[PATCH] drm/i915/display: Do not zero past infoframes.vsc" failed to apply to 5.13-stable tree
To:     keescook@chromium.org, jose.souza@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Sep 2021 15:11:38 +0200
Message-ID: <163179789810049@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c88e2647c5bb45d04dc4302018ebe6ebbf331823 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Thu, 17 Jun 2021 14:33:01 -0700
Subject: [PATCH] drm/i915/display: Do not zero past infoframes.vsc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

intel_dp_vsc_sdp_unpack() was using a memset() size (36, struct dp_sdp)
larger than the destination (24, struct drm_dp_vsc_sdp), clobbering
fields in struct intel_crtc_state after infoframes.vsc. Use the actual
target size for the memset().

Fixes: 1b404b7dbb10 ("drm/i915/dp: Read out DP SDPs")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210617213301.1824728-1-keescook@chromium.org

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 5c9222283044..6cc03b9e4321 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2868,7 +2868,7 @@ static int intel_dp_vsc_sdp_unpack(struct drm_dp_vsc_sdp *vsc,
 	if (size < sizeof(struct dp_sdp))
 		return -EINVAL;
 
-	memset(vsc, 0, size);
+	memset(vsc, 0, sizeof(*vsc));
 
 	if (sdp->sdp_header.HB0 != 0)
 		return -EINVAL;

