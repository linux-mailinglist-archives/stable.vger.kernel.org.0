Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F1C55C6AF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiF0L0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbiF0LZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:25:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7545659D;
        Mon, 27 Jun 2022 04:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 257EC61459;
        Mon, 27 Jun 2022 11:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284EDC341C7;
        Mon, 27 Jun 2022 11:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329118;
        bh=Xs774V0mF+K9kaKGqJ0IKq9qDk6UomBqM7x0sPzgZWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlKsdM20MQzMKjXLsgjmSvmpp9mZcwmfrFc2HhqNq5kWzbl6F1hCKF/Ip1f5BZQqt
         GHSSaacJEmu2qqHXx1LXrSOnwG86jA7uESNGGclzzg3nQZlgwiofOfMo1CQyX+iTwe
         hGS2IWJD8bp9LtYlEPe0roZPOgwP1irKtq730SXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/102] nvme: dont check nvme_req flags for new req
Date:   Mon, 27 Jun 2022 13:21:08 +0200
Message-Id: <20220627111935.162378464@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit c03fd85de293a4f65fcb94a795bf4c12a432bb6c ]

nvme_clear_request() has a check for flag REQ_DONTPREP and it is called
from nvme_init_request() and nvme_setuo_cmd().

The function nvme_init_request() is called from nvme_alloc_request()
and nvme_alloc_request_qid(). From these two callers new request is
allocated everytime. For newly allocated request RQF_DONTPREP is never
set. Since after getting a tag, block layer sets the req->rq_flags == 0
and never sets the REQ_DONTPREP when returning the request :-

nvme_alloc_request()
	blk_mq_alloc_request()
		blk_mq_rq_ctx_init()
			rq->rq_flags = 0 <----

nvme_alloc_request_qid()
	blk_mq_alloc_request_hctx()
		blk_mq_rq_ctx_init()
			rq->rq_flags = 0 <----

The block layer does set req->rq_flags but REQ_DONTPREP is not one of
them and that is set by the driver.

That means we can unconditinally set the REQ_DONTPREP value to the
rq->rq_flags when nvme_init_request()->nvme_clear_request() is called
from above two callers.

Move the check for REQ_DONTPREP from nvme_clear_nvme_request() into
nvme_setup_cmd().

This is needed since nvme_alloc_request() now gets called from fast
path when NVMeOF target is configured with passthru backend to avoid
unnecessary checks in the fast path.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d81b0cff15e0..c42ad0b8247b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -531,11 +531,9 @@ EXPORT_SYMBOL_NS_GPL(nvme_put_ns, NVME_TARGET_PASSTHRU);
 
 static inline void nvme_clear_nvme_request(struct request *req)
 {
-	if (!(req->rq_flags & RQF_DONTPREP)) {
-		nvme_req(req)->retries = 0;
-		nvme_req(req)->flags = 0;
-		req->rq_flags |= RQF_DONTPREP;
-	}
+	nvme_req(req)->retries = 0;
+	nvme_req(req)->flags = 0;
+	req->rq_flags |= RQF_DONTPREP;
 }
 
 static inline unsigned int nvme_req_op(struct nvme_command *cmd)
@@ -854,7 +852,8 @@ blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 	struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
 	blk_status_t ret = BLK_STS_OK;
 
-	nvme_clear_nvme_request(req);
+	if (!(req->rq_flags & RQF_DONTPREP))
+		nvme_clear_nvme_request(req);
 
 	memset(cmd, 0, sizeof(*cmd));
 	switch (req_op(req)) {
-- 
2.35.1



