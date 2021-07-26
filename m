Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514C93D5FA1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhGZPSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236361AbhGZPQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:16:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6329860F38;
        Mon, 26 Jul 2021 15:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315027;
        bh=o+Hl5PxnNN66nfBYS6wwfVNpuDJJjn/wYQjy4g+risI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLZzy/W6RjDei+PnhOrmRvTflBs8LXFmK5yncPNMrcd7ArV9S4PnhvPjOevBoOWuR
         mdLVHjgTKJioB8UmkvmOUjQgr+DopACe3iufYrK5dAGtJ/6KR8fxsLjYB2GHOxDc2m
         cRpJnrIEabligeNDXYVXIun9aEfKS+ovyMaYqPTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/108] net: hns3: fix rx VLAN offload state inconsistent issue
Date:   Mon, 26 Jul 2021 17:38:58 +0200
Message-Id: <20210726153833.508400110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit bbfd4506f962e7e6fff8f37f017154a3c3791264 ]

Currently, VF doesn't enable rx VLAN offload when initializating,
and PF does it for VFs. If user disable the rx VLAN offload for
VF with ethtool -K, and reload the VF driver, it may cause the
rx VLAN offload state being inconsistent between hardware and
software.

Fixes it by enabling rx VLAN offload when VF initializing.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index fc275d4f484c..ea348ebbbf2e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2119,6 +2119,16 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 
 static int hclgevf_init_vlan_config(struct hclgevf_dev *hdev)
 {
+	struct hnae3_handle *nic = &hdev->nic;
+	int ret;
+
+	ret = hclgevf_en_hw_strip_rxvtag(nic, true);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to enable rx vlan offload, ret = %d\n", ret);
+		return ret;
+	}
+
 	return hclgevf_set_vlan_filter(&hdev->nic, htons(ETH_P_8021Q), 0,
 				       false);
 }
-- 
2.30.2



