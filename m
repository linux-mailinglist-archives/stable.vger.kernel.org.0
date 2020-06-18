Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DD01FDAEB
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgFRBJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:09:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbgFRBJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:09:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5885A21D94;
        Thu, 18 Jun 2020 01:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442555;
        bh=K2pe3NCo/QG0jx6Lga6JkIfLAV/kZWob+/1HGIxDGgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTyOfArvDKc2ZGuwHb0+BGTr6VbkG2epIpRdC2meSZPJs7DqnU0jTcmdsaAVP0bbW
         fX6b3UVejWPF3XmJy2rptblp7U43M0z4t0bp+qGUtJLs1fel8+JpjrHx5d6MKTsX4c
         qJzbkcfz1CvjBXaaiB+SWxB6J3oOPbCl4JSHnBp8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 052/388] RDMA/srpt: Fix disabling device management
Date:   Wed, 17 Jun 2020 21:02:29 -0400
Message-Id: <20200618010805.600873-52-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 23bbd5818e2b0d265aa1835e66f5055f63a8fa4c ]

Avoid disabling device management for devices that don't support
Management datagrams (MADs) by checking if the "mad_agent" pointer is
initialized before calling ib_modify_port, also fix the error flow in
srpt_refresh_port() to disable device management if
ib_register_mad_agent() fail.

Fixes: 09f8a1486dca ("RDMA/srpt: Fix handling of SR-IOV and iWARP ports")
Link: https://lore.kernel.org/r/20200514114720.141139-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 98552749d71c..fcf982c60db6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -610,6 +610,11 @@ static int srpt_refresh_port(struct srpt_port *sport)
 			       dev_name(&sport->sdev->device->dev), sport->port,
 			       PTR_ERR(sport->mad_agent));
 			sport->mad_agent = NULL;
+			memset(&port_modify, 0, sizeof(port_modify));
+			port_modify.clr_port_cap_mask = IB_PORT_DEVICE_MGMT_SUP;
+			ib_modify_port(sport->sdev->device, sport->port, 0,
+				       &port_modify);
+
 		}
 	}
 
@@ -633,9 +638,8 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
 		sport = &sdev->port[i - 1];
 		WARN_ON(sport->port != i);
-		if (ib_modify_port(sdev->device, i, 0, &port_modify) < 0)
-			pr_err("disabling MAD processing failed.\n");
 		if (sport->mad_agent) {
+			ib_modify_port(sdev->device, i, 0, &port_modify);
 			ib_unregister_mad_agent(sport->mad_agent);
 			sport->mad_agent = NULL;
 		}
-- 
2.25.1

