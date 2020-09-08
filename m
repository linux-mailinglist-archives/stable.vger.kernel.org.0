Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD7261ACD
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgIHQI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731297AbgIHQIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:08:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE6FD23F33;
        Tue,  8 Sep 2020 15:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580084;
        bh=/d6blObAe5VISG8pssX/+RsbDXxLlxLYTvkMDNsadpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOB1+bv7G+HazhV6YzW9JGAEkPMEVmm9N5xSacf0gSsOL/YMwe+5vIaJrs6ph5Oz1
         maCzXvg5V8T6l2fx6LqzBCtI5VwOGDs4UL4WBk5FjFj5h8SYuyminiQ7x+5oPXqmWE
         rLtI6vtEYB8TyshXda5FGiBJkLZ9N9K7iwWkjUS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/88] net: hns: Fix memleak in hns_nic_dev_probe
Date:   Tue,  8 Sep 2020 17:25:26 +0200
Message-Id: <20200908152222.324764551@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
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
index 024b08fafd3b2..4de65a9de0a63 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -2297,8 +2297,10 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
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
@@ -2314,7 +2316,8 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
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



