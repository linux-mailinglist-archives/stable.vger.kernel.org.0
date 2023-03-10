Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C7E6B3E14
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCJLiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjCJLiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:38:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D59019C7C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:38:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00B00CE289D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27E8C433EF;
        Fri, 10 Mar 2023 11:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448283;
        bh=0D14J+EBn2KDwVVU7H+4fd6GwV28qYpe+ubqCT5Wi/4=;
        h=Subject:To:Cc:From:Date:From;
        b=VdN9cG4Xt8l5kGsYDlRh57Z+3r6ZqRQ9ZxmHIi4Tf0z65Ma3vIf5Ay5xrP16vrRp/
         WXJK7uugv7HXhaR+RiWBvBTtKTVD4aWljfqbzE4nkgZ1jLSnObXKnizLhVDEGn+/A2
         PiF4efVDxLVvzAxImMly5Mt68rYIAUjxlEUST1oY=
Subject: FAILED: patch "[PATCH] drm/i915/display: Check source height is > 0" failed to apply to 5.10-stable tree
To:     ddavenport@chromium.org, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:37:50 +0100
Message-ID: <1678448270113189@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 0fe76b198d482b41771a8d17b45fb726d13083cf
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678448270113189@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

0fe76b198d48 ("drm/i915/display: Check source height is > 0")
46d12f911821 ("drm/i915: migrate skl planes code new file (v5)")
29e925590133 ("Merge tag 'topic/adl-s-enabling-2021-02-01-1' of git://anongit.freedesktop.org/drm/drm-intel into drm-intel-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0fe76b198d482b41771a8d17b45fb726d13083cf Mon Sep 17 00:00:00 2001
From: Drew Davenport <ddavenport@chromium.org>
Date: Mon, 26 Dec 2022 22:53:24 -0700
Subject: [PATCH] drm/i915/display: Check source height is > 0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The error message suggests that the height of the src rect must be at
least 1. Reject source with height of 0.

Cc: stable@vger.kernel.org
Signed-off-by: Drew Davenport <ddavenport@chromium.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221226225246.1.I15dff7bb5a0e485c862eae61a69096caf12ef29f@changeid

diff --git a/drivers/gpu/drm/i915/display/skl_universal_plane.c b/drivers/gpu/drm/i915/display/skl_universal_plane.c
index 76490cc59d8f..7d07fa3123ec 100644
--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -1627,7 +1627,7 @@ static int skl_check_main_surface(struct intel_plane_state *plane_state)
 	u32 offset;
 	int ret;
 
-	if (w > max_width || w < min_width || h > max_height) {
+	if (w > max_width || w < min_width || h > max_height || h < 1) {
 		drm_dbg_kms(&dev_priv->drm,
 			    "requested Y/RGB source size %dx%d outside limits (min: %dx1 max: %dx%d)\n",
 			    w, h, min_width, max_width, max_height);

