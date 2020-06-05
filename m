Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4801EFAA2
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgFEOTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbgFEOTX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:19:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 247FC2086A;
        Fri,  5 Jun 2020 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366762;
        bh=8bC9I4a/4Z40qQbMuok38AUGb7l9vCZ1XVVilCGKiE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecJwKYIVlJAyUIzZIAMNxUc71fjSLLIyE9lbtYvEw7vxbONzgSeDX6F2OW49QpGcF
         KLUFuBz5yuR/c6WyNpZX9bm8aVt+3EPQHl8OJHsLylAnW0oaDi/fudbbfqRUn+vaL5
         0si24Ie7BDFHoU0TA+uelyMYAIrQms7mwgweJSGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/38] net: smsc911x: Fix runtime PM imbalance on error
Date:   Fri,  5 Jun 2020 16:15:21 +0200
Message-Id: <20200605140255.084830284@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 539d39ad0c61b35f69565a037d7586deaf6d6166 ]

Remove runtime PM usage counter decrement when the
increment function has not been called to keep the
counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smsc911x.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 38068fc34141..c7bdada4d1b9 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2502,20 +2502,20 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
 
 	retval = smsc911x_init(dev);
 	if (retval < 0)
-		goto out_disable_resources;
+		goto out_init_fail;
 
 	netif_carrier_off(dev);
 
 	retval = smsc911x_mii_init(pdev, dev);
 	if (retval) {
 		SMSC_WARN(pdata, probe, "Error %i initialising mii", retval);
-		goto out_disable_resources;
+		goto out_init_fail;
 	}
 
 	retval = register_netdev(dev);
 	if (retval) {
 		SMSC_WARN(pdata, probe, "Error %i registering device", retval);
-		goto out_disable_resources;
+		goto out_init_fail;
 	} else {
 		SMSC_TRACE(pdata, probe,
 			   "Network interface: \"%s\"", dev->name);
@@ -2556,9 +2556,10 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
 
 	return 0;
 
-out_disable_resources:
+out_init_fail:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+out_disable_resources:
 	(void)smsc911x_disable_resources(pdev);
 out_enable_resources_fail:
 	smsc911x_free_resources(pdev);
-- 
2.25.1



