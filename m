Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0616B42E6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjCJOIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbjCJOIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:08:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F65C117859
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:07:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 378DA60F11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C5C4339E;
        Fri, 10 Mar 2023 14:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457263;
        bh=fKMLIisuKxN2IsUu+quvm9sR7r2tdZoEdvnLhOKsPgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfWDx3ZbPcaEThAVcRu8dPebLCkdzl4/TEZnOnZICRL+hnnbp40gAW/8E2kkQEJO4
         y7jsLf6PXjHm1h42Z9+yXiamEUFrZYDq6fRvKzDjddo6eAXSyskjKKSQOioiDpjWCO
         weJos7CMp0Rxbd5No7+wFxewv9FCN2Tva6o+4pjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/200] 9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()
Date:   Fri, 10 Mar 2023 14:38:04 +0100
Message-Id: <20230310133719.473422804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 74a25e6e916cb57dab4267a96fbe8864ed21abdb ]

When down_interruptible() or ib_post_send() failed in rdma_request(),
receive dma buffer is not unmapped. Add unmap action to error path.
Also if ib_post_recv() failed in post_recv(), dma buffer is not unmapped.
Add unmap action to error path.

Link: https://lkml.kernel.org/r/20230104020424.611926-1-shaozhengchao@huawei.com
Fixes: fc79d4b104f0 ("9p: rdma: RDMA Transport Support for 9P")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_rdma.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index e9a830c69058c..29a9292303ea3 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -386,6 +386,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct p9_trans_rdma *rdma = client->trans;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
+	int ret;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
@@ -403,7 +404,12 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	wr.wr_cqe = &c->cqe;
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
-	return ib_post_recv(rdma->qp, &wr, NULL);
+
+	ret = ib_post_recv(rdma->qp, &wr, NULL);
+	if (ret)
+		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+				    client->msize, DMA_FROM_DEVICE);
+	return ret;
 
  error:
 	p9_debug(P9_DEBUG_ERROR, "EIO\n");
@@ -500,7 +506,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
-		goto send_error;
+		goto dma_unmap;
 	}
 
 	/* Mark request as `sent' *before* we actually send it,
@@ -510,11 +516,14 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	WRITE_ONCE(req->status, REQ_STATUS_SENT);
 	err = ib_post_send(rdma->qp, &wr, NULL);
 	if (err)
-		goto send_error;
+		goto dma_unmap;
 
 	/* Success */
 	return 0;
 
+dma_unmap:
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+			    c->req->tc.size, DMA_TO_DEVICE);
  /* Handle errors that happened during or while preparing the send: */
  send_error:
 	WRITE_ONCE(req->status, REQ_STATUS_ERROR);
-- 
2.39.2



