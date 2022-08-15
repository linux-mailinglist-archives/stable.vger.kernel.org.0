Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910BF5946B3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351877AbiHOXAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345864AbiHOW6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3679474DC;
        Mon, 15 Aug 2022 12:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80C526113B;
        Mon, 15 Aug 2022 19:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83240C433D6;
        Mon, 15 Aug 2022 19:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593421;
        bh=dC3DNuwK+mEw99lMl/mt9cbWGoqxAMyTQd+LbtZwKyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2kky4/ofQe7I71yG7WULP2jsj3OJ+A0vViga+BK8UL3gL0a4/IjH6u8UjJ7PfB69+
         CfEkcSTAoOtXuA2A/OFu78BYIYufbevr/YXU4g7dZj+GRkV+fMyyVFBTmETuox123C
         btgqUf4bPUygJUegMf/3C6JRHzwWfEC28t/Y0wcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuwen Chen <chenyuwen1@meizu.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0265/1157] erofs: wake up all waiters after z_erofs_lzma_head ready
Date:   Mon, 15 Aug 2022 19:53:41 +0200
Message-Id: <20220815180450.191033016@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuwen Chen <chenyuwen1@meizu.com>

[ Upstream commit 2df7c4bd7c1d2bc5ece5e9ed19dbd386810c2a65 ]

When the user mounts the erofs second times, the decompression thread
may hung. The problem happens due to a sequence of steps like the
following:

1) Task A called z_erofs_load_lzma_config which obtain all of the node
   from the z_erofs_lzma_head.

2) At this time, task B called the z_erofs_lzma_decompress and wanted to
   get a node. But the z_erofs_lzma_head was empty, the Task B had to
   sleep.

3) Task A release nodes and push nodes into the z_erofs_lzma_head. But
   task B was still sleeping.

One example report when the hung happens:
task:kworker/u3:1 state:D stack:14384 pid: 86 ppid: 2 flags:0x00004000
Workqueue: erofs_unzipd z_erofs_decompressqueue_work
Call Trace:
 <TASK>
 __schedule+0x281/0x760
 schedule+0x49/0xb0
 z_erofs_lzma_decompress+0x4bc/0x580
 ? cpu_core_flags+0x10/0x10
 z_erofs_decompress_pcluster+0x49b/0xba0
 ? __update_load_avg_se+0x2b0/0x330
 ? __update_load_avg_se+0x2b0/0x330
 ? update_load_avg+0x5f/0x690
 ? update_load_avg+0x5f/0x690
 ? set_next_entity+0xbd/0x110
 ? _raw_spin_unlock+0xd/0x20
 z_erofs_decompress_queue.isra.0+0x2e/0x50
 z_erofs_decompressqueue_work+0x30/0x60
 process_one_work+0x1d3/0x3a0
 worker_thread+0x45/0x3a0
 ? process_one_work+0x3a0/0x3a0
 kthread+0xe2/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30
 </TASK>

Signed-off-by: Yuwen Chen <chenyuwen1@meizu.com>
Fixes: 622ceaddb764 ("erofs: lzma compression support")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220626224041.4288-1-chenyuwen1@meizu.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor_lzma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 05a3063cf2bc..5e59b3f523eb 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -143,6 +143,7 @@ int z_erofs_load_lzma_config(struct super_block *sb,
 	DBG_BUGON(z_erofs_lzma_head);
 	z_erofs_lzma_head = head;
 	spin_unlock(&z_erofs_lzma_lock);
+	wake_up_all(&z_erofs_lzma_wq);
 
 	z_erofs_lzma_max_dictsize = dict_size;
 	mutex_unlock(&lzma_resize_mutex);
-- 
2.35.1



