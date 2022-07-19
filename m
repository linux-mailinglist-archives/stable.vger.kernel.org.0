Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982E6579F04
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243013AbiGSNJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242968AbiGSNIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:08:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836B551413;
        Tue, 19 Jul 2022 05:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DC5A6090A;
        Tue, 19 Jul 2022 12:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C50C341C6;
        Tue, 19 Jul 2022 12:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233688;
        bh=0tB/LX5tbGmxD7/pJ3RV12uRuMbISjx0rX5KmfklPqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QloKiFyNfkVujndCLsG2/grMR/ObaBb9WYVNVBLiV+HSu2WoFKjb/Z5CcTLQRgULs
         T4qeodEuvRvr7WltlywqVu9v/dl6bNnVu9j/ckhw4OqVC18VawqbVLQ8LWi4rekHOl
         13ZZuh+JnHHDuJGdnWGAsUoo1Bp6qzt0yzuuclfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 180/231] nvme-tcp: always fail a request when sending it failed
Date:   Tue, 19 Jul 2022 13:54:25 +0200
Message-Id: <20220719114729.353520239@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index ad3a2bf2f1e9..e44d0570e694 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1180,8 +1180,7 @@ static int nvme_tcp_try_send(struct nvme_tcp_queue *queue)
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



