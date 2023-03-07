Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325366AF172
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjCGSoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbjCGSnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:43:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52EAA90B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:33:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9245161514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89611C433EF;
        Tue,  7 Mar 2023 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214028;
        bh=hD2BvJLSd/M3aiKh7/fdmWlFxABG0f6fyzt4dUZfTZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWwrunPuhl5uKtQc2QIA9t+aVrm/cmyd3zXrGg2M/7KaGNkzTilGYWBZuc/3hKXDg
         cS0QmEOqbiAWylmxR/BwF3B4qF5rA7VPbJGmnwkCWyQdedDmJvlVHC8DwV37Nv0e3A
         Bj9/HwmdQtciss6roMQ1iWHGWLiWutMm5XbtFwdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 6.1 696/885] fs: dlm: move sending fin message into state change handling
Date:   Tue,  7 Mar 2023 18:00:30 +0100
Message-Id: <20230307170032.338734383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

commit a58496361802070996f9bd76e941d109c4a85ebd upstream.

This patch moves the send fin handling, which should appear in a specific
state change, into the state change handling while the per node
state_lock is held. I experienced issues with other messages because
we changed the state and a fin message was sent out in a different state.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/midcomms.c |   33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -401,7 +401,7 @@ static int dlm_send_fin(struct midcomms_
 	struct dlm_mhandle *mh;
 	char *ppc;
 
-	mh = dlm_midcomms_get_mhandle(node->nodeid, mb_len, GFP_NOFS, &ppc);
+	mh = dlm_midcomms_get_mhandle(node->nodeid, mb_len, GFP_ATOMIC, &ppc);
 	if (!mh)
 		return -ENOMEM;
 
@@ -503,8 +503,8 @@ static void dlm_midcomms_receive_buffer(
 					node->state = DLM_LAST_ACK;
 					pr_debug("switch node %d to state %s case 1\n",
 						 node->nodeid, dlm_state_str(node->state));
-					spin_unlock(&node->state_lock);
-					goto send_fin;
+					set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
+					dlm_send_fin(node, dlm_pas_fin_ack_rcv);
 				}
 				break;
 			case DLM_FIN_WAIT1:
@@ -547,12 +547,6 @@ static void dlm_midcomms_receive_buffer(
 		log_print_ratelimited("ignore dlm msg because seq mismatch, seq: %u, expected: %u, nodeid: %d",
 				      seq, node->seq_next, node->nodeid);
 	}
-
-	return;
-
-send_fin:
-	set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
-	dlm_send_fin(node, dlm_pas_fin_ack_rcv);
 }
 
 static struct midcomms_node *
@@ -1286,11 +1280,11 @@ void dlm_midcomms_remove_member(int node
 		case DLM_CLOSE_WAIT:
 			/* passive shutdown DLM_LAST_ACK case 2 */
 			node->state = DLM_LAST_ACK;
-			spin_unlock(&node->state_lock);
-
 			pr_debug("switch node %d to state %s case 2\n",
 				 node->nodeid, dlm_state_str(node->state));
-			goto send_fin;
+			set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
+			dlm_send_fin(node, dlm_pas_fin_ack_rcv);
+			break;
 		case DLM_LAST_ACK:
 			/* probably receive fin caught it, do nothing */
 			break;
@@ -1306,12 +1300,6 @@ void dlm_midcomms_remove_member(int node
 	spin_unlock(&node->state_lock);
 
 	srcu_read_unlock(&nodes_srcu, idx);
-	return;
-
-send_fin:
-	set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
-	dlm_send_fin(node, dlm_pas_fin_ack_rcv);
-	srcu_read_unlock(&nodes_srcu, idx);
 }
 
 static void midcomms_node_release(struct rcu_head *rcu)
@@ -1342,6 +1330,7 @@ static void midcomms_shutdown(struct mid
 		node->state = DLM_FIN_WAIT1;
 		pr_debug("switch node %d to state %s case 2\n",
 			 node->nodeid, dlm_state_str(node->state));
+		dlm_send_fin(node, dlm_act_fin_ack_rcv);
 		break;
 	case DLM_CLOSED:
 		/* we have what we want */
@@ -1355,12 +1344,8 @@ static void midcomms_shutdown(struct mid
 	}
 	spin_unlock(&node->state_lock);
 
-	if (node->state == DLM_FIN_WAIT1) {
-		dlm_send_fin(node, dlm_act_fin_ack_rcv);
-
-		if (DLM_DEBUG_FENCE_TERMINATION)
-			msleep(5000);
-	}
+	if (DLM_DEBUG_FENCE_TERMINATION)
+		msleep(5000);
 
 	/* wait for other side dlm + fin */
 	ret = wait_event_timeout(node->shutdown_wait,


