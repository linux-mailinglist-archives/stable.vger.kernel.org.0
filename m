Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676CC592312
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241661AbiHNPxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241928AbiHNPuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6331CFCB;
        Sun, 14 Aug 2022 08:36:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE61060C92;
        Sun, 14 Aug 2022 15:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF86C433D6;
        Sun, 14 Aug 2022 15:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491366;
        bh=EYVjw1q+dpeO/mjOC3orZPoHYiNWoXIRtQLqP1kf+8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNyntqWI66MfgeZVFJydEtXQepMMTk9BsjJPeMRNt5P1IV8RIR54D/ljs8D95yJCU
         cbh8+OTQPqma0Wn0a+fDULTRZzxKRyo/fRptFMWoNWdj040ujGtnbTVpvOA20HwfOJ
         KXD0tlQmn6uAt5/CJIOmL8f6yrwkDBXzMkApoNLVisKH40KmgT4PpopA9Dv8sj8H69
         IkEJdUMHNh/zKekUv15026e+exfN52sGi68G0pWOVhouYGrlQ3zZeGIfELAz+d9t1E
         gBGjg8H0ocM+MIMV0+lyDqKwAfqbR0JNwNAacR5nBPeaeogpL+zkLjOQGeQc37oKBT
         BSMkZInBrUfAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagi Grimberg <sagi@grimberg.me>, Yi Zhang <yi.zhang@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, kch@nvidia.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 18/21] nvmet-tcp: fix lockdep complaint on nvmet_tcp_wq flush during queue teardown
Date:   Sun, 14 Aug 2022 11:35:28 -0400
Message-Id: <20220814153531.2379705-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153531.2379705-1-sashal@kernel.org>
References: <20220814153531.2379705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 533d2e8b4d5e4c89772a0adce913525fb86cbbee ]

We probably need nvmet_tcp_wq to have MEM_RECLAIM as we are
sending/receiving for the socket from works on this workqueue.
Also this eliminates lockdep complaints:
--
[ 6174.010200] workqueue: WQ_MEM_RECLAIM
nvmet-wq:nvmet_tcp_release_queue_work [nvmet_tcp] is flushing
!WQ_MEM_RECLAIM nvmet_tcp_wq:nvmet_tcp_io_work [nvmet_tcp]
[ 6174.010216] WARNING: CPU: 20 PID: 14456 at kernel/workqueue.c:2628
check_flush_dependency+0x110/0x14c

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 4341c7244662..e9512d077b8a 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1762,7 +1762,8 @@ static int __init nvmet_tcp_init(void)
 {
 	int ret;
 
-	nvmet_tcp_wq = alloc_workqueue("nvmet_tcp_wq", WQ_HIGHPRI, 0);
+	nvmet_tcp_wq = alloc_workqueue("nvmet_tcp_wq",
+				WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!nvmet_tcp_wq)
 		return -ENOMEM;
 
-- 
2.35.1

