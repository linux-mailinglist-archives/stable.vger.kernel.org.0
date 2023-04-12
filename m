Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82596DEF31
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjDLItC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjDLIsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693D27EEC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C2CC62A82
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90073C433EF;
        Wed, 12 Apr 2023 08:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289266;
        bh=kSfMlW5eVR9DAOMH/2ul2MyNtZv4s5yj5Dne60UaMTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCpZ/wqIZFy0+++zZCmeVZFV+MrTebMBsUEk3nGGnAlyTo5z/xxFFOL1BP9obTbma
         ZeFdeb1pwvkuKgGhwFJ66Yk8zwxb2PDpC1lOkNtcQilezXZ/ZSNt4hrJOUGUq0tRrj
         K6i+UoZ0ds57bEZYlHlX0Ej1qlbw/7Cj14+eXIsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Manivannan Sadhasivam <mani@kernel.org>,
        Ram Kumar Dharuman <quic_ramd@quicinc.com>,
        Sricharan Ramabadhran <quic_srichara@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 034/173] net: qrtr: Do not do DEL_SERVER broadcast after DEL_CLIENT
Date:   Wed, 12 Apr 2023 10:32:40 +0200
Message-Id: <20230412082839.458133674@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sricharan Ramabadhran <quic_srichara@quicinc.com>

[ Upstream commit 839349d13905927d8a567ca4d21d88c82028e31d ]

On the remote side, when QRTR socket is removed, af_qrtr will call
qrtr_port_remove() which broadcasts the DEL_CLIENT packet to all neighbours
including local NS. NS upon receiving the DEL_CLIENT packet, will remove
the lookups associated with the node:port and broadcasts the DEL_SERVER
packet.

But on the host side, due to the arrival of the DEL_CLIENT packet, the NS
would've already deleted the server belonging to that port. So when the
remote's NS again broadcasts the DEL_SERVER for that port, it throws below
error message on the host:

"failed while handling packet from 2:-2"

So fix this error by not broadcasting the DEL_SERVER packet when the
DEL_CLIENT packet gets processed."

Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Ram Kumar Dharuman <quic_ramd@quicinc.com>
Signed-off-by: Sricharan Ramabadhran <quic_srichara@quicinc.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index e595079c2cafe..3e40a1ba48f79 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -273,7 +273,7 @@ static struct qrtr_server *server_add(unsigned int service,
 	return NULL;
 }
 
-static int server_del(struct qrtr_node *node, unsigned int port)
+static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 {
 	struct qrtr_lookup *lookup;
 	struct qrtr_server *srv;
@@ -286,7 +286,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
 	radix_tree_delete(&node->servers, port);
 
 	/* Broadcast the removal of local servers */
-	if (srv->node == qrtr_ns.local_node)
+	if (srv->node == qrtr_ns.local_node && bcast)
 		service_announce_del(&qrtr_ns.bcast_sq, srv);
 
 	/* Announce the service's disappearance to observers */
@@ -372,7 +372,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
 		}
 		slot = radix_tree_iter_resume(slot, &iter);
 		rcu_read_unlock();
-		server_del(node, srv->port);
+		server_del(node, srv->port, true);
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
@@ -458,10 +458,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
 		kfree(lookup);
 	}
 
-	/* Remove the server belonging to this port */
+	/* Remove the server belonging to this port but don't broadcast
+	 * DEL_SERVER. Neighbours would've already removed the server belonging
+	 * to this port due to the DEL_CLIENT broadcast from qrtr_port_remove().
+	 */
 	node = node_get(node_id);
 	if (node)
-		server_del(node, port);
+		server_del(node, port, false);
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
@@ -566,7 +569,7 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
 	if (!node)
 		return -ENOENT;
 
-	return server_del(node, port);
+	return server_del(node, port, true);
 }
 
 static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
-- 
2.39.2



