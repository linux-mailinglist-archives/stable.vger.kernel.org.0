Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A951034C63B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhC2IGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232090AbhC2IFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ACF561974;
        Mon, 29 Mar 2021 08:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005103;
        bh=bu9Eq3kNXr4FyHrjK60GQwJP3tzHCRp9scyrY/Xx4yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSJBo8p61AekOf+kwCFIwzTlxgy/hmu7NPuug15fqkLrxbnjipZCcfgXeKIVaUFin
         I+tz1HkoPS+Et7BBBprr9lVZBR1h+p9gk/cdFWm4RZycy3ZLsjWBGX2WRBJjVIftEj
         hkeAvyZDbPUwugZ9+tkzrxPkmcyDGJ47115c0jSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.14 24/59] arm64: dts: ls1046a: mark crypto engine dma coherent
Date:   Mon, 29 Mar 2021 09:58:04 +0200
Message-Id: <20210329075609.683634115@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horia Geantă <horia.geanta@nxp.com>

commit 9c3a16f88385e671b63a0de7b82b85e604a80f42 upstream.

Crypto engine (CAAM) on LS1046A platform is configured HW-coherent,
mark accordingly the DT node.

As reported by Greg and Sascha, and explained by Robin, lack of
"dma-coherent" property for an IP that is configured HW-coherent
can lead to problems, e.g. on v5.11:

> kernel BUG at drivers/crypto/caam/jr.c:247!
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-20210225-3-00039-g434215968816-dirty #12
> Hardware name: TQ TQMLS1046A SoM on Arkona AT1130 (C300) board (DT)
> pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> pc : caam_jr_dequeue+0x98/0x57c
> lr : caam_jr_dequeue+0x98/0x57c
> sp : ffff800010003d50
> x29: ffff800010003d50 x28: ffff8000118d4000
> x27: ffff8000118d4328 x26: 00000000000001f0
> x25: ffff0008022be480 x24: ffff0008022c6410
> x23: 00000000000001f1 x22: ffff8000118d4329
> x21: 0000000000004d80 x20: 00000000000001f1
> x19: 0000000000000001 x18: 0000000000000020
> x17: 0000000000000000 x16: 0000000000000015
> x15: ffff800011690230 x14: 2e2e2e2e2e2e2e2e
> x13: 2e2e2e2e2e2e2020 x12: 3030303030303030
> x11: ffff800011700a38 x10: 00000000fffff000
> x9 : ffff8000100ada30 x8 : ffff8000116a8a38
> x7 : 0000000000000001 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000
> x3 : 00000000ffffffff x2 : 0000000000000000
> x1 : 0000000000000000 x0 : 0000000000001800
> Call trace:
>  caam_jr_dequeue+0x98/0x57c
>  tasklet_action_common.constprop.0+0x164/0x18c
>  tasklet_action+0x44/0x54
>  __do_softirq+0x160/0x454
>  __irq_exit_rcu+0x164/0x16c
>  irq_exit+0x1c/0x30
>  __handle_domain_irq+0xc0/0x13c
>  gic_handle_irq+0x5c/0xf0
>  el1_irq+0xb4/0x180
>  arch_cpu_idle+0x18/0x30
>  default_idle_call+0x3c/0x1c0
>  do_idle+0x23c/0x274
>  cpu_startup_entry+0x34/0x70
>  rest_init+0xdc/0xec
>  arch_call_rest_init+0x1c/0x28
>  start_kernel+0x4ac/0x4e4
> Code: 91392021 912c2000 d377d8c6 97f24d96 (d4210000)

Cc: <stable@vger.kernel.org> # v4.10+
Fixes: 8126d88162a5 ("arm64: dts: add QorIQ LS1046A SoC support")
Link: https://lore.kernel.org/linux-crypto/fe6faa24-d8f7-d18f-adfa-44fa0caa1598@arm.com
Reported-by: Greg Ungerer <gerg@kernel.org>
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Acked-by: Greg Ungerer <gerg@kernel.org>
Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -244,6 +244,7 @@
 			ranges = <0x0 0x00 0x1700000 0x100000>;
 			reg = <0x00 0x1700000 0x0 0x100000>;
 			interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;
+			dma-coherent;
 
 			sec_jr0: jr@10000 {
 				compatible = "fsl,sec-v5.4-job-ring",


