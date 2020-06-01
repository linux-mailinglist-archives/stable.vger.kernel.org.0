Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5C1EAB04
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbgFASNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731355AbgFASNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:13:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95BA82065C;
        Mon,  1 Jun 2020 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035211;
        bh=8mKFo4m2KfwjD/OA2OEZB0dylCL7xLNhx9szY9d4FiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skf4BTxetjhrCLst7fX6fOeWgTAJKVyx0vhIOJwBes9ACuN3G876+kbUx1ugrhDaE
         iL2NKX7I4zLoYQ3QLigJaDcuvXpO4ChM/ymgtlZeNujoGTxEzGS2RTH9uB/JC+WSV7
         vrq25B37DQfjM1wlJKHU1kg0fmUufz7jlFJyY4r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 041/177] net: sgi: ioc3-eth: Fix return value check in ioc3eth_probe()
Date:   Mon,  1 Jun 2020 19:52:59 +0200
Message-Id: <20200601174052.432605014@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

commit a7654211d0ffeaa8eb0545ea00f8445242cbce05 upstream.

In the function devm_platform_ioremap_resource(), if get resource
failed, the return value is ERR_PTR() not NULL. Thus it must be
replaced by IS_ERR(), or else it may result in crashes if a critical
error path is encountered.

Fixes: 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip")
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/sgi/ioc3-eth.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -865,14 +865,14 @@ static int ioc3eth_probe(struct platform
 	ip = netdev_priv(dev);
 	ip->dma_dev = pdev->dev.parent;
 	ip->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (!ip->regs) {
-		err = -ENOMEM;
+	if (IS_ERR(ip->regs)) {
+		err = PTR_ERR(ip->regs);
 		goto out_free;
 	}
 
 	ip->ssram = devm_platform_ioremap_resource(pdev, 1);
-	if (!ip->ssram) {
-		err = -ENOMEM;
+	if (IS_ERR(ip->ssram)) {
+		err = PTR_ERR(ip->ssram);
 		goto out_free;
 	}
 


