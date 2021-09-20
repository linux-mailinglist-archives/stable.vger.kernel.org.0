Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2606B411F7E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352798AbhITRlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352557AbhITRjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29ACE6152A;
        Mon, 20 Sep 2021 17:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157674;
        bh=nmDD1Fm5wkT0WQQ0xdu0qiv3NE8y4txPDoEklNeqtcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Me7KCg9s1mPZVQYzsw2nxkn0miEOKIm1m11Y3KPfDVVYxH/u/a2bDSyEeaBiyj8af
         zfTnAgIeNH2rRiFWX/jt/ONHf09b4araKPAyVz6bXLnq5nFAFWJk0EseAP9Dispj8o
         1N7WsZMiHvLXc+oDuZFb9pf73p8hMi3zmwQbH2JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Adriana Reus <adriana.reus@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/293] tty: serial: fsl_lpuart: fix the wrong mapbase value
Date:   Mon, 20 Sep 2021 18:41:00 +0200
Message-Id: <20210920163936.615606367@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index deb9d4fa9cb0..b757fd1bdbfa 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2164,7 +2164,7 @@ static int lpuart_probe(struct platform_device *pdev)
 		return PTR_ERR(sport->port.membase);
 
 	sport->port.membase += sdata->reg_off;
-	sport->port.mapbase = res->start;
+	sport->port.mapbase = res->start + sdata->reg_off;
 	sport->port.dev = &pdev->dev;
 	sport->port.type = PORT_LPUART;
 	ret = platform_get_irq(pdev, 0);
-- 
2.30.2



