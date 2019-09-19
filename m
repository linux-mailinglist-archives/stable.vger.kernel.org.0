Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3457FB8414
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393284AbfISWHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393278AbfISWHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:07:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 166DF21924;
        Thu, 19 Sep 2019 22:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930862;
        bh=TBM/g7fLh8WR9QTERgiZC7qPfWyjzVeCnZnE5JZBrvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEcE9H8WKppXhuqr3f4X7rTZANJGODGV+kNziWWWnykHn9g3lfneGhWxkiOFZsM8y
         fvPz6rGe7+JdxLxq2V1gVr8j9utNJRuUYSH5/cA/q/efUEsknW6Gvq1gdpIGVKPCkc
         9WGyN3a449HdS/eJcOdhI0CUDk1uhQ4HM+q0a3JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 004/124] net: hns3: adjust hns3_uninit_phy()s location in the hns3_client_uninit()
Date:   Fri, 20 Sep 2019 00:01:32 +0200
Message-Id: <20190919214819.348401191@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

commit 0d2f68c7bcf4c7bbdd6f810f7b6e658f43d4461e upstream.

hns3_uninit_phy() should be called before checking
HNS3_NIC_STATE_INITED flags, otherwise when this checking fails,
there is nobody to call hns3_uninit_phy().

Fixes: c8a8045b2d0a ("net: hns3: Fix NULL deref when unloading driver")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3896,6 +3896,8 @@ static void hns3_client_uninit(struct hn
 
 	hns3_client_stop(handle);
 
+	hns3_uninit_phy(netdev);
+
 	if (!test_and_clear_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
 		netdev_warn(netdev, "already uninitialized\n");
 		goto out_netdev_free;
@@ -3905,8 +3907,6 @@ static void hns3_client_uninit(struct hn
 
 	hns3_clear_all_ring(handle, true);
 
-	hns3_uninit_phy(netdev);
-
 	hns3_nic_uninit_vector_data(priv);
 
 	ret = hns3_nic_dealloc_vector_data(priv);


