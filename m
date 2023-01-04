Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA9065D55F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbjADOR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239269AbjADORq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:17:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B59817424
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3805A6174F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A61CC433EF;
        Wed,  4 Jan 2023 14:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841864;
        bh=g0ai9/5dDzuy0JONzJEREvCeTwFM2AAXANoeBk0Ibzo=;
        h=Subject:To:Cc:From:Date:From;
        b=FsSlOkgR8YjdbkLuRXdqHGwn/dOs/JswyqriChXATeFbeg53Z+6fpBCTk+/k95PGe
         acyPsGIOROTgOVJ8OWYjblv2ecT0Iymnt1xjnMmHkmGda9AJMaqcYWIDruAoDeR8/d
         FnPa+zTV9X2J+cLvYEiJjadRYyozuAH3G+BcPAT4=
Subject: FAILED: patch "[PATCH] drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs()" failed to apply to 5.10-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, alexander.deucher@amd.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:17:29 +0100
Message-ID: <1672841849228233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a3ae99598b9f ("drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs() return code")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3ae99598b9f89dd5ac9d2900fb7ffb3dcfa3d35 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Mon, 14 Nov 2022 17:17:53 -0500
Subject: [PATCH] drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs()
 return code

Looks like that we're accidentally dropping a pretty important return code
here. For some reason, we just return -EINVAL if we fail to get the MST
topology state. This is wrong: error codes are important and should never
be squashed without being handled, which here seems to have the potential
to cause a deadlock.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Fixes: 8ec046716ca8 ("drm/dp_mst: Add helper to trigger modeset on affected DSC MST CRTCs")
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index ecd22c038c8c..51a46689cda7 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -5186,7 +5186,7 @@ int drm_dp_mst_add_affected_dsc_crtcs(struct drm_atomic_state *state, struct drm
 	mst_state = drm_atomic_get_mst_topology_state(state, mgr);
 
 	if (IS_ERR(mst_state))
-		return -EINVAL;
+		return PTR_ERR(mst_state);
 
 	list_for_each_entry(pos, &mst_state->payloads, next) {
 

