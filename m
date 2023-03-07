Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E612A6AEAFC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjCGRjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjCGRin (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AB78C53D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:34:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E50B8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE92C433EF;
        Tue,  7 Mar 2023 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210483;
        bh=REW6aO2v/aelZGSE6c2tOk8tsu4KVA/BLgyud6ijnUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1/6cwqYz8Yedqdp5HoAOtie+I4xnD1lA6RCewfXz1ZoVYM9uOY37yJtnIhRSGJIr
         JiOOwKacYORuYqzb879Q8uHreYBg4bgR41crvC5dbyNS9D3ozOHGW5IKmDfr3h69T+
         GgO9hjZPYwCySdEQa5mzwr7+V9fZeFxVMT1tsFRA=
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
Subject: [PATCH 6.2 0554/1001] driver core: fw_devlink: Improve check for fwnode with no device/driver
Date:   Tue,  7 Mar 2023 17:55:26 +0100
Message-Id: <20230307170045.529111631@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 411c0d58ca6faa9bc4b9f5382118a31c7bb92a6f ]

fw_devlink shouldn't defer the probe of a device to wait on a supplier
that'll never have a struct device or will never be probed by a driver.
We currently check if a supplier falls into this category, but don't
check its ancestors. We need to check the ancestors too because if the
ancestor will never probe, then the supplier will never probe either.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcom/sm7225-fairphone-fp4
Link: https://lore.kernel.org/r/20230207014207.1678715-3-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 3fb16866b51d ("driver core: fw_devlink: Make cycle detection more robust")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 05c3e9a09b323..8f32e2cbcc63a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1908,6 +1908,35 @@ static int fw_devlink_relax_cycle(struct device *con, void *sup)
 	return ret;
 }
 
+static bool fwnode_init_without_drv(struct fwnode_handle *fwnode)
+{
+	struct device *dev;
+	bool ret;
+
+	if (!(fwnode->flags & FWNODE_FLAG_INITIALIZED))
+		return false;
+
+	dev = get_dev_from_fwnode(fwnode);
+	ret = !dev || dev->links.status == DL_DEV_NO_DRIVER;
+	put_device(dev);
+
+	return ret;
+}
+
+static bool fwnode_ancestor_init_without_drv(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *parent;
+
+	fwnode_for_each_parent_node(fwnode, parent) {
+		if (fwnode_init_without_drv(parent)) {
+			fwnode_handle_put(parent);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * fw_devlink_create_devlink - Create a device link from a consumer to fwnode
  * @con: consumer device for the device link
@@ -1996,9 +2025,16 @@ static int fw_devlink_create_devlink(struct device *con,
 		goto out;
 	}
 
-	/* Supplier that's already initialized without a struct device. */
-	if (sup_handle->flags & FWNODE_FLAG_INITIALIZED)
+	/*
+	 * Supplier or supplier's ancestor already initialized without a struct
+	 * device or being probed by a driver.
+	 */
+	if (fwnode_init_without_drv(sup_handle) ||
+	    fwnode_ancestor_init_without_drv(sup_handle)) {
+		dev_dbg(con, "Not linking %pfwP - Might never probe\n",
+			sup_handle);
 		return -EINVAL;
+	}
 
 	/*
 	 * DL_FLAG_SYNC_STATE_ONLY doesn't block probing and supports
-- 
2.39.2



