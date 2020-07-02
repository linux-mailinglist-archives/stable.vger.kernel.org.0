Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99716211851
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgGBB0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbgGBB0x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3887D20C56;
        Thu,  2 Jul 2020 01:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653213;
        bh=rnB7oV8v4NfwAOxGZ3yJ0hQ68m7fINDU3JLiiRZH5vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6a30b7Ika6Zqgcyr0ZeGdRbb3I7dUka/GKxD9tED4UzXUigumFmiyJB/XwDRaVPW
         nmBt69lI+/65FeDZkJsHyNh6gOsn8kZEyDxNXKd3rgAe9XiOPD4SqFow+Jf3tzCt1u
         1bmeToBNrZNeDxuOONe741lAOxFREe0PymVx46BI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/17] gpu: host1x: Detach driver on unregister
Date:   Wed,  1 Jul 2020 21:26:34 -0400
Message-Id: <20200702012649.2701799-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012649.2701799-1-sashal@kernel.org>
References: <20200702012649.2701799-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f9cde03030fd9..c2a9dcf6f4907 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -615,8 +615,17 @@ EXPORT_SYMBOL(host1x_driver_register_full);
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

