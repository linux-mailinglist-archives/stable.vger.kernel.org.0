Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2736F480034
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbhL0Pnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:43:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40994 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbhL0Pln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1554D61113;
        Mon, 27 Dec 2021 15:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0BEC36AEA;
        Mon, 27 Dec 2021 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619702;
        bh=72nJ8rouFggmvVSzO12hdWTiOkFhyr/4h4WyEXURU+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hr0J+KsrFV2hQfCnGbIeFUyQcopvNXT9TkTfy62NVy5RoZZKA2nAZBAYrNO2IUdZS
         gYnjTNNnf9Ea4BSWlsBMNaPkP3HS/OTsSjZ78+jCa8jX3jilET+SkA5varP1UzePO0
         +LOumw/QfisLEYHzZ1MzSRgCsgmDr/YvUghs/gGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/128] net: ks8851: Check for error irq
Date:   Mon, 27 Dec 2021 16:30:14 +0100
Message-Id: <20211227151332.831280217@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 99d7fbb5cedf598f67e8be106d6c7b8d91366aef ]

Because platform_get_irq() could fail and return error irq.
Therefore, it might be better to check it if order to avoid the use of
error irq.

Fixes: 797047f875b5 ("net: ks8851: Implement Parallel bus operations")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8851_par.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
index 2e8fcce50f9d1..c6f517c07bb9a 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -321,6 +321,8 @@ static int ks8851_probe_par(struct platform_device *pdev)
 		return ret;
 
 	netdev->irq = platform_get_irq(pdev, 0);
+	if (netdev->irq < 0)
+		return netdev->irq;
 
 	return ks8851_probe_common(netdev, dev, msg_enable);
 }
-- 
2.34.1



