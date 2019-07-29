Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795B5795FD
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389990AbfG2Trf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390357AbfG2Trc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E92420C01;
        Mon, 29 Jul 2019 19:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429651;
        bh=MqF8HHLqzYEMhjxa/Iw6PcCVntom90MdjouzgeIFzrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rfcm+isbpG+Uzz/gE6CXrSNrO8B3pIEy/PneiZJUeBj/9aVoJOh8/yO3osJc1023H
         Jfl0dLafByIoLbvBn4JDcr+a7iwCWdqcGVcxI/ByshiqTaLAOjJIJHPVknkWummbfB
         xFUxUj1pqSri+gb6DCQmP2O6Q18fYWsy4M/zOcyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 051/215] tty: serial: msm_serial: avoid system lockup condition
Date:   Mon, 29 Jul 2019 21:20:47 +0200
Message-Id: <20190729190749.370988457@linuxfoundation.org>
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

[ Upstream commit ba3684f99f1b25d2a30b6956d02d339d7acb9799 ]

The function msm_wait_for_xmitr can be taken with interrupts
disabled. In order to avoid a potential system lockup - demonstrated
under stress testing conditions on SoC QCS404/5 - make sure we wait
for a bounded amount of time.

Tested on SoC QCS404.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/msm_serial.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 23833ad952ba..3657a24913fc 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -383,10 +383,14 @@ static void msm_request_rx_dma(struct msm_port *msm_port, resource_size_t base)
 
 static inline void msm_wait_for_xmitr(struct uart_port *port)
 {
+	unsigned int timeout = 500000;
+
 	while (!(msm_read(port, UART_SR) & UART_SR_TX_EMPTY)) {
 		if (msm_read(port, UART_ISR) & UART_ISR_TX_READY)
 			break;
 		udelay(1);
+		if (!timeout--)
+			break;
 	}
 	msm_write(port, UART_CR_CMD_RESET_TX_READY, UART_CR);
 }
-- 
2.20.1



