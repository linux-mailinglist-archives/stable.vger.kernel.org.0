Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E536B3E0F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjCJLiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjCJLhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:37:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B60B75A52
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 03:37:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38A9161369
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 11:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA2EC433EF;
        Fri, 10 Mar 2023 11:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678448268;
        bh=b19V/le9z7lL843j4h1J+Qbl+W8pyzc9gKUybA3eYy4=;
        h=Subject:To:Cc:From:Date:From;
        b=TzY97lPEj+Tuqsu+AM/sK29y2cJdUPNJoN2LNdeH6wetQBaLiNBBZJoFNHgGrlQpU
         Ovj3elILB3G7sUgJwyU5onVV8mzu9iXEjFaluOGvFP+OK9FqWbhmmPHsHkmG7ayHKg
         8seCvdT6c8Ol84TVqLIdyxF0bjk1UcuaRjb/cD9M=
Subject: FAILED: patch "[PATCH] drm/i915/dsi: fix VBT send packet port selection for dual" failed to apply to 5.15-stable tree
To:     mikko.kovanen@aavamobile.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 12:37:35 +0100
Message-ID: <167844825562231@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 8d58bb7991c45f6b60710cc04c9498c6ea96db90
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167844825562231@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

8d58bb7991c4 ("drm/i915/dsi: fix VBT send packet port selection for dual link DSI")
08c59dde71b7 ("drm/i915/dsi: fix VBT send packet port selection for ICL+")

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
 

