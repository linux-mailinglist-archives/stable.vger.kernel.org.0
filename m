Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B72F59E08F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353699AbiHWKSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354342AbiHWKRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:17:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25C580B5A;
        Tue, 23 Aug 2022 02:01:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D5C61459;
        Tue, 23 Aug 2022 09:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2EFC433D6;
        Tue, 23 Aug 2022 09:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245283;
        bh=k99rQfAN/Lt2RYkkU5H2EoGW+vQy2MUMH4d2va9jXms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKFkLDk1w3mGccHmsXwpBa9OrTrXLiV/b6zDXoaMFK7Y3/Og8YVCaLDiWhoo4pEE9
         /cRSk/p7kopfOTRWKRf7YPWv0lhhrxrfqxG92+AhD4BmvYqQNjXjns7MsEOUu2/RX0
         +2cTAxiGWOFXYykoacA1ovu30HjVTHGf6nITrgLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Guo <yi.guo@cavium.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Narendra Hadke <nhadke@marvell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4.19 029/287] serial: mvebu-uart: uart2 error bits clearing
Date:   Tue, 23 Aug 2022 10:23:18 +0200
Message-Id: <20220823080101.256900175@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Narendra Hadke <nhadke@marvell.com>

commit a7209541239e5dd44d981289e5f9059222d40fd1 upstream.

For mvebu uart2, error bits are not cleared on buffer read.
This causes interrupt loop and system hang.

Cc: stable@vger.kernel.org
Reviewed-by: Yi Guo <yi.guo@cavium.com>
Reviewed-by: Nadav Haklai <nadavh@marvell.com>
Signed-off-by: Narendra Hadke <nhadke@marvell.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20220726091221.12358-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mvebu-uart.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -237,6 +237,7 @@ static void mvebu_uart_rx_chars(struct u
 	struct tty_port *tport = &port->state->port;
 	unsigned char ch = 0;
 	char flag = 0;
+	int ret;
 
 	do {
 		if (status & STAT_RX_RDY(port)) {
@@ -249,6 +250,16 @@ static void mvebu_uart_rx_chars(struct u
 				port->icount.parity++;
 		}
 
+		/*
+		 * For UART2, error bits are not cleared on buffer read.
+		 * This causes interrupt loop and system hang.
+		 */
+		if (IS_EXTENDED(port) && (status & STAT_BRK_ERR)) {
+			ret = readl(port->membase + UART_STAT);
+			ret |= STAT_BRK_ERR;
+			writel(ret, port->membase + UART_STAT);
+		}
+
 		if (status & STAT_BRK_DET) {
 			port->icount.brk++;
 			status &= ~(STAT_FRM_ERR | STAT_PAR_ERR);


