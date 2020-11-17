Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0921A2B62E2
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731908AbgKQNck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:42440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732322AbgKQNcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C48C32078E;
        Tue, 17 Nov 2020 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619959;
        bh=1bGqEOXpk0hm8uIgX2dJ8U9XAH9cjPnVfN81Puua2XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sowWMSUyBXF4qHZGykFnl6lYFhT/IKA7JTj4aj0kWcFeNnszDNSKq4TnKtAYhCVmD
         UqKgTMIz2HmUgX6CTrFTwIX7HzbrJC3k5HH2UUH/ws5F9oCqjisALdTTu/OwN88ief
         P7mA7giY1VZ6HD25iPNcGPuR2M6GHfjtmZG9YASI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 031/255] IB/srpt: Fix memory leak in srpt_add_one
Date:   Tue, 17 Nov 2020 14:02:51 +0100
Message-Id: <20201117122140.460354493@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 372a1786283e50e7cb437ab7fdb1b95597310ad7 ]

Failure in srpt_refresh_port() for the second port will leave MAD
registered for the first one, however, the srpt_add_one() will be marked
as "failed" and SRPT will leak resources for that registered but not used
and released first port.

Unregister the MAD agent for all ports in case of failure.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Link: https://lore.kernel.org/r/20201028065051.112430-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0065eb17ae36b..1b096305de1a4 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -622,10 +622,11 @@ static int srpt_refresh_port(struct srpt_port *sport)
 /**
  * srpt_unregister_mad_agent - unregister MAD callback functions
  * @sdev: SRPT HCA pointer.
+ * #port_cnt: number of ports with registered MAD
  *
  * Note: It is safe to call this function more than once for the same device.
  */
-static void srpt_unregister_mad_agent(struct srpt_device *sdev)
+static void srpt_unregister_mad_agent(struct srpt_device *sdev, int port_cnt)
 {
 	struct ib_port_modify port_modify = {
 		.clr_port_cap_mask = IB_PORT_DEVICE_MGMT_SUP,
@@ -633,7 +634,7 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	struct srpt_port *sport;
 	int i;
 
-	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
+	for (i = 1; i <= port_cnt; i++) {
 		sport = &sdev->port[i - 1];
 		WARN_ON(sport->port != i);
 		if (sport->mad_agent) {
@@ -3185,7 +3186,8 @@ static int srpt_add_one(struct ib_device *device)
 		if (ret) {
 			pr_err("MAD registration failed for %s-%d.\n",
 			       dev_name(&sdev->device->dev), i);
-			goto err_event;
+			i--;
+			goto err_port;
 		}
 	}
 
@@ -3197,7 +3199,8 @@ static int srpt_add_one(struct ib_device *device)
 	pr_debug("added %s.\n", dev_name(&device->dev));
 	return 0;
 
-err_event:
+err_port:
+	srpt_unregister_mad_agent(sdev, i);
 	ib_unregister_event_handler(&sdev->event_handler);
 err_cm:
 	if (sdev->cm_id)
@@ -3221,7 +3224,7 @@ static void srpt_remove_one(struct ib_device *device, void *client_data)
 	struct srpt_device *sdev = client_data;
 	int i;
 
-	srpt_unregister_mad_agent(sdev);
+	srpt_unregister_mad_agent(sdev, sdev->device->phys_port_cnt);
 
 	ib_unregister_event_handler(&sdev->event_handler);
 
-- 
2.27.0



