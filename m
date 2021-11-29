Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A79461F79
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379573AbhK2Srn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:47:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48416 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380131AbhK2Spk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:45:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E85BB815D1;
        Mon, 29 Nov 2021 18:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712A2C53FC7;
        Mon, 29 Nov 2021 18:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211339;
        bh=twnHZTsznmzqTBnfr3amrB3bUH+1amQjhIfqxqvx8Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0RjOgLIz6gHylZwx5lKvNjyHZ+lXS2/fOenJeke9o1072WlSbsomSRLbMDKtVV+K
         mE8Ov9ozZcJjsTS2LcIWvM6O7OLDX35CvS4KnJ1+Nd8LPKBEJyFlWswe79Y8sUUy5n
         0ACzl2+GRDuv8UDPhcwkNfcvGYdmsl3axjLIdKSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/179] net: hns3: fix incorrect components info of ethtool --reset command
Date:   Mon, 29 Nov 2021 19:19:06 +0100
Message-Id: <20211129181723.958733764@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 82229c4dbb8a2780f05fa1bab29c97ef7bcd21bb ]

Currently, HNS3 driver doesn't clear the reset flags of components after
successfully executing reset, it causes userspace info of
"Components reset" and "Components not reset" is incorrect.

So fix this problem by clear corresponding reset flag after reset process.

Fixes: ddccc5e368a3 ("net: hns3: add support for triggering reset by ethtool")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 5ebd96f6833d6..526fb56c84f24 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -985,6 +985,7 @@ static int hns3_set_reset(struct net_device *netdev, u32 *flags)
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
 	const struct hns3_reset_type_map *rst_type_map;
+	enum ethtool_reset_flags rst_flags;
 	u32 i, size;
 
 	if (ops->ae_dev_resetting && ops->ae_dev_resetting(h))
@@ -1004,6 +1005,7 @@ static int hns3_set_reset(struct net_device *netdev, u32 *flags)
 	for (i = 0; i < size; i++) {
 		if (rst_type_map[i].rst_flags == *flags) {
 			rst_type = rst_type_map[i].rst_type;
+			rst_flags = rst_type_map[i].rst_flags;
 			break;
 		}
 	}
@@ -1019,6 +1021,8 @@ static int hns3_set_reset(struct net_device *netdev, u32 *flags)
 
 	ops->reset_event(h->pdev, h);
 
+	*flags &= ~rst_flags;
+
 	return 0;
 }
 
-- 
2.33.0



