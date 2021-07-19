Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C473CDAF8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243118AbhGSOka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244262AbhGSOjN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F031561285;
        Mon, 19 Jul 2021 15:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707893;
        bh=ab6FQ0oyXXk/p6gdcqEThgIh3Vh11d4Kx0nxeVLiCJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8RzVChYitqO5aQBNy55P1RDSergpKmNAXnXyq305lAkW2ywVBuM29dezFFxucAwv
         +QXm/F0eED3Ap1T0aai3mtlWs3Iq8WmpzEb5wUb+VMb+8xTpQsq57hdPyRT9h6vlG5
         HH8PL3LZAH/6O6pNoh/Ojm223hCdIPVk1C0nPjr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/315] ehea: fix error return code in ehea_restart_qps()
Date:   Mon, 19 Jul 2021 16:49:47 +0200
Message-Id: <20210719144946.103842527@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index 373deb247ac0..a754e2ce7730 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2647,10 +2647,8 @@ static int ehea_restart_qps(struct net_device *dev)
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
@@ -2670,6 +2668,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					    cb0);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "query_ehea_qp failed (1)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -2682,6 +2681,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					     &dummy64, &dummy16, &dummy16);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "modify_ehea_qp failed (1)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -2690,6 +2690,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					    cb0);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "query_ehea_qp failed (2)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
-- 
2.30.2



