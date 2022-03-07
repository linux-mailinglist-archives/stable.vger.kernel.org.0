Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350494CF988
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240017AbiCGKGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240027AbiCGKFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:05:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FCC76651;
        Mon,  7 Mar 2022 01:52:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE6BB608C0;
        Mon,  7 Mar 2022 09:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6403C340F3;
        Mon,  7 Mar 2022 09:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646731;
        bh=ubYZLPsvSjt4wj0ebdsKZ/CA5idFgv8UFzuCxWiQYVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uq6c12xm+kL2VgOmPDmPi23q6Uu1/7cxrwrSY3tbuMa/3FEuupEsQryD6Fh0Zpb8
         vi1NsqdPm30TE3rm/PTOKZyb7y/Et7i6cwpf2QR8FkfysYF8h4P3i9xUiplXkIXAYs
         Z7d48lzt5peHxk27FJpTRoELBoL9H+Wew2zKFE0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.16 076/186] batman-adv: Request iflink once in batadv-on-batadv check
Date:   Mon,  7 Mar 2022 10:18:34 +0100
Message-Id: <20220307091656.214375021@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit 690bb6fb64f5dc7437317153902573ecad67593d upstream.

There is no need to call dev_get_iflink multiple times for the same
net_device in batadv_is_on_batman_iface. And since some of the
.ndo_get_iflink callbacks are dynamic (for example via RCUs like in
vxcan_get_iflink), it could easily happen that the returned values are not
stable. The pre-checks before __dev_get_by_index are then of course bogus.

Fixes: b7eddd0b3950 ("batman-adv: prevent using any virtual device created on batman-adv as hard-interface")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/hard-interface.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -149,22 +149,23 @@ static bool batadv_is_on_batman_iface(co
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


