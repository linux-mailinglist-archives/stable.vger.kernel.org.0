Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D749D13F4E2
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389416AbgAPSwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:52:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbgAPRI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3629C206D9;
        Thu, 16 Jan 2020 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194507;
        bh=FD8ZedaDnpHepCcE3/KmJTfI3S/G7ueYrQti2ixlsvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcsTXLbvAAnLNTVe6sXeVOOAM1U72oE23z5jLm+ewsuT6ilf4tP3FtJmIV699ZJyK
         acHVuK2KUaRbQCkwGdZO/OAfZ2Kg186h+e1ikvuQJwIcbViZzs1l9QZp8BaHhJgIG0
         MPQDCjUoC156p0Rk2LgnNKL7H929CFX18xGs6glU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borut Seljak <borut.seljak@t-2.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 402/671] serial: stm32: fix a recursive locking in stm32_config_rs485
Date:   Thu, 16 Jan 2020 12:00:40 -0500
Message-Id: <20200116170509.12787-139-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borut Seljak <borut.seljak@t-2.net>

[ Upstream commit 707aeea13a9c85520262e11899d86df3c4b48262 ]

Remove spin_lock_irqsave in stm32_config_rs485, it cause recursive locking.
Already locked in uart_set_rs485_config.

Fixes: 1bcda09d291081 ("serial: stm32: add support for RS485 hardware control mode")
Signed-off-by: Borut Seljak <borut.seljak@t-2.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 1334e4293977..d096e552176c 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -105,9 +105,7 @@ static int stm32_config_rs485(struct uart_port *port,
 	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	u32 usartdiv, baud, cr1, cr3;
 	bool over8;
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	stm32_clr_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
 
 	port->rs485 = *rs485conf;
@@ -147,7 +145,6 @@ static int stm32_config_rs485(struct uart_port *port,
 	}
 
 	stm32_set_bits(port, ofs->cr1, BIT(cfg->uart_enable_bit));
-	spin_unlock_irqrestore(&port->lock, flags);
 
 	return 0;
 }
-- 
2.20.1

