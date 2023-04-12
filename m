Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96DF6DEEC3
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjDLIo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjDLIog (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864AE8689
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4358963058
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54214C433D2;
        Wed, 12 Apr 2023 08:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289034;
        bh=dePYVyhhQ2CroVwonwelpyCQdVX/unKh+KuH+KtUeZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRUAaj2rgFdqFFIKrmv/w9zxCOBxdvpfXGdxIMc4Vx4PxmDnZUp3xkEr2ZYSu/Rv7
         T2Emu5bDnKdY+pc3wilALxfBQSMItd74t9Zfnif6IgLGrlrx32cKpEymZpj0Mn9l0e
         7NMqcunYfVBbiLc8V1mGEL6MTNOgFCNqMM0UPSEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: [PATCH 6.1 081/164] tty: serial: fsl_lpuart: avoid checking for transfer complete when UARTCTRL_SBK is asserted in lpuart32_tx_empty
Date:   Wed, 12 Apr 2023 10:33:23 +0200
Message-Id: <20230412082840.191066353@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

commit 9425914f3de6febbd6250395f56c8279676d9c3c upstream.

According to LPUART RM, Transmission Complete Flag becomes 0 if queuing
a break character by writing 1 to CTRL[SBK], so here need to avoid
checking for transmission complete when UARTCTRL_SBK is asserted,
otherwise the lpuart32_tx_empty may never get TIOCSER_TEMT.

Commit 2411fd94ceaa("tty: serial: fsl_lpuart: skip waiting for
transmission complete when UARTCTRL_SBK is asserted") only fix it in
lpuart32_set_termios(), here also fix it in lpuart32_tx_empty().

Fixes: 380c966c093e ("tty: serial: fsl_lpuart: add 32-bit register interface support")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230323054415.20363-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -838,11 +838,17 @@ static unsigned int lpuart32_tx_empty(st
 			struct lpuart_port, port);
 	unsigned long stat = lpuart32_read(port, UARTSTAT);
 	unsigned long sfifo = lpuart32_read(port, UARTFIFO);
+	unsigned long ctrl = lpuart32_read(port, UARTCTRL);
 
 	if (sport->dma_tx_in_progress)
 		return 0;
 
-	if (stat & UARTSTAT_TC && sfifo & UARTFIFO_TXEMPT)
+	/*
+	 * LPUART Transmission Complete Flag may never be set while queuing a break
+	 * character, so avoid checking for transmission complete when UARTCTRL_SBK
+	 * is asserted.
+	 */
+	if ((stat & UARTSTAT_TC && sfifo & UARTFIFO_TXEMPT) || ctrl & UARTCTRL_SBK)
 		return TIOCSER_TEMT;
 
 	return 0;


