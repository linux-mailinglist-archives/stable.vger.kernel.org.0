Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E444BE665
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352274AbiBUJyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:54:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352283AbiBUJxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:53:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07FA36E10;
        Mon, 21 Feb 2022 01:23:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F387B80EA1;
        Mon, 21 Feb 2022 09:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFCFC340E9;
        Mon, 21 Feb 2022 09:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435409;
        bh=wJmGrICC3wKZT0xL+U7a9yjc8m1LvWGA1Zirvk0fbuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRE38Fu6jObPNBavMaqFtZ15VoSqolYwAS+QuRT5zGipQHwCubQkEu7BAt7sYgthj
         hD7OfVYMgIMg6PoZ8LKaxfNha78PalKqjEMTP6B+LAO7N0DgId7ABrvg0Eqs/v68tT
         Ruueg4Ii8WFyEPmqNG3uHv5zlYqK1iJlrlAAKFbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 154/227] tipc: fix wrong notification node addresses
Date:   Mon, 21 Feb 2022 09:49:33 +0100
Message-Id: <20220221084939.947633132@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Jon Maloy <jmaloy@redhat.com>

commit c08e58438d4a709fb451b6d7d33432cc9907a2a8 upstream.

The previous bug fix had an unfortunate side effect that broke
distribution of binding table entries between nodes. The updated
tipc_sock_addr struct is also used further down in the same
function, and there the old value is still the correct one.

Fixes: 032062f363b4 ("tipc: fix wrong publisher node address in link publications")
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
Link: https://lore.kernel.org/r/20220216020009.3404578-1-jmaloy@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -403,7 +403,7 @@ static void tipc_node_write_unlock(struc
 	u32 flags = n->action_flags;
 	struct list_head *publ_list;
 	struct tipc_uaddr ua;
-	u32 bearer_id;
+	u32 bearer_id, node;
 
 	if (likely(!flags)) {
 		write_unlock_bh(&n->lock);
@@ -414,6 +414,7 @@ static void tipc_node_write_unlock(struc
 		   TIPC_LINK_STATE, n->addr, n->addr);
 	sk.ref = n->link_id;
 	sk.node = tipc_own_addr(net);
+	node = n->addr;
 	bearer_id = n->link_id & 0xffff;
 	publ_list = &n->publ_list;
 
@@ -423,17 +424,17 @@ static void tipc_node_write_unlock(struc
 	write_unlock_bh(&n->lock);
 
 	if (flags & TIPC_NOTIFY_NODE_DOWN)
-		tipc_publ_notify(net, publ_list, sk.node, n->capabilities);
+		tipc_publ_notify(net, publ_list, node, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_NODE_UP)
-		tipc_named_node_up(net, sk.node, n->capabilities);
+		tipc_named_node_up(net, node, n->capabilities);
 
 	if (flags & TIPC_NOTIFY_LINK_UP) {
-		tipc_mon_peer_up(net, sk.node, bearer_id);
+		tipc_mon_peer_up(net, node, bearer_id);
 		tipc_nametbl_publish(net, &ua, &sk, sk.ref);
 	}
 	if (flags & TIPC_NOTIFY_LINK_DOWN) {
-		tipc_mon_peer_down(net, sk.node, bearer_id);
+		tipc_mon_peer_down(net, node, bearer_id);
 		tipc_nametbl_withdraw(net, &ua, &sk, sk.ref);
 	}
 }


