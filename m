Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0C3537C1D
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiE3NbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbiE3NaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548B213EA9;
        Mon, 30 May 2022 06:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA3EC60ED0;
        Mon, 30 May 2022 13:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F72C36AE9;
        Mon, 30 May 2022 13:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917203;
        bh=Dz8ai7iKPglweNQzZKbSzXedFDeTrb0db8t40QK1R4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYh3m+E4acp2qt55yLiva1Vnd4jFEF8P5sTCZaSRsuu/6UICb4na/dglBJlVwrZSm
         T7fmzTwO18wWcDRCbyv5K0pbTEA7TypBIs+M5Yp259lFTNDHjx8My6ZqcNFWm7tSvQ
         8FLtpWdsSV0N7LdIsrcR2gbRvNlHlx+4Q7WVBlbMcBQvAVOzoyAoJQEbIgo4OYLo6K
         Bg8B26jy1lTV9Vr5bssEC+P6Mc6ZaeKFwcE99DovpY1XWKxK+DlR+zEMwBJZ5Tdbb5
         VwJFboncJt+lxgHaoHhbiVOt5nmitRLhWtV3IeSu8eifVO+hVvZc8HZfKiwkBza/rP
         waIqnD/kQ5yvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aidan MacDonald <aidanmacdonald.0x0@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, paul@crapouillou.net,
        linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 055/159] mmc: jz4740: Apply DMA engine limits to maximum segment size
Date:   Mon, 30 May 2022 09:22:40 -0400
Message-Id: <20220530132425.1929512-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>

[ Upstream commit afadb04f1d6e74b18a253403f5274cde5e3fd7bd ]

Do what is done in other DMA-enabled MMC host drivers (cf. host/mmci.c) and
limit the maximum segment size based on the DMA engine's capabilities. This
is needed to avoid warnings like the following with CONFIG_DMA_API_DEBUG=y.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 21 at kernel/dma/debug.c:1162 debug_dma_map_sg+0x2f4/0x39c
DMA-API: jz4780-dma 13420000.dma-controller: mapping sg segment longer than device claims to support [len=98304] [max=65536]
CPU: 0 PID: 21 Comm: kworker/0:1H Not tainted 5.18.0-rc1 #19
Workqueue: kblockd blk_mq_run_work_fn
Stack : 81575aec 00000004 80620000 80620000 80620000 805e7358 00000009 801537ac
        814c832c 806276e3 806e34b4 80620000 81575aec 00000001 81575ab8 09291444
        00000000 00000000 805e7358 81575958 ffffffea 8157596c 00000000 636f6c62
        6220646b 80387a70 0000000f 6d5f6b6c 80620000 00000000 81575ba4 00000009
        805e170c 80896640 00000001 00010000 00000000 00000000 00006098 806e0000
        ...
Call Trace:
[<80107670>] show_stack+0x84/0x120
[<80528cd8>] __warn+0xb8/0xec
[<80528d78>] warn_slowpath_fmt+0x6c/0xb8
[<8016f1d4>] debug_dma_map_sg+0x2f4/0x39c
[<80169d4c>] __dma_map_sg_attrs+0xf0/0x118
[<8016a27c>] dma_map_sg_attrs+0x14/0x28
[<804f66b4>] jz4740_mmc_prepare_dma_data+0x74/0xa4
[<804f6714>] jz4740_mmc_pre_request+0x30/0x54
[<804f4ff4>] mmc_blk_mq_issue_rq+0x6e0/0x7bc
[<804f5590>] mmc_mq_queue_rq+0x220/0x2d4
[<8038b2c0>] blk_mq_dispatch_rq_list+0x480/0x664
[<80391040>] blk_mq_do_dispatch_sched+0x2dc/0x370
[<80391468>] __blk_mq_sched_dispatch_requests+0xec/0x164
[<80391540>] blk_mq_sched_dispatch_requests+0x44/0x94
[<80387900>] __blk_mq_run_hw_queue+0xb0/0xcc
[<80134c14>] process_one_work+0x1b8/0x264
[<80134ff8>] worker_thread+0x2ec/0x3b8
[<8013b13c>] kthread+0x104/0x10c
[<80101dcc>] ret_from_kernel_thread+0x14/0x1c

---[ end trace 0000000000000000 ]---

Signed-off-by: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
Link: https://lore.kernel.org/r/20220411153753.50443-1-aidanmacdonald.0x0@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/jz4740_mmc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 7ab1b38a7be5..b1d563b2ed1b 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -247,6 +247,26 @@ static int jz4740_mmc_acquire_dma_channels(struct jz4740_mmc_host *host)
 		return PTR_ERR(host->dma_rx);
 	}
 
+	/*
+	 * Limit the maximum segment size in any SG entry according to
+	 * the parameters of the DMA engine device.
+	 */
+	if (host->dma_tx) {
+		struct device *dev = host->dma_tx->device->dev;
+		unsigned int max_seg_size = dma_get_max_seg_size(dev);
+
+		if (max_seg_size < host->mmc->max_seg_size)
+			host->mmc->max_seg_size = max_seg_size;
+	}
+
+	if (host->dma_rx) {
+		struct device *dev = host->dma_rx->device->dev;
+		unsigned int max_seg_size = dma_get_max_seg_size(dev);
+
+		if (max_seg_size < host->mmc->max_seg_size)
+			host->mmc->max_seg_size = max_seg_size;
+	}
+
 	return 0;
 }
 
-- 
2.35.1

