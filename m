Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B313F22F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391807AbgAPRYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:24:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403817AbgAPRYs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A9424683;
        Thu, 16 Jan 2020 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195487;
        bh=i5c+aZC1cSbxesexqnQKRgEPDNtvqLGBWgzftqcetSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Abejdd7JuwzhZ63c1rMMvDPPufVTPWmhFg6a/guy/0CMBt4rOMOVA5KDZz0Usl8hH
         aocwOTorhNfDhH4OVrF6Kuew2OT8Oz9TBGkek0BHEaXENnSwgxdlO6KtwfBZPSy0Rt
         n6fntAoLBFjpLPdJ6CsivwjT+Vp5jRTPQTVCmjdQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Wise <swise@opengridcomputing.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 091/371] iw_cxgb4: use tos when finding ipv6 routes
Date:   Thu, 16 Jan 2020 12:19:23 -0500
Message-Id: <20200116172403.18149-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

[ Upstream commit c8a7eb554a83214c3d8ee5cb322da8c72810d2dc ]

When IPv6 support was added, the correct tos was not passed to
cxgb_find_route6(). This potentially results in the wrong route entry.

Fixes: 830662f6f032 ("RDMA/cxgb4: Add support for active and passive open connection with IPv6 address")
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 942403e42dd0..7eb1cc1b1aa0 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2147,7 +2147,8 @@ static int c4iw_reconnect(struct c4iw_ep *ep)
 					   laddr6->sin6_addr.s6_addr,
 					   raddr6->sin6_addr.s6_addr,
 					   laddr6->sin6_port,
-					   raddr6->sin6_port, 0,
+					   raddr6->sin6_port,
+					   ep->com.cm_id->tos,
 					   raddr6->sin6_scope_id);
 		iptype = 6;
 		ra = (__u8 *)&raddr6->sin6_addr;
@@ -3298,7 +3299,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 					   laddr6->sin6_addr.s6_addr,
 					   raddr6->sin6_addr.s6_addr,
 					   laddr6->sin6_port,
-					   raddr6->sin6_port, 0,
+					   raddr6->sin6_port, cm_id->tos,
 					   raddr6->sin6_scope_id);
 	}
 	if (!ep->dst) {
-- 
2.20.1

