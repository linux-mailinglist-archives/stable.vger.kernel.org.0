Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3446C8DA7B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbfHNRMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730499AbfHNRMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:12:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C85072133F;
        Wed, 14 Aug 2019 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802764;
        bh=zhxAZGvoqo0f1xdBBUnCSimhFegjwoKQYTfVfwVAH1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDpRZ7Bu/pTVCtO/yT1NM1aVhhSh1LOmmkb3o9bQf3OlCW1dVV/iQdPCYrQrlKABu
         RSoqv5R6ySgXxzjusZNzvcHQOXiDOnlSBPQdMY6gXUsCxAqK0qM+/imoxBfPgF7n9A
         6xcJ/qcaOLMclqIkWrpMNLYoDPcNf+BBs3P03vv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 07/69] mmc: cavium: Set the correct dma max segment size for mmc_host
Date:   Wed, 14 Aug 2019 19:01:05 +0200
Message-Id: <20190814165745.812876206@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit fa25eba6993b3750f417baabba169afaba076178 upstream.

We have set the mmc_host.max_seg_size to 8M, but the dma max segment
size of PCI device is set to 64K by default in function pci_device_add().
The mmc_host.max_seg_size is used to set the max segment size of
the blk queue. Then this mismatch will trigger a calltrace like below
when a bigger than 64K segment request arrives at mmc dev. So we should
consider the limitation of the cvm_mmc_host when setting the
mmc_host.max_seg_size.
  DMA-API: thunderx_mmc 0000:01:01.4: mapping sg segment longer than device claims to support [len=131072] [max=65536]
  WARNING: CPU: 6 PID: 238 at kernel/dma/debug.c:1221 debug_dma_map_sg+0x2b8/0x350
  Modules linked in:
  CPU: 6 PID: 238 Comm: kworker/6:1H Not tainted 5.3.0-rc1-next-20190724-yocto-standard+ #62
  Hardware name: Marvell OcteonTX CN96XX board (DT)
  Workqueue: kblockd blk_mq_run_work_fn
  pstate: 80c00009 (Nzcv daif +PAN +UAO)
  pc : debug_dma_map_sg+0x2b8/0x350
  lr : debug_dma_map_sg+0x2b8/0x350
  sp : ffff00001770f9e0
  x29: ffff00001770f9e0 x28: ffffffff00000000
  x27: 00000000ffffffff x26: ffff800bc2c73180
  x25: ffff000010e83700 x24: 0000000000000002
  x23: 0000000000000001 x22: 0000000000000001
  x21: 0000000000000000 x20: ffff800bc48ba0b0
  x19: ffff800bc97e8c00 x18: ffffffffffffffff
  x17: 0000000000000000 x16: 0000000000000000
  x15: ffff000010e835c8 x14: 6874207265676e6f
  x13: 6c20746e656d6765 x12: 7320677320676e69
  x11: 7070616d203a342e x10: 31303a31303a3030
  x9 : 303020636d6d5f78 x8 : 35363d78616d5b20
  x7 : 00000000000002fd x6 : ffff000010fd57dc
  x5 : 0000000000000000 x4 : ffff0000106c61f0
  x3 : 00000000ffffffff x2 : 0000800bee060000
  x1 : 7010678df3041a00 x0 : 0000000000000000
  Call trace:
   debug_dma_map_sg+0x2b8/0x350
   cvm_mmc_request+0x3c4/0x988
   __mmc_start_request+0x9c/0x1f8
   mmc_start_request+0x7c/0xb0
   mmc_blk_mq_issue_rq+0x5c4/0x7b8
   mmc_mq_queue_rq+0x11c/0x278
   blk_mq_dispatch_rq_list+0xb0/0x568
   blk_mq_do_dispatch_sched+0x6c/0x108
   blk_mq_sched_dispatch_requests+0x110/0x1b8
   __blk_mq_run_hw_queue+0xb0/0x118
   blk_mq_run_work_fn+0x28/0x38
   process_one_work+0x210/0x490
   worker_thread+0x48/0x458
   kthread+0x130/0x138
   ret_from_fork+0x10/0x1c

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Fixes: ba3869ff32e4 ("mmc: cavium: Add core MMC driver for Cavium SOCs")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/cavium.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/cavium.c
+++ b/drivers/mmc/host/cavium.c
@@ -1046,7 +1046,8 @@ int cvm_mmc_of_slot_probe(struct device
 		mmc->max_segs = 1;
 
 	/* DMA size field can address up to 8 MB */
-	mmc->max_seg_size = 8 * 1024 * 1024;
+	mmc->max_seg_size = min_t(unsigned int, 8 * 1024 * 1024,
+				  dma_get_max_seg_size(host->dev));
 	mmc->max_req_size = mmc->max_seg_size;
 	/* External DMA is in 512 byte blocks */
 	mmc->max_blk_size = 512;


