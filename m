Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D518B42100D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbhJDNkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238488AbhJDNih (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57CFB61BB2;
        Mon,  4 Oct 2021 13:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353458;
        bh=9KhqeDG8312Ingw/vmRTdRLJRQ+HJQrM09/MRBuI6wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bgyt3RSJOPplEWkYbMj1B996+4F04iuJA5FgilXPSs7NvukNFij1K84Dp4G5ezoI+
         uQZD5oiPW/X7w+A7kJx89Lnu07dMfpMDNrDFgbY2tBa8FAEwZAqhYZJqcZhIV8gq9M
         13FQJQk39+5DLZrDKJRZXAJvBLDW4313/mOdvKcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 093/172] driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
Date:   Mon,  4 Oct 2021 14:52:23 +0200
Message-Id: <20211004125047.995287597@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 5501765a02a6c324f78581e6bb8209d054fe13ae ]

If a parent device is also a supplier to a child device, fw_devlink=on by
design delays the probe() of the child device until the probe() of the
parent finishes successfully.

However, some drivers of such parent devices (where parent is also a
supplier) expect the child device to finish probing successfully as soon as
they are added using device_add() and before the probe() of the parent
device has completed successfully. One example of such a case is discussed
in the link mentioned below.

Add a flag to make fw_devlink=on not enforce these supplier-consumer
relationships, so these drivers can continue working.

Link: https://lore.kernel.org/netdev/CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com/
Fixes: ea718c699055 ("Revert "Revert "driver core: Set fw_devlink=on by default""")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210915170940.617415-3-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 19 +++++++++++++++++++
 include/linux/fwnode.h | 11 ++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8c77e14987d4..3d2fc70b9951 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1721,6 +1721,25 @@ static int fw_devlink_create_devlink(struct device *con,
 	struct device *sup_dev;
 	int ret = 0;
 
+	/*
+	 * In some cases, a device P might also be a supplier to its child node
+	 * C. However, this would defer the probe of C until the probe of P
+	 * completes successfully. This is perfectly fine in the device driver
+	 * model. device_add() doesn't guarantee probe completion of the device
+	 * by the time it returns.
+	 *
+	 * However, there are a few drivers that assume C will finish probing
+	 * as soon as it's added and before P finishes probing. So, we provide
+	 * a flag to let fw_devlink know not to delay the probe of C until the
+	 * probe of P completes successfully.
+	 *
+	 * When such a flag is set, we can't create device links where P is the
+	 * supplier of C as that would delay the probe of C.
+	 */
+	if (sup_handle->flags & FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD &&
+	    fwnode_is_ancestor_of(sup_handle, con->fwnode))
+		return -EINVAL;
+
 	sup_dev = get_dev_from_fwnode(sup_handle);
 	if (sup_dev) {
 		/*
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 59828516ebaf..9f4ad719bfe3 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -22,10 +22,15 @@ struct device;
  * LINKS_ADDED:	The fwnode has already be parsed to add fwnode links.
  * NOT_DEVICE:	The fwnode will never be populated as a struct device.
  * INITIALIZED: The hardware corresponding to fwnode has been initialized.
+ * NEEDS_CHILD_BOUND_ON_ADD: For this fwnode/device to probe successfully, its
+ *			     driver needs its child devices to be bound with
+ *			     their respective drivers as soon as they are
+ *			     added.
  */
-#define FWNODE_FLAG_LINKS_ADDED		BIT(0)
-#define FWNODE_FLAG_NOT_DEVICE		BIT(1)
-#define FWNODE_FLAG_INITIALIZED		BIT(2)
+#define FWNODE_FLAG_LINKS_ADDED			BIT(0)
+#define FWNODE_FLAG_NOT_DEVICE			BIT(1)
+#define FWNODE_FLAG_INITIALIZED			BIT(2)
+#define FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD	BIT(3)
 
 struct fwnode_handle {
 	struct fwnode_handle *secondary;
-- 
2.33.0



