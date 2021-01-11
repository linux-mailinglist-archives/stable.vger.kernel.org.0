Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF302F1305
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbhAKNCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729314AbhAKNCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:02:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB3B52250E;
        Mon, 11 Jan 2021 13:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370112;
        bh=mQrKzEhE0lfko0hSa7iYajsD9DroLaanyDC1YYELfsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=obbF5WbI3uXgOUU8YuA2ASLDjwOyAZ/TXGB4O9VD2MB+ObM9//FZ31IDvuOyKmWE6
         +Ukya7lz2iU2qlBOy9W1AMBv0N3HKrl3p5DK01LWiai8efIkylGJl9MH3/lRo0RYU0
         CqANiUsS9b5AMX/iT3/EI8BewEk2+pDH5Fp9SQKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 08/38] net: hns: fix return value check in __lb_other_process()
Date:   Mon, 11 Jan 2021 14:00:40 +0100
Message-Id: <20210111130032.867246503@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
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
@@ -433,6 +433,10 @@ static void __lb_other_process(struct hn
 	/* for mutl buffer*/
 	new_skb = skb_copy(skb, GFP_ATOMIC);
 	dev_kfree_skb_any(skb);
+	if (!new_skb) {
+		netdev_err(ndev, "skb alloc failed\n");
+		return;
+	}
 	skb = new_skb;
 
 	check_ok = 0;


