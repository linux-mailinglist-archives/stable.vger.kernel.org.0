Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE9C6AF059
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjCGSaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjCGS3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:29:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230C22CFCF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:23:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D569B818EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C718BC433EF;
        Tue,  7 Mar 2023 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213381;
        bh=cGk+zTdHgqk+6y/xroC7BPL2QM2Y92Xstss8k2IjGNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8hyY1pTVBjFYKmirv+F/dCEV46TdjsRfOvvb8UdBwanRdy8i2gqcYBY16O++p39d
         H9gBeK+KY4w8g3b1Ngtd3LMVPtb0gtPUS8BUosKLaSLLTN5jIJHn+eKTnY95IdcwpB
         vWKtcfRhc34Gd7M1CSvzbieZgh4hqJ6WPkOC4Ud4=
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
Subject: [PATCH 6.1 472/885] driver core: fw_devlink: Consolidate device link flag computation
Date:   Tue,  7 Mar 2023 17:56:46 +0100
Message-Id: <20230307170023.014965938@linuxfoundation.org>
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

[ Upstream commit cd115c0409f283edde94bd5a9a42dc42bee0aba8 ]

Consolidate the code that computes the flags to be used when creating a
device link from a fwnode link.

Fixes: 2de9d8e0d2fe ("driver core: fw_devlink: Improve handling of cyclic dependencies")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcom/sm7225-fairphone-fp4
Link: https://lore.kernel.org/r/20230207014207.1678715-8-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 28 +++++++++++++++-------------
 include/linux/fwnode.h |  1 -
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 24c48fe3a0252..f623ebc131f8d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1726,8 +1726,11 @@ static int __init fw_devlink_strict_setup(char *arg)
 }
 early_param("fw_devlink.strict", fw_devlink_strict_setup);
 
-u32 fw_devlink_get_flags(void)
+static inline u32 fw_devlink_get_flags(u8 fwlink_flags)
 {
+	if (fwlink_flags & FWLINK_FLAG_CYCLE)
+		return FW_DEVLINK_FLAGS_PERMISSIVE | DL_FLAG_CYCLE;
+
 	return fw_devlink_flags;
 }
 
@@ -1908,7 +1911,7 @@ static int fw_devlink_relax_cycle(struct device *con, void *sup)
  * fw_devlink_create_devlink - Create a device link from a consumer to fwnode
  * @con: consumer device for the device link
  * @sup_handle: fwnode handle of supplier
- * @flags: devlink flags
+ * @link: fwnode link that's being converted to a device link
  *
  * This function will try to create a device link between the consumer device
  * @con and the supplier device represented by @sup_handle.
@@ -1925,10 +1928,17 @@ static int fw_devlink_relax_cycle(struct device *con, void *sup)
  *  possible to do that in the future
  */
 static int fw_devlink_create_devlink(struct device *con,
-				     struct fwnode_handle *sup_handle, u32 flags)
+				     struct fwnode_handle *sup_handle,
+				     struct fwnode_link *link)
 {
 	struct device *sup_dev;
 	int ret = 0;
+	u32 flags;
+
+	if (con->fwnode == link->consumer)
+		flags = fw_devlink_get_flags(link->flags);
+	else
+		flags = FW_DEVLINK_FLAGS_PERMISSIVE;
 
 	/*
 	 * In some cases, a device P might also be a supplier to its child node
@@ -2054,7 +2064,6 @@ static void __fw_devlink_link_to_consumers(struct device *dev)
 	struct fwnode_link *link, *tmp;
 
 	list_for_each_entry_safe(link, tmp, &fwnode->consumers, s_hook) {
-		u32 dl_flags = fw_devlink_get_flags();
 		struct device *con_dev;
 		bool own_link = true;
 		int ret;
@@ -2084,14 +2093,13 @@ static void __fw_devlink_link_to_consumers(struct device *dev)
 				con_dev = NULL;
 			} else {
 				own_link = false;
-				dl_flags = FW_DEVLINK_FLAGS_PERMISSIVE;
 			}
 		}
 
 		if (!con_dev)
 			continue;
 
-		ret = fw_devlink_create_devlink(con_dev, fwnode, dl_flags);
+		ret = fw_devlink_create_devlink(con_dev, fwnode, link);
 		put_device(con_dev);
 		if (!own_link || ret == -EAGAIN)
 			continue;
@@ -2132,19 +2140,13 @@ static void __fw_devlink_link_to_suppliers(struct device *dev,
 	bool own_link = (dev->fwnode == fwnode);
 	struct fwnode_link *link, *tmp;
 	struct fwnode_handle *child = NULL;
-	u32 dl_flags;
-
-	if (own_link)
-		dl_flags = fw_devlink_get_flags();
-	else
-		dl_flags = FW_DEVLINK_FLAGS_PERMISSIVE;
 
 	list_for_each_entry_safe(link, tmp, &fwnode->suppliers, c_hook) {
 		int ret;
 		struct device *sup_dev;
 		struct fwnode_handle *sup = link->supplier;
 
-		ret = fw_devlink_create_devlink(dev, sup, dl_flags);
+		ret = fw_devlink_create_devlink(dev, sup, link);
 		if (!own_link || ret == -EAGAIN)
 			continue;
 
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index fdf2ee0285b7a..5700451b300fb 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -207,7 +207,6 @@ static inline void fwnode_dev_initialized(struct fwnode_handle *fwnode,
 		fwnode->flags &= ~FWNODE_FLAG_INITIALIZED;
 }
 
-extern u32 fw_devlink_get_flags(void);
 extern bool fw_devlink_is_strict(void);
 int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup);
 void fwnode_links_purge(struct fwnode_handle *fwnode);
-- 
2.39.2



