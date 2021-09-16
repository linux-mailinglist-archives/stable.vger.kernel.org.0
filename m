Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA2D40E2AB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243927AbhIPQlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242870AbhIPQh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:37:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7327861439;
        Thu, 16 Sep 2021 16:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809342;
        bh=quXyZ1nLaoVG94oIBq0it1F7qds3SnrQl+zd90DLktw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUy+DPFFFO4HUdbXyxQiZZVayl/tOHmAc+/bzzIvC79JZRKm6QJnaP7cQxWk00Mr2
         7HuVKbMTqIdwAfhg5utaftcrFg97oosU22+cmlpHSOwDW4yyeLlfWNewMxWx+GgM1j
         FS6Cr9/Ck48rgqMvrGkbPSnWMqaYsoBTmHwt8KDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Junxian Huang <huangjunxian4@hisilicon.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 120/380] RDMA/hns: Bugfix for data type of dip_idx
Date:   Thu, 16 Sep 2021 17:57:57 +0200
Message-Id: <20210916155808.118474406@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxian Huang <huangjunxian4@hisilicon.com>

[ Upstream commit 4303e61264c45cb535255c5b76400f5c4ab1305d ]

dip_idx is associated with qp_num whose data type is u32. However, dip_idx
is incorrectly defined as u8 data in the hns_roce_dip struct, which leads
to data truncation during value assignment.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Link: https://lore.kernel.org/r/1629884592-23424-2-git-send-email-liangwenpeng@huawei.com
Signed-off-by: Junxian Huang <huangjunxian4@hisilicon.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 23cf2f6bc7a5..d4da840dbc2e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1784,7 +1784,7 @@ struct hns_roce_eq_context {
 
 struct hns_roce_dip {
 	u8 dgid[GID_LEN_V2];
-	u8 dip_idx;
+	u32 dip_idx;
 	struct list_head node;	/* all dips are on a list */
 };
 
-- 
2.30.2



