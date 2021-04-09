Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E133599E2
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhDIJyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhDIJyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F06C6115B;
        Fri,  9 Apr 2021 09:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962065;
        bh=ebCKY1BXUY81DgOIs4B+9aAjjhqc6Cnm7oJ/bZ/NAdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfIVBA4bOUssxX2PsDljGXjZu/FhgXzUfFObyKQZdy4EaPgJTruiTo0oEjI8ASJiY
         64anU3gEsscfc+BYZIBWA+xSJCcXyeRa40wLKvcCok8JLPFY+HmMrgVK34zd/vGzFN
         YbqG7YkT1z2x6J1I+AZmuspTlum2Kku2/KUULaJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Andrianov <andrianov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/20] net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Date:   Fri,  9 Apr 2021 11:53:07 +0200
Message-Id: <20210409095300.004646193@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095259.957388690@linuxfoundation.org>
References: <20210409095259.957388690@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Andrianov <andrianov@ispras.ru>

[ Upstream commit 0571a753cb07982cc82f4a5115e0b321da89e1f3 ]

pxa168_eth_remove() firstly calls unregister_netdev(),
then cancels a timeout work. unregister_netdev() shuts down a device
interface and removes it from the kernel tables. If the timeout occurs
in parallel, the timeout work (pxa168_eth_tx_timeout_task) performs stop
and open of the device. It may lead to an inconsistent state and memory
leaks.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Pavel Andrianov <andrianov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 7ace07dad6a3..9986f88618bd 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1577,8 +1577,8 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
-	unregister_netdev(dev);
 	cancel_work_sync(&pep->tx_timeout_task);
+	unregister_netdev(dev);
 	free_netdev(dev);
 	return 0;
 }
-- 
2.30.2



