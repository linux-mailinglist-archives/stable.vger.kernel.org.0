Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8A913F740
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387395AbgAPRA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387798AbgAPRA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8137A20728;
        Thu, 16 Jan 2020 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194026;
        bh=eJT0pA3Ews33BGcx/06b3r3W2gLnwH7uKFMyTpIy9kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=biDByIzCn/wKohE7kD5jZxsm4CHTDYP9ocWp2ODq3LsEk74QILN0iy7lkuVgiUoDv
         koi98ydKBohVwoiE37cWo94sPL3muU7AOxGFwF5kUgNG24nLIKVd8R4tq1sN8ggbOt
         gyOLMWkEaaZDRIAmc/r+2nQRjjCzjluJ8tflzUYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 146/671] driver core: Do not call rpm_put_suppliers() in pm_runtime_drop_link()
Date:   Thu, 16 Jan 2020 11:50:55 -0500
Message-Id: <20200116165940.10720-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

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
index 20ae18f44dcd..7599147d5f83 100644
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
index b914932d3ca1..ab454c4533ba 100644
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

