Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C05412592
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384016AbhITSqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353443AbhITSm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB94161AE1;
        Mon, 20 Sep 2021 17:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159120;
        bh=GSkFnDIELaBtcinw7Rn4/dyjtsaBin5+Zzcp0Y70OG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObOBA0/dPjZiizc6uj/oXaESfAdkOX4wuetwE59I2QvySpCqNWUHZvJ2Xo6PrrqKx
         WbaPu+3Cabi1zVRwyZlUksojlmreG8lVHVK0+3nnYueQD+WyUfzlM5wxK0daZI5fcB
         8FKrIWLvLtNE0Cs396wpQr3O64E89iTed4f3UAnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaran Zhang <zhangjiaran@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 085/168] net: hns3: fix the exception when query imp info
Date:   Mon, 20 Sep 2021 18:43:43 +0200
Message-Id: <20210920163924.429982624@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

[ Upstream commit 472430a7b066f19afa1b55867d621b2d6d323e0d ]

When the command for querying imp info is issued to the firmware,
if the firmware does not support the command, the returned value
of bd num is 0.
Add protection mechanism before alloc memory to prevent apply for
0-length memory.

Fixes: 0b198b0d80ea ("net: hns3: refactor dump m7 info of debugfs")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 288788186ecc..e6e617aba2a4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1710,6 +1710,10 @@ hclge_dbg_get_imp_stats_info(struct hclge_dev *hdev, char *buf, int len)
 	}
 
 	bd_num = le32_to_cpu(req->bd_num);
+	if (!bd_num) {
+		dev_err(&hdev->pdev->dev, "imp statistics bd number is 0!\n");
+		return -EINVAL;
+	}
 
 	desc_src = kcalloc(bd_num, sizeof(struct hclge_desc), GFP_KERNEL);
 	if (!desc_src)
-- 
2.30.2



