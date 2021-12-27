Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7273247FF9B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhL0PjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:39:08 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41030 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238723AbhL0Ph0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:37:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 22F19CE10AF;
        Mon, 27 Dec 2021 15:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E89C36AE7;
        Mon, 27 Dec 2021 15:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619443;
        bh=WeGlJ3NOkYaQlfqTvogg5A1jCTf9BRLYQ21K42mI3hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjcZMB01vQWGfop/v55MmiuWh9sgmDdiI8r1OeKguWUTj2elcAlXDd+DzxH+aFr7c
         aDozbPE6kwfqUFTkBeFWgLj2y/9jF16nWTw9vj6esgnuJZm8kTdVwofwXwZNXjR9BQ
         W2Rf2AE9LJu4qh4x2Fe9wABdfG1Z/RfcaW11T9gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/76] net: ks8851: Check for error irq
Date:   Mon, 27 Dec 2021 16:30:40 +0100
Message-Id: <20211227151325.564034445@linuxfoundation.org>
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
index 3bab0cb2b1a56..c7c99cc54ca11 100644
--- a/drivers/net/ethernet/micrel/ks8851_par.c
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -323,6 +323,8 @@ static int ks8851_probe_par(struct platform_device *pdev)
 		return ret;
 
 	netdev->irq = platform_get_irq(pdev, 0);
+	if (netdev->irq < 0)
+		return netdev->irq;
 
 	return ks8851_probe_common(netdev, dev, msg_enable);
 }
-- 
2.34.1



