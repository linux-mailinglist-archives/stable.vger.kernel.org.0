Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAD1583080
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242048AbiG0Riy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242674AbiG0RiT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:38:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D945C8720C;
        Wed, 27 Jul 2022 09:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8263061703;
        Wed, 27 Jul 2022 16:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC19C433D6;
        Wed, 27 Jul 2022 16:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940637;
        bh=o+akZ35ZAEw0I3rv/1uVKaBlVR4impvq0HOGY5wcKYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mR3snXN57K0UJiorfNTINx2sh+2vxSb4hw6DXTC1zcb5SMWnaTxZA7lzYzc5sb8cz
         7uVeKdzoZbOJPfPljJtVeYGPZyMudvwettZGcuNiURcx7TQXJ56Pwqe7fAIuZzBCOm
         dQQWwMJQMRvNryxaZCyvxSu0CM0+daaxvLSbD3RE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 093/158] net: dsa: fix NULL pointer dereference in dsa_port_reset_vlan_filtering
Date:   Wed, 27 Jul 2022 18:12:37 +0200
Message-Id: <20220727161025.191624282@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 1699b4d502eda3c7ea4070debad3ee570b5091b1 ]

The "ds" iterator variable used in dsa_port_reset_vlan_filtering() ->
dsa_switch_for_each_port() overwrites the "dp" received as argument,
which is later used to call dsa_port_vlan_filtering() proper.

As a result, switches which do enter that code path (the ones with
vlan_filtering_is_global=true) will dereference an invalid dp in
dsa_port_reset_vlan_filtering() after leaving a VLAN-aware bridge.

Use a dedicated "other_dp" iterator variable to avoid this from
happening.

Fixes: d0004a020bb5 ("net: dsa: remove the "dsa_to_port in a loop" antipattern from the core")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6aab5768ef96..7bc79e28d48e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -248,6 +248,7 @@ static void dsa_port_reset_vlan_filtering(struct dsa_port *dp,
 	struct netlink_ext_ack extack = {0};
 	bool change_vlan_filtering = false;
 	struct dsa_switch *ds = dp->ds;
+	struct dsa_port *other_dp;
 	bool vlan_filtering;
 	int err;
 
@@ -270,8 +271,8 @@ static void dsa_port_reset_vlan_filtering(struct dsa_port *dp,
 	 * VLAN-aware bridge.
 	 */
 	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
-		dsa_switch_for_each_port(dp, ds) {
-			struct net_device *br = dsa_port_bridge_dev_get(dp);
+		dsa_switch_for_each_port(other_dp, ds) {
+			struct net_device *br = dsa_port_bridge_dev_get(other_dp);
 
 			if (br && br_vlan_enabled(br)) {
 				change_vlan_filtering = false;
-- 
2.35.1



