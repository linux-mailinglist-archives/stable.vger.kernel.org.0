Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE5F177F15
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgCCRsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbgCCRsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2834420CC7;
        Tue,  3 Mar 2020 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257716;
        bh=gevy0Y7WUjal6/sURl3hPhZqxBEX4jIYewIp5CtAAmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuH8/5kykIWdsfCKwnt84zmstIHdc1YDbZmt9/eEfdPjT3vnwP/zrMcd5tw6Np2RM
         g/0W7znOxuh+i8A7GZiUAm0n04X32b9okZ/Bcwe8lxke5+BO7S7ScmC2BsCPl1q2PF
         tpRHDJuslZ6Dy5uI6N/iQiShUl07xC+yTN3O8ojs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 076/176] net: hns3: fix VF bandwidth does not take effect in some case
Date:   Tue,  3 Mar 2020 18:42:20 +0100
Message-Id: <20200303174313.420985834@linuxfoundation.org>
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

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 19eb1123b4e9337fe20b1763fec528f837ec6568 ]

When enabling 4 TC after setting the bandwidth of VF, the bandwidth
of VF will resume to default value, because of the qset resources
changed in this case.

This patch fixes it by using a fixed VF's qset resources according to
HNAE3_MAX_TC macro.

Fixes: ee9e44248f52 ("net: hns3: add support for configuring bandwidth of VF on the host")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index 180224eab1ca4..28db13253a5e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -566,7 +566,7 @@ static void hclge_tm_vport_tc_info_update(struct hclge_vport *vport)
 	 */
 	kinfo->num_tc = vport->vport_id ? 1 :
 			min_t(u16, vport->alloc_tqps, hdev->tm_info.num_tc);
-	vport->qs_offset = (vport->vport_id ? hdev->tm_info.num_tc : 0) +
+	vport->qs_offset = (vport->vport_id ? HNAE3_MAX_TC : 0) +
 				(vport->vport_id ? (vport->vport_id - 1) : 0);
 
 	max_rss_size = min_t(u16, hdev->rss_size_max,
-- 
2.20.1



