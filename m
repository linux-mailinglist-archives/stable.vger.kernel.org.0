Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31C32F1682
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387962AbhAKNxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728072AbhAKNI1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FE662225E;
        Mon, 11 Jan 2021 13:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370491;
        bh=fva7RPyukFLyATIhb2owJRVdVcnxJZQeD2TuuPYw2Dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnhuNUG6n8tt1qROX2sHPnlNs8IGRydc2m0/eG/BeuGH/rewVG7coioSvcbnXt5KY
         KHNc1d9yk6DvTrridjUjNPWG1StkY2TASStxA8SDzWBHKDn6WqHQnaj5DPCaHfvbNE
         G/YOKRQ1qzbzP/PxJbG4Us4x6gule1uwMVsBj9MQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 28/77] net: hns: fix return value check in __lb_other_process()
Date:   Mon, 11 Jan 2021 14:01:37 +0100
Message-Id: <20210111130037.763783989@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -419,6 +419,10 @@ static void __lb_other_process(struct hn
 	/* for mutl buffer*/
 	new_skb = skb_copy(skb, GFP_ATOMIC);
 	dev_kfree_skb_any(skb);
+	if (!new_skb) {
+		netdev_err(ndev, "skb alloc failed\n");
+		return;
+	}
 	skb = new_skb;
 
 	check_ok = 0;


