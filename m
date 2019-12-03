Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBF7111E61
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbfLCXBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:01:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbfLCWzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:55:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DCF5215F2;
        Tue,  3 Dec 2019 22:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413751;
        bh=G7w5RbeO/+w8Vm7XQsY9gouBpRjZ2H9R0THohGO6CbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJANcW2/Y/pvnq29KEn+ESnNQI73ucAO7Bqsu1gZzhyQfHJsoedeWCi/gkvxYXrKI
         6Mp4M20lPrmo1EgOX2FJOy0wk7H4Epju6kkRE+tuWQGwxYa8aRpXFFCQzW4ctn2iJx
         4QGRpYYmImmUxaMkKVTpcBfO8qLcL0tOGplYTFmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 247/321] net: hns3: fix an issue for hns3_update_new_int_gl
Date:   Tue,  3 Dec 2019 23:35:13 +0100
Message-Id: <20191203223439.988774057@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit 6241e71e7207102ffc733991f7a00f74098d7da0 ]

HNS3 supports setting rx-usecs|tx-usecs as 0, but it will not
update dynamically when adaptive-tx or adaptive-rx is enable.
This patch removes the Redundant check.

Fixes: a95e1f8666e9 ("net: hns3: change the time interval of int_gl calculating")
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3708f149d0a6a..b2860087a7dc7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2366,7 +2366,7 @@ static bool hns3_get_new_int_gl(struct hns3_enet_ring_group *ring_group)
 	u32 time_passed_ms;
 	u16 new_int_gl;
 
-	if (!ring_group->coal.int_gl || !tqp_vector->last_jiffies)
+	if (!tqp_vector->last_jiffies)
 		return false;
 
 	if (ring_group->total_packets == 0) {
-- 
2.20.1



