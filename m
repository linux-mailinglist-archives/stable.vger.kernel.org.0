Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFB85939F2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbiHOT3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344516AbiHOT04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64ED25A3D3;
        Mon, 15 Aug 2022 11:42:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1347611C2;
        Mon, 15 Aug 2022 18:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCF6C433C1;
        Mon, 15 Aug 2022 18:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588961;
        bh=TZ2I0orKzVsErbjWyCR70Fk0ZaBl7NXIQBB05th5cEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUWlGyOHKOXDkGTHk8nIHIsTDpyiusFC83LTE9yYCQugOXUu/OyKA2c5RHnFvGWKa
         ya0swIv6Y/SbWUPxitETbVbiIjD3ub9njJIURsqI/u4KDVeq+YKtafrsJKdmnAxlk/
         WR8UCYTTSIhhGOE6fqGgmXaqjJg0m+Srg62mHdFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 570/779] serial: 8250_dw: Store LSR into lsr_saved_flags in dw8250_tx_wait_empty()
Date:   Mon, 15 Aug 2022 20:03:34 +0200
Message-Id: <20220815180401.697120685@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit af14f3007e2dca0d112f10f6717ba43093f74e81 ]

Make sure LSR flags are preserved in dw8250_tx_wait_empty(). This
function is called from a low-level out function and therefore cannot
call serial_lsr_in() as it would lead to infinite recursion.

It is borderline if the flags need to be saved here at all since this
code relates to writing LCR register which usually implies no important
characters should be arriving.

Fixes: 914eaf935ec7 ("serial: 8250_dw: Allow TX FIFO to drain before writing to UART_LCR")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220608095431.18376-7-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 49559731bbcf..ace221afeb03 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -124,12 +124,15 @@ static void dw8250_check_lcr(struct uart_port *p, int value)
 /* Returns once the transmitter is empty or we run out of retries */
 static void dw8250_tx_wait_empty(struct uart_port *p)
 {
+	struct uart_8250_port *up = up_to_u8250p(p);
 	unsigned int tries = 20000;
 	unsigned int delay_threshold = tries - 1000;
 	unsigned int lsr;
 
 	while (tries--) {
 		lsr = readb (p->membase + (UART_LSR << p->regshift));
+		up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
+
 		if (lsr & UART_LSR_TEMT)
 			break;
 
-- 
2.35.1



