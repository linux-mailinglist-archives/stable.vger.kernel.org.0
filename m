Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9D126C47
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfLSSst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:48:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbfLSSss (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:48:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D0FC24683;
        Thu, 19 Dec 2019 18:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781327;
        bh=Ph09qFfmaBHHIt4pNk55ghnUGqDVXfldIT3+1xaUYjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+CPpPa+dI0UrwLuQKDsyPpUlSsdYuCvsUtQ+BmJf0owYMTzPKBteEyxqZ+tXDUZT
         2iLG/vrgIw2ZixfM353p4cgDBgJiAkKvgrlCk6pMDSemLcl68AWRX+c+uPwZuy8oPo
         FxAmUyhwd2IzweT6SfdO0IN9Yqqo831R25z7s41Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 177/199] net: ethernet: ti: cpsw: fix extra rx interrupt
Date:   Thu, 19 Dec 2019 19:34:19 +0100
Message-Id: <20191219183225.379351583@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 51302f77bedab8768b761ed1899c08f89af9e4e2 ]

Now RX interrupt is triggered twice every time, because in
cpsw_rx_interrupt() it is asked first and then disabled. So there will be
pending interrupt always, when RX interrupt is enabled again in NAPI
handler.

Fix it by first disabling IRQ and then do ask.

Fixes: 870915feabdc ("drivers: net: cpsw: remove disable_irq/enable_irq as irq can be masked from cpsw itself")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -773,8 +773,8 @@ static irqreturn_t cpsw_rx_interrupt(int
 {
 	struct cpsw_common *cpsw = dev_id;
 
-	cpdma_ctlr_eoi(cpsw->dma, CPDMA_EOI_RX);
 	writel(0, &cpsw->wr_regs->rx_en);
+	cpdma_ctlr_eoi(cpsw->dma, CPDMA_EOI_RX);
 
 	if (cpsw->quirk_irq) {
 		disable_irq_nosync(cpsw->irqs_table[0]);


