Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDD22F1501
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731893AbhAKNeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:34:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732133AbhAKNOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF3D022515;
        Mon, 11 Jan 2021 13:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370860;
        bh=YRUgOafeQmpHV/J0qrndzUdfreBjoaD9/Lyb/gJf8uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DP5jVvcvEsr8bKEWsQCMGvCjWbjNN54i/hr0uvV/vjgtpKsyERoFd7IrniMlt8hXC
         3kfYB8I5QucID1qz8E2pWuT/O75y9vv2VFFKN01GZKRXOQeQ7+rv2hPQyQQIgRMs9a
         KEuvyiy1Nx7Uh9MAFfNGYhn2DucQs0BMxbL9A9eU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 036/145] net: hns: fix return value check in __lb_other_process()
Date:   Mon, 11 Jan 2021 14:01:00 +0100
Message-Id: <20210111130050.254628076@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
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
@@ -415,6 +415,10 @@ static void __lb_other_process(struct hn
 	/* for mutl buffer*/
 	new_skb = skb_copy(skb, GFP_ATOMIC);
 	dev_kfree_skb_any(skb);
+	if (!new_skb) {
+		netdev_err(ndev, "skb alloc failed\n");
+		return;
+	}
 	skb = new_skb;
 
 	check_ok = 0;


