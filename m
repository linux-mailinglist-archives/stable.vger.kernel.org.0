Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E73A1E2CD2
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392040AbgEZTOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392021AbgEZTOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:14:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD65208B3;
        Tue, 26 May 2020 19:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520439;
        bh=h3nanM41ukwymtF8exi7HnqTu4nfJo7K4MCWXtWxfmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdcG01f27C7YVI/zibMQQb52Yr034yyMgSv74CuvCVOh+Dkm3QNjhjRVYcCNRmZSf
         vM+rt0cSgOL8+1bA4aE2LupCmRUjTauke+KH4M4dgxIdgnlbeQpa1wwyqwMPAjaA9B
         md068o2fM7HsUtJlHYIpmClhGRpn87YOARgV5iHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.6 081/126] dmaengine: owl: Use correct lock in owl_dma_get_pchan()
Date:   Tue, 26 May 2020 20:53:38 +0200
Message-Id: <20200526183944.910317337@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>

commit f8f482deb078389b42768b2193e050a81aae137d upstream.

When the kernel is built with lockdep support and the owl-dma driver is
used, the following message is shown:

[    2.496939] INFO: trying to register non-static key.
[    2.501889] the code is fine but needs lockdep annotation.
[    2.507357] turning off the locking correctness validator.
[    2.512834] CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.6.3+ #15
[    2.519084] Hardware name: Generic DT based system
[    2.523878] Workqueue: events_freezable mmc_rescan
[    2.528681] [<801127f0>] (unwind_backtrace) from [<8010da58>] (show_stack+0x10/0x14)
[    2.536420] [<8010da58>] (show_stack) from [<8080fbe8>] (dump_stack+0xb4/0xe0)
[    2.543645] [<8080fbe8>] (dump_stack) from [<8017efa4>] (register_lock_class+0x6f0/0x718)
[    2.551816] [<8017efa4>] (register_lock_class) from [<8017b7d0>] (__lock_acquire+0x78/0x25f0)
[    2.560330] [<8017b7d0>] (__lock_acquire) from [<8017e5e4>] (lock_acquire+0xd8/0x1f4)
[    2.568159] [<8017e5e4>] (lock_acquire) from [<80831fb0>] (_raw_spin_lock_irqsave+0x3c/0x50)
[    2.576589] [<80831fb0>] (_raw_spin_lock_irqsave) from [<8051b5fc>] (owl_dma_issue_pending+0xbc/0x120)
[    2.585884] [<8051b5fc>] (owl_dma_issue_pending) from [<80668cbc>] (owl_mmc_request+0x1b0/0x390)
[    2.594655] [<80668cbc>] (owl_mmc_request) from [<80650ce0>] (mmc_start_request+0x94/0xbc)
[    2.602906] [<80650ce0>] (mmc_start_request) from [<80650ec0>] (mmc_wait_for_req+0x64/0xd0)
[    2.611245] [<80650ec0>] (mmc_wait_for_req) from [<8065aa10>] (mmc_app_send_scr+0x10c/0x144)
[    2.619669] [<8065aa10>] (mmc_app_send_scr) from [<80659b3c>] (mmc_sd_setup_card+0x4c/0x318)
[    2.628092] [<80659b3c>] (mmc_sd_setup_card) from [<80659f0c>] (mmc_sd_init_card+0x104/0x430)
[    2.636601] [<80659f0c>] (mmc_sd_init_card) from [<8065a3e0>] (mmc_attach_sd+0xcc/0x16c)
[    2.644678] [<8065a3e0>] (mmc_attach_sd) from [<8065301c>] (mmc_rescan+0x3ac/0x40c)
[    2.652332] [<8065301c>] (mmc_rescan) from [<80143244>] (process_one_work+0x2d8/0x780)
[    2.660239] [<80143244>] (process_one_work) from [<80143730>] (worker_thread+0x44/0x598)
[    2.668323] [<80143730>] (worker_thread) from [<8014b5f8>] (kthread+0x148/0x150)
[    2.675708] [<8014b5f8>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)
[    2.682912] Exception stack(0xee8fdfb0 to 0xee8fdff8)
[    2.687954] dfa0:                                     00000000 00000000 00000000 00000000
[    2.696118] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.704277] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000

The obvious fix would be to use 'spin_lock_init()' on 'pchan->lock'
before attempting to call 'spin_lock_irqsave()' in 'owl_dma_get_pchan()'.

However, according to Manivannan Sadhasivam, 'pchan->lock' was supposed
to only protect 'pchan->vchan' while 'od->lock' does a similar job in
'owl_dma_terminate_pchan()'.

Therefore, this patch substitutes 'pchan->lock' with 'od->lock' and
removes the 'lock' attribute in 'owl_dma_pchan' struct.

Fixes: 47e20577c24d ("dmaengine: Add Actions Semi Owl family S900 DMA driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Andreas Färber <afaerber@suse.de>
Link: https://lore.kernel.org/r/c6e6cdaca252b5364bd294093673951036488cf0.1588439073.git.cristian.ciocaltea@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/owl-dma.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/dma/owl-dma.c
+++ b/drivers/dma/owl-dma.c
@@ -175,13 +175,11 @@ struct owl_dma_txd {
  * @id: physical index to this channel
  * @base: virtual memory base for the dma channel
  * @vchan: the virtual channel currently being served by this physical channel
- * @lock: a lock to use when altering an instance of this struct
  */
 struct owl_dma_pchan {
 	u32			id;
 	void __iomem		*base;
 	struct owl_dma_vchan	*vchan;
-	spinlock_t		lock;
 };
 
 /**
@@ -437,14 +435,14 @@ static struct owl_dma_pchan *owl_dma_get
 	for (i = 0; i < od->nr_pchans; i++) {
 		pchan = &od->pchans[i];
 
-		spin_lock_irqsave(&pchan->lock, flags);
+		spin_lock_irqsave(&od->lock, flags);
 		if (!pchan->vchan) {
 			pchan->vchan = vchan;
-			spin_unlock_irqrestore(&pchan->lock, flags);
+			spin_unlock_irqrestore(&od->lock, flags);
 			break;
 		}
 
-		spin_unlock_irqrestore(&pchan->lock, flags);
+		spin_unlock_irqrestore(&od->lock, flags);
 	}
 
 	return pchan;


