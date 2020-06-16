Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A071FB95C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgFPPt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbgFPPty (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:49:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FD562071A;
        Tue, 16 Jun 2020 15:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322593;
        bh=PyvlkaWrcbPam4O4e/8ZNE9XZyO8pT0w6I3T8D0LlBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hq5eQDAeWuws2J9x26nFZskqd03gklzFH2KYdbV+QoQo6ocTMvS7QaySX7k2eXnPO
         SAg9k9Sttc+RkXomgBOoNA/rXvNj1Y1nP5C+mb4glajDLg8NBx7JfSdaezFFWVg1HL
         EYJgXAPQz+cPQmrLfIC56n+4xBkGInWe1OAef7tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rrafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 028/161] driver core: Update device link status correctly for SYNC_STATE_ONLY links
Date:   Tue, 16 Jun 2020 17:33:38 +0200
Message-Id: <20200616153107.740672845@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 8c3e315d4296421cd26b3300ee0ac117f0877f20 ]

When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
core: Add device link support for SYNC_STATE_ONLY flag"),
SYNC_STATE_ONLY links were treated similar to STATELESS links in terms
of not blocking consumer probe if the supplier hasn't probed yet.

That caused a SYNC_STATE_ONLY device link's status to not get updated.
Since SYNC_STATE_ONLY device link is no longer useful once the
consumer probes, commit 21c27f06587d ("driver core: Fix
SYNC_STATE_ONLY device link implementation") addresses the status
update issue by deleting the SYNC_STATE_ONLY device link instead of
complicating the status update code.

However, there are still some cases where we need to update the status
of a SYNC_STATE_ONLY device link. This is because a SYNC_STATE_ONLY
device link can later get converted into a normal MANAGED device link
when a normal MANAGED device link is created between a supplier and
consumer that already have a SYNC_STATE_ONLY device link between them.

If a SYNC_STATE_ONLY device link's status isn't maintained correctly
till it's converted to a normal MANAGED device link, then the normal
MANAGED device link will end up with a wrong link status. This can cause
a warning stack trace[1] when the consumer device probes successfully.

This commit fixes the SYNC_STATE_ONLY device link status update issue
where it wouldn't transition correctly from DL_STATE_DORMANT or
DL_STATE_AVAILABLE to DL_STATE_CONSUMER_PROBE. It also resets the status
back to DL_STATE_DORMANT or DL_STATE_AVAILABLE if the consumer probe
fails.

[1] - https://lore.kernel.org/lkml/20200522204120.3b3c9ed6@apollo/
Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
Fixes: 21c27f06587d ("driver core: Fix SYNC_STATE_ONLY device link implementation")
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Rafael J. Wysocki <rrafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20200526220928.49939-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 68277687c160..3c4ecb824247 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -643,9 +643,17 @@ static void device_links_missing_supplier(struct device *dev)
 {
 	struct device_link *link;
 
-	list_for_each_entry(link, &dev->links.suppliers, c_node)
-		if (link->status == DL_STATE_CONSUMER_PROBE)
+	list_for_each_entry(link, &dev->links.suppliers, c_node) {
+		if (link->status != DL_STATE_CONSUMER_PROBE)
+			continue;
+
+		if (link->supplier->links.status == DL_DEV_DRIVER_BOUND) {
 			WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
+		} else {
+			WARN_ON(!(link->flags & DL_FLAG_SYNC_STATE_ONLY));
+			WRITE_ONCE(link->status, DL_STATE_DORMANT);
+		}
+	}
 }
 
 /**
@@ -684,11 +692,11 @@ int device_links_check_suppliers(struct device *dev)
 	device_links_write_lock();
 
 	list_for_each_entry(link, &dev->links.suppliers, c_node) {
-		if (!(link->flags & DL_FLAG_MANAGED) ||
-		    link->flags & DL_FLAG_SYNC_STATE_ONLY)
+		if (!(link->flags & DL_FLAG_MANAGED))
 			continue;
 
-		if (link->status != DL_STATE_AVAILABLE) {
+		if (link->status != DL_STATE_AVAILABLE &&
+		    !(link->flags & DL_FLAG_SYNC_STATE_ONLY)) {
 			device_links_missing_supplier(dev);
 			ret = -EPROBE_DEFER;
 			break;
@@ -949,11 +957,21 @@ static void __device_links_no_driver(struct device *dev)
 		if (!(link->flags & DL_FLAG_MANAGED))
 			continue;
 
-		if (link->flags & DL_FLAG_AUTOREMOVE_CONSUMER)
+		if (link->flags & DL_FLAG_AUTOREMOVE_CONSUMER) {
 			device_link_drop_managed(link);
-		else if (link->status == DL_STATE_CONSUMER_PROBE ||
-			 link->status == DL_STATE_ACTIVE)
+			continue;
+		}
+
+		if (link->status != DL_STATE_CONSUMER_PROBE &&
+		    link->status != DL_STATE_ACTIVE)
+			continue;
+
+		if (link->supplier->links.status == DL_DEV_DRIVER_BOUND) {
 			WRITE_ONCE(link->status, DL_STATE_AVAILABLE);
+		} else {
+			WARN_ON(!(link->flags & DL_FLAG_SYNC_STATE_ONLY));
+			WRITE_ONCE(link->status, DL_STATE_DORMANT);
+		}
 	}
 
 	dev->links.status = DL_DEV_NO_DRIVER;
-- 
2.25.1



