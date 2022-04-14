Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B3E5013DA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348938AbiDNONo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347607AbiDNN7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7796822B35;
        Thu, 14 Apr 2022 06:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A0F4B828F4;
        Thu, 14 Apr 2022 13:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5E0C385A1;
        Thu, 14 Apr 2022 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944220;
        bh=0j51b2k5USNEgRfbIAqo46KnmXhRxmSxnwI1iI9Vohc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYUybhZ0l0icqVAN0ajlUK0ZwrwhkFfVdI2wvhiVZIgAG3zapQQXc4NXvrR9mwgWE
         ykxnbsL/r2PE118SrmybnqXagzNMyMpfmjprnkBTtQB7LAai7+tUGUEfEKyAJPkp4z
         jY7AKIH69yQMpNI4bHYEVmkP0IVoVnD0KEfw4gXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Leonardo=20M=C3=B6rlein?= <freifunk@irrelefant.net>,
        Sven Eckelmann <sven@narfation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 397/475] macvtap: advertise link netns via netlink
Date:   Thu, 14 Apr 2022 15:13:02 +0200
Message-Id: <20220414110906.180400810@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index 694e2f5dbbe5..39801c31e507 100644
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



