Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBDA795BF
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbfG2Tpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbfG2Tpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 619902054F;
        Mon, 29 Jul 2019 19:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429530;
        bh=TnkhYFdG64j3M4QTR20C6tS2fGS0G482Y1I7WB6kNGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3zgFaG7H2eg/maDl60gi+N1v7+wLj/HBa+lymFMMuftSo8/O9zEn5CJlVEJIEhhm
         lAsh5VN9ePKje3FvNoHHeiEGOm1y2n/NtYQTjRozOfoYEsRE6BVOat3EGR4qdHje0r
         uTkX0N7ovGrNWDSiSM/rLDSVHF1xf22vIUaB6XcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 014/215] tty: max310x: Fix invalid baudrate divisors calculator
Date:   Mon, 29 Jul 2019 21:20:10 +0200
Message-Id: <20190729190741.948556157@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 35240ba26a932b279a513f66fa4cabfd7af55221 ]

Current calculator doesn't do it' job quite correct. First of all the
max310x baud-rates generator supports the divisor being less than 16.
In this case the x2/x4 modes can be used to double or quadruple
the reference frequency. But the current baud-rate setter function
just filters all these modes out by the first condition and setups
these modes only if there is a clocks-baud division remainder. The former
doesn't seem right at all, since enabling the x2/x4 modes causes the line
noise tolerance reduction and should be only used as a last resort to
enable a requested too high baud-rate.

Finally the fraction is supposed to be calculated from D = Fref/(c*baud)
formulae, but not from D % 16, which causes the precision loss. So to speak
the current baud-rate calculator code works well only if the baud perfectly
fits to the uart reference input frequency.

Lets fix the calculator by implementing the algo fully compliant with
the fractional baud-rate generator described in the datasheet:
D = Fref / (c*baud), where c={16,8,4} is the x1/x2/x4 rate mode
respectively, Fref - reference input frequency. The divisor fraction is
calculated from the same formulae, but making sure it is found with a
resolution of 0.0625 (four bits).

Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 51 ++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index e5aebbf5f302..c3afd128b8fc 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -496,37 +496,48 @@ static bool max310x_reg_precious(struct device *dev, unsigned int reg)
 
 static int max310x_set_baud(struct uart_port *port, int baud)
 {
-	unsigned int mode = 0, clk = port->uartclk, div = clk / baud;
+	unsigned int mode = 0, div = 0, frac = 0, c = 0, F = 0;
 
-	/* Check for minimal value for divider */
-	if (div < 16)
-		div = 16;
-
-	if (clk % baud && (div / 16) < 0x8000) {
+	/*
+	 * Calculate the integer divisor first. Select a proper mode
+	 * in case if the requested baud is too high for the pre-defined
+	 * clocks frequency.
+	 */
+	div = port->uartclk / baud;
+	if (div < 8) {
+		/* Mode x4 */
+		c = 4;
+		mode = MAX310X_BRGCFG_4XMODE_BIT;
+	} else if (div < 16) {
 		/* Mode x2 */
+		c = 8;
 		mode = MAX310X_BRGCFG_2XMODE_BIT;
-		clk = port->uartclk * 2;
-		div = clk / baud;
-
-		if (clk % baud && (div / 16) < 0x8000) {
-			/* Mode x4 */
-			mode = MAX310X_BRGCFG_4XMODE_BIT;
-			clk = port->uartclk * 4;
-			div = clk / baud;
-		}
+	} else {
+		c = 16;
 	}
 
-	max310x_port_write(port, MAX310X_BRGDIVMSB_REG, (div / 16) >> 8);
-	max310x_port_write(port, MAX310X_BRGDIVLSB_REG, div / 16);
-	max310x_port_write(port, MAX310X_BRGCFG_REG, (div % 16) | mode);
+	/* Calculate the divisor in accordance with the fraction coefficient */
+	div /= c;
+	F = c*baud;
+
+	/* Calculate the baud rate fraction */
+	if (div > 0)
+		frac = (16*(port->uartclk % F)) / F;
+	else
+		div = 1;
+
+	max310x_port_write(port, MAX310X_BRGDIVMSB_REG, div >> 8);
+	max310x_port_write(port, MAX310X_BRGDIVLSB_REG, div);
+	max310x_port_write(port, MAX310X_BRGCFG_REG, frac | mode);
 
-	return DIV_ROUND_CLOSEST(clk, div);
+	/* Return the actual baud rate we just programmed */
+	return (16*port->uartclk) / (c*(16*div + frac));
 }
 
 static int max310x_update_best_err(unsigned long f, long *besterr)
 {
 	/* Use baudrate 115200 for calculate error */
-	long err = f % (115200 * 16);
+	long err = f % (460800 * 16);
 
 	if ((*besterr < 0) || (*besterr > err)) {
 		*besterr = err;
-- 
2.20.1



