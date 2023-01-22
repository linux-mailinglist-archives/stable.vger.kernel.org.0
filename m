Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196E8676EEC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjAVPPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjAVPPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:15:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DB822033
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:15:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3205B80B1A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D45C433EF;
        Sun, 22 Jan 2023 15:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400548;
        bh=QAQssnu91n57wUCsf9Rt3u9HIRbVMIgt0CtjMPne0Os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2NC6FAJsdt3YtoI9oqbZrdnj4EziiXgPr9KHgGjm+5IavmNtheJis3A1kCoAABc+
         xdQZxqfWbOQCN+G5qUADSF8k2PCJP5tu11NCai2Oewo9vhv+KIn8lyn9+nlYF/SnY+
         07jtdCBymKEwAfq5aB5n7edqfiBb4xFBLFlL6XdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Shawn.Shao" <shawn.shao@jaguarmicro.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 018/117] Add exception protection processing for vd in axi_chan_handle_err function
Date:   Sun, 22 Jan 2023 16:03:28 +0100
Message-Id: <20230122150233.437717456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn.Shao <shawn.shao@jaguarmicro.com>

commit 57054fe516d59d03a7bcf1888e82479ccc244f87 upstream.

Since there is no protection for vd, a kernel panic will be
triggered here in exceptional cases.

You can refer to the processing of axi_chan_block_xfer_complete function

The triggered kernel panic is as follows:

[   67.848444] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000060
[   67.848447] Mem abort info:
[   67.848449]   ESR = 0x96000004
[   67.848451]   EC = 0x25: DABT (current EL), IL = 32 bits
[   67.848454]   SET = 0, FnV = 0
[   67.848456]   EA = 0, S1PTW = 0
[   67.848458] Data abort info:
[   67.848460]   ISV = 0, ISS = 0x00000004
[   67.848462]   CM = 0, WnR = 0
[   67.848465] user pgtable: 4k pages, 48-bit VAs, pgdp=00000800c4c0b000
[   67.848468] [0000000000000060] pgd=0000000000000000, p4d=0000000000000000
[   67.848472] Internal error: Oops: 96000004 [#1] SMP
[   67.848475] Modules linked in: dmatest
[   67.848479] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.100-emu_x2rc+ #11
[   67.848483] pstate: 62000085 (nZCv daIf -PAN -UAO +TCO BTYPE=--)
[   67.848487] pc : axi_chan_handle_err+0xc4/0x230
[   67.848491] lr : axi_chan_handle_err+0x30/0x230
[   67.848493] sp : ffff0803fe55ae50
[   67.848495] x29: ffff0803fe55ae50 x28: ffff800011212200
[   67.848500] x27: ffff0800c42c0080 x26: ffff0800c097c080
[   67.848504] x25: ffff800010d33880 x24: ffff80001139d850
[   67.848508] x23: ffff0800c097c168 x22: 0000000000000000
[   67.848512] x21: 0000000000000080 x20: 0000000000002000
[   67.848517] x19: ffff0800c097c080 x18: 0000000000000000
[   67.848521] x17: 0000000000000000 x16: 0000000000000000
[   67.848525] x15: 0000000000000000 x14: 0000000000000000
[   67.848529] x13: 0000000000000000 x12: 0000000000000040
[   67.848533] x11: ffff0800c0400248 x10: ffff0800c040024a
[   67.848538] x9 : ffff800010576cd4 x8 : ffff0800c0400270
[   67.848542] x7 : 0000000000000000 x6 : ffff0800c04003e0
[   67.848546] x5 : ffff0800c0400248 x4 : ffff0800c4294480
[   67.848550] x3 : dead000000000100 x2 : dead000000000122
[   67.848555] x1 : 0000000000000100 x0 : ffff0800c097c168
[   67.848559] Call trace:
[   67.848562]  axi_chan_handle_err+0xc4/0x230
[   67.848566]  dw_axi_dma_interrupt+0xf4/0x590
[   67.848569]  __handle_irq_event_percpu+0x60/0x220
[   67.848573]  handle_irq_event+0x64/0x120
[   67.848576]  handle_fasteoi_irq+0xc4/0x220
[   67.848580]  __handle_domain_irq+0x80/0xe0
[   67.848583]  gic_handle_irq+0xc0/0x138
[   67.848585]  el1_irq+0xc8/0x180
[   67.848588]  arch_cpu_idle+0x14/0x2c
[   67.848591]  default_idle_call+0x40/0x16c
[   67.848594]  do_idle+0x1f0/0x250
[   67.848597]  cpu_startup_entry+0x2c/0x60
[   67.848600]  rest_init+0xc0/0xcc
[   67.848603]  arch_call_rest_init+0x14/0x1c
[   67.848606]  start_kernel+0x4cc/0x500
[   67.848610] Code: eb0002ff 9a9f12d6 f2fbd5a2 f2fbd5a3 (a94602c1)
[   67.848613] ---[ end trace 585a97036f88203a ]---

Signed-off-by: Shawn.Shao <shawn.shao@jaguarmicro.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230112055802.1764-1-shawn.shao@jaguarmicro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -980,6 +980,11 @@ static noinline void axi_chan_handle_err
 
 	/* The bad descriptor currently is in the head of vc list */
 	vd = vchan_next_desc(&chan->vc);
+	if (!vd) {
+		dev_err(chan2dev(chan), "BUG: %s, IRQ with no descriptors\n",
+			axi_chan_name(chan));
+		goto out;
+	}
 	/* Remove the completed descriptor from issued list */
 	list_del(&vd->node);
 
@@ -994,6 +999,7 @@ static noinline void axi_chan_handle_err
 	/* Try to restart the controller */
 	axi_chan_start_first_queued(chan);
 
+out:
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
 }
 


