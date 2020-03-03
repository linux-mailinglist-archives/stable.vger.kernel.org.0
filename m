Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01F3177F12
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbgCCRse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731527AbgCCRsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D3D20870;
        Tue,  3 Mar 2020 17:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257713;
        bh=uaI06Q+VT+zupIXMyse4ElXQfxh08km6yMMEEHSyq+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cw03c+UxYReLX6x9gCDbiuW13PYo4uUraenBaEIu2hXOz8IAOCv/cbl33CJRqhkK/
         Z3EtezM/ZygbSxe9KIk74SrfqL2kWfuPCV/LNIlzCtHkx6wqRvS1FaKMe8hUqZ2Y44
         TUr2s2s8erl3smz/p6bw8+m7nm3lNTZAauJOE4Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 075/176] net: hns3: add management table after IMP reset
Date:   Tue,  3 Mar 2020 18:42:19 +0100
Message-Id: <20200303174313.320196547@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit d0db7ed397517c8b2be24a0d1abfa15df776908e ]

In the current process, the management table is missing after the
IMP reset. This patch adds the management table to the reset process.

Fixes: f5aac71c0327 ("net: hns3: add manager table initialization for hardware")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 13dbd249f35fa..bfdb08572f0cc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9821,6 +9821,13 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
+	ret = init_mgr_tbl(hdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to reinit manager table, ret = %d\n", ret);
+		return ret;
+	}
+
 	ret = hclge_init_fd_config(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "fd table init fail, ret=%d\n", ret);
-- 
2.20.1



