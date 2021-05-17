Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330473833DF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbhEQPDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241479AbhEQPBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23B4661350;
        Mon, 17 May 2021 14:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261629;
        bh=xLpDf4K2JjtPSvXNkULM/lu74JUPeBUuWOGi/Nb0DLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDnvHSFSGKDZzlNh+0Mp+rR5TTa/EarttT3KEPfba0O721DzhabUwWzmLF5Tsrr45
         zVyHvMtTpCZRM82Y84cvBVRqQxA2owMITUkgSiCloZHodYcn9BoaeQAxXzzBsXs7Kl
         Ij8F4ShMJojbQXDAi/1mN5qyRhENPL2pK/Y7m1dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/141] net: hns3: add check for HNS3_NIC_STATE_INITED in hns3_reset_notify_up_enet()
Date:   Mon, 17 May 2021 16:02:00 +0200
Message-Id: <20210517140245.063416417@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit b4047aac4ec1066bab6c71950623746d7bcf7154 ]

In some cases, the device is not initialized because reset failed.
If another task calls hns3_reset_notify_up_enet() before reset
retry, it will cause an error since uninitialized pointer access.
So add check for HNS3_NIC_STATE_INITED before calling
hns3_nic_net_open() in hns3_reset_notify_up_enet().

Fixes: bb6b94a896d4 ("net: hns3: Add reset interface implementation in client")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 696f21543aa7..6b43cbf4f909 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4280,6 +4280,11 @@ static int hns3_reset_notify_up_enet(struct hnae3_handle *handle)
 	struct hns3_nic_priv *priv = netdev_priv(kinfo->netdev);
 	int ret = 0;
 
+	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
+		netdev_err(kinfo->netdev, "device is not initialized yet\n");
+		return -EFAULT;
+	}
+
 	clear_bit(HNS3_NIC_STATE_RESETTING, &priv->state);
 
 	if (netif_running(kinfo->netdev)) {
-- 
2.30.2



