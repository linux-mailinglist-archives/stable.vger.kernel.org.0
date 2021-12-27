Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC24747FFA5
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbhL0Pj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238919AbhL0Phx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:37:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA63AC06175A;
        Mon, 27 Dec 2021 07:37:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 551D1610A3;
        Mon, 27 Dec 2021 15:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFE3C36AE7;
        Mon, 27 Dec 2021 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619440;
        bh=jZ82D7RXYUwTmSX0ujpm6XMyh3lTYbhmZtKWj3pDSZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8BLpy42yB63P8N9pyeY7iXJUhxy6qAc0Di/UmtJVvT3nWI3zmAIlWLXe4qHs+vdp
         lfL+y7GMmwH+n7/4ZhyryImiherXX2vYOUvwibzJKCY20aDJYHdaU80bYrmZEeIak5
         Sc1ZXTwCn8ctJC3B5n4joplqjgKDTZHgcRv3FM6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/76] drivers: net: smc911x: Check for error irq
Date:   Mon, 27 Dec 2021 16:30:39 +0100
Message-Id: <20211227151325.531314695@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit cb93b3e11d405f20a405a07482d01147ef4934a3 ]

Because platform_get_irq() could fail and return error irq.
Therefore, it might be better to check it if order to avoid the use of
error irq.

Fixes: ae150435b59e ("smsc: Move the SMC (SMSC) drivers")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smc911x.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 01069dfaf75c9..288b420f88d42 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -2069,6 +2069,11 @@ static int smc911x_drv_probe(struct platform_device *pdev)
 
 	ndev->dma = (unsigned char)-1;
 	ndev->irq = platform_get_irq(pdev, 0);
+	if (ndev->irq < 0) {
+		ret = ndev->irq;
+		goto release_both;
+	}
+
 	lp = netdev_priv(ndev);
 	lp->netdev = ndev;
 #ifdef SMC_DYNAMIC_BUS_CONFIG
-- 
2.34.1



