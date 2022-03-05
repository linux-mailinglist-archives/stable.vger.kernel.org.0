Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC494CE4B7
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 13:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiCEMSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 07:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiCEMSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 07:18:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E8043AD8
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 04:17:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 564A36123F
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 12:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEFFC004E1;
        Sat,  5 Mar 2022 12:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646482632;
        bh=YKnjlxZ/8j+y7Ogaq7H4U/jgKR1pzpcjE58cbpPH/BI=;
        h=Subject:To:Cc:From:Date:From;
        b=gHbm6lHrSr5syMJoQ6AIQvqGAJsK1YxkCAPRtjq37tkG5JqMX8hzlqAKkt48NjZ+f
         RrBnDbP4LhjMY2eEIPFVbdwDpYw1Ck+5a/fNU0BKMM7gXBVOAe+nuphDEA4lwZ+HMR
         2Xb8/9f5Vy1FdBNOd0X9FI4Vre0kf5b6NkKrHQi4=
Subject: FAILED: patch "[PATCH] batman-adv: Request iflink once in batadv-on-batadv check" failed to apply to 4.9-stable tree
To:     sven@narfation.org, sw@simonwunderlich.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 13:17:09 +0100
Message-ID: <1646482629201193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From 690bb6fb64f5dc7437317153902573ecad67593d Mon Sep 17 00:00:00 2001
From: Sven Eckelmann <sven@narfation.org>
Date: Mon, 28 Feb 2022 00:01:24 +0100
Subject: [PATCH] batman-adv: Request iflink once in batadv-on-batadv check

There is no need to call dev_get_iflink multiple times for the same
net_device in batadv_is_on_batman_iface. And since some of the
.ndo_get_iflink callbacks are dynamic (for example via RCUs like in
vxcan_get_iflink), it could easily happen that the returned values are not
stable. The pre-checks before __dev_get_by_index are then of course bogus.

Fixes: b7eddd0b3950 ("batman-adv: prevent using any virtual device created on batman-adv as hard-interface")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 8a2b78f9c4b2..35aa1122043b 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -149,22 +149,23 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 	struct net *net = dev_net(net_dev);
 	struct net_device *parent_dev;
 	struct net *parent_net;
+	int iflink;
 	bool ret;
 
 	/* check if this is a batman-adv mesh interface */
 	if (batadv_softif_is_valid(net_dev))
 		return true;
 
+	iflink = dev_get_iflink(net_dev);
+
 	/* no more parents..stop recursion */
-	if (dev_get_iflink(net_dev) == 0 ||
-	    dev_get_iflink(net_dev) == net_dev->ifindex)
+	if (iflink == 0 || iflink == net_dev->ifindex)
 		return false;
 
 	parent_net = batadv_getlink_net(net_dev, net);
 
 	/* recurse over the parent device */
-	parent_dev = __dev_get_by_index((struct net *)parent_net,
-					dev_get_iflink(net_dev));
+	parent_dev = __dev_get_by_index((struct net *)parent_net, iflink);
 	/* if we got a NULL parent_dev there is something broken.. */
 	if (!parent_dev) {
 		pr_err("Cannot find parent device\n");

