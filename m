Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC40566E21
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbiGEMbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237976AbiGEM0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A35A18E13;
        Tue,  5 Jul 2022 05:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 051ED61984;
        Tue,  5 Jul 2022 12:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14460C341C7;
        Tue,  5 Jul 2022 12:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023532;
        bh=ADwui9E0rfIJoCR/H1EoQbMIg5U6xbIwzSp52+1nWDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXHU2SmYknjpyzeo4UprzpEODAD5ler7kyF0bREDbN1gjQoBcniRSZpEKmcpjpsKk
         JYKBSS8qJ6l1F+do30bZ1AFPAVA94DAoAiOPqOBQ34J2T1gY3aQkukyN3O4K06I+9a
         gWhHbc5n/1I71/lTzFiYxfcDg8AEQdGPlBIx1YKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casper Andersson <casper.casan@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 095/102] net: sparx5: mdb add/del handle non-sparx5 devices
Date:   Tue,  5 Jul 2022 13:59:01 +0200
Message-Id: <20220705115621.116971720@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Casper Andersson <casper.casan@gmail.com>

[ Upstream commit 9c5de246c1dbe785268fc2e83c88624b92e4ec93 ]

When adding/deleting mdb entries on other net_devices, eg., tap
interfaces, it should not crash.

Fixes: 3bacfccdcb2d ("net: sparx5: Add mdb handlers")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Link: https://lore.kernel.org/r/20220630122226.316812-1-casper.casan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 3429660cd2e5..5edc8b7176c8 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -396,6 +396,9 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	u32 mact_entry;
 	int res, err;
 
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
 	if (netif_is_bridge_master(v->obj.orig_dev)) {
 		sparx5_mact_learn(spx5, PGID_CPU, v->addr, v->vid);
 		return 0;
@@ -466,6 +469,9 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 	u32 mact_entry, res, pgid_entry[3];
 	int err;
 
+	if (!sparx5_netdevice_check(dev))
+		return -EOPNOTSUPP;
+
 	if (netif_is_bridge_master(v->obj.orig_dev)) {
 		sparx5_mact_forget(spx5, v->addr, v->vid);
 		return 0;
-- 
2.35.1



