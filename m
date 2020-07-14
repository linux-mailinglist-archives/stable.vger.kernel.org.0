Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8D21FCC2
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgGNStF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgGNStF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:49:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECCCB22B2C;
        Tue, 14 Jul 2020 18:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752544;
        bh=bP4Svco64tcbNZ0VKLuxdblCqIX6tIwtPXqy85bho7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jzjvsb0ZpVX4zzz3EQ8cx4EO9I4wjcEViTxWPz8z4+xJe7c94otudtWlyIoPK0HRw
         m4+FaM0YvNyh0OToFxPofNVDabCQMC62ltDtjzXft56Bl8wlts6eSyk+IZ8IZMfTvA
         7lH2b6LAOm7ho4biYWt9a74kQYchWXSucSMXhKfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/109] gpu: host1x: Detach driver on unregister
Date:   Tue, 14 Jul 2020 20:43:13 +0200
Message-Id: <20200714184106.019140730@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit d9a0a05bf8c76e6dc79230669a8b5d685b168c30 ]

Currently when a host1x device driver is unregistered, it is not
detached from the host1x controller, which means that the device
will stay around and when the driver is registered again, it may
bind to the old, stale device rather than the new one that was
created from scratch upon driver registration. This in turn can
cause various weird crashes within the driver core because it is
confronted with a device that was already deleted.

Fix this by detaching the driver from the host1x controller when
it is unregistered. This ensures that the deleted device also is
no longer present in the device list that drivers will bind to.

Reported-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/bus.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index 742aa9ff21b87..fcda8621ae6f9 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -686,8 +686,17 @@ EXPORT_SYMBOL(host1x_driver_register_full);
  */
 void host1x_driver_unregister(struct host1x_driver *driver)
 {
+	struct host1x *host1x;
+
 	driver_unregister(&driver->driver);
 
+	mutex_lock(&devices_lock);
+
+	list_for_each_entry(host1x, &devices, list)
+		host1x_detach_driver(host1x, driver);
+
+	mutex_unlock(&devices_lock);
+
 	mutex_lock(&drivers_lock);
 	list_del_init(&driver->list);
 	mutex_unlock(&drivers_lock);
-- 
2.25.1



