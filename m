Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4175318D8
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240503AbiEWRSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240686AbiEWRQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:16:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72150252A8;
        Mon, 23 May 2022 10:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FAD3B8120F;
        Mon, 23 May 2022 17:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18EBC385A9;
        Mon, 23 May 2022 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326005;
        bh=SwZZ1wBIYlC9EHPI5vWZ3DJXkxhGGuW+aePkTfWxLZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+RKUMKsXpocYWY+mkTzl6qUGpmWScxclvUHPVr3BgzsLrW8Wr9LxR4ouTl+L5Ukd
         JAWUAw2O5AgCtd5EvyQypDJktE+xpMbqr/gOiSoje3ks4gl2eP3qfAnnSVzqJsrJvv
         eFG1qeGfygZxxbz/t+b7DivoXYAJU0dV0b2DWslM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Zixuan Fu <r33s3n6@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/68] net: vmxnet3: fix possible use-after-free bugs in vmxnet3_rq_alloc_rx_buf()
Date:   Mon, 23 May 2022 19:05:05 +0200
Message-Id: <20220523165808.887724578@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Zixuan Fu <r33s3n6@gmail.com>

[ Upstream commit 9e7fef9521e73ca8afd7da9e58c14654b02dfad8 ]

In vmxnet3_rq_alloc_rx_buf(), when dma_map_single() fails, rbi->skb is
freed immediately. Similarly, in another branch, when dma_map_page() fails,
rbi->page is also freed. In the two cases, vmxnet3_rq_alloc_rx_buf()
returns an error to its callers vmxnet3_rq_init() -> vmxnet3_rq_init_all()
-> vmxnet3_activate_dev(). Then vmxnet3_activate_dev() calls
vmxnet3_rq_cleanup_all() in error handling code, and rbi->skb or rbi->page
are freed again in vmxnet3_rq_cleanup_all(), causing use-after-free bugs.

To fix these possible bugs, rbi->skb and rbi->page should be cleared after
they are freed.

The error log in our fault-injection testing is shown as follows:

[   14.319016] BUG: KASAN: use-after-free in consume_skb+0x2f/0x150
...
[   14.321586] Call Trace:
...
[   14.325357]  consume_skb+0x2f/0x150
[   14.325671]  vmxnet3_rq_cleanup_all+0x33a/0x4e0 [vmxnet3]
[   14.326150]  vmxnet3_activate_dev+0xb9d/0x2ca0 [vmxnet3]
[   14.326616]  vmxnet3_open+0x387/0x470 [vmxnet3]
...
[   14.361675] Allocated by task 351:
...
[   14.362688]  __netdev_alloc_skb+0x1b3/0x6f0
[   14.362960]  vmxnet3_rq_alloc_rx_buf+0x1b0/0x8d0 [vmxnet3]
[   14.363317]  vmxnet3_activate_dev+0x3e3/0x2ca0 [vmxnet3]
[   14.363661]  vmxnet3_open+0x387/0x470 [vmxnet3]
...
[   14.367309]
[   14.367412] Freed by task 351:
...
[   14.368932]  __dev_kfree_skb_any+0xd2/0xe0
[   14.369193]  vmxnet3_rq_alloc_rx_buf+0x71e/0x8d0 [vmxnet3]
[   14.369544]  vmxnet3_activate_dev+0x3e3/0x2ca0 [vmxnet3]
[   14.369883]  vmxnet3_open+0x387/0x470 [vmxnet3]
[   14.370174]  __dev_open+0x28a/0x420
[   14.370399]  __dev_change_flags+0x192/0x590
[   14.370667]  dev_change_flags+0x7a/0x180
[   14.370919]  do_setlink+0xb28/0x3570
[   14.371150]  rtnl_newlink+0x1160/0x1740
[   14.371399]  rtnetlink_rcv_msg+0x5bf/0xa50
[   14.371661]  netlink_rcv_skb+0x1cd/0x3e0
[   14.371913]  netlink_unicast+0x5dc/0x840
[   14.372169]  netlink_sendmsg+0x856/0xc40
[   14.372420]  ____sys_sendmsg+0x8a7/0x8d0
[   14.372673]  __sys_sendmsg+0x1c2/0x270
[   14.372914]  do_syscall_64+0x41/0x90
[   14.373145]  entry_SYSCALL_64_after_hwframe+0x44/0xae
...

Fixes: 5738a09d58d5a ("vmxnet3: fix checks for dma mapping errors")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
Link: https://lore.kernel.org/r/20220514050656.2636588-1-r33s3n6@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index cf090f88dac0..b71a019e9867 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -595,6 +595,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
 					dev_kfree_skb_any(rbi->skb);
+					rbi->skb = NULL;
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
@@ -619,6 +620,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
 					put_page(rbi->page);
+					rbi->page = NULL;
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
-- 
2.35.1



