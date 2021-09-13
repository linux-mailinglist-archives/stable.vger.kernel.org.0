Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56165408FD3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243820AbhIMNqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243683AbhIMNov (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:44:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89C1561526;
        Mon, 13 Sep 2021 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539877;
        bh=6C5AL6c/MmRnBi3WIrw+eU+bK3WDGbJgxK76cPrBuN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc6elvWuA2fF4bng2hw4St0b1VV5PgD86/huigqF2VlS93RXnuOvGT6hcsw3Didta
         i3YwLl4pZlm+SAPzCkVm2rsLRR+EWaHAfpECQMppOyij60Q+eDiRcsto2fO32xGfay
         Io62hkJvweYn/B/XBH4W3UHb2dyk1g/0DaSm4JJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Adriana Reus <adriana.reus@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/236] tty: serial: fsl_lpuart: fix the wrong mapbase value
Date:   Mon, 13 Sep 2021 15:15:01 +0200
Message-Id: <20210913131107.052058301@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>

[ Upstream commit d5c38948448abc2bb6b36dbf85a554bf4748885e ]

Register offset needs to be applied on mapbase also.
dma_tx/rx_request use the physical address of UARTDATA.
Register offset is currently only applied to membase (the
corresponding virtual addr) but not on mapbase.

Fixes: 24b1e5f0e83c ("tty: serial: lpuart: add imx7ulp support")
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Adriana Reus <adriana.reus@nxp.com>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Andy Duan <fugang.duan@nxp.com>
Link: https://lore.kernel.org/r/20210819021033.32606-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 2e74c88808db..a70911a227a8 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2597,7 +2597,7 @@ static int lpuart_probe(struct platform_device *pdev)
 		return PTR_ERR(sport->port.membase);
 
 	sport->port.membase += sdata->reg_off;
-	sport->port.mapbase = res->start;
+	sport->port.mapbase = res->start + sdata->reg_off;
 	sport->port.dev = &pdev->dev;
 	sport->port.type = PORT_LPUART;
 	sport->devtype = sdata->devtype;
-- 
2.30.2



