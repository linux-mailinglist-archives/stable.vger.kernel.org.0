Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF45147BF5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387666AbgAXJrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387676AbgAXJrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:47:49 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38F85206D5;
        Fri, 24 Jan 2020 09:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859268;
        bh=wwfrqVSElqD2J9lqJC+Y6J/tNlLKq0K7yDsR37nexT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cy5XQ1oIRVtsH8kVFUfJtHa7+H1dZNEVk6By7rdYt4URrW4b2u8harNdGcBNLul4V
         miGloTu8B/5/pfeTsGcMWDz+I7ri6fyw3gMqpZxeQib000z8P1kyYVk59cZOTw7RBb
         LXHgtvDc+Sxag9wdZRv3vyTlKE/qYs4zmO3b/kYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/343] driver core: Do not resume suppliers under device_links_write_lock()
Date:   Fri, 24 Jan 2020 10:28:19 +0100
Message-Id: <20200124092930.601494941@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5db25c9eb893df8f6b93c1d97b8006d768e1b6f5 ]

It is incorrect to call pm_runtime_get_sync() under
device_links_write_lock(), because it may end up trying to take
device_links_read_lock() while resuming the target device and that
will deadlock in the non-SRCU case, so avoid that by resuming the
supplier device in device_link_add() before calling
device_links_write_lock().

Fixes: 21d5c57b3726 ("PM / runtime: Use device links")
Fixes: baa8809f6097 ("PM / runtime: Optimize the use of device links")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b0a1054535ce..93c2fc58013ed 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -180,11 +180,20 @@ struct device_link *device_link_add(struct device *consumer,
 				    struct device *supplier, u32 flags)
 {
 	struct device_link *link;
+	bool rpm_put_supplier = false;
 
 	if (!consumer || !supplier ||
 	    ((flags & DL_FLAG_STATELESS) && (flags & DL_FLAG_AUTOREMOVE)))
 		return NULL;
 
+	if (flags & DL_FLAG_PM_RUNTIME && flags & DL_FLAG_RPM_ACTIVE) {
+		if (pm_runtime_get_sync(supplier) < 0) {
+			pm_runtime_put_noidle(supplier);
+			return NULL;
+		}
+		rpm_put_supplier = true;
+	}
+
 	device_links_write_lock();
 	device_pm_lock();
 
@@ -209,13 +218,8 @@ struct device_link *device_link_add(struct device *consumer,
 
 	if (flags & DL_FLAG_PM_RUNTIME) {
 		if (flags & DL_FLAG_RPM_ACTIVE) {
-			if (pm_runtime_get_sync(supplier) < 0) {
-				pm_runtime_put_noidle(supplier);
-				kfree(link);
-				link = NULL;
-				goto out;
-			}
 			link->rpm_active = true;
+			rpm_put_supplier = false;
 		}
 		pm_runtime_new_link(consumer);
 		/*
@@ -286,6 +290,10 @@ struct device_link *device_link_add(struct device *consumer,
  out:
 	device_pm_unlock();
 	device_links_write_unlock();
+
+	if (rpm_put_supplier)
+		pm_runtime_put(supplier);
+
 	return link;
 }
 EXPORT_SYMBOL_GPL(device_link_add);
-- 
2.20.1



