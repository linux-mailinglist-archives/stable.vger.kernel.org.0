Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6053E1013DA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfKSF14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbfKSF1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE63421823;
        Tue, 19 Nov 2019 05:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141275;
        bh=bxAO4w5X5zEmrbHOpKpbvHsXKjaiz0sk0Z5cc1tOT0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPe953DRAqT3vw5ItIx43Lixq+rCgaEgcLp/9zqnPZV8cuEJePoKJpFIxTjY3c6sj
         u9hXfCb02RZDK+08qwfFnVMlup/MECpxhSgbrpG/1f2uhGxbrDD444xGcqBlUim47m
         sq9CZID+iNa5BzmBfSe78u3hSJYmtLYyqkxt5KJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/422] net: hns3: Change the dst mac addr of loopback packet
Date:   Tue, 19 Nov 2019 06:15:03 +0100
Message-Id: <20191119051406.047353103@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 7f7d9e501f4123e64b130576621d24f9379adc8f ]

Currently, the dst mac addr of loopback packet is the same as
the host' mac addr, the SSU component may loop back the packet
to host before the packet reaches mac or serdes, which will defect
the purpose of mac or serdes selftest.

This patch changes it by adding 0x1f to the last byte of dst mac
addr.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 5bdcd92d86122..0c34ea1223580 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -137,6 +137,7 @@ static void hns3_lp_setup_skb(struct sk_buff *skb)
 	packet = skb_put(skb, HNS3_NIC_LB_TEST_PACKET_SIZE);
 
 	memcpy(ethh->h_dest, ndev->dev_addr, ETH_ALEN);
+	ethh->h_dest[5] += 0x1f;
 	eth_zero_addr(ethh->h_source);
 	ethh->h_proto = htons(ETH_P_ARP);
 	skb_reset_mac_header(skb);
-- 
2.20.1



