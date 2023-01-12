Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5526686C1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 23:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240561AbjALWUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 17:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240547AbjALWUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 17:20:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40D111C09
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673561460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zrv3Cpf3PC4JC4IQVUQ24d/+11YjpOhvE0jh+Ejw0S8=;
        b=PSrUfCZRYEGI++Y8R21f5teSDyv898/tB84h3hWfx6VLd5JFAxrNif4xQuLK2/OJhifP7I
        gTzG//6/XN6wRlhUTt6eZrJNPeIwmYd90MGFwSbq1CE9st8rwiv1IiPJAiAcQmlg2UY/9L
        2oE/qAoPkWNDnB97JXBnxxjFsRVXWYw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-iFXGSx6rMIOqKIN9lpSBlA-1; Thu, 12 Jan 2023 17:10:57 -0500
X-MC-Unique: iFXGSx6rMIOqKIN9lpSBlA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 671508828C1
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 22:10:57 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 401661121314;
        Thu, 12 Jan 2023 22:10:57 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, aahringo@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH dlm/next 6/7] fs: dlm: move sending fin message into state change handling
Date:   Thu, 12 Jan 2023 17:10:36 -0500
Message-Id: <20230112221037.1882548-6-aahringo@redhat.com>
In-Reply-To: <20230112221037.1882548-1-aahringo@redhat.com>
References: <20230112221037.1882548-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch moves the send fin handling which should appear in a specific
state change into the state change handling while the per node
state_lock is held. I expierenced issues when other messages because
we changed the state and a fin message was send out in a different state.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/midcomms.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 1fef99214204..fd9f413cabcd 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -402,7 +402,7 @@ static int dlm_send_fin(struct midcomms_node *node,
 	struct dlm_mhandle *mh;
 	char *ppc;
 
-	mh = dlm_midcomms_get_mhandle(node->nodeid, mb_len, GFP_NOFS, &ppc);
+	mh = dlm_midcomms_get_mhandle(node->nodeid, mb_len, GFP_ATOMIC, &ppc);
 	if (!mh)
 		return -ENOMEM;
 
@@ -518,8 +518,8 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
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
@@ -563,12 +563,6 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
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
@@ -1368,11 +1362,11 @@ void dlm_midcomms_remove_member(int nodeid)
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
@@ -1388,12 +1382,6 @@ void dlm_midcomms_remove_member(int nodeid)
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
@@ -1425,6 +1413,7 @@ static void midcomms_shutdown(struct midcomms_node *node)
 		node->state = DLM_FIN_WAIT1;
 		pr_debug("switch node %d to state %s case 2\n",
 			 node->nodeid, dlm_state_str(node->state));
+		dlm_send_fin(node, dlm_act_fin_ack_rcv);
 		break;
 	case DLM_CLOSED:
 		/* we have what we want */
@@ -1438,12 +1427,8 @@ static void midcomms_shutdown(struct midcomms_node *node)
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
-- 
2.31.1

