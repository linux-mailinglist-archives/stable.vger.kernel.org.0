Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D856BB229
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjCOMdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbjCOMd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:33:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA408EA17
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67F60B81E06
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB222C4339B;
        Wed, 15 Mar 2023 12:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883541;
        bh=UNDYHpeGlfFNYwkXamtfmtyBaa6ciPT80EzGn7U4vNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sm/WYhEXKP49GPbOazC73jBvVp3CGMuKWf2bHfyUJnvD5iJekqy0uTm3HACkCmv87
         RodWJ1r3iMglwBtsNt2G+ORzHXlr3JIf6kv1COQmaHqIvvBIR7eb2VK3rQ+rpQaEto
         Hm5AaCyxdV/lTIfK0THJeR1bWkh9Gj/b3YtH2FFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/143] fs: dlm: use WARN_ON_ONCE() instead of WARN_ON()
Date:   Wed, 15 Mar 2023 13:12:03 +0100
Message-Id: <20230315115741.638396465@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

[ Upstream commit 775af207464bd28a2086f8399c0b2a3f1f40c7ae ]

To not get the console spammed about WARN_ON() of invalid states in the
dlm midcomms hot path handling we switch to WARN_ON_ONCE() to get it
only once that there might be an issue with the midcomms state handling.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 7354fa4ef697 ("fs: dlm: be sure to call dlm_send_queue_flush()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 0477493706edb..b53d7a281be93 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -469,7 +469,7 @@ static void dlm_pas_fin_ack_rcv(struct midcomms_node *node)
 		spin_unlock(&node->state_lock);
 		log_print("%s: unexpected state: %d\n",
 			  __func__, node->state);
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		return;
 	}
 	spin_unlock(&node->state_lock);
@@ -542,13 +542,13 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 				spin_unlock(&node->state_lock);
 				log_print("%s: unexpected state: %d\n",
 					  __func__, node->state);
-				WARN_ON(1);
+				WARN_ON_ONCE(1);
 				return;
 			}
 			spin_unlock(&node->state_lock);
 			break;
 		default:
-			WARN_ON(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));
+			WARN_ON_ONCE(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));
 			dlm_receive_buffer_3_2_trace(seq, p);
 			dlm_receive_buffer(p, node->nodeid);
 			set_bit(DLM_NODE_ULP_DELIVERED, &node->flags);
@@ -764,7 +764,7 @@ static void dlm_midcomms_receive_buffer_3_2(union dlm_packet *p, int nodeid)
 			goto out;
 		}
 
-		WARN_ON(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));
+		WARN_ON_ONCE(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));
 		dlm_receive_buffer(p, nodeid);
 		break;
 	case DLM_OPTS:
@@ -1089,7 +1089,7 @@ struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len,
 	}
 
 	/* this is a bug, however we going on and hope it will be resolved */
-	WARN_ON(test_bit(DLM_NODE_FLAG_STOP_TX, &node->flags));
+	WARN_ON_ONCE(test_bit(DLM_NODE_FLAG_STOP_TX, &node->flags));
 
 	mh = dlm_allocate_mhandle();
 	if (!mh)
@@ -1121,7 +1121,7 @@ struct dlm_mhandle *dlm_midcomms_get_mhandle(int nodeid, int len,
 		break;
 	default:
 		dlm_free_mhandle(mh);
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		goto err;
 	}
 
@@ -1197,7 +1197,7 @@ void dlm_midcomms_commit_mhandle(struct dlm_mhandle *mh,
 		break;
 	default:
 		srcu_read_unlock(&nodes_srcu, mh->idx);
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		break;
 	}
 }
@@ -1254,7 +1254,7 @@ static void dlm_act_fin_ack_rcv(struct midcomms_node *node)
 		spin_unlock(&node->state_lock);
 		log_print("%s: unexpected state: %d\n",
 			  __func__, node->state);
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		return;
 	}
 	spin_unlock(&node->state_lock);
@@ -1366,7 +1366,7 @@ static void midcomms_node_release(struct rcu_head *rcu)
 {
 	struct midcomms_node *node = container_of(rcu, struct midcomms_node, rcu);
 
-	WARN_ON(atomic_read(&node->send_queue_cnt));
+	WARN_ON_ONCE(atomic_read(&node->send_queue_cnt));
 	kfree(node);
 }
 
-- 
2.39.2



