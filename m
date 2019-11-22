Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA1301060FD
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbfKVFxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:53:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbfKVFxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D38C12082F;
        Fri, 22 Nov 2019 05:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401994;
        bh=XixCqk5Dctp3gu17mdUdZfPgqxJFaELcs0HpON1q1h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Urk9/6Bmg5HSJVE4IpPkL5G4YH+O0r4rqtb2EpDVh9LibeBk0x2Rt4WXtmn48qPLe
         qdaJRH0MyHf+EH/7p5gLC0+AQ7Yj1acBWLSnR6gUsBrmXWFSoLtbzQRwzQJnnr1LWZ
         C545Ph9qNi/x+Vlwz6kEN+ZchaPtll8ypq+mrFSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 212/219] RDMA/hns: Bugfix for the scene without receiver queue
Date:   Fri, 22 Nov 2019 00:49:03 -0500
Message-Id: <20191122054911.1750-204-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 4d103905eb1e4f14cb62fcf962c9d35da7005dea ]

In some application scenario, the user could not have receive queue when
run rdma write or read operation.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 2fa4fb17f6d3c..44729ae5f11cd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -503,7 +503,8 @@ static int hns_roce_qp_has_sq(struct ib_qp_init_attr *attr)
 static int hns_roce_qp_has_rq(struct ib_qp_init_attr *attr)
 {
 	if (attr->qp_type == IB_QPT_XRC_INI ||
-	    attr->qp_type == IB_QPT_XRC_TGT || attr->srq)
+	    attr->qp_type == IB_QPT_XRC_TGT || attr->srq ||
+	    !attr->cap.max_recv_wr)
 		return 0;
 
 	return 1;
-- 
2.20.1

