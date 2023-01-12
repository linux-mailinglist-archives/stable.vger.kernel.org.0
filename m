Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF6A6686C0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 23:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbjALWUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 17:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240526AbjALWUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 17:20:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27EA10FC0
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673561458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QKerf75mGdqSczuGWvWFGHCdRsVt2SwwyqzzTCTr0Zw=;
        b=Xu79yshcpPx93lpoVdFVoLSuDM7rS7MjxXScAmskb9i2f92cVitc5jspQjD3YW4A7L+bmC
        h5HJpDoju6BXUpvMkkQyNGTGt+RQrxxhmnWL5387zmMQAGhaobbtwHqnyNAmf0jzehP1kS
        aELGla5na2xafVzSJn5rbV3hKnOZNp8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-zGjEuIZ6PJuoIeQAjKWxAQ-1; Thu, 12 Jan 2023 17:10:57 -0500
X-MC-Unique: zGjEuIZ6PJuoIeQAjKWxAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 379F63C01DF5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 22:10:57 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 109DB1121314;
        Thu, 12 Jan 2023 22:10:57 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     teigland@redhat.com
Cc:     cluster-devel@redhat.com, aahringo@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH dlm/next 5/7] fs: dlm: don't set stop rx flag after node reset
Date:   Thu, 12 Jan 2023 17:10:35 -0500
Message-Id: <20230112221037.1882548-5-aahringo@redhat.com>
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

Similar like the stop tx flag the rx flag should warn about dlm message
being received at DLM_FIN state change and we are not assuming any other
application DLM messages anymore. If we receive a FIN message and we are
in the state DLM_FIN_WAIT2 we call midcomms_node_reset() which puts the
midcomms node into DLM_CLOSED state. Afterwards we should not the
DLM_NODE_FLAG_STOP_RX flag what we are currently doing. This patch
handles to set the DLM_NODE_FLAG_STOP_RX flag only in those cases if we
receive a FIN message and we don't assume other dlm application messages
to be received anymore.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 fs/dlm/midcomms.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 9d459d5bf800..1fef99214204 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -524,6 +524,7 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 				break;
 			case DLM_FIN_WAIT1:
 				node->state = DLM_CLOSING;
+				set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
 				break;
@@ -544,8 +545,6 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 				return;
 			}
 			spin_unlock(&node->state_lock);
-
-			set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 			break;
 		default:
 			WARN_ON_ONCE(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));
-- 
2.31.1

