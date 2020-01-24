Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D14F148469
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgAXLId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389665AbgAXLIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:08:30 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8452920663;
        Fri, 24 Jan 2020 11:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864109;
        bh=ZNwfo03+JGyHN9RFQZGPM6JCe6Atx9L9vMIG3nyNoQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlopXTcr+u6FDrbMlixjTGKc7vFU2Vk5vozT8UKffXrht88QSvDQKqYcqgPieFLkK
         urVaIKv2VuD95zfiAtte9Vc720bnyGi1r2EnZS+tUvH/4SYoAfDe4H1m/tZR7oM6VK
         fLHyVfFkhagc5CUsoUA9CFbZlvE/cACRPFmEBOs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/639] driver core: Fix DL_FLAG_AUTOREMOVE_SUPPLIER device link flag handling
Date:   Fri, 24 Jan 2020 10:25:28 +0100
Message-Id: <20200124093106.988423955@linuxfoundation.org>
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

[ Upstream commit c8d50986da5d74ddfc233b13b91d0a13369fa164 ]

Change the list walk in device_links_driver_cleanup() to a safe one
to avoid use-after-free when dropping a link from the list during the
walk.

Also, while at it, fix device_link_add() to refuse to create
stateless device links with DL_FLAG_AUTOREMOVE_SUPPLIER set, which is
an invalid combination (setting that flag means that the driver core
should manage the link, so it cannot be stateless), and extend the
kerneldoc comment of device_link_add() to cover the
DL_FLAG_AUTOREMOVE_SUPPLIER flag properly too.

Fixes: 1689cac5b32a ("driver core: Add flag to autoremove device link on supplier unbind")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 985ccced33a21..055132f2292aa 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -179,10 +179,14 @@ void device_pm_move_to_tail(struct device *dev)
  * of the link.  If DL_FLAG_PM_RUNTIME is not set, DL_FLAG_RPM_ACTIVE will be
  * ignored.
  *
- * If the DL_FLAG_AUTOREMOVE_CONSUMER is set, the link will be removed
- * automatically when the consumer device driver unbinds from it.
- * The combination of both DL_FLAG_AUTOREMOVE_CONSUMER and DL_FLAG_STATELESS
- * set is invalid and will cause NULL to be returned.
+ * If the DL_FLAG_AUTOREMOVE_CONSUMER flag is set, the link will be removed
+ * automatically when the consumer device driver unbinds from it.  Analogously,
+ * if DL_FLAG_AUTOREMOVE_SUPPLIER is set in @flags, the link will be removed
+ * automatically when the supplier device driver unbinds from it.
+ *
+ * The combination of DL_FLAG_STATELESS and either DL_FLAG_AUTOREMOVE_CONSUMER
+ * or DL_FLAG_AUTOREMOVE_SUPPLIER set in @flags at the same time is invalid and
+ * will cause NULL to be returned upfront.
  *
  * A side effect of the link creation is re-ordering of dpm_list and the
  * devices_kset list by moving the consumer device and all devices depending
@@ -199,8 +203,8 @@ struct device_link *device_link_add(struct device *consumer,
 	struct device_link *link;
 
 	if (!consumer || !supplier ||
-	    ((flags & DL_FLAG_STATELESS) &&
-	     (flags & DL_FLAG_AUTOREMOVE_CONSUMER)))
+	    (flags & DL_FLAG_STATELESS &&
+	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER | DL_FLAG_AUTOREMOVE_SUPPLIER)))
 		return NULL;
 
 	device_links_write_lock();
@@ -539,11 +543,11 @@ void device_links_no_driver(struct device *dev)
  */
 void device_links_driver_cleanup(struct device *dev)
 {
-	struct device_link *link;
+	struct device_link *link, *ln;
 
 	device_links_write_lock();
 
-	list_for_each_entry(link, &dev->links.consumers, s_node) {
+	list_for_each_entry_safe(link, ln, &dev->links.consumers, s_node) {
 		if (link->flags & DL_FLAG_STATELESS)
 			continue;
 
-- 
2.20.1



