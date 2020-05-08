Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EE81CAEF4
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgEHNMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729674AbgEHMsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F1521473;
        Fri,  8 May 2020 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942111;
        bh=6sRp/ShxUWakFUSR0H/jKpiuBU3Tr1r1Q4kbnxQJHoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpLV5ODyNdsPyWNgddBb5mxlOHelZ6Y6JsdtCVCk4PTKsgwKX0k5nEr2qUb/klxVZ
         UsmSmO2zK5puMnPmuHXrAD23IOjIQpBNPZ1dChVMGYrWJSY3EjsVHvtZt+6i+Yr1Dt
         x8yHhCH4h0Rm8eZh975hPUTsYxNYMlafwR+YBOgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 274/312] net: axienet: Fix return value check in axienet_probe()
Date:   Fri,  8 May 2020 14:34:25 +0200
Message-Id: <20200508123143.701824736@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 3ad7b1477ef9b01988ac052b02be9cd410c95157 upstream.

In case of error, the function of_parse_phandle() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value
check should be replaced with NULL test.

Fixes: 46aa27df8853 ('net: axienet: Use devm_* calls')
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1602,9 +1602,9 @@ static int axienet_probe(struct platform
 
 	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
 	np = of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
-	if (IS_ERR(np)) {
+	if (!np) {
 		dev_err(&pdev->dev, "could not find DMA node\n");
-		ret = PTR_ERR(np);
+		ret = -ENODEV;
 		goto free_netdev;
 	}
 	ret = of_address_to_resource(np, 0, &dmares);


