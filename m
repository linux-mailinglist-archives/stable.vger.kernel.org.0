Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D3E6B3E0C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCJLho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjCJLhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:37:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1DB75A52
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:37:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44790B82267
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD92AC433EF;
        Fri, 10 Mar 2023 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448257;
        bh=f1IBRgdHREi/nC128Q2B/uLYsR8dayjdgBITCImP+NQ=;
        h=Subject:To:Cc:From:Date:From;
        b=ZcAhZSNn3ZyRV/wIDAX47Y1xYrnnFFWzhFOFyzpT9S4sDqEBkZo653msqqgyBiBjC
         2Yk2zzDin4LDS8X3eXwNELDPX5G2d6vlVOGiebuFLNlFpfNlv8idQlXdkQvZ21n5xO
         XA1+ddpfm0TwwsDlXv4Po1vfO2nL3gcn8CjJwJLw=
Subject: FAILED: patch "[PATCH] drm/i915/dsi: fix VBT send packet port selection for dual" failed to apply to 6.2-stable tree
To:     mikko.kovanen@aavamobile.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:37:34 +0100
Message-ID: <167844825420220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x 8d58bb7991c45f6b60710cc04c9498c6ea96db90
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844825420220@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

8d58bb7991c4 ("drm/i915/dsi: fix VBT send packet port selection for dual link DSI")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8d58bb7991c45f6b60710cc04c9498c6ea96db90 Mon Sep 17 00:00:00 2001
From: Mikko Kovanen <mikko.kovanen@aavamobile.com>
Date: Sat, 26 Nov 2022 13:27:13 +0000
Subject: [PATCH] drm/i915/dsi: fix VBT send packet port selection for dual
 link DSI

intel_dsi->ports contains bitmask of enabled ports and correspondingly
logic for selecting port for VBT packet sending must use port specific
bitmask when deciding appropriate port.

Fixes: 08c59dde71b7 ("drm/i915/dsi: fix VBT send packet port selection for ICL+")
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Kovanen <mikko.kovanen@aavamobile.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/DBBPR09MB466592B16885D99ABBF2393A91119@DBBPR09MB4665.eurprd09.prod.outlook.com

diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
index 75e8cc4337c9..fce69fa446d5 100644
--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -137,9 +137,9 @@ static enum port intel_dsi_seq_port_to_port(struct intel_dsi *intel_dsi,
 		return ffs(intel_dsi->ports) - 1;
 
 	if (seq_port) {
-		if (intel_dsi->ports & PORT_B)
+		if (intel_dsi->ports & BIT(PORT_B))
 			return PORT_B;
-		else if (intel_dsi->ports & PORT_C)
+		else if (intel_dsi->ports & BIT(PORT_C))
 			return PORT_C;
 	}
 

