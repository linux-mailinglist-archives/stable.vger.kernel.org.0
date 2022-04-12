Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1454FD3F0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbiDLHsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357124AbiDLHjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DEBE0C9;
        Tue, 12 Apr 2022 00:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 531AD61701;
        Tue, 12 Apr 2022 07:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66537C385A5;
        Tue, 12 Apr 2022 07:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747545;
        bh=pVMto6fjjwueK9ViwPV90DDETbSPUIeOI1EqV4D79rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPFvxgi3efw8Fm2ugpkp+DTVO9y8kxWe03UqOREfVtFJlnBZZMPIxcPKFSBkiO/0z
         PCgaQdKsZnKV6hp1/ebPcw9I9MDm5zuW7g2jAC0UHgcaDXKq4bPgsrIv5akH/u5Kh+
         qCLTMxNrYxCPLXeMWy37DWa+vvf3g0FeaKqCz/vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Leonardo=20M=C3=B6rlein?= <freifunk@irrelefant.net>,
        Sven Eckelmann <sven@narfation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 119/343] macvtap: advertise link netns via netlink
Date:   Tue, 12 Apr 2022 08:28:57 +0200
Message-Id: <20220412062954.823238910@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit a02192151b7dbf855084c38dca380d77c7658353 ]

Assign rtnl_link_ops->get_link_net() callback so that IFLA_LINK_NETNSID is
added to rtnetlink messages. This fixes iproute2 which otherwise resolved
the link interface to an interface in the wrong namespace.

Test commands:

  ip netns add nst
  ip link add dummy0 type dummy
  ip link add link macvtap0 link dummy0 type macvtap
  ip link set macvtap0 netns nst
  ip -netns nst link show macvtap0

Before:

  10: macvtap0@gre0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 500
      link/ether 5e:8f:ae:1d:60:50 brd ff:ff:ff:ff:ff:ff

After:

  10: macvtap0@if2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 500
      link/ether 5e:8f:ae:1d:60:50 brd ff:ff:ff:ff:ff:ff link-netnsid 0

Reported-by: Leonardo Mörlein <freifunk@irrelefant.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Link: https://lore.kernel.org/r/20220228003240.1337426-1-sven@narfation.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvtap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 6b12902a803f..cecf8c63096c 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -133,11 +133,17 @@ static void macvtap_setup(struct net_device *dev)
 	dev->tx_queue_len = TUN_READQ_SIZE;
 }
 
+static struct net *macvtap_link_net(const struct net_device *dev)
+{
+	return dev_net(macvlan_dev_real_dev(dev));
+}
+
 static struct rtnl_link_ops macvtap_link_ops __read_mostly = {
 	.kind		= "macvtap",
 	.setup		= macvtap_setup,
 	.newlink	= macvtap_newlink,
 	.dellink	= macvtap_dellink,
+	.get_link_net	= macvtap_link_net,
 	.priv_size      = sizeof(struct macvtap_dev),
 };
 
-- 
2.35.1



