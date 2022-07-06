Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54DA568D87
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiGFPeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiGFPeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:34:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1E128E04;
        Wed,  6 Jul 2022 08:32:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2229CE2081;
        Wed,  6 Jul 2022 15:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1092DC3411C;
        Wed,  6 Jul 2022 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121572;
        bh=J/EuGZdmSepc7xcdlMXsN1KoG6+RToJa/DgYPisABGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjQLyyVG8l0m+lyrIEfTJQypKiE2LIPINtENd8KoU4EIsG/l7TNMGF1sujFaBUnj5
         uwQl7zjzs1WH+GcFKWE57hYZEYsjy/xdcJjaM0ROQr87A3mJiQpX0VKtY3F8umIDjz
         7UE4rZTueXDHmXqAY+q7NjWQjz/txtcBEhkiV5W516m/p/ATgaofgRa/K/44IOX/5r
         v7EPBeQvkOelU6JPNQHugGIfaYP5XTb+iOgWkUtqmP8WZhB8FdZJVWRTTpXBFfPhzq
         V6SQrthLWsmrv24ats4sI/nyBCBQh3WbWb0byKj4/Gz00DO7H0GXE75T3g/UyZZxwy
         w6IMdBpv9FsKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 16/18] nvme-tcp: always fail a request when sending it failed
Date:   Wed,  6 Jul 2022 11:31:51 -0400
Message-Id: <20220706153153.1598076-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153153.1598076-1-sashal@kernel.org>
References: <20220706153153.1598076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 41d07df7de841bfbc32725ce21d933ad358f2844 ]

queue stoppage and inflight requests cancellation is fully fenced from
io_work and thus failing a request from this context. Hence we don't
need to try to guess from the socket retcode if this failure is because
the queue is about to be torn down or not.

We are perfectly safe to just fail it, the request will not be cancelled
later on.

This solves possible very long shutdown delays when the users issues a
'nvme disconnect-all'

Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 10882d3d554c..1821d38e620e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1162,8 +1162,7 @@ static int nvme_tcp_try_send(struct nvme_tcp_queue *queue)
 	} else if (ret < 0) {
 		dev_err(queue->ctrl->ctrl.device,
 			"failed to send request %d\n", ret);
-		if (ret != -EPIPE && ret != -ECONNRESET)
-			nvme_tcp_fail_request(queue->request);
+		nvme_tcp_fail_request(queue->request);
 		nvme_tcp_done_send_req(queue);
 	}
 	return ret;
-- 
2.35.1

