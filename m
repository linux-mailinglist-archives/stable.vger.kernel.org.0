Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2C12F177E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbhAKOGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbhAKNDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACEC422ADF;
        Mon, 11 Jan 2021 13:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370176;
        bh=CpjiHtyJeATbfgkR8IbujFim1oHq4xj2LJmCjeroXW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d37bZTfA57oWnIQAyG0DW6KI/8BVLvEKScQ0pN9WyjuA4x0Hc+Pn+Dm5PLNUD5wey
         NYfQTXrsFRU4a9oDRr3PpDnLNYKPFq+NjrFUfPLwIz3hGKm0k2gf9qNC1dy2xvQaw0
         u8apqsozJ/9+qW269ni0naWm9DhgHFmioKDy0N/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 11/45] net: hns: fix return value check in __lb_other_process()
Date:   Mon, 11 Jan 2021 14:00:49 +0100
Message-Id: <20210111130034.207604013@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 5ede3ada3da7f050519112b81badc058190b9f9f ]

The function skb_copy() could return NULL, the return value
need to be checked.

Fixes: b5996f11ea54 ("net: add Hisilicon Network Subsystem basic ethernet support")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -447,6 +447,10 @@ static void __lb_other_process(struct hn
 	/* for mutl buffer*/
 	new_skb = skb_copy(skb, GFP_ATOMIC);
 	dev_kfree_skb_any(skb);
+	if (!new_skb) {
+		netdev_err(ndev, "skb alloc failed\n");
+		return;
+	}
 	skb = new_skb;
 
 	check_ok = 0;


