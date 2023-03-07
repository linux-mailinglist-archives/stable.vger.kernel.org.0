Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BEB6AF039
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbjCGS3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbjCGS3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE219B049D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:22:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0778ACE1C81
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A26C433EF;
        Tue,  7 Mar 2023 18:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213322;
        bh=04vQtvOQKewmrLiNfEkk3xEmc8kEXhQqKiy+lgmYg1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuXdoH6keI9hOa18Fxz5A7Pix9xSG7mesxyVoYtJqoau+/4b2sNmRrnfOGmTTOFCa
         AVqNSWP+/i38qFTFQc8RK931D6iHMbKhteDKvracSMtmFjwkXHT6wLz6QHsAMgiSZ0
         3Z5s2fKvt83IthOFiACkpvyno+CT2T6HZaxw2rO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saravana Kannan <saravanak@google.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Douglas Anderson <dianders@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 6.1 469/885] driver core: fw_devlink: Add DL_FLAG_CYCLE support to device links
Date:   Tue,  7 Mar 2023 17:56:43 +0100
Message-Id: <20230307170022.873322541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 67cad5c67019c38126b749621665b6723d3ae7e6 ]

fw_devlink uses DL_FLAG_SYNC_STATE_ONLY device link flag for two
purposes:

1. To allow a parent device to proxy its child device's dependency on a
   supplier so that the supplier doesn't get its sync_state() callback
   before the child device/consumer can be added and probed. In this
   usage scenario, we need to ignore cycles for ensure correctness of
   sync_state() callbacks.

2. When there are dependency cycles in firmware, we don't know which of
   those dependencies are valid. So, we have to ignore them all wrt
   probe ordering while still making sure the sync_state() callbacks
   come correctly.

However, when detecting dependency cycles, there can be multiple
dependency cycles between two devices that we need to detect. For
example:

A -> B -> A and A -> C -> B -> A.

To detect multiple cycles correct, we need to be able to differentiate
DL_FLAG_SYNC_STATE_ONLY device links used for (1) vs (2) above.

To allow this differentiation, add a DL_FLAG_CYCLE that can be use to
mark use case (2). We can then use the DL_FLAG_CYCLE to decide which
DL_FLAG_SYNC_STATE_ONLY device links to follow when looking for
dependency cycles.

Fixes: 2de9d8e0d2fe ("driver core: fw_devlink: Improve handling of cyclic dependencies")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcom/sm7225-fairphone-fp4
Link: https://lore.kernel.org/r/20230207014207.1678715-6-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 28 ++++++++++++++++++----------
 include/linux/device.h |  1 +
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 9019b81405bf2..816b0288579fd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -271,6 +271,12 @@ static bool device_is_ancestor(struct device *dev, struct device *target)
 	return false;
 }
 
+static inline bool device_link_flag_is_sync_state_only(u32 flags)
+{
+	return (flags & ~(DL_FLAG_INFERRED | DL_FLAG_CYCLE)) ==
+		(DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED);
+}
+
 /**
  * device_is_dependent - Check if one device depends on another one
  * @dev: Device to check dependencies for.
@@ -297,8 +303,7 @@ int device_is_dependent(struct device *dev, void *target)
 		return ret;
 
 	list_for_each_entry(link, &dev->links.consumers, s_node) {
-		if ((link->flags & ~DL_FLAG_INFERRED) ==
-		    (DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED))
+		if (device_link_flag_is_sync_state_only(link->flags))
 			continue;
 
 		if (link->consumer == target)
@@ -371,8 +376,7 @@ static int device_reorder_to_tail(struct device *dev, void *not_used)
 
 	device_for_each_child(dev, NULL, device_reorder_to_tail);
 	list_for_each_entry(link, &dev->links.consumers, s_node) {
-		if ((link->flags & ~DL_FLAG_INFERRED) ==
-		    (DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED))
+		if (device_link_flag_is_sync_state_only(link->flags))
 			continue;
 		device_reorder_to_tail(link->consumer, NULL);
 	}
@@ -633,7 +637,8 @@ postcore_initcall(devlink_class_init);
 			       DL_FLAG_AUTOREMOVE_SUPPLIER | \
 			       DL_FLAG_AUTOPROBE_CONSUMER  | \
 			       DL_FLAG_SYNC_STATE_ONLY | \
-			       DL_FLAG_INFERRED)
+			       DL_FLAG_INFERRED | \
+			       DL_FLAG_CYCLE)
 
 #define DL_ADD_VALID_FLAGS (DL_MANAGED_LINK_FLAGS | DL_FLAG_STATELESS | \
 			    DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE)
@@ -702,8 +707,6 @@ struct device_link *device_link_add(struct device *consumer,
 	if (!consumer || !supplier || consumer == supplier ||
 	    flags & ~DL_ADD_VALID_FLAGS ||
 	    (flags & DL_FLAG_STATELESS && flags & DL_MANAGED_LINK_FLAGS) ||
-	    (flags & DL_FLAG_SYNC_STATE_ONLY &&
-	     (flags & ~DL_FLAG_INFERRED) != DL_FLAG_SYNC_STATE_ONLY) ||
 	    (flags & DL_FLAG_AUTOPROBE_CONSUMER &&
 	     flags & (DL_FLAG_AUTOREMOVE_CONSUMER |
 		      DL_FLAG_AUTOREMOVE_SUPPLIER)))
@@ -719,6 +722,10 @@ struct device_link *device_link_add(struct device *consumer,
 	if (!(flags & DL_FLAG_STATELESS))
 		flags |= DL_FLAG_MANAGED;
 
+	if (flags & DL_FLAG_SYNC_STATE_ONLY &&
+	    !device_link_flag_is_sync_state_only(flags))
+		return NULL;
+
 	device_links_write_lock();
 	device_pm_lock();
 
@@ -1671,7 +1678,7 @@ static void fw_devlink_relax_link(struct device_link *link)
 	if (!(link->flags & DL_FLAG_INFERRED))
 		return;
 
-	if (link->flags == (DL_FLAG_MANAGED | FW_DEVLINK_FLAGS_PERMISSIVE))
+	if (device_link_flag_is_sync_state_only(link->flags))
 		return;
 
 	pm_runtime_drop_link(link);
@@ -1795,8 +1802,8 @@ static int fw_devlink_relax_cycle(struct device *con, void *sup)
 		return ret;
 
 	list_for_each_entry(link, &con->links.consumers, s_node) {
-		if ((link->flags & ~DL_FLAG_INFERRED) ==
-		    (DL_FLAG_SYNC_STATE_ONLY | DL_FLAG_MANAGED))
+		if (!(link->flags & DL_FLAG_CYCLE) &&
+		    device_link_flag_is_sync_state_only(link->flags))
 			continue;
 
 		if (!fw_devlink_relax_cycle(link->consumer, sup))
@@ -1805,6 +1812,7 @@ static int fw_devlink_relax_cycle(struct device *con, void *sup)
 		ret = 1;
 
 		fw_devlink_relax_link(link);
+		link->flags |= DL_FLAG_CYCLE;
 	}
 	return ret;
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 424b55df02727..7cf24330d6814 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -327,6 +327,7 @@ enum device_link_state {
 #define DL_FLAG_MANAGED			BIT(6)
 #define DL_FLAG_SYNC_STATE_ONLY		BIT(7)
 #define DL_FLAG_INFERRED		BIT(8)
+#define DL_FLAG_CYCLE			BIT(9)
 
 /**
  * enum dl_dev_state - Device driver presence tracking information.
-- 
2.39.2



