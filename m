Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1B9548803
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354888AbiFMMzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357911AbiFMMys (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:54:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A494D35242;
        Mon, 13 Jun 2022 04:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4178860B60;
        Mon, 13 Jun 2022 11:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54065C3411C;
        Mon, 13 Jun 2022 11:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118815;
        bh=J5SFK+pRZRZW0WBYohQfCLZMxVO9JONEq/gjKiUdi8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEebamtGSfnut1XeWL3vSxvBCL+APltZzhoYkm+1gqMGFfOcHo9wFdHN4H0jkwGE/
         lqSOxkoWn/bz5V2RW6v2EM7gY0ofcqAgPIx9eqOUnSN+ssPTUk/zuzDHvKyqj3n8yX
         gvuMYlhDxd2j+YA0GfSrNsP5ccI14lJd3Ep0gDkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/247] serial: sifive: Report actual baud base rather than fixed 115200
Date:   Mon, 13 Jun 2022 12:08:59 +0200
Message-Id: <20220613094924.067072485@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 0a7ff843d507ce2cca2c3b7e169ee56e28133530 ]

The base baud value reported is supposed to be the highest baud rate
that can be set for a serial port.  The SiFive FU740-C000 SOC's on-chip
UART supports baud rates of up to 1/16 of the input clock rate, which is
the bus clock `tlclk'[1], often at 130MHz in the case of the HiFive
Unmatched board.

However the sifive UART driver reports a fixed value of 115200 instead:

10010000.serial: ttySIF0 at MMIO 0x10010000 (irq = 1, base_baud = 115200) is a SiFive UART v0
10011000.serial: ttySIF1 at MMIO 0x10011000 (irq = 2, base_baud = 115200) is a SiFive UART v0

even though we already support setting higher baud rates, e.g.:

$ tty
/dev/ttySIF1
$ stty speed
230400

The baud base value is computed by the serial core by dividing the UART
clock recorded in `struct uart_port' by 16, which is also the minimum
value of the clock divider supported, so correct the baud base value
reported by setting the UART clock recorded to the input clock rate
rather than 115200:

10010000.serial: ttySIF0 at MMIO 0x10010000 (irq = 1, base_baud = 8125000) is a SiFive UART v0
10011000.serial: ttySIF1 at MMIO 0x10011000 (irq = 2, base_baud = 8125000) is a SiFive UART v0


[1] "SiFive FU740-C000 Manual", v1p3, SiFive, Inc., August 13, 2021,
    Section 16.9 "Baud Rate Divisor Register (div)", pp.143-144

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 1f1496a923b6 ("riscv: Fix sifive serial driver")
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2204291656280.9383@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sifive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index 0ac0371f943b..a579d46ed78c 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -998,7 +998,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	/* Set up clock divider */
 	ssp->clkin_rate = clk_get_rate(ssp->clk);
 	ssp->baud_rate = SIFIVE_DEFAULT_BAUD_RATE;
-	ssp->port.uartclk = ssp->baud_rate * 16;
+	ssp->port.uartclk = ssp->clkin_rate;
 	__ssp_update_div(ssp);
 
 	platform_set_drvdata(pdev, ssp);
-- 
2.35.1



