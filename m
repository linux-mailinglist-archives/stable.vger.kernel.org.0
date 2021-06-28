Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785313B6031
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhF1OWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhF1OV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF54E61C83;
        Mon, 28 Jun 2021 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889966;
        bh=MsshXwOVTdMZveGiqYEW42xX7VKhpFkIC19Vl47loLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0uSQfK80xNu3hotEaxqdVwrNiXu4q8w379W4F8cVaDEK4i+AlcCVb4tVP4MdM9vq
         29XCgwF/U/k1pWxgh+MS79/qG5J7bXs5rlQQJUkwfnoBq9U9kmmErt60qKnDiRozlJ
         9s0EsHTTqiYvGHBXAj0CCz/yI7yR6hc90jnoeITDCm1k8SRDoO3TEsnwq0ODhX/Hz/
         PDPST4wIrAL/M3KF/7J14rJJQuqkTmGAG94RpeH92hTLATo/kQ60MeIk27LmKG0VPE
         /gklFbDGtqAEJrj1k1Vetd5TEBcRd5TTrR2XGJTFIdvFEES7ePL/3ZR8gzCbOK/BiD
         ptq+OjPIdMnNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 067/110] software node: Handle software node injection to an existing device properly
Date:   Mon, 28 Jun 2021 10:17:45 -0400
Message-Id: <20210628141828.31757-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 5dca69e26fe97f17d4a6cbd6872103c868577b14 ]

The function software_node_notify() - the function that creates
and removes the symlinks between the node and the device - was
called unconditionally in device_add_software_node() and
device_remove_software_node(), but it needs to be called in
those functions only in the special case where the node is
added to a device that has already been registered.

This fixes NULL pointer dereference that happens if
device_remove_software_node() is used with device that was
never registered.

Fixes: b622b24519f5 ("software node: Allow node addition to already existing device")
Reported-and-tested-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 88310ac9ce90..62c536f9d925 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -1032,7 +1032,15 @@ int device_add_software_node(struct device *dev, const struct software_node *nod
 	}
 
 	set_secondary_fwnode(dev, &swnode->fwnode);
-	software_node_notify(dev, KOBJ_ADD);
+
+	/*
+	 * If the device has been fully registered by the time this function is
+	 * called, software_node_notify() must be called separately so that the
+	 * symlinks get created and the reference count of the node is kept in
+	 * balance.
+	 */
+	if (device_is_registered(dev))
+		software_node_notify(dev, KOBJ_ADD);
 
 	return 0;
 }
@@ -1052,7 +1060,8 @@ void device_remove_software_node(struct device *dev)
 	if (!swnode)
 		return;
 
-	software_node_notify(dev, KOBJ_REMOVE);
+	if (device_is_registered(dev))
+		software_node_notify(dev, KOBJ_REMOVE);
 	set_secondary_fwnode(dev, NULL);
 	kobject_put(&swnode->kobj);
 }
@@ -1106,8 +1115,7 @@ int software_node_notify(struct device *dev, unsigned long action)
 
 	switch (action) {
 	case KOBJ_ADD:
-		ret = sysfs_create_link_nowarn(&dev->kobj, &swnode->kobj,
-					       "software_node");
+		ret = sysfs_create_link(&dev->kobj, &swnode->kobj, "software_node");
 		if (ret)
 			break;
 
-- 
2.30.2

