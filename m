Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7865B0DB
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbjABL2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbjABL2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:28:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C155F63AF
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BCFC60F55
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F18BC433EF;
        Mon,  2 Jan 2023 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658841;
        bh=OZpJqhQAttmZZ/KRw6qYQwysnKhALi1konYZ7deLMIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1TSFrb5avNaIswQACcX9umCHNAY1waNG+PjBNFcxz2qjUAARa2MpClz0SRJvRgoE
         pl8tlclYVI49Njc1f5W0VuLZlkyN1s8SaIHqnx345/3DmIDvGTWH/lzoM2qF86cPCu
         QmO5RxnvSAOATO2LRyHiU83pCGN04oyZnjorUK8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Andreas Herrmann <aherrmann@suse.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 02/74] blk-cgroup: fix error unwinding in blkcg_init_queue
Date:   Mon,  2 Jan 2023 12:21:35 +0100
Message-Id: <20230102110552.167118885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 33dc62796cb657a633050138a86253fb2a553713 ]

When blk_throtl_init fails, we need to call blk_ioprio_exit.  Switch to
proper goto based unwinding to fix this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 813e693023ba ("blk-iolatency: Fix memory leak on add_disk() failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c8f0c865bf4e..bcd3873ac5ff 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1297,17 +1297,18 @@ int blkcg_init_queue(struct request_queue *q)
 
 	ret = blk_throtl_init(q);
 	if (ret)
-		goto err_destroy_all;
+		goto err_ioprio_exit;
 
 	ret = blk_iolatency_init(q);
-	if (ret) {
-		blk_throtl_exit(q);
-		blk_ioprio_exit(q);
-		goto err_destroy_all;
-	}
+	if (ret)
+		goto err_throtl_exit;
 
 	return 0;
 
+err_throtl_exit:
+	blk_throtl_exit(q);
+err_ioprio_exit:
+	blk_ioprio_exit(q);
 err_destroy_all:
 	blkg_destroy_all(q);
 	return ret;
-- 
2.35.1



