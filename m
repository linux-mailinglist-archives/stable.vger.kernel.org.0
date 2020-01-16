Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5EE13EE1E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394980AbgAPSHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:07:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388465AbgAPRjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15CD72470B;
        Thu, 16 Jan 2020 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196353;
        bh=UNs+FSMFE5y+swkCJ1aDB112pLnvBCrA4j+3vrVOtCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZNXl/mTbICGnk57ECMmoa+e89YNPWSo69iXneV793Fkq9LHrj48vQI2AW+iOMYhZ
         N8dcshzCQweula9DxQELodtl2LKRZO95cuMAXZRIsu9qiXuAJjKGCytM1P9AfnFDwi
         KRngyNJmxOBHXWPDTBTECTaYzVgnB9R7WDRf913A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erwan Le Ray <erwan.leray@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 146/251] serial: stm32: fix transmit_chars when tx is stopped
Date:   Thu, 16 Jan 2020 12:34:55 -0500
Message-Id: <20200116173641.22137-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@st.com>

[ Upstream commit b83b957c91f68e53f0dc596e129e8305761f2a32 ]

Disables the tx irq  when the transmission is ended and updates stop_tx
conditions for code cleanup.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Signed-off-by: Erwan Le Ray <erwan.leray@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 033856287ca2..ea8b591dd46f 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -293,13 +293,8 @@ static void stm32_transmit_chars(struct uart_port *port)
 		return;
 	}
 
-	if (uart_tx_stopped(port)) {
-		stm32_stop_tx(port);
-		return;
-	}
-
-	if (uart_circ_empty(xmit)) {
-		stm32_stop_tx(port);
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
+		stm32_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 		return;
 	}
 
@@ -312,7 +307,7 @@ static void stm32_transmit_chars(struct uart_port *port)
 		uart_write_wakeup(port);
 
 	if (uart_circ_empty(xmit))
-		stm32_stop_tx(port);
+		stm32_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
 static irqreturn_t stm32_interrupt(int irq, void *ptr)
-- 
2.20.1

