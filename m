Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221102F2E8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbfE3EYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbfE3DOu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:50 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48FE024563;
        Thu, 30 May 2019 03:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186090;
        bh=Cdd8ZuPR7dL03IVKm9Fx91+2UqBDbrqTk3hy+I1JM8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/dQcZ/I7PFePBMyna6K/u9/06Kn/h0VmpGCUZktvuzKifkcOiliSbYZxuYh3jidy
         PlnCsXOiZK4pwU39XcACdP4ou99ZUNPkWaGXcQ5w9cxP+HwUUrGpH7AaNlfxRVMRVs
         YxnLMzdiTPfrgHm+UHmLipUw5fRtqlL3lLOuMS7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 220/346] net: hns3: check resetting status in hns3_get_stats()
Date:   Wed, 29 May 2019 20:04:53 -0700
Message-Id: <20190530030552.233467630@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c4e401e5a934bb0798ebbba98e08dab129695eff ]

hns3_get_stats() should check the resetting status firstly,
since the device will be reinitialized when resetting. If the
reset has not completed, the hns3_get_stats() may access
invalid memory.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e678b6939da39..36b35c58304b5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -482,6 +482,11 @@ static void hns3_get_stats(struct net_device *netdev,
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	u64 *p = data;
 
+	if (hns3_nic_resetting(netdev)) {
+		netdev_err(netdev, "dev resetting, could not get stats\n");
+		return;
+	}
+
 	if (!h->ae_algo->ops->get_stats || !h->ae_algo->ops->update_stats) {
 		netdev_err(netdev, "could not get any statistics\n");
 		return;
-- 
2.20.1



