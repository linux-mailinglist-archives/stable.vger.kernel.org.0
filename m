Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7159126F428
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgIRDM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgIRCCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060E523119;
        Fri, 18 Sep 2020 02:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394528;
        bh=IG69orGZizecW30f5Fn2mdLJYq0+6DQXjUuszz2XqGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6BZVghQlTeGsAZS2PRT7TiwEgNtMv/ls4UKYMzsMR+RTyda1Y2I5UWkhzUxIYsrs
         7dqD6Rb22xVIyJvyiOXqJJeTQrKuY0pfq6trUST7znIZp6L7NzoeyNt30XdPiSfeTL
         QqFUPiVq7iwmnKbwYz46eTcNKPC22HMT7cc8cRiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 048/330] RDMA/qedr: Fix potential use after free
Date:   Thu, 17 Sep 2020 21:56:28 -0400
Message-Id: <20200918020110.2063155-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 960657b732e1ce21b07be5ab48a7ad3913d72ba4 ]

Move the release operation after error log to avoid possible use after
free.

Link: https://lore.kernel.org/r/1573021434-18768-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index a7a926b7b5628..6dea49e11f5f0 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -490,10 +490,10 @@ qedr_addr6_resolve(struct qedr_dev *dev,
 
 	if ((!dst) || dst->error) {
 		if (dst) {
-			dst_release(dst);
 			DP_ERR(dev,
 			       "ip6_route_output returned dst->error = %d\n",
 			       dst->error);
+			dst_release(dst);
 		}
 		return -EINVAL;
 	}
-- 
2.25.1

