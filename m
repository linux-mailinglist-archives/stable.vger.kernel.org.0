Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A406686C3
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 23:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240515AbjALWUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 17:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240093AbjALWUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 17:20:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A683882
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673561461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hh8VI5GRuqAAiw1BB0CJ46qCuKlgxt4vyg96XgbpWLY=;
        b=P8heTuyVX0bAapI7pcvT2N41BSSm2Yf5wemUcGcyXYFBCEUHmXA5xLW9JA9yAb4HenZ/ap
        FPBsLVBB5YjAvHMTrsEXQzw3IQUOrPyi7NJ7euW8CwQUI4s8sU9xMaYWfP08RauAm4hx7t
        hk7gR78pMPX0wau4GmL0E8vzdVfrxdw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-sQTFUOG2MeOaVcULhC-v2A-1; Thu, 12 Jan 2023 17:10:58 -0500
X-MC-Unique: sQTFUOG2MeOaVcULhC-v2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96736281DE7B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 22:10:57 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F5D61121319;
        Thu, 12 Jan 2023 22:10:57 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, aahringo@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH dlm/next 7/7] fs: dlm: send FIN ack back in right cases
Date:   Thu, 12 Jan 2023 17:10:37 -0500
Message-Id: <20230112221037.1882548-7-aahringo@redhat.com>
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

This patch moves to send a ack back for receiving a FIN message only
when we are in valid states. In other cases and there might be a sender
waiting for a ack we just let it timeout at the senders time and
hopefully all other cleanups will remove the FIN message on their
sending queue. As an example we should never send out an ACK being in
LAST_ACK state or we cannot assume a working socket communication when
we are in CLOSED state.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/midcomms.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index fd9f413cabcd..ecfb3beb0bb8 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -375,7 +375,7 @@ static int dlm_send_ack(int nodeid, uint32_t seq)
 	struct dlm_msg *msg;
 	char *ppc;
 
-	msg = dlm_lowcomms_new_msg(nodeid, mb_len, GFP_NOFS, &ppc,
+	msg = dlm_lowcomms_new_msg(nodeid, mb_len, GFP_ATOMIC, &ppc,
 				   NULL, NULL);
 	if (!msg)
 		return -ENOMEM;
@@ -498,15 +498,14 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 
 		switch (p->header.h_cmd) {
 		case DLM_FIN:
-			/* send ack before fin */
-			dlm_send_ack(node->nodeid, node->seq_next);
-
 			spin_lock(&node->state_lock);
 			pr_debug("receive fin msg from node %d with state %s\n",
 				 node->nodeid, dlm_state_str(node->state));
 
 			switch (node->state) {
 			case DLM_ESTABLISHED:
+				dlm_send_ack(node->nodeid, node->seq_next);
+
 				node->state = DLM_CLOSE_WAIT;
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
@@ -523,12 +522,14 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 				}
 				break;
 			case DLM_FIN_WAIT1:
+				dlm_send_ack(node->nodeid, node->seq_next);
 				node->state = DLM_CLOSING;
 				set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
 				break;
 			case DLM_FIN_WAIT2:
+				dlm_send_ack(node->nodeid, node->seq_next);
 				midcomms_node_reset(node);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
-- 
2.31.1

