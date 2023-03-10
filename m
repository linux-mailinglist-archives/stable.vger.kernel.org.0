Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDCB6B49F6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbjCJPRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbjCJPQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:16:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00E161A1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 006736196E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48FEC433EF;
        Fri, 10 Mar 2023 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460836;
        bh=gSArcQeBInGNnE/75DQppn4fBcTQQLwjPqPQzVdksbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0jjcFUYoJJiHGw182MNCIqr8wD9Jbbl8ktxiHz2Go69SIea9sQchpcTtj8EHtUdt
         w5c86SEBcBCRUvhOx6qfzukX5NlhNMLT7DTDlDVUz6xz/k/wDsp9+qyf5P0Jjv9TJ1
         QqgECGfnddZXxHEhCLcwHjUhnr897sKgPjUEzp7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        Simon Horman <simon.horman@corigine.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 467/529] 9p/xen: fix connection sequence
Date:   Fri, 10 Mar 2023 14:40:10 +0100
Message-Id: <20230310133826.495537720@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit c15fe55d14b3b4ded5af2a3260877460a6ffb8ad ]

Today the connection sequence of the Xen 9pfs frontend doesn't match
the documented sequence. It can work reliably only for a PV 9pfs device
having been added at boot time already, as the frontend is not waiting
for the backend to have set its state to "XenbusStateInitWait" before
reading the backend properties from Xenstore.

Fix that by following the documented sequence [1] (the documentation
has a bug, so the reference is for the patch fixing that).

[1]: https://lore.kernel.org/xen-devel/20230130090937.31623-1-jgross@suse.com/T/#u

Link: https://lkml.kernel.org/r/20230130113036.7087-3-jgross@suse.com
Fixes: 868eb122739a ("xen/9pfs: introduce Xen 9pfs transport driver")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index d8ed75e8dbb1d..220e8f4ac0cfe 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -393,12 +393,11 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 	return ret;
 }
 
-static int xen_9pfs_front_probe(struct xenbus_device *dev,
-				const struct xenbus_device_id *id)
+static int xen_9pfs_front_init(struct xenbus_device *dev)
 {
 	int ret, i;
 	struct xenbus_transaction xbt;
-	struct xen_9pfs_front_priv *priv = NULL;
+	struct xen_9pfs_front_priv *priv = dev_get_drvdata(&dev->dev);
 	char *versions, *v;
 	unsigned int max_rings, max_ring_order, len = 0;
 
@@ -426,11 +425,6 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 	if (p9_xen_trans.maxsize > XEN_FLEX_RING_SIZE(max_ring_order))
 		p9_xen_trans.maxsize = XEN_FLEX_RING_SIZE(max_ring_order) / 2;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->dev = dev;
 	priv->num_rings = XEN_9PFS_NUM_RINGS;
 	priv->rings = kcalloc(priv->num_rings, sizeof(*priv->rings),
 			      GFP_KERNEL);
@@ -489,23 +483,35 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 		goto error;
 	}
 
-	write_lock(&xen_9pfs_lock);
-	list_add_tail(&priv->list, &xen_9pfs_devs);
-	write_unlock(&xen_9pfs_lock);
-	dev_set_drvdata(&dev->dev, priv);
-	xenbus_switch_state(dev, XenbusStateInitialised);
-
 	return 0;
 
  error_xenbus:
 	xenbus_transaction_end(xbt, 1);
 	xenbus_dev_fatal(dev, ret, "writing xenstore");
  error:
-	dev_set_drvdata(&dev->dev, NULL);
 	xen_9pfs_front_free(priv);
 	return ret;
 }
 
+static int xen_9pfs_front_probe(struct xenbus_device *dev,
+				const struct xenbus_device_id *id)
+{
+	struct xen_9pfs_front_priv *priv = NULL;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = dev;
+	dev_set_drvdata(&dev->dev, priv);
+
+	write_lock(&xen_9pfs_lock);
+	list_add_tail(&priv->list, &xen_9pfs_devs);
+	write_unlock(&xen_9pfs_lock);
+
+	return 0;
+}
+
 static int xen_9pfs_front_resume(struct xenbus_device *dev)
 {
 	dev_warn(&dev->dev, "suspend/resume unsupported\n");
@@ -524,6 +530,8 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
+		if (!xen_9pfs_front_init(dev))
+			xenbus_switch_state(dev, XenbusStateInitialised);
 		break;
 
 	case XenbusStateConnected:
-- 
2.39.2



