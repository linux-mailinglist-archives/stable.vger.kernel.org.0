Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1107A27CA25
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbgI2MQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgI2LhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88CAC23ED2;
        Tue, 29 Sep 2020 11:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379174;
        bh=IG69orGZizecW30f5Fn2mdLJYq0+6DQXjUuszz2XqGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeDib49Q1GljPSbRyaIiTy3EGODc4Co2rkeenqTuLnDkxwAyy+D2dNW0hQSbxyaWJ
         jilEB1feHG9ibW40+Os+sWxC/VgMEYUdJsVrCbcXthVGZQRmvxiJdG3ONqhT1YkfES
         AIVs6JJCreVwzOKkvDBpcbNtXbrJa9HA4VSWOB1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/388] RDMA/qedr: Fix potential use after free
Date:   Tue, 29 Sep 2020 12:56:16 +0200
Message-Id: <20200929110012.669519663@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



