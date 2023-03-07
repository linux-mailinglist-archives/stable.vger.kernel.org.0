Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14936AEC38
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCGRxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbjCGRxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:53:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30801117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28DBDB818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B039C433EF;
        Tue,  7 Mar 2023 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211243;
        bh=OWp+nk4nX8xD9jgF3VLMaMKyhhsBlELlmRL0Tm3XGKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpXLb7UbG2qKNNaUYBQFCqTQLQDt8Q3mwgJ7NN1LDxZs+FFg30c3Ugwa9vvyjpm21
         we8QioZO58qrs2RafNNXhr9zQIjIAdBSSDvIjrKlqrUWYri8kSGxYiOS978fNbAUv2
         DuOlT5srV1hcYRQO4LEw1GYuLmIEp2X/QZdXNxjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 6.2 0800/1001] fs: dlm: fix race setting stop tx flag
Date:   Tue,  7 Mar 2023 17:59:32 +0100
Message-Id: <20230307170056.449052827@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

commit 164272113b685927126c938b4a9cbd2075eb15ee upstream.

This patch sets the stop tx flag before we commit the dlm message.
This flag will report about unexpected transmissions after we
send the DLM_FIN message out, which should be the last message sent.
When we commit the dlm fin message, it could be that we already
got an ack back and the CLOSED state change already happened.
We should not set this flag when we are in CLOSED state. To avoid this
race we simply set the tx flag before the state change can be in
progress by moving it before dlm_midcomms_commit_mhandle().

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/midcomms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -406,6 +406,7 @@ static int dlm_send_fin(struct midcomms_
 	if (!mh)
 		return -ENOMEM;
 
+	set_bit(DLM_NODE_FLAG_STOP_TX, &node->flags);
 	mh->ack_rcv = ack_rcv;
 
 	m_header = (struct dlm_header *)ppc;
@@ -417,7 +418,6 @@ static int dlm_send_fin(struct midcomms_
 
 	pr_debug("sending fin msg to node %d\n", node->nodeid);
 	dlm_midcomms_commit_mhandle(mh, NULL, 0);
-	set_bit(DLM_NODE_FLAG_STOP_TX, &node->flags);
 
 	return 0;
 }


