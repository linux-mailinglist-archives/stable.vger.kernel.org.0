Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42363CB543
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 11:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhGPJcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 05:32:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6943 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbhGPJcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 05:32:53 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GR5TS5d4yz7vVS;
        Fri, 16 Jul 2021 17:26:20 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 17:29:53 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 16 Jul
 2021 17:29:52 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <sudipm.mukherjee@gmail.com>, <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <davem@davemloft.net>, <sashal@kernel.org>
Subject: [PATCH 5.4] net: moxa: Use devm_platform_get_and_ioremap_resource()
Date:   Fri, 16 Jul 2021 17:32:45 +0800
Message-ID: <20210716093245.315536-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 35cba15a504bf4f585bb9d78f47b22b28a1a06b2 ]

Use devm_platform_get_and_ioremap_resource() to simplify
code and avoid a null-ptr-deref by checking 'res' in it.

[yyl: since devm_platform_get_and_ioremap_resource() is introduced
      in linux-5.7, so just check the return value after calling
      platform_get_resource()]

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index f70bb81e1ed65..caf7051302725 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -481,6 +481,10 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	priv->pdev = pdev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -EINVAL;
+		goto init_fail;
+	}
 	ndev->base_addr = res->start;
 	priv->base = devm_ioremap_resource(p_dev, res);
 	if (IS_ERR(priv->base)) {
-- 
2.25.1

