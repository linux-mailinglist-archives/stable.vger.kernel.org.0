Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682D1603EE4
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiJSJWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiJSJVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:21:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F3E4F38E;
        Wed, 19 Oct 2022 02:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A34617E3;
        Wed, 19 Oct 2022 09:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A475C433D7;
        Wed, 19 Oct 2022 09:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170091;
        bh=c0R0Pqk7vm5nMDDXB0fP+xSWuyXvMdhOLlZ3l/PnEKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+JaT81rQTqEfTU1y/587uBieJf6NmrOvBRVA+30WmZBT3x3lxdwoA3JCgjPV0ZrB
         8uAdrUMANFvRqr5e0wFrMgrzdRRZ/Ytb04ORuK5AHqZKXw05qWHWGoipngrNCLHj7l
         +ML/6gZLrwK0hxHoexLCCA2Sp0x+QwGCr4yT9RTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 487/862] tty: xilinx_uartps: Check clk_enable return value
Date:   Wed, 19 Oct 2022 10:29:34 +0200
Message-Id: <20221019083311.500145609@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

[ Upstream commit 957e8c047bf25bd24271ab049f06dc47f382973f ]

If clocks are not enabled the register access may hang the system.
Check for the clock enable return value and bail out if not enabled.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://lore.kernel.org/r/20220729114748.18332-2-shubhrajyoti.datta@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b8a6c3b3d465 ("tty: xilinx_uartps: Fix the ignore_status")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/xilinx_uartps.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 9e01fe6c0ab8..51fd09e14eda 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1329,12 +1329,20 @@ static int cdns_uart_resume(struct device *device)
 	unsigned long flags;
 	u32 ctrl_reg;
 	int may_wake;
+	int ret;
 
 	may_wake = device_may_wakeup(device);
 
 	if (console_suspend_enabled && uart_console(port) && !may_wake) {
-		clk_enable(cdns_uart->pclk);
-		clk_enable(cdns_uart->uartclk);
+		ret = clk_enable(cdns_uart->pclk);
+		if (ret)
+			return ret;
+
+		ret = clk_enable(cdns_uart->uartclk);
+		if (ret) {
+			clk_disable(cdns_uart->pclk);
+			return ret;
+		}
 
 		spin_lock_irqsave(&port->lock, flags);
 
-- 
2.35.1



