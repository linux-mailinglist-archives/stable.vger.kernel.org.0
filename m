Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDFD6AB009
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCENqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCENq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:46:29 -0500
Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E782D6F;
        Sun,  5 Mar 2023 05:46:01 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Vd6Wt0b_1678023896;
Received: from e18g06460.et15sqa.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vd6Wt0b_1678023896)
          by smtp.aliyun-inc.com;
          Sun, 05 Mar 2023 21:45:05 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     linux-erofs@lists.ozlabs.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Gao Xiang <hsiangkao@linux.alibaba.com>, stable@vger.kernel.org
Subject: [PATCH] erofs: fix wrong kunmap when using LZMA on HIGHMEM platforms
Date:   Sun,  5 Mar 2023 21:44:55 +0800
Message-Id: <20230305134455.88236-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As the call trace shown, the root cause is kunmap incorrect pages:

 BUG: kernel NULL pointer dereference, address: 00000000
 CPU: 1 PID: 40 Comm: kworker/u5:0 Not tainted 6.2.0-rc5 #4
 Workqueue: erofs_worker z_erofs_decompressqueue_work
 EIP: z_erofs_lzma_decompress+0x34b/0x8ac
  z_erofs_decompress+0x12/0x14
  z_erofs_decompress_queue+0x7e7/0xb1c
  z_erofs_decompressqueue_work+0x32/0x60
  process_one_work+0x24b/0x4d8
  ? process_one_work+0x1a4/0x4d8
  worker_thread+0x14c/0x3fc
  kthread+0xe6/0x10c
  ? rescuer_thread+0x358/0x358
  ? kthread_complete_and_exit+0x18/0x18
  ret_from_fork+0x1c/0x28
 ---[ end trace 0000000000000000 ]---

The bug is trivial and should be fixed now.  It has no impact on
!HIGHMEM platforms.

Fixes: 622ceaddb764 ("erofs: lzma compression support")
Cc: <stable@vger.kernel.org> # 5.16+
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/erofs/decompressor_lzma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor_lzma.c b/fs/erofs/decompressor_lzma.c
index 091fd5adf818..5cd612a8f858 100644
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -278,7 +278,7 @@ int z_erofs_lzma_decompress(struct z_erofs_decompress_req *rq,
 		}
 	}
 	if (no < nrpages_out && strm->buf.out)
-		kunmap(rq->in[no]);
+		kunmap(rq->out[no]);
 	if (ni < nrpages_in)
 		kunmap(rq->in[ni]);
 	/* 4. push back LZMA stream context to the global list */
-- 
2.24.4

