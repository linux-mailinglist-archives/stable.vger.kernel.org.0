Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157D012179D
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfLPSGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbfLPSGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:06:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4974D20700;
        Mon, 16 Dec 2019 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519567;
        bh=q9fg2RGYUfCx8OVfkcI7VQQW/sZ7MeV3AOZm5gBVNBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJXdqi5a9Zp4u2bvW54bgTwRNnfWdgANWNND8XRoz6Ra+i47tCUoJjHT6kSXhkgpp
         Erz+VOidXkffcv0LG0lcE9UdXtMUwcWTx+eLNZOgOjA0UKKbPOR706KwSFUS+qPiA6
         Ldjd2OKddAO/GtLfZpEVh8FiGJY04l0MKXbXPcs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/140] net: hns3: Check variable is valid before assigning it to another
Date:   Mon, 16 Dec 2019 18:49:47 +0100
Message-Id: <20191216174820.206660974@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 676131f7c53ecdd79e29fc8cfcdefe6f9f2485e8 ]

In hnae3_register_ae_dev(), ae_algo->ops is assigned to ae_dev->ops
before check that ae_algo->ops is valid.

And in hnae3_register_ae_algo(), missing check for ae_algo->ops.

This patch fixes them.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index f98bff60bec37..f9259e568fa05 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -173,8 +173,12 @@ void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo)
 		if (!id)
 			continue;
 
-		/* ae_dev init should set flag */
+		if (!ae_algo->ops) {
+			dev_err(&ae_dev->pdev->dev, "ae_algo ops are null\n");
+			continue;
+		}
 		ae_dev->ops = ae_algo->ops;
+
 		ret = ae_algo->ops->init_ae_dev(ae_dev);
 		if (ret) {
 			dev_err(&ae_dev->pdev->dev,
@@ -182,6 +186,7 @@ void hnae3_register_ae_algo(struct hnae3_ae_algo *ae_algo)
 			continue;
 		}
 
+		/* ae_dev init should set flag */
 		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_INITED_B, 1);
 
 		/* check the client list for the match with this ae_dev type and
@@ -256,15 +261,13 @@ int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
 		if (!id)
 			continue;
 
-		ae_dev->ops = ae_algo->ops;
-
-		if (!ae_dev->ops) {
-			dev_err(&ae_dev->pdev->dev, "ae_dev ops are null\n");
+		if (!ae_algo->ops) {
+			dev_err(&ae_dev->pdev->dev, "ae_algo ops are null\n");
 			ret = -EOPNOTSUPP;
 			goto out_err;
 		}
+		ae_dev->ops = ae_algo->ops;
 
-		/* ae_dev init should set flag */
 		ret = ae_dev->ops->init_ae_dev(ae_dev);
 		if (ret) {
 			dev_err(&ae_dev->pdev->dev,
@@ -272,6 +275,7 @@ int hnae3_register_ae_dev(struct hnae3_ae_dev *ae_dev)
 			goto out_err;
 		}
 
+		/* ae_dev init should set flag */
 		hnae3_set_bit(ae_dev->flag, HNAE3_DEV_INITED_B, 1);
 		break;
 	}
-- 
2.20.1



