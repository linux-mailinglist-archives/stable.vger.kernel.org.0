Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4E26AF037
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbjCGS3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbjCGS3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8FBB0490
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 935E4B819D3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1F5C433D2;
        Tue,  7 Mar 2023 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213319;
        bh=FLtrJxCU8svaKcDRb4gucpSxupy5YS++0q4zrd5VOKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9MJrvnW49rJXhnvCyZNUqvJBEHbdiyLOYle2f+GOPSE081CG5IZ/+T9iMHJVAfqS
         ortvLqS2rZlEP9L7H8xs62nig2bB6/n6C0t/L1NR4E5h52TcTs+/f63AdKRX/G93Ks
         YrHDOuiEBYbuSiV19kEHSxhI5rZoTgIhM0h3BIJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sherry Sun <sherry.sun@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Jason Liu <jason.hui.liu@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 468/885] tty: serial: imx: disable Ageing Timer interrupt request irq
Date:   Tue,  7 Mar 2023 17:56:42 +0100
Message-Id: <20230307170022.828287376@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit ef25e16ea9674b713a68c3bda821556ce9901254 ]

There maybe pending USR interrupt before requesting irq, however
uart_add_one_port has not executed, so there will be kernel panic:
[    0.795668] Unable to handle kernel NULL pointer dereference at virtual addre
ss 0000000000000080
[    0.802701] Mem abort info:
[    0.805367]   ESR = 0x0000000096000004
[    0.808950]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.814033]   SET = 0, FnV = 0
[    0.816950]   EA = 0, S1PTW = 0
[    0.819950]   FSC = 0x04: level 0 translation fault
[    0.824617] Data abort info:
[    0.827367]   ISV = 0, ISS = 0x00000004
[    0.831033]   CM = 0, WnR = 0
[    0.833866] [0000000000000080] user address but active_mm is swapper
[    0.839951] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[    0.845953] Modules linked in:
[    0.848869] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.1+g56321e101aca #1
[    0.855617] Hardware name: Freescale i.MX8MP EVK (DT)
[    0.860452] pstate: 000000c5 (nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.867117] pc : __imx_uart_rxint.constprop.0+0x11c/0x2c0
[    0.872283] lr : imx_uart_int+0xf8/0x1ec

The issue only happends in the inmate linux when Jailhouse hypervisor
enabled. The test procedure is:
while true; do
	jailhouse enable imx8mp.cell
	jailhouse cell linux xxxx
	sleep 10
	jailhouse cell destroy 1
	jailhouse disable
	sleep 5
done

And during the upper test, press keys to the 2nd linux console.
When `jailhouse cell destroy 1`, the 2nd linux has no chance to put
the uart to a quiese state, so USR1/2 may has pending interrupts. Then
when `jailhosue cell linux xx` to start 2nd linux again, the issue
trigger.

In order to disable irqs before requesting them, both UCR1 and UCR2 irqs
should be disabled, so here fix that, disable the Ageing Timer interrupt
in UCR2 as UCR1 does.

Fixes: 8a61f0c70ae6 ("serial: imx: Disable irqs before requesting them")
Suggested-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Jason Liu <jason.hui.liu@nxp.com>
Link: https://lore.kernel.org/r/20230206013016.29352-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index f3f03cef3c7a9..f07c4f9ff13c0 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2377,6 +2377,11 @@ static int imx_uart_probe(struct platform_device *pdev)
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
 	imx_uart_writel(sport, ucr1, UCR1);
 
+	/* Disable Ageing Timer interrupt */
+	ucr2 = imx_uart_readl(sport, UCR2);
+	ucr2 &= ~UCR2_ATEN;
+	imx_uart_writel(sport, ucr2, UCR2);
+
 	/*
 	 * In case RS485 is enabled without GPIO RTS control, the UART IP
 	 * is used to control CTS signal. Keep both the UART and Receiver
-- 
2.39.2



