Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE962F65B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388970AbfE3EzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbfE3DKQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01271244A9;
        Thu, 30 May 2019 03:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185816;
        bh=F6fL20tFwnTnHRQPPUAAQLpR0OjfBcTWFSmquw6yw04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKnO7evygkzQiEYrSJN+H+nOAf7bd4g3q3Z7V8iehDQmhoM2EICpMdei3hGNBFkrW
         1Ifeuh4TY193HRb9TL9yIY6mcaZf3JQVMmRIvUjshjJ8pFS6ovAQZVv6Aj1IfeZSaz
         v0jH0EQb5TCwQ5PbHPrnM49cr5JbMuQdTsHe4AUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 108/405] net: hns3: fix pause configure fail problem
Date:   Wed, 29 May 2019 20:01:46 -0700
Message-Id: <20190530030546.469198018@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fba2efdae8b4f998f66a2ff4c9f0575e1c4bbc40 ]

When configure pause, current implementation returns directly
after setup PFC without setup BP, which is not sufficient.

So this patch fixes it, only return while setting PFC failed.

Fixes: 44e59e375bf7 ("net: hns3: do not return GE PFC setting err when initializing")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index aafc69f4bfdd6..a7bbb6d3091a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -1331,8 +1331,11 @@ int hclge_pause_setup_hw(struct hclge_dev *hdev, bool init)
 	ret = hclge_pfc_setup_hw(hdev);
 	if (init && ret == -EOPNOTSUPP)
 		dev_warn(&hdev->pdev->dev, "GE MAC does not support pfc\n");
-	else
+	else if (ret) {
+		dev_err(&hdev->pdev->dev, "config pfc failed! ret = %d\n",
+			ret);
 		return ret;
+	}
 
 	return hclge_tm_bp_setup(hdev);
 }
-- 
2.20.1



