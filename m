Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1866F594B96
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348843AbiHPAXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353228AbiHPAUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:20:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE9617C32E;
        Mon, 15 Aug 2022 13:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D326117D;
        Mon, 15 Aug 2022 20:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A21C433C1;
        Mon, 15 Aug 2022 20:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595622;
        bh=VQGx/IU7kOtacVCrGRXqdtCla6OPAn5IxSG9vexBIsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjEKGMWzhJZTczRf++1qDOI/3PDIlA1SjGZuc34EDR3FaNTYHSBY+X157vZervGY0
         4xofmq+ogUyW1nllZr919xNofP6tFpFmq0mLDY73PheFiDTjCbTvSJvQvNMHGkzPWX
         UGNAenFTlahLOBs8itCrjb3mehOPG1aj9S5+lTQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0821/1157] RDMA/irdma: Fix VLAN connection with wildcard address
Date:   Mon, 15 Aug 2022 20:02:57 +0200
Message-Id: <20220815180512.326176096@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 82ab2b52654c43ba24a3f6603fec40874cc5a7e5 ]

When an application listens on a wildcard address, and there are VLAN and
non-VLAN IP addresses, iWARP connection establishemnt can fail if the listen
node VLAN ID does not match.

Fix this by checking the vlan_id only if not a wildcard listen node.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Link: https://lore.kernel.org/r/20220705230815.265-7-shiraz.saleem@intel.com
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 646fa8677490..7b086fe63a24 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1477,12 +1477,13 @@ irdma_find_listener(struct irdma_cm_core *cm_core, u32 *dst_addr, u16 dst_port,
 	list_for_each_entry (listen_node, &cm_core->listen_list, list) {
 		memcpy(listen_addr, listen_node->loc_addr, sizeof(listen_addr));
 		listen_port = listen_node->loc_port;
+		if (listen_port != dst_port ||
+		    !(listener_state & listen_node->listener_state))
+			continue;
 		/* compare node pair, return node handle if a match */
-		if ((!memcmp(listen_addr, dst_addr, sizeof(listen_addr)) ||
-		     !memcmp(listen_addr, ip_zero, sizeof(listen_addr))) &&
-		    listen_port == dst_port &&
-		    vlan_id == listen_node->vlan_id &&
-		    (listener_state & listen_node->listener_state)) {
+		if (!memcmp(listen_addr, ip_zero, sizeof(listen_addr)) ||
+		    (!memcmp(listen_addr, dst_addr, sizeof(listen_addr)) &&
+		     vlan_id == listen_node->vlan_id)) {
 			refcount_inc(&listen_node->refcnt);
 			spin_unlock_irqrestore(&cm_core->listen_list_lock,
 					       flags);
-- 
2.35.1



