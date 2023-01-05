Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE47565EBFC
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjAENFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbjAENEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:04:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0572D5A88D
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9734C61A05
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC06C433F0;
        Thu,  5 Jan 2023 13:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923880;
        bh=Qc/9/EI40VfW4YK415q4toUB3NTM9HnCYECaJJ/rayY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j653sr8z1hV87EJqkREY7yD8f1SNfpKZFKfmGLnChU+lsJeEHUmvPsvtldW5hSj9c
         CXrgWH7DbbEwrx9i/xa2Qsig1MYo/mLEksZNdM1cwsqBwmXrh6HyqFoW3nXO2WeA/w
         DI0msdNDzf2viVorYN2bi9FNkumw4SI+ytsnx99o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiamei Xie <jiamei.xie@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 132/251] serial: amba-pl011: avoid SBSA UART accessing DMACR register
Date:   Thu,  5 Jan 2023 13:54:29 +0100
Message-Id: <20230105125340.873967721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiamei Xie <jiamei.xie@arm.com>

[ Upstream commit 94cdb9f33698478b0e7062586633c42c6158a786 ]

Chapter "B Generic UART" in "ARM Server Base System Architecture" [1]
documentation describes a generic UART interface. Such generic UART
does not support DMA. In current code, sbsa_uart_pops and
amba_pl011_pops share the same stop_rx operation, which will invoke
pl011_dma_rx_stop, leading to an access of the DMACR register. This
commit adds a using_rx_dma check in pl011_dma_rx_stop to avoid the
access to DMACR register for SBSA UARTs which does not support DMA.

When the kernel enables DMA engine with "CONFIG_DMA_ENGINE=y", Linux
SBSA PL011 driver will access PL011 DMACR register in some functions.
For most real SBSA Pl011 hardware implementations, the DMACR write
behaviour will be ignored. So these DMACR operations will not cause
obvious problems. But for some virtual SBSA PL011 hardware, like Xen
virtual SBSA PL011 (vpl011) device, the behaviour might be different.
Xen vpl011 emulation will inject a data abort to guest, when guest is
accessing an unimplemented UART register. As Xen VPL011 is SBSA
compatible, it will not implement DMACR register. So when Linux SBSA
PL011 driver access DMACR register, it will get an unhandled data abort
fault and the application will get a segmentation fault:
Unhandled fault at 0xffffffc00944d048
Mem abort info:
  ESR = 0x96000000
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x00: ttbr address size fault
Data abort info:
  ISV = 0, ISS = 0x00000000
  CM = 0, WnR = 0
swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000020e2e000
[ffffffc00944d048] pgd=100000003ffff803, p4d=100000003ffff803, pud=100000003ffff803, pmd=100000003fffa803, pte=006800009c090f13
Internal error: ttbr address size fault: 96000000 [#1] PREEMPT SMP
...
Call trace:
 pl011_stop_rx+0x70/0x80
 tty_port_shutdown+0x7c/0xb4
 tty_port_close+0x60/0xcc
 uart_close+0x34/0x8c
 tty_release+0x144/0x4c0
 __fput+0x78/0x220
 ____fput+0x1c/0x30
 task_work_run+0x88/0xc0
 do_notify_resume+0x8d0/0x123c
 el0_svc+0xa8/0xc0
 el0t_64_sync_handler+0xa4/0x130
 el0t_64_sync+0x1a0/0x1a4
Code: b9000083 b901f001 794038a0 8b000042 (b9000041)
---[ end trace 83dd93df15c3216f ]---
note: bootlogd[132] exited with preempt_count 1
/etc/rcS.d/S07bootlogd: line 47: 132 Segmentation fault start-stop-daemon

This has been discussed in the Xen community, and we think it should fix
this in Linux. See [2] for more information.

[1] https://developer.arm.com/documentation/den0094/c/?lang=en
[2] https://lists.xenproject.org/archives/html/xen-devel/2022-11/msg00543.html

Fixes: 0dd1e247fd39 (drivers: PL011: add support for the ARM SBSA generic UART)
Signed-off-by: Jiamei Xie <jiamei.xie@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20221117103237.86856-1-jiamei.xie@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index ad1d665e9962..59092f1d2856 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1048,6 +1048,9 @@ static void pl011_dma_rx_callback(void *data)
  */
 static inline void pl011_dma_rx_stop(struct uart_amba_port *uap)
 {
+	if (!uap->using_rx_dma)
+		return;
+
 	/* FIXME.  Just disable the DMA enable */
 	uap->dmacr &= ~UART011_RXDMAE;
 	pl011_write(uap->dmacr, uap, REG_DMACR);
-- 
2.35.1



