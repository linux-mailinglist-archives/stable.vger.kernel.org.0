Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40EB60AA34
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiJXNbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiJXN3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:29:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86798AB80F;
        Mon, 24 Oct 2022 05:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4C076128E;
        Mon, 24 Oct 2022 12:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3719C4347C;
        Mon, 24 Oct 2022 12:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614379;
        bh=/ADuqSbrPhq/DIYL6JjVOOh+yAXtSJSCtWMkYRSaMVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgKD7Ddt2euyKHt+vAOpVuHtl+moFLQvFg2oAarSrxyzvu2S8vr/JaS+wHiqK5pXh
         8HV+LC2BAcVix41OTU9JFECk2iPTm83FGl0neyWFhAdc+yqAUID9u7ULWr/oBDOGl0
         BDtwzZbZfooNrdhDz89SPK6Nyykph9DA54Ley5yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/390] tty: serial: fsl_lpuart: disable dma rx/tx use flags in lpuart_dma_shutdown
Date:   Mon, 24 Oct 2022 13:30:35 +0200
Message-Id: <20221024113032.930479160@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 316ae95c175a7d770d1bfe4c011192712f57aa4a ]

lpuart_dma_shutdown tears down lpuart dma, but lpuart_flush_buffer can
still occur which in turn tries to access dma apis if lpuart_dma_tx_use
flag is true. At this point since dma is torn down, these dma apis can
abort. Set lpuart_dma_tx_use and the corresponding rx flag
lpuart_dma_rx_use to false in lpuart_dma_shutdown so that dmas are not
accessed after they are relinquished.

Otherwise, when try to kill btattach, kernel may panic. This patch may
fix this issue.
root@imx8ulpevk:~# btattach -B /dev/ttyLP2 -S 115200
^C[   90.182296] Internal error: synchronous external abort: 96000210 [#1] PREEMPT SMP
[   90.189806] Modules linked in: moal(O) mlan(O)
[   90.194258] CPU: 0 PID: 503 Comm: btattach Tainted: G           O      5.15.32-06136-g34eecdf2f9e4 #37
[   90.203554] Hardware name: NXP i.MX8ULP 9X9 EVK (DT)
[   90.208513] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   90.215470] pc : fsl_edma3_disable_request+0x8/0x60
[   90.220358] lr : fsl_edma3_terminate_all+0x34/0x20c
[   90.225237] sp : ffff800013f0bac0
[   90.228548] x29: ffff800013f0bac0 x28: 0000000000000001 x27: ffff000008404800
[   90.235681] x26: ffff000008404960 x25: ffff000008404a08 x24: ffff000008404a00
[   90.242813] x23: ffff000008404a60 x22: 0000000000000002 x21: 0000000000000000
[   90.249946] x20: ffff800013f0baf8 x19: ffff00000559c800 x18: 0000000000000000
[   90.257078] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[   90.264211] x14: 0000000000000003 x13: 0000000000000000 x12: 0000000000000040
[   90.271344] x11: ffff00000600c248 x10: ffff800013f0bb10 x9 : ffff000057bcb090
[   90.278477] x8 : fffffc0000241a08 x7 : ffff00000534ee00 x6 : ffff000008404804
[   90.285609] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff0000055b3480
[   90.292742] x2 : ffff8000135c0000 x1 : ffff00000534ee00 x0 : ffff00000559c800
[   90.299876] Call trace:
[   90.302321]  fsl_edma3_disable_request+0x8/0x60
[   90.306851]  lpuart_flush_buffer+0x40/0x160
[   90.311037]  uart_flush_buffer+0x88/0x120
[   90.315050]  tty_driver_flush_buffer+0x20/0x30
[   90.319496]  hci_uart_flush+0x44/0x90
[   90.323162]  +0x34/0x12c
[   90.327253]  tty_ldisc_close+0x38/0x70
[   90.331005]  tty_ldisc_release+0xa8/0x190
[   90.335018]  tty_release_struct+0x24/0x8c
[   90.339022]  tty_release+0x3ec/0x4c0
[   90.342593]  __fput+0x70/0x234
[   90.345652]  ____fput+0x14/0x20
[   90.348790]  task_work_run+0x84/0x17c
[   90.352455]  do_exit+0x310/0x96c
[   90.355688]  do_group_exit+0x3c/0xa0
[   90.359259]  __arm64_sys_exit_group+0x1c/0x20
[   90.363609]  invoke_syscall+0x48/0x114
[   90.367362]  el0_svc_common.constprop.0+0xd4/0xfc
[   90.372068]  do_el0_svc+0x2c/0x94
[   90.375379]  el0_svc+0x28/0x80
[   90.378438]  el0t_64_sync_handler+0xa8/0x130
[   90.382711]  el0t_64_sync+0x1a0/0x1a4
[   90.386376] Code: 17ffffda d503201f d503233f f9409802 (b9400041)
[   90.392467] ---[ end trace 2f60524b4a43f1f6 ]---
[   90.397073] note: btattach[503] exited with preempt_count 1
[   90.402636] Fixing recursive fault but reboot is needed!

Fixes: 6250cc30c4c4 ("tty: serial: fsl_lpuart: Use scatter/gather DMA for Tx")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Thara Gopinath <tgopinath@microsoft.com>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20220920111703.1532-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index a2c4eab0b470..269d1e3a025d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1725,6 +1725,7 @@ static void lpuart_dma_shutdown(struct lpuart_port *sport)
 	if (sport->lpuart_dma_rx_use) {
 		del_timer_sync(&sport->lpuart_timer);
 		lpuart_dma_rx_free(&sport->port);
+		sport->lpuart_dma_rx_use = false;
 	}
 
 	if (sport->lpuart_dma_tx_use) {
@@ -1733,6 +1734,7 @@ static void lpuart_dma_shutdown(struct lpuart_port *sport)
 			sport->dma_tx_in_progress = false;
 			dmaengine_terminate_all(sport->dma_tx_chan);
 		}
+		sport->lpuart_dma_tx_use = false;
 	}
 
 	if (sport->dma_tx_chan)
-- 
2.35.1



