Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB8037C3D0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhELPWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234656AbhELPUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3DE361444;
        Wed, 12 May 2021 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832094;
        bh=OHOzOBDV21nnOwDOWDSt1njwUBPU9OcEKDDqfLCjEPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ol7crF6f2r+2poLIN12rvSErsTGLfqSCBHMidQOLKBlAWD1F6EG8u+nClBR3zwh/Q
         8EJ6E+uzrJagCUS5IWqx69ryNmIciLKtXvVnWOur1DDkn6y/MZ2eqieVCga7R/FO88
         tWLW4sCW/xRvzxDU6MCl94E3ljlobGuDtL8ycvE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/530] serial: stm32: fix tx dma completion, release channel
Date:   Wed, 12 May 2021 16:44:08 +0200
Message-Id: <20210512144824.354025042@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 44522ddc7e6d..c2d87a8a8fe5 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -291,6 +291,7 @@ static void stm32_usart_tx_dma_complete(void *arg)
 	struct stm32_port *stm32port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32port->info->ofs;
 
+	dmaengine_terminate_async(stm32port->tx_ch);
 	stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
 	stm32port->tx_dma_busy = false;
 
-- 
2.30.2



