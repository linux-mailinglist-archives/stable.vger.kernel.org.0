Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772405050E3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiDRM3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238972AbiDRM1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A881D0CB;
        Mon, 18 Apr 2022 05:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C7CB80EDB;
        Mon, 18 Apr 2022 12:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2086CC385A8;
        Mon, 18 Apr 2022 12:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284458;
        bh=wcPlPnh2qViyo5jp28WdnDo3WOOO2Zu7J2KmS57eJt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/8ZTNxuc71KzKRGtdorkfs+7NSBQbrZp8ByxSNHb9fKK3rEcSDBAEwjGjEBx9yFh
         gRCruPtnD3CWZx/Y5h/HfykqD5bPNyjzyCDhsQGgbjt3WxXZaeCI0VHuo1VxYkkLdX
         6siLUh5bD88uYbEGJj/0AIIpXUl5iBVrYkjzHc2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 104/219] net: lan966x: Fix when a ports upper is changed.
Date:   Mon, 18 Apr 2022 14:11:13 +0200
Message-Id: <20220418121209.804793703@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit d7a947d289dc205fc717c004dcebe33b15305afd ]

On lan966x it is not allowed to have foreign interfaces under a bridge
which already contains lan966x ports. So when a port leaves the bridge
it would call switchdev_bridge_port_unoffload which eventually will
notify the other ports that bridge left the vlan group but that is not
true because the bridge is still part of the vlan group.

Therefore when a port leaves the bridge, stop generating replays because
already the HW cleared after itself and the other ports don't need to do
anything else.

Fixes: cf2f60897e921e ("net: lan966x: Add support to offload the forwarding.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 7de55f6a4da8..3c987fd6b9e2 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -261,8 +261,7 @@ static int lan966x_port_prechangeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		switchdev_bridge_port_unoffload(port->dev, port,
-						&lan966x_switchdev_nb,
-						&lan966x_switchdev_blocking_nb);
+						NULL, NULL);
 
 	return NOTIFY_DONE;
 }
-- 
2.35.1



