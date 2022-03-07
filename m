Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98134CF5E6
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbiCGJbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbiCGJ26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290C566AC3;
        Mon,  7 Mar 2022 01:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09315B810C2;
        Mon,  7 Mar 2022 09:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B32DC340E9;
        Mon,  7 Mar 2022 09:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645216;
        bh=GJm7fJ8uut8H1LDJ+ADgX5VYZSZ0FaWV/2sJMYkllf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gdzZ0Elc9+k2tzpLZSpqZ1Kwrt3OH9gZfx6lB1wkiyfvrcdj1t60e/LlZxs5dVLae
         9X27z7Pi2ITMsu+l0axxW3i9kqsJvcy0uB8F9bY97jhUqaWUaabe2dwoo3sSrwReQn
         1umVDE6qmf1dd87pTV2ytlwV4H+gJJUrQneagfXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.4 24/64] batman-adv: Request iflink once in batadv_get_real_netdevice
Date:   Mon,  7 Mar 2022 10:18:57 +0100
Message-Id: <20220307091639.832079053@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
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

commit 6116ba09423f7d140f0460be6a1644dceaad00da upstream.

There is no need to call dev_get_iflink multiple times for the same
net_device in batadv_get_real_netdevice. And since some of the
ndo_get_iflink callbacks are dynamic (for example via RCUs like in
vxcan_get_iflink), it could easily happen that the returned values are not
stable. The pre-checks before __dev_get_by_index are then of course bogus.

Fixes: 5ed4a460a1d3 ("batman-adv: additional checks for virtual interfaces on top of WiFi")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/hard-interface.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -217,14 +217,16 @@ static struct net_device *batadv_get_rea
 	struct net_device *real_netdev = NULL;
 	struct net *real_net;
 	struct net *net;
-	int ifindex;
+	int iflink;
 
 	ASSERT_RTNL();
 
 	if (!netdev)
 		return NULL;
 
-	if (netdev->ifindex == dev_get_iflink(netdev)) {
+	iflink = dev_get_iflink(netdev);
+
+	if (netdev->ifindex == iflink) {
 		dev_hold(netdev);
 		return netdev;
 	}
@@ -234,9 +236,8 @@ static struct net_device *batadv_get_rea
 		goto out;
 
 	net = dev_net(hard_iface->soft_iface);
-	ifindex = dev_get_iflink(netdev);
 	real_net = batadv_getlink_net(netdev, net);
-	real_netdev = dev_get_by_index(real_net, ifindex);
+	real_netdev = dev_get_by_index(real_net, iflink);
 
 out:
 	if (hard_iface)


