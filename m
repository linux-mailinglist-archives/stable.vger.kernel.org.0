Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC1A549683
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354275AbiFMLcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354426AbiFML33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:29:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154A8DE99;
        Mon, 13 Jun 2022 03:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A89046112A;
        Mon, 13 Jun 2022 10:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B305EC34114;
        Mon, 13 Jun 2022 10:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117064;
        bh=IAVbfGTRA6I43BJFnxsN8vzB8Joruj/IdTtsLWXc08Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Q0PJO2Henn1hYRd1rU1twCLXVx6Brh0uPkqdI/k49eoqoYQhlPiO09iUMZyE5NIa
         VJgIplcHSsRYyypmYONTyxlKdCVSEyN1SEY0xjS3EghRvqDKJ8j6WHdqkMX3DtEN2i
         wTqPLkRGkbfh9rjv7nVqZD+KcEB4Zc3+YzBMlE48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 285/411] tty: serial: owl: Fix missing clk_disable_unprepare() in owl_uart_probe
Date:   Mon, 13 Jun 2022 12:09:18 +0200
Message-Id: <20220613094937.304784853@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit bcea0f547ec1a2ee44d429aaf0334633e386e67c ]

Fix the missing clk_disable_unprepare() before return
from owl_uart_probe() in the error handling case.

Fixes: abf42d2f333b ("tty: serial: owl: add "much needed" clk_prepare_enable()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220307105135.11698-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/owl-uart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/owl-uart.c b/drivers/tty/serial/owl-uart.c
index c55c8507713c..e87953f8a768 100644
--- a/drivers/tty/serial/owl-uart.c
+++ b/drivers/tty/serial/owl-uart.c
@@ -695,6 +695,7 @@ static int owl_uart_probe(struct platform_device *pdev)
 	owl_port->port.uartclk = clk_get_rate(owl_port->clk);
 	if (owl_port->port.uartclk == 0) {
 		dev_err(&pdev->dev, "clock rate is zero\n");
+		clk_disable_unprepare(owl_port->clk);
 		return -EINVAL;
 	}
 	owl_port->port.flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP | UPF_LOW_LATENCY;
-- 
2.35.1



