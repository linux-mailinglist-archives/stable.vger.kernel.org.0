Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F31B8685
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406439AbfISWRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406426AbfISWRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:17:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A6121907;
        Thu, 19 Sep 2019 22:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931426;
        bh=PAUG5iixFXxTPmQ6sxSR0YC0MClEKtce7SpzYuzozrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZI1DByGbp14iWN63d92vZ+hFdHVvGJPS+LMmsJT1edsn8Pbz177YT+f4aFa04ZTM
         IAAhM98v9Pii/FaPrlEOJemRccd31iBPXGO+LLnMTUGWAt0JMo0utyrwl7BLM/shxl
         alkOSCt0iEBzlSWY/+pBedczOBErklwVUX5Cndic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 42/59] amd-xgbe: Fix error path in xgbe_mod_init()
Date:   Fri, 20 Sep 2019 00:03:57 +0200
Message-Id: <20190919214807.076319117@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit b6b4dc4c1fa7f1c99398e7dc85758049645e9588 ]

In xgbe_mod_init(), we should do cleanup if some error occurs

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: efbaa828330a ("amd-xgbe: Add support to handle device renaming")
Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index e31d9d1fb6a66..e4e632e025d31 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -487,13 +487,19 @@ static int __init xgbe_mod_init(void)
 
 	ret = xgbe_platform_init();
 	if (ret)
-		return ret;
+		goto err_platform_init;
 
 	ret = xgbe_pci_init();
 	if (ret)
-		return ret;
+		goto err_pci_init;
 
 	return 0;
+
+err_pci_init:
+	xgbe_platform_exit();
+err_platform_init:
+	unregister_netdevice_notifier(&xgbe_netdev_notifier);
+	return ret;
 }
 
 static void __exit xgbe_mod_exit(void)
-- 
2.20.1



