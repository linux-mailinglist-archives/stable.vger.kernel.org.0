Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5947A6AF189
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjCGSpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbjCGSpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:45:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1211FB862E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:34:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB5AB61539
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3086C433EF;
        Tue,  7 Mar 2023 18:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214031;
        bh=snydt9SDylcvlEycW7Cq3ohmB91GMuioW7jmWWjzlHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1swpYXhojZipc2mRw2luojwXHDv7/N7f2gkrVqQdgkbWtCVJwcLMVTH+cf4Cg6AZ
         PoPu1nFSaVszDHcVqT/101068nVL2fmOgpEJhHfGMV7Azt/nVxtiLqchtmsbvrUNxi
         2U6jnjOL3M5Lu8njHTp7+pAX58trU133VxjzJ+nA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 6.1 697/885] fs: dlm: send FIN ack back in right cases
Date:   Tue,  7 Mar 2023 18:00:31 +0100
Message-Id: <20230307170032.379767301@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 00908b3388255fc1d3782b744d07f327712f401f upstream.

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
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/midcomms.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -374,7 +374,7 @@ static int dlm_send_ack(int nodeid, uint
 	struct dlm_msg *msg;
 	char *ppc;
 
-	msg = dlm_lowcomms_new_msg(nodeid, mb_len, GFP_NOFS, &ppc,
+	msg = dlm_lowcomms_new_msg(nodeid, mb_len, GFP_ATOMIC, &ppc,
 				   NULL, NULL);
 	if (!msg)
 		return -ENOMEM;
@@ -483,15 +483,14 @@ static void dlm_midcomms_receive_buffer(
 
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
@@ -508,12 +507,14 @@ static void dlm_midcomms_receive_buffer(
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


