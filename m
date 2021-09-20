Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD15411DA2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343775AbhITRWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347061AbhITRRf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:17:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 721F561A0A;
        Mon, 20 Sep 2021 16:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157165;
        bh=xT/UEm68U9gaQpYZ6KneUJvsLB3QODEWq5LuFfdQmyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqvuTG8rHSyquIYlPG3hDhuO/rl3L87Kmdc60vftPWjKKlrPTCX/k4l8H4qkmtAR+
         FmbxrwIgoNexKm9QV+Yiw7O9aq3RIsvcGtx3xIa8BYXr3560UbuRF0O6H/sFPXq7Wn
         c13INk4TpHRH79AmJwfI4LfnyTD/SntOXA44/THI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Adriana Reus <adriana.reus@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/217] tty: serial: fsl_lpuart: fix the wrong mapbase value
Date:   Mon, 20 Sep 2021 18:41:45 +0200
Message-Id: <20210920163927.484903996@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index 3d5fe53988e5..62d1e4607912 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2170,7 +2170,7 @@ static int lpuart_probe(struct platform_device *pdev)
 		return PTR_ERR(sport->port.membase);
 
 	sport->port.membase += sdata->reg_off;
-	sport->port.mapbase = res->start;
+	sport->port.mapbase = res->start + sdata->reg_off;
 	sport->port.dev = &pdev->dev;
 	sport->port.type = PORT_LPUART;
 	ret = platform_get_irq(pdev, 0);
-- 
2.30.2



