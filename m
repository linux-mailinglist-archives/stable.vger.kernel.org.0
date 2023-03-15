Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8866BB22B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbjCOMd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbjCOMd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CD02F795
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC94461CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ADCC433D2;
        Wed, 15 Mar 2023 12:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883546;
        bh=UgyKCeg3ZFTmCBpsP3tl+6WT67eJ6WLb3X2erX6Rbs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOWVrumNae/rfg/s+1GcgNgiE418UCDIRsPPhNz5OzUj/1MIoUonSZ7l+GubEnmOl
         ivhmFwTzQ+R22BPPJT5DzwCnObPqps9VxV6PtcJajqtGQGTnyYiWR4OcHfrJ+81jkS
         AOjScI0pLtIU//aat44NDsYFYlXWLlytrBswEAAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/143] fs: dlm: fix race setting stop tx flag
Date:   Wed, 15 Mar 2023 13:12:05 +0100
Message-Id: <20230315115741.699360110@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

[ Upstream commit 164272113b685927126c938b4a9cbd2075eb15ee ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/midcomms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index d976c2009b185..b2a25a33a1488 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -406,6 +406,7 @@ static int dlm_send_fin(struct midcomms_node *node,
 	if (!mh)
 		return -ENOMEM;
 
+	set_bit(DLM_NODE_FLAG_STOP_TX, &node->flags);
 	mh->ack_rcv = ack_rcv;
 
 	m_header = (struct dlm_header *)ppc;
@@ -417,7 +418,6 @@ static int dlm_send_fin(struct midcomms_node *node,
 
 	pr_debug("sending fin msg to node %d\n", node->nodeid);
 	dlm_midcomms_commit_mhandle(mh, NULL, 0);
-	set_bit(DLM_NODE_FLAG_STOP_TX, &node->flags);
 
 	return 0;
 }
-- 
2.39.2



