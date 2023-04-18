Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B616E6159
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjDRMZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjDRMZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:25:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4528694
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 566BD630FE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1BDC433EF;
        Tue, 18 Apr 2023 12:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820677;
        bh=IXApLIblXqVMMEmJCof5iNSyIP3K04WctoV2hdNfo4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LS8KyvQH8xbIVftNqhmYJaWVBbflRzpQYYZXX73IeDuPxfBCE+rXlcb+cdKa6fLGI
         XfgbcRJm7dZUSysfEK2Z5aJlPOuYpG/Zxkr8DVyqYkp0n66rBq6vC99VUtsTwsMxYK
         aTEBn6hdDGI4DXMvmFXTvATurx9g3grGRbTbQyc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/37] net: macb: fix a memory corruption in extended buffer descriptor mode
Date:   Tue, 18 Apr 2023 14:21:37 +0200
Message-Id: <20230418120255.635534725@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <roman.gushchin@linux.dev>

[ Upstream commit e8b74453555872851bdd7ea43a7c0ec39659834f ]

For quite some time we were chasing a bug which looked like a sudden
permanent failure of networking and mmc on some of our devices.
The bug was very sensitive to any software changes and even more to
any kernel debug options.

Finally we got a setup where the problem was reproducible with
CONFIG_DMA_API_DEBUG=y and it revealed the issue with the rx dma:

[   16.992082] ------------[ cut here ]------------
[   16.996779] DMA-API: macb ff0b0000.ethernet: device driver tries to free DMA memory it has not allocated [device address=0x0000000875e3e244] [size=1536 bytes]
[   17.011049] WARNING: CPU: 0 PID: 85 at kernel/dma/debug.c:1011 check_unmap+0x6a0/0x900
[   17.018977] Modules linked in: xxxxx
[   17.038823] CPU: 0 PID: 85 Comm: irq/55-8000f000 Not tainted 5.4.0 #28
[   17.045345] Hardware name: xxxxx
[   17.049528] pstate: 60000005 (nZCv daif -PAN -UAO)
[   17.054322] pc : check_unmap+0x6a0/0x900
[   17.058243] lr : check_unmap+0x6a0/0x900
[   17.062163] sp : ffffffc010003c40
[   17.065470] x29: ffffffc010003c40 x28: 000000004000c03c
[   17.070783] x27: ffffffc010da7048 x26: ffffff8878e38800
[   17.076095] x25: ffffff8879d22810 x24: ffffffc010003cc8
[   17.081407] x23: 0000000000000000 x22: ffffffc010a08750
[   17.086719] x21: ffffff8878e3c7c0 x20: ffffffc010acb000
[   17.092032] x19: 0000000875e3e244 x18: 0000000000000010
[   17.097343] x17: 0000000000000000 x16: 0000000000000000
[   17.102647] x15: ffffff8879e4a988 x14: 0720072007200720
[   17.107959] x13: 0720072007200720 x12: 0720072007200720
[   17.113261] x11: 0720072007200720 x10: 0720072007200720
[   17.118565] x9 : 0720072007200720 x8 : 000000000000022d
[   17.123869] x7 : 0000000000000015 x6 : 0000000000000098
[   17.129173] x5 : 0000000000000000 x4 : 0000000000000000
[   17.134475] x3 : 00000000ffffffff x2 : ffffffc010a1d370
[   17.139778] x1 : b420c9d75d27bb00 x0 : 0000000000000000
[   17.145082] Call trace:
[   17.147524]  check_unmap+0x6a0/0x900
[   17.151091]  debug_dma_unmap_page+0x88/0x90
[   17.155266]  gem_rx+0x114/0x2f0
[   17.158396]  macb_poll+0x58/0x100
[   17.161705]  net_rx_action+0x118/0x400
[   17.165445]  __do_softirq+0x138/0x36c
[   17.169100]  irq_exit+0x98/0xc0
[   17.172234]  __handle_domain_irq+0x64/0xc0
[   17.176320]  gic_handle_irq+0x5c/0xc0
[   17.179974]  el1_irq+0xb8/0x140
[   17.183109]  xiic_process+0x5c/0xe30
[   17.186677]  irq_thread_fn+0x28/0x90
[   17.190244]  irq_thread+0x208/0x2a0
[   17.193724]  kthread+0x130/0x140
[   17.196945]  ret_from_fork+0x10/0x20
[   17.200510] ---[ end trace 7240980785f81d6f ]---

[  237.021490] ------------[ cut here ]------------
[  237.026129] DMA-API: exceeded 7 overlapping mappings of cacheline 0x0000000021d79e7b
[  237.033886] WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:499 add_dma_entry+0x214/0x240
[  237.041802] Modules linked in: xxxxx
[  237.061637] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.4.0 #28
[  237.068941] Hardware name: xxxxx
[  237.073116] pstate: 80000085 (Nzcv daIf -PAN -UAO)
[  237.077900] pc : add_dma_entry+0x214/0x240
[  237.081986] lr : add_dma_entry+0x214/0x240
[  237.086072] sp : ffffffc010003c30
[  237.089379] x29: ffffffc010003c30 x28: ffffff8878a0be00
[  237.094683] x27: 0000000000000180 x26: ffffff8878e387c0
[  237.099987] x25: 0000000000000002 x24: 0000000000000000
[  237.105290] x23: 000000000000003b x22: ffffffc010a0fa00
[  237.110594] x21: 0000000021d79e7b x20: ffffffc010abe600
[  237.115897] x19: 00000000ffffffef x18: 0000000000000010
[  237.121201] x17: 0000000000000000 x16: 0000000000000000
[  237.126504] x15: ffffffc010a0fdc8 x14: 0720072007200720
[  237.131807] x13: 0720072007200720 x12: 0720072007200720
[  237.137111] x11: 0720072007200720 x10: 0720072007200720
[  237.142415] x9 : 0720072007200720 x8 : 0000000000000259
[  237.147718] x7 : 0000000000000001 x6 : 0000000000000000
[  237.153022] x5 : ffffffc010003a20 x4 : 0000000000000001
[  237.158325] x3 : 0000000000000006 x2 : 0000000000000007
[  237.163628] x1 : 8ac721b3a7dc1c00 x0 : 0000000000000000
[  237.168932] Call trace:
[  237.171373]  add_dma_entry+0x214/0x240
[  237.175115]  debug_dma_map_page+0xf8/0x120
[  237.179203]  gem_rx_refill+0x190/0x280
[  237.182942]  gem_rx+0x224/0x2f0
[  237.186075]  macb_poll+0x58/0x100
[  237.189384]  net_rx_action+0x118/0x400
[  237.193125]  __do_softirq+0x138/0x36c
[  237.196780]  irq_exit+0x98/0xc0
[  237.199914]  __handle_domain_irq+0x64/0xc0
[  237.204000]  gic_handle_irq+0x5c/0xc0
[  237.207654]  el1_irq+0xb8/0x140
[  237.210789]  arch_cpu_idle+0x40/0x200
[  237.214444]  default_idle_call+0x18/0x30
[  237.218359]  do_idle+0x200/0x280
[  237.221578]  cpu_startup_entry+0x20/0x30
[  237.225493]  rest_init+0xe4/0xf0
[  237.228713]  arch_call_rest_init+0xc/0x14
[  237.232714]  start_kernel+0x47c/0x4a8
[  237.236367] ---[ end trace 7240980785f81d70 ]---

Lars was fast to find an explanation: according to the datasheet
bit 2 of the rx buffer descriptor entry has a different meaning in the
extended mode:
  Address [2] of beginning of buffer, or
  in extended buffer descriptor mode (DMA configuration register [28] = 1),
  indicates a valid timestamp in the buffer descriptor entry.

The macb driver didn't mask this bit while getting an address and it
eventually caused a memory corruption and a dma failure.

The problem is resolved by explicitly clearing the problematic bit
if hw timestamping is used.

Fixes: 7b4296148066 ("net: macb: Add support for PTP timestamps in DMA descriptors")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Co-developed-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20230412232144.770336-1-roman.gushchin@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 456d84cbcc6be..9e51e0462e2c6 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -701,6 +701,10 @@ static dma_addr_t macb_get_addr(struct macb *bp, struct macb_dma_desc *desc)
 	}
 #endif
 	addr |= MACB_BF(RX_WADDR, MACB_BFEXT(RX_WADDR, desc->addr));
+#ifdef CONFIG_MACB_USE_HWSTAMP
+	if (bp->hw_dma_cap & HW_DMA_CAP_PTP)
+		addr &= ~GEM_BIT(DMA_RXVALID);
+#endif
 	return addr;
 }
 
-- 
2.39.2



