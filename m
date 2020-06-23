Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE7205C87
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbgFWUCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387929AbgFWUCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:02:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 816552078A;
        Tue, 23 Jun 2020 20:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942571;
        bh=lqyzhP1PQiVBIkYus2B1GyE3WsU8Zw/YfbY68zxjvR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DD9XhX9spv1rPCy1IDW7HxlHKhSUcOtHoEk25sXPdF7hvSNLtPSarqwIxGKMg9o5I
         RFVpaT5PW6krgXm+b+sspcdG1pJonXpioSkpoG1Yblk/qCCzOuojuwng5Agg3C4Cgu
         +ZvOqkriSilbfFikMEgc0gDrEY3WjLfmDGH60Dvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 051/477] RDMA/srpt: Fix disabling device management
Date:   Tue, 23 Jun 2020 21:50:48 +0200
Message-Id: <20200623195410.019319167@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 98552749d71cb..fcf982c60db6a 100644
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



