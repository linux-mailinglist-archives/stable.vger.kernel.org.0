Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC98D44161
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbfFMQN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731200AbfFMImh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:42:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3CA52147A;
        Thu, 13 Jun 2019 08:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415356;
        bh=/IMbikxRv8tv9hKiJzmRlZz3kER9v/NyBLeLBn/W8KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g528rEXwFvTKqc2iMrOPLxKPJsF05zteK5ZGMlgff/xZ8yW2skDcv5C+QYO8thl67
         u1jirAvgR7fPeMbzAdli3tAqB8R9todlom9d8FpUZjEdTsOmwV8sOx8/KeiMx3tYXP
         BwieR2Lta8Zhnb7EzaYAmgRRIS3+ptdudHKKnB7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/118] net: hns3: return 0 and print warning when hit duplicate MAC
Date:   Thu, 13 Jun 2019 10:33:53 +0200
Message-Id: <20190613075649.440852957@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 72110b567479f0282489a9b3747e76d8c67d75f5 ]

When set 2 same MAC to different function of one port, IMP
will return error as the later one may modify the origin one.
This will cause bond fail for 2 VFs of one port.

Driver just print warning and return 0 with this patch, so
if set same MAC address, it will return 0 but do not really
configure HW.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 340baf6a470c..4648c6a9d9e8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4300,8 +4300,11 @@ int hclge_add_uc_addr_common(struct hclge_vport *vport,
 		return hclge_add_mac_vlan_tbl(vport, &req, NULL);
 
 	/* check if we just hit the duplicate */
-	if (!ret)
-		ret = -EINVAL;
+	if (!ret) {
+		dev_warn(&hdev->pdev->dev, "VF %d mac(%pM) exists\n",
+			 vport->vport_id, addr);
+		return 0;
+	}
 
 	dev_err(&hdev->pdev->dev,
 		"PF failed to add unicast entry(%pM) in the MAC table\n",
-- 
2.20.1



