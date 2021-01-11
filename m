Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE22F159E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbhAKNml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:42:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730878AbhAKNMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:12:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B967D229CA;
        Mon, 11 Jan 2021 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370713;
        bh=YRUgOafeQmpHV/J0qrndzUdfreBjoaD9/Lyb/gJf8uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5mjjVjVwKljsq9cQnSdpiVugOGW9z+ADWvKav/6DNbQMBActj6w6WLJujllz2WyP
         94Ofb8QnIl8j/APz7a9zKFVA9hloqY9wLerjnPzdZVkIvdnY6Sqldm2NyuN7pIIn2L
         YooiHhPBFaoSAkYxhSRbT3DKhc08ej13dnb6SeGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 35/92] net: hns: fix return value check in __lb_other_process()
Date:   Mon, 11 Jan 2021 14:01:39 +0100
Message-Id: <20210111130040.841793263@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
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


