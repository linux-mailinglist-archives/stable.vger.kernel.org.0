Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2765950CA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiHPEqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbiHPEpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:45:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52823F1DA;
        Mon, 15 Aug 2022 13:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D6D5B811A1;
        Mon, 15 Aug 2022 20:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85415C433D6;
        Mon, 15 Aug 2022 20:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596246;
        bh=+axC2UCXXYpHbsM2UCfs8sZhbdEsDfVjDNihD+9RBik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsca4kCRu6HoTiclY2OjnRWR2/9fudoaok9i/8I98Y1aY+S6SqXp2pA2R95AOoDu7
         odc/q6tp3YSUGSzdhquAiaS8xsHFz6p7eplGrmCc2cyhwekTyckiRYx4BTOAyLPqq5
         jJmh0Ad+XepHZzn4mX+tQkESpjWQMIbzov4AD3JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1019/1157] tty: serial: qcom-geni-serial: Fix %lu -> %u in print statements
Date:   Mon, 15 Aug 2022 20:06:15 +0200
Message-Id: <20220815180520.663487574@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 0fec518018cc5ceffa706370b6e3acbbb1e3c798 ]

When we multiply an unsigned int by a u32 we still end up with an
unsigned int. That means we should specify "%u" not "%lu" in the
format code.

NOTE: this fix was chosen instead of somehow promoting the value to
"unsigned long" since the max baud rate from the earlier call to
uart_get_baud_rate() is 4000000 and the max sampling rate is 32.
4000000 * 32 = 0x07a12000, not even close to overflowing 32-bits.

Fixes: c474c775716e ("tty: serial: qcom-geni-serial: Fix get_clk_div_rate() which otherwise could return a sub-optimal clock rate.")
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220802132250.1.Iea061e14157a17e114dbe2eca764568a02d6b889@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index f754619451dc..f7c1f1807040 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1033,12 +1033,12 @@ static void qcom_geni_serial_set_termios(struct uart_port *uport,
 		sampling_rate, &clk_div);
 	if (!clk_rate) {
 		dev_err(port->se.dev,
-			"Couldn't find suitable clock rate for %lu\n",
+			"Couldn't find suitable clock rate for %u\n",
 			baud * sampling_rate);
 		goto out_restart_rx;
 	}
 
-	dev_dbg(port->se.dev, "desired_rate-%lu, clk_rate-%lu, clk_div-%u\n",
+	dev_dbg(port->se.dev, "desired_rate-%u, clk_rate-%lu, clk_div-%u\n",
 			baud * sampling_rate, clk_rate, clk_div);
 
 	uport->uartclk = clk_rate;
-- 
2.35.1



