Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDFB261947
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbgIHSMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731487AbgIHQLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86E1A24804;
        Tue,  8 Sep 2020 15:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579792;
        bh=qyEMB8r3tiEAuqTUSGSgpNUdXlTrEioTFRuEo9D+KLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRj1raLkt0Xyc6rjXNOjzJGdI+yd1JnlYW424hRd7rJ91LzhC6RaFBVdQWfvk0uI7
         UB8UChv4587qvnq4AmtPieP0L3qAHHVdTumbuvwTxq2LGMOHDcFSeTehpAltqifP7l
         rouVL2lPFBXnao2FPWi/je5jkAHwbjwVdjprzUVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/129] net: hns: Fix memleak in hns_nic_dev_probe
Date:   Tue,  8 Sep 2020 17:24:36 +0200
Message-Id: <20200908152231.430946553@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 100e3345c6e719d2291e1efd5de311cc24bb9c0b ]

hns_nic_dev_probe allocates ndev, but not free it on
two error handling paths, which may lead to memleak.

Fixes: 63434888aaf1b ("net: hns: net: hns: enet adds support of acpi")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index eb69e5c81a4d0..6d5d53cfc7ab4 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -2296,8 +2296,10 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 			priv->enet_ver = AE_VERSION_1;
 		else if (acpi_dev_found(hns_enet_acpi_match[1].id))
 			priv->enet_ver = AE_VERSION_2;
-		else
-			return -ENXIO;
+		else {
+			ret = -ENXIO;
+			goto out_read_prop_fail;
+		}
 
 		/* try to find port-idx-in-ae first */
 		ret = acpi_node_get_property_reference(dev->fwnode,
@@ -2313,7 +2315,8 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 		priv->fwnode = args.fwnode;
 	} else {
 		dev_err(dev, "cannot read cfg data from OF or acpi\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto out_read_prop_fail;
 	}
 
 	ret = device_property_read_u32(dev, "port-idx-in-ae", &port_id);
-- 
2.25.1



