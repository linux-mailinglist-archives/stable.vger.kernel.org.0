Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B3E3C4DEC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhGLHPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241517AbhGLHOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A17613E6;
        Mon, 12 Jul 2021 07:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073882;
        bh=MCwjGlUhMs9fRJNOMQKclYgS0+8CWreKuf7GuCiuqT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYhUYgHUpBlYrDjxJUt4kcVZ8tP+i49eUdLj/ldgVJPT4enAN8Ctbkgmts59P9lrG
         ntpoFDL3WUhOwmmlZG2PzGm2HkN1xuV2RvgogdJCS1y945Rq99jbOQ1g6n1lhMmD5l
         kixD9+CjV0IIov2tZ08N0hqgsnCw2c+sHN/iog8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 389/700] ehea: fix error return code in ehea_restart_qps()
Date:   Mon, 12 Jul 2021 08:07:52 +0200
Message-Id: <20210712061017.785496687@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 015dbf5662fd689d581c0bc980711b073ca09a1a ]

Fix to return -EFAULT from the error handling case instead of 0, as done
elsewhere in this function.

By the way, when get_zeroed_page() fails, directly return -ENOMEM to
simplify code.

Fixes: 2c69448bbced ("ehea: DLPAR memory add fix")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210528085555.9390-1-thunder.leizhen@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index c2e740475786..f63066736425 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2617,10 +2617,8 @@ static int ehea_restart_qps(struct net_device *dev)
 	u16 dummy16 = 0;
 
 	cb0 = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!cb0) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!cb0)
+		return -ENOMEM;
 
 	for (i = 0; i < (port->num_def_qps); i++) {
 		struct ehea_port_res *pr =  &port->port_res[i];
@@ -2640,6 +2638,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					    cb0);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "query_ehea_qp failed (1)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -2652,6 +2651,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					     &dummy64, &dummy16, &dummy16);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "modify_ehea_qp failed (1)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -2660,6 +2660,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					    cb0);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "query_ehea_qp failed (2)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
-- 
2.30.2



