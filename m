Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5358A408DE4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbhIMNad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241269AbhIMNXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:23:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 230CC604DA;
        Mon, 13 Sep 2021 13:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539293;
        bh=2Yu2URnTwuahz5+Qhb1hOD8ZAuqv3NuPCXnogSxZdUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdkKDU0HEtA7KtGZhOgjttG44wr2gDL95KUdpQsmGHSa2F3/p6lb89R877yOx52YO
         38w3Wi9VhSpfmLL7Hty6kRpZ45tO1T03c8e6lTAlTF8Bbuafw65WIEW/qPN5g/S+5q
         41C4URst0BTx5GmhGP1GM5uujOLuuim6SEuJmFfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Adriana Reus <adriana.reus@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/144] tty: serial: fsl_lpuart: fix the wrong mapbase value
Date:   Mon, 13 Sep 2021 15:14:55 +0200
Message-Id: <20210913131051.746782973@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index b053345dfd1a..13e705b53217 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2414,7 +2414,7 @@ static int lpuart_probe(struct platform_device *pdev)
 		return PTR_ERR(sport->port.membase);
 
 	sport->port.membase += sdata->reg_off;
-	sport->port.mapbase = res->start;
+	sport->port.mapbase = res->start + sdata->reg_off;
 	sport->port.dev = &pdev->dev;
 	sport->port.type = PORT_LPUART;
 	sport->devtype = sdata->devtype;
-- 
2.30.2



