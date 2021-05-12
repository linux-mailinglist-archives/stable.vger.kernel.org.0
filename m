Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9151E37CBD0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhELQiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236255AbhELQ22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B994561288;
        Wed, 12 May 2021 15:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834998;
        bh=PzUYWI56G6/K4dFyKLi2bpIntv096eTA9x9mskYXUT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SERFvT4uMzAg02fDP0EwPAZ2WOm3KeDe5bAH/g3IVNdU2YaqYNdAAJw3xabpk7Qbz
         Cj+5eDuyKQZCmxyS51Du7S2qqbflKbrESjz0YEm6duPEwpfN1QQaU3lavEx610t808
         weVljZ5N+RlsLgmiMJrjB+iqLRo0+RN4C01kycAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 167/677] serial: stm32: fix tx dma completion, release channel
Date:   Wed, 12 May 2021 16:43:33 +0200
Message-Id: <20210512144842.795044055@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@foss.st.com>

[ Upstream commit fb4f2e04ac13e7c400e6b86afbbd314a5a2a7e8d ]

This patch add a proper release of dma channels when completing dma tx.

Fixes: 3489187204eb ("serial: stm32: adding dma support")
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Link: https://lore.kernel.org/r/20210304162308.8984-9-erwan.leray@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index a381ee52168a..74046ae3a412 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -292,6 +292,7 @@ static void stm32_usart_tx_dma_complete(void *arg)
 	struct stm32_port *stm32port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 
+	dmaengine_terminate_async(stm32port->tx_ch);
 	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 	stm32port->tx_dma_busy = false;
 
-- 
2.30.2



