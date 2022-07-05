Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D595566E20
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbiGEMbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbiGEM0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF3118B2D;
        Tue,  5 Jul 2022 05:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D01161A3D;
        Tue,  5 Jul 2022 12:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A214C341C7;
        Tue,  5 Jul 2022 12:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023529;
        bh=h3DDDGZB2qjDKZitOmDgiiz5Usvu8cFrm0N1ASIINAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRT63QO+gFaQJAqMjZN8KZ8i7dMMU01JI5np+a9Iil4lGtnOZZiaTtA7lQEsem1db
         hS5kjP11XyiC7lVuJp8lcac8Zxi+C3UcbYdpsmnvFeZJK5MFNf22Teu0sO2PmaWII8
         An9zHbiPZKG7MsxFU4AvW43IaAKJDS0nATd6JeBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casper Andersson <casper.casan@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 094/102] net: sparx5: Add handling of host MDB entries
Date:   Tue,  5 Jul 2022 13:59:00 +0200
Message-Id: <20220705115621.088985844@linuxfoundation.org>
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

[ Upstream commit 1c1ed5a48411e1686997157c21633653fbe045c6 ]

Handle adding and removing MDB entries for host

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Link: https://lore.kernel.org/r/20220503093922.1630804-1-casper.casan@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/sparx5/sparx5_switchdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 5389fffc694a..3429660cd2e5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -396,6 +396,11 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	u32 mact_entry;
 	int res, err;
 
+	if (netif_is_bridge_master(v->obj.orig_dev)) {
+		sparx5_mact_learn(spx5, PGID_CPU, v->addr, v->vid);
+		return 0;
+	}
+
 	/* When VLAN unaware the vlan value is not parsed and we receive vid 0.
 	 * Fall back to bridge vid 1.
 	 */
@@ -461,6 +466,11 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 	u32 mact_entry, res, pgid_entry[3];
 	int err;
 
+	if (netif_is_bridge_master(v->obj.orig_dev)) {
+		sparx5_mact_forget(spx5, v->addr, v->vid);
+		return 0;
+	}
+
 	if (!br_vlan_enabled(spx5->hw_bridge_dev))
 		vid = 1;
 	else
@@ -500,6 +510,7 @@ static int sparx5_handle_port_obj_add(struct net_device *dev,
 						  SWITCHDEV_OBJ_PORT_VLAN(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
 		err = sparx5_handle_port_mdb_add(dev, nb,
 						 SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
@@ -552,6 +563,7 @@ static int sparx5_handle_port_obj_del(struct net_device *dev,
 						  SWITCHDEV_OBJ_PORT_VLAN(obj)->vid);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
+	case SWITCHDEV_OBJ_ID_HOST_MDB:
 		err = sparx5_handle_port_mdb_del(dev, nb,
 						 SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
-- 
2.35.1



