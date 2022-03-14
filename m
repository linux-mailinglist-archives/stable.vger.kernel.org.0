Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27CE4D8231
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbiCNMBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbiCNMA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:00:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E524926B;
        Mon, 14 Mar 2022 04:58:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3838A61251;
        Mon, 14 Mar 2022 11:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438F3C340EC;
        Mon, 14 Mar 2022 11:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259120;
        bh=z/rfUC3bs5xUQF7MrxppmBBSox12yeRXfJM/e/xowDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6L/MWMQzHs7tzoVLMW/gZI6Yd+y8mwNOBB0LucwfuliAk3q3pXlPkKAY5shyTn9E
         KHY0BGCNM8KrpbgFoQdxW/+gYd5P0DJOzyk3mRvH/rb7nOwWw5A1BD5ieJ8IgA4nrR
         wH5Ro6sTp8OLVm5GYhQSBxyy6vsq+EwQcqXb9UYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Halil Pasic" <pasic@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.4 37/43] virtio: acknowledge all features before access
Date:   Mon, 14 Mar 2022 12:53:48 +0100
Message-Id: <20220314112735.460634266@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

commit 4fa59ede95195f267101a1b8916992cf3f245cdb upstream.

The feature negotiation was designed in a way that
makes it possible for devices to know which config
fields will be accessed by drivers.

This is broken since commit 404123c2db79 ("virtio: allow drivers to
validate features") with fallout in at least block and net.  We have a
partial work-around in commit 2f9a174f918e ("virtio: write back
F_VERSION_1 before validate") which at least lets devices find out which
format should config space have, but this is a partial fix: guests
should not access config space without acknowledging features since
otherwise we'll never be able to change the config space format.

To fix, split finalize_features from virtio_finalize_features and
call finalize_features with all feature bits before validation,
and then - if validation changed any bits - once again after.

Since virtio_finalize_features no longer writes out features
rename it to virtio_features_ok - since that is what it does:
checks that features are ok with the device.

As a side effect, this also reduces the amount of hypervisor accesses -
we now only acknowledge features once unless we are clearing any
features when validating (which is uncommon).

IRC I think that this was more or less always the intent in the spec but
unfortunately the way the spec is worded does not say this explicitly, I
plan to address this at the spec level, too.

Acked-by: Jason Wang <jasowang@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
Cc: "Halil Pasic" <pasic@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio.c       |   38 +++++++++++++++++++++-----------------
 include/linux/virtio_config.h |    3 ++-
 2 files changed, 23 insertions(+), 18 deletions(-)

--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -167,14 +167,12 @@ void virtio_add_status(struct virtio_dev
 }
 EXPORT_SYMBOL_GPL(virtio_add_status);
 
-static int virtio_finalize_features(struct virtio_device *dev)
+/* Do some validation, then set FEATURES_OK */
+static int virtio_features_ok(struct virtio_device *dev)
 {
-	int ret = dev->config->finalize_features(dev);
 	unsigned status;
 
 	might_sleep();
-	if (ret)
-		return ret;
 
 	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
 		return 0;
@@ -224,17 +222,6 @@ static int virtio_dev_probe(struct devic
 		driver_features_legacy = driver_features;
 	}
 
-	/*
-	 * Some devices detect legacy solely via F_VERSION_1. Write
-	 * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
-	 * these when needed.
-	 */
-	if (drv->validate && !virtio_legacy_is_little_endian()
-			  && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
-		dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
-		dev->config->finalize_features(dev);
-	}
-
 	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
 		dev->features = driver_features & device_features;
 	else
@@ -245,13 +232,26 @@ static int virtio_dev_probe(struct devic
 		if (device_features & (1ULL << i))
 			__virtio_set_bit(dev, i);
 
+	err = dev->config->finalize_features(dev);
+	if (err)
+		goto err;
+
 	if (drv->validate) {
+		u64 features = dev->features;
+
 		err = drv->validate(dev);
 		if (err)
 			goto err;
+
+		/* Did validation change any features? Then write them again. */
+		if (features != dev->features) {
+			err = dev->config->finalize_features(dev);
+			if (err)
+				goto err;
+		}
 	}
 
-	err = virtio_finalize_features(dev);
+	err = virtio_features_ok(dev);
 	if (err)
 		goto err;
 
@@ -416,7 +416,11 @@ int virtio_device_restore(struct virtio_
 	/* We have a driver! */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
 
-	ret = virtio_finalize_features(dev);
+	ret = dev->config->finalize_features(dev);
+	if (ret)
+		goto err;
+
+	ret = virtio_features_ok(dev);
 	if (ret)
 		goto err;
 
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -56,8 +56,9 @@ struct irq_affinity;
  *	Returns the first 64 feature bits (all we currently need).
  * @finalize_features: confirm what device features we'll be using.
  *	vdev: the virtio_device
- *	This gives the final feature bits for the device: it can change
+ *	This sends the driver feature bits to the device: it can change
  *	the dev->feature bits if it wants.
+ * Note: despite the name this can be called any number of times.
  *	Returns 0 on success or error status
  * @bus_name: return the bus name associated with the device (optional)
  *	vdev: the virtio_device


