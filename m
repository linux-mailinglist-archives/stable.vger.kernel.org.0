Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5846E6329
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjDRMiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbjDRMiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:38:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21F613873
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EEB1632CA
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915A7C4339C;
        Tue, 18 Apr 2023 12:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821490;
        bh=9xrZezkYN7ydKsfoRJeGhUlkNvA7pmv13b08FYg4RBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkzGf5OdbimngTjNEWpWnVyrNqEWuUADRfaAEOmGdAT7uFUNeYScSW2Ga0r1Yd2z3
         SBiM5hn4vmnyT4Mm70/1JmC7/PhXdoDcDunuBYruxHU991B4hR7XhmUphf9q78sA9t
         1ru4NxoVu19moSYvsZs7GFUyKcLpA2Pdv7m5LhWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/91] RDMA/irdma: Add ipv4 check to irdma_find_listener()
Date:   Tue, 18 Apr 2023 14:21:26 +0200
Message-Id: <20230418120306.353307245@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

[ Upstream commit e4522c097ec10f23ea0933e9e69d4fa9d8ae9441 ]

Add ipv4 check to irdma_find_listener(). Otherwise the function
incorrectly finds and returns a listener with a different addr family for
the zero IP addr, if a listener with a zero IP addr and the same port as
the one searched for has already been created.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20230315145231.931-5-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index a8ec3d8f6e465..64d4bb0e9a12f 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1458,13 +1458,15 @@ static int irdma_send_fin(struct irdma_cm_node *cm_node)
  * irdma_find_listener - find a cm node listening on this addr-port pair
  * @cm_core: cm's core
  * @dst_addr: listener ip addr
+ * @ipv4: flag indicating IPv4 when true
  * @dst_port: listener tcp port num
  * @vlan_id: virtual LAN ID
  * @listener_state: state to match with listen node's
  */
 static struct irdma_cm_listener *
-irdma_find_listener(struct irdma_cm_core *cm_core, u32 *dst_addr, u16 dst_port,
-		    u16 vlan_id, enum irdma_cm_listener_state listener_state)
+irdma_find_listener(struct irdma_cm_core *cm_core, u32 *dst_addr, bool ipv4,
+		    u16 dst_port, u16 vlan_id,
+		    enum irdma_cm_listener_state listener_state)
 {
 	struct irdma_cm_listener *listen_node;
 	static const u32 ip_zero[4] = { 0, 0, 0, 0 };
@@ -1477,7 +1479,7 @@ irdma_find_listener(struct irdma_cm_core *cm_core, u32 *dst_addr, u16 dst_port,
 	list_for_each_entry (listen_node, &cm_core->listen_list, list) {
 		memcpy(listen_addr, listen_node->loc_addr, sizeof(listen_addr));
 		listen_port = listen_node->loc_port;
-		if (listen_port != dst_port ||
+		if (listen_node->ipv4 != ipv4 || listen_port != dst_port ||
 		    !(listener_state & listen_node->listener_state))
 			continue;
 		/* compare node pair, return node handle if a match */
@@ -2899,9 +2901,10 @@ irdma_make_listen_node(struct irdma_cm_core *cm_core,
 	unsigned long flags;
 
 	/* cannot have multiple matching listeners */
-	listener = irdma_find_listener(cm_core, cm_info->loc_addr,
-				       cm_info->loc_port, cm_info->vlan_id,
-				       IRDMA_CM_LISTENER_EITHER_STATE);
+	listener =
+		irdma_find_listener(cm_core, cm_info->loc_addr, cm_info->ipv4,
+				    cm_info->loc_port, cm_info->vlan_id,
+				    IRDMA_CM_LISTENER_EITHER_STATE);
 	if (listener &&
 	    listener->listener_state == IRDMA_CM_LISTENER_ACTIVE_STATE) {
 		refcount_dec(&listener->refcnt);
@@ -3150,6 +3153,7 @@ void irdma_receive_ilq(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *rbuf)
 
 		listener = irdma_find_listener(cm_core,
 					       cm_info.loc_addr,
+					       cm_info.ipv4,
 					       cm_info.loc_port,
 					       cm_info.vlan_id,
 					       IRDMA_CM_LISTENER_ACTIVE_STATE);
-- 
2.39.2



