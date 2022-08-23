Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD7659E301
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242609AbiHWLYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243725AbiHWLWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:22:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB69B37FB8;
        Tue, 23 Aug 2022 02:23:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1CDDB81C66;
        Tue, 23 Aug 2022 09:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49539C433D6;
        Tue, 23 Aug 2022 09:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246303;
        bh=R4C2c3WFFmkYTu566XNSyyK3NoFMApqQVZetXM93FfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMB0elDSirvuOPkEOhBXR9ZZWygm1EG4h3s5ZY95479+7d3l2k4tesZ1yRteYH6mJ
         0F9C12xowdurRIYmnzdkxkXyhP2RKHCSoC0qv5h38Yyc0YYQDjZun2PzKhwdSKaD4k
         0YfHxo0jzODQqGkqPrvRzI8QWLIB+K2sXb2StYUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Guo <yi.guo@cavium.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Narendra Hadke <nhadke@marvell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.4 036/389] serial: mvebu-uart: uart2 error bits clearing
Date:   Tue, 23 Aug 2022 10:21:54 +0200
Message-Id: <20220823080117.160262496@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -238,6 +238,7 @@ static void mvebu_uart_rx_chars(struct u
 	struct tty_port *tport = &port->state->port;
 	unsigned char ch = 0;
 	char flag = 0;
+	int ret;
 
 	do {
 		if (status & STAT_RX_RDY(port)) {
@@ -250,6 +251,16 @@ static void mvebu_uart_rx_chars(struct u
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


