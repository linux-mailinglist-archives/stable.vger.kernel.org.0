Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DC34BBAF7
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 15:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiBROwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 09:52:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiBROwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 09:52:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4F43C49C
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 06:52:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57D4E617CB
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 14:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C10C340E9;
        Fri, 18 Feb 2022 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645195925;
        bh=8LHfCzvVGIMgDsbMV+xKkmWi3pVv2YurgllhtvMOFo0=;
        h=Subject:To:Cc:From:Date:From;
        b=bRo+Q8UeMyTTlhljof/SxJG4I2n7rfgVgeMAgwdAPGufvbnVZSX0lsIdAWYK34dvh
         BQ/8aW/zrUjr8vg+TY1X7ZQLaZW4FsNDJk98XnqJO24FjROvmggHVA979Vvue143qF
         NufrarS93LEMlCqUiXYKsYFE6L+t3ZwHL31XyHbA=
Subject: FAILED: patch "[PATCH] net: bridge: multicast: notify switchdev driver whenever MC" failed to apply to 4.14-stable tree
To:     oleksandr.mazur@plvision.eu, kuba@kernel.org, nikolay@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 15:51:59 +0100
Message-ID: <164519591918944@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c832962ac972082b3a1f89775c9d4274c8cb5670 Mon Sep 17 00:00:00 2001
From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Date: Tue, 15 Feb 2022 18:53:03 +0200
Subject: [PATCH] net: bridge: multicast: notify switchdev driver whenever MC
 processing gets disabled

Whenever bridge driver hits the max capacity of MDBs, it disables
the MC processing (by setting corresponding bridge option), but never
notifies switchdev about such change (the notifiers are called only upon
explicit setting of this option, through the registered netlink interface).

This could lead to situation when Software MDB processing gets disabled,
but this event never gets offloaded to the underlying Hardware.

Fix this by adding a notify message in such case.

Fixes: 147c1e9b902c ("switchdev: bridge: Offload multicast disabled")
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/20220215165303.31908-1-oleksandr.mazur@plvision.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de2409889489..db4f2641d1cd 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -82,6 +82,9 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
 
+static int br_mc_disabled_update(struct net_device *dev, bool value,
+				 struct netlink_ext_ack *extack);
+
 static struct net_bridge_port_group *
 br_sg_port_find(struct net_bridge *br,
 		struct net_bridge_port_group_sg_key *sg_p)
@@ -1156,6 +1159,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		return mp;
 
 	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
+		br_mc_disabled_update(br->dev, false, NULL);
 		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 		return ERR_PTR(-E2BIG);
 	}

