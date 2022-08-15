Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2567B595128
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiHPEt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiHPErl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:47:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3419B07C2;
        Mon, 15 Aug 2022 13:43:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF88860F60;
        Mon, 15 Aug 2022 20:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D9DC433C1;
        Mon, 15 Aug 2022 20:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596198;
        bh=8h8eRryY+Nlcy5QakMX7qwQudFKSukdR+46jHwLhkvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQHMQWAMLFVhqExyA1393Fe1KH/uIrirAmcYGKhRsCVVYNT1tIzBk1vcfb4CFcWVj
         QMlYylzR5zgKgjrsm1FIgx6YzmGJOCEHnSo7h4qcnF/S7SectZ0+u2HwEZ3TclQWPi
         gqujlRYKtKO2HRzFZqv7nWzwaXOm9dU5XawrPLnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1002/1157] tty: serial: qcom-geni-serial: Fix get_clk_div_rate() which otherwise could return a sub-optimal clock rate.
Date:   Mon, 15 Aug 2022 20:05:58 +0200
Message-Id: <20220815180519.873396149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>

[ Upstream commit c474c775716edd46a51bf8161142bbd1545f8733 ]

In the logic around call to clk_round_rate(), for some corner conditions,
get_clk_div_rate() could return an sub-optimal clock rate. Also, if an
exact clock rate was not found lowest clock was being returned.

Search for suitable clock rate in 2 steps
a) exact match or within 2% tolerance
b) within 5% tolerance
This also takes care of corner conditions.

Fixes: c2194bc999d4 ("tty: serial: qcom-geni-serial: Remove uart frequency table. Instead, find suitable frequency with call to clk_round_rate")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>
Link: https://lore.kernel.org/r/1657911343-1909-1-git-send-email-quic_vnivarth@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 88 ++++++++++++++++-----------
 1 file changed, 53 insertions(+), 35 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index f8f950641ad9..f754619451dc 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -940,52 +940,63 @@ static int qcom_geni_serial_startup(struct uart_port *uport)
 	return 0;
 }
 
-static unsigned long get_clk_div_rate(struct clk *clk, unsigned int baud,
-			unsigned int sampling_rate, unsigned int *clk_div)
+static unsigned long find_clk_rate_in_tol(struct clk *clk, unsigned int desired_clk,
+			unsigned int *clk_div, unsigned int percent_tol)
 {
-	unsigned long ser_clk;
-	unsigned long desired_clk;
-	unsigned long freq, prev;
+	unsigned long freq;
 	unsigned long div, maxdiv;
-	int64_t mult;
-
-	desired_clk = baud * sampling_rate;
-	if (!desired_clk) {
-		pr_err("%s: Invalid frequency\n", __func__);
-		return 0;
-	}
+	u64 mult;
+	unsigned long offset, abs_tol, achieved;
 
+	abs_tol = div_u64((u64)desired_clk * percent_tol, 100);
 	maxdiv = CLK_DIV_MSK >> CLK_DIV_SHFT;
-	prev = 0;
-
-	for (div = 1; div <= maxdiv; div++) {
-		mult = div * desired_clk;
-		if (mult > ULONG_MAX)
+	div = 1;
+	while (div <= maxdiv) {
+		mult = (u64)div * desired_clk;
+		if (mult != (unsigned long)mult)
 			break;
 
-		freq = clk_round_rate(clk, (unsigned long)mult);
-		if (!(freq % desired_clk)) {
-			ser_clk = freq;
-			break;
-		}
+		offset = div * abs_tol;
+		freq = clk_round_rate(clk, mult - offset);
 
-		if (!prev)
-			ser_clk = freq;
-		else if (prev == freq)
+		/* Can only get lower if we're done */
+		if (freq < mult - offset)
 			break;
 
-		prev = freq;
-	}
+		/*
+		 * Re-calculate div in case rounding skipped rates but we
+		 * ended up at a good one, then check for a match.
+		 */
+		div = DIV_ROUND_CLOSEST(freq, desired_clk);
+		achieved = DIV_ROUND_CLOSEST(freq, div);
+		if (achieved <= desired_clk + abs_tol &&
+		    achieved >= desired_clk - abs_tol) {
+			*clk_div = div;
+			return freq;
+		}
 
-	if (!ser_clk) {
-		pr_err("%s: Can't find matching DFS entry for baud %d\n",
-								__func__, baud);
-		return ser_clk;
+		div = DIV_ROUND_UP(freq, desired_clk);
 	}
 
-	*clk_div = ser_clk / desired_clk;
-	if (!(*clk_div))
-		*clk_div = 1;
+	return 0;
+}
+
+static unsigned long get_clk_div_rate(struct clk *clk, unsigned int baud,
+			unsigned int sampling_rate, unsigned int *clk_div)
+{
+	unsigned long ser_clk;
+	unsigned long desired_clk;
+
+	desired_clk = baud * sampling_rate;
+	if (!desired_clk)
+		return 0;
+
+	/*
+	 * try to find a clock rate within 2% tolerance, then within 5%
+	 */
+	ser_clk = find_clk_rate_in_tol(clk, desired_clk, clk_div, 2);
+	if (!ser_clk)
+		ser_clk = find_clk_rate_in_tol(clk, desired_clk, clk_div, 5);
 
 	return ser_clk;
 }
@@ -1020,8 +1031,15 @@ static void qcom_geni_serial_set_termios(struct uart_port *uport,
 
 	clk_rate = get_clk_div_rate(port->se.clk, baud,
 		sampling_rate, &clk_div);
-	if (!clk_rate)
+	if (!clk_rate) {
+		dev_err(port->se.dev,
+			"Couldn't find suitable clock rate for %lu\n",
+			baud * sampling_rate);
 		goto out_restart_rx;
+	}
+
+	dev_dbg(port->se.dev, "desired_rate-%lu, clk_rate-%lu, clk_div-%u\n",
+			baud * sampling_rate, clk_rate, clk_div);
 
 	uport->uartclk = clk_rate;
 	dev_pm_opp_set_rate(uport->dev, clk_rate);
-- 
2.35.1



