Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92B938AB54
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240587AbhETLXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240612AbhETLVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3664861D8B;
        Thu, 20 May 2021 10:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505478;
        bh=Ib3Rf7fOtI18G1hLrQ1hr2G3Y9ChlM74GR7dIzqlUmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQxP5pmIh/dvoDNnEfBUT+NkWDGU+RJntoTxmW/2gCmYQohATVsvjcuoPNlNEP1TN
         2yVkvCf3mdPrVJGSO3e5r7yQAMFpnbgJ0Ms2Dxz7JHk4lejFgmM6uXePwy2by+4usm
         nBbI2w3YWhb8+9DAaDgKJzq56/o4/9DdZ7O9Rs0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 109/190] HSI: core: fix resource leaks in hsi_add_client_from_dt()
Date:   Thu, 20 May 2021 11:22:53 +0200
Message-Id: <20210520092105.794467347@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 5c08b0f75575648032f309a6f58294453423ed93 ]

If some of the allocations fail between the dev_set_name() and the
device_register() then the name will not be freed.  Fix this by
moving dev_set_name() directly in front of the call to device_register().

Fixes: a2aa24734d9d ("HSI: Add common DT binding for HSI client devices")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/hsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index df380d55c58f..55e36fcd7ff3 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -223,8 +223,6 @@ static void hsi_add_client_from_dt(struct hsi_port *port,
 	if (err)
 		goto err;
 
-	dev_set_name(&cl->device, "%s", name);
-
 	err = hsi_of_property_parse_mode(client, "hsi-mode", &mode);
 	if (err) {
 		err = hsi_of_property_parse_mode(client, "hsi-rx-mode",
@@ -307,6 +305,7 @@ static void hsi_add_client_from_dt(struct hsi_port *port,
 	cl->device.release = hsi_client_release;
 	cl->device.of_node = client;
 
+	dev_set_name(&cl->device, "%s", name);
 	if (device_register(&cl->device) < 0) {
 		pr_err("hsi: failed to register client: %s\n", name);
 		put_device(&cl->device);
-- 
2.30.2



