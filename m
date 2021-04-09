Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14609359A5F
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhDIJ6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233607AbhDIJ5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9666F61207;
        Fri,  9 Apr 2021 09:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962227;
        bh=f1Q9AGfcVv+toR9gzrUrSGsm72nuPO+uY1goqwm9C2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZyZ+gT6JsDRT1FKS+kd5Iy/ute4fv00DtxPXZEvBb8JHHnBNqNt+gfiX8WBpRJ86
         WOpT2Ur0U9beoXI19fWEnv/aMChLxYNqMQCt7D+qEq12ir9Zx2sp0CQ1keBDr9wyGm
         pnVZIBqoxvvym2j6j8GMYKBBcxe1JU0oWmbh/ZJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Andrianov <andrianov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/18] net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Date:   Fri,  9 Apr 2021 11:53:32 +0200
Message-Id: <20210409095301.672498371@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095301.525783608@linuxfoundation.org>
References: <20210409095301.525783608@linuxfoundation.org>
User-Agent: quilt/0.66
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
index ff2fea0f8b75..0d6a4e47e7a5 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1564,8 +1564,8 @@ static int pxa168_eth_remove(struct platform_device *pdev)
 
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



