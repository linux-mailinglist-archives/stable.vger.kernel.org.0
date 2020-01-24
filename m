Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4419414846D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389689AbgAXLIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389686AbgAXLIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:08:44 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0608F20663;
        Fri, 24 Jan 2020 11:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864123;
        bh=eWRkYCS1XL9YkNnhsGLKtC1fiZMMAWnLCQqSNCv2kcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07l+EvSt7rOxws7pgJVaQzqehROTpHPziuHqrNSk2SNsubNrwqa5O5neMerO7f5Aw
         z3exCf4jX1ntxdSLaVLyzYH1xxN2cdsjv2cQi4psYpMufRDldmfvdqvKZqSRzlWcV2
         QUHlqnMAnaDjxvMqN9S+G0Ez9u7O98UMu5zZnEvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/639] driver core: Do not call rpm_put_suppliers() in pm_runtime_drop_link()
Date:   Fri, 24 Jan 2020 10:25:32 +0100
Message-Id: <20200124093107.474491990@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit a1fdbfbb1da2063ba98a12eb6f1bdd07451c7145 ]

Calling rpm_put_suppliers() from pm_runtime_drop_link() is excessive
as it affects all suppliers of the consumer device and not just the
one pointed to by the device link being dropped.  Worst case it may
cause the consumer device to stop working unexpectedly.  Moreover, in
principle it is racy with respect to runtime PM of the consumer
device.

To avoid these problems drop runtime PM references on the particular
supplier pointed to by the link in question only and do that after
the link has been dropped from the consumer device's list of links to
suppliers, which is in device_link_free().

Fixes: a0504aecba76 ("PM / runtime: Drop usage count for suppliers at device link removal")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c          | 3 +++
 drivers/base/power/runtime.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20ae18f44dcdf..7599147d5f83c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -357,6 +357,9 @@ EXPORT_SYMBOL_GPL(device_link_add);
 
 static void device_link_free(struct device_link *link)
 {
+	while (refcount_dec_not_one(&link->rpm_active))
+		pm_runtime_put(link->supplier);
+
 	put_device(link->consumer);
 	put_device(link->supplier);
 	kfree(link);
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index b914932d3ca1a..ab454c4533ba1 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1603,8 +1603,6 @@ void pm_runtime_new_link(struct device *dev)
 
 void pm_runtime_drop_link(struct device *dev)
 {
-	rpm_put_suppliers(dev);
-
 	spin_lock_irq(&dev->power.lock);
 	WARN_ON(dev->power.links_count == 0);
 	dev->power.links_count--;
-- 
2.20.1



