Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56947148465
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbgAXLHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:42804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732427AbgAXLHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:34 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59FD72071A;
        Fri, 24 Jan 2020 11:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864053;
        bh=JpbGFaVqvCFMCutViGa8QSn9JWFJ0c7Uuy6gghZq4iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbG0KQpmSqWsNLEPT8YqOrDdDJwYdeY1Ku6ygiPQU5uuRjKPK8Yd9QBcrbtrAXf9u
         AxSY6O1dXPprpmN8t1mGDWwFymCeoZ0qeMaTwMxC99Pu7cAqA7csn8Xvq3GutrphOf
         pOLVm9RRVewv7etYWl1LILsgJ0LfiZzXXjSGiLCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/639] net: hns3: fix bug of ethtool_ops.get_channels for VF
Date:   Fri, 24 Jan 2020 10:25:15 +0100
Message-Id: <20200124093105.406619516@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 8be7362186bd5ccb5f6f72be49751ad2778e2636 ]

The current code returns the number of all queues that can be used and
the number of queues that have been allocated, which is incorrect.
What should be returned is the number of queues allocated for each enabled
TC and the number of queues that can be allocated.

This patch fixes it.

Fixes: 849e46077689 ("net: hns3: add ethtool_ops.get_channels support for VF")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 67db19709deaa..fd5375b5991bb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1957,7 +1957,8 @@ static u32 hclgevf_get_max_channels(struct hclgevf_dev *hdev)
 	struct hnae3_handle *nic = &hdev->nic;
 	struct hnae3_knic_private_info *kinfo = &nic->kinfo;
 
-	return min_t(u32, hdev->rss_size_max * kinfo->num_tc, hdev->num_tqps);
+	return min_t(u32, hdev->rss_size_max,
+		     hdev->num_tqps / kinfo->num_tc);
 }
 
 /**
@@ -1978,7 +1979,7 @@ static void hclgevf_get_channels(struct hnae3_handle *handle,
 	ch->max_combined = hclgevf_get_max_channels(hdev);
 	ch->other_count = 0;
 	ch->max_other = 0;
-	ch->combined_count = hdev->num_tqps;
+	ch->combined_count = handle->kinfo.rss_size;
 }
 
 static void hclgevf_get_tqps_and_rss_info(struct hnae3_handle *handle,
-- 
2.20.1



