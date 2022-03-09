Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17ADE4D35E3
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbiCIRFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239472AbiCIRFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:05:02 -0500
X-Greylist: delayed 532 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 08:55:33 PST
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59582DBD3B
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1646844370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9LT95Zfk+rYqKuti6LG5WksKN8jujhcd8v0/tR98hA=;
        b=1NDXs2YkNozfJH6XDRcrzQ0aps5sq9tz9S3AiXKUQqXNgeJBAUF1XYfYEcV1xX228/2nM9
        nPY8rcxZCmLDnN/rm1xRRA7SfoN3DIVPS5h/uOc9AOkXuQKYW7O4L442SGC2CwGYgwke9h
        xXM1aUBqJLi4sXpgLcQTfqWPCQHjA/U=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 1/2] batman-adv: Request iflink once in batadv-on-batadv check
Date:   Wed,  9 Mar 2022 17:45:41 +0100
Message-Id: <20220309164542.408824-2-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220309164542.408824-1-sven@narfation.org>
References: <20220309164542.408824-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 690bb6fb64f5dc7437317153902573ecad67593d upstream.

There is no need to call dev_get_iflink multiple times for the same
net_device in batadv_is_on_batman_iface. And since some of the
.ndo_get_iflink callbacks are dynamic (for example via RCUs like in
vxcan_get_iflink), it could easily happen that the returned values are not
stable. The pre-checks before __dev_get_by_index are then of course bogus.

Fixes: b7eddd0b3950 ("batman-adv: prevent using any virtual device created on batman-adv as hard-interface")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.9 backported: adjust context. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/hard-interface.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 4f384abb4ced..64cf9cd3be4d 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -155,22 +155,23 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 	struct net *net = dev_net(net_dev);
 	struct net_device *parent_dev;
 	const struct net *parent_net;
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
-- 
2.30.2

