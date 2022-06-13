Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399DD548DDD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355475AbiFMM4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358193AbiFMMzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D267E3586B;
        Mon, 13 Jun 2022 04:14:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F93BB80EA7;
        Mon, 13 Jun 2022 11:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BF5C34114;
        Mon, 13 Jun 2022 11:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118873;
        bh=P/nzK0UNFvAdOrbmeXLbhiCspT6Z32fGD2W+9m5or6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oowszK6QS+FxIuZEM/l//Ap6iAB4xEwPqiBE70eZTfuxom39C1P/3XL1tIiiXo76P
         wFKZFP4+8bSkSNx3rksZlJZCOJXFRREjdU2kV4jkzESnxmGHa4yYDdFAaR1i1caDrH
         z4PP0JXxMpw6VEXDTMVvtlhJfdc9Jp0ny1v8Yoew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/247] serial: sifive: Sanitize CSIZE and c_iflag
Date:   Mon, 13 Jun 2022 12:09:21 +0200
Message-Id: <20220613094924.747234519@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit c069d2756c01ed36121fae6a42c14fdf1325c71d ]

Only CS8 is supported but CSIZE was not sanitized to CS8.

Set CSIZE correctly so that userspace knows the effective value.
Incorrect CSIZE also results in miscalculation of the frame bits in
tty_get_char_size() or in its predecessor where the roughly the same
code is directly within uart_update_timeout().

Similarly, INPCK, PARMRK, and BRKINT are reported textually unsupported
but were not cleared in termios c_iflag which is the machine-readable
format.

Fixes: 45c054d0815b (tty: serial: add driver for the SiFive UART)
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220519081808.3776-7-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sifive.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index a579d46ed78c..4b0fa91e9f9a 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -666,12 +666,16 @@ static void sifive_serial_set_termios(struct uart_port *port,
 	int rate;
 	char nstop;
 
-	if ((termios->c_cflag & CSIZE) != CS8)
+	if ((termios->c_cflag & CSIZE) != CS8) {
 		dev_err_once(ssp->port.dev, "only 8-bit words supported\n");
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
+	}
 	if (termios->c_iflag & (INPCK | PARMRK))
 		dev_err_once(ssp->port.dev, "parity checking not supported\n");
 	if (termios->c_iflag & BRKINT)
 		dev_err_once(ssp->port.dev, "BREAK detection not supported\n");
+	termios->c_iflag &= ~(INPCK|PARMRK|BRKINT);
 
 	/* Set number of stop bits */
 	nstop = (termios->c_cflag & CSTOPB) ? 2 : 1;
-- 
2.35.1



