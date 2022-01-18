Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1AC492BD7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 18:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbiARREA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 12:04:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236454AbiARREA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 12:04:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642525439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gp9KSX6Flr6j6FmwJ5l+iw44DxlO8pNbZWCP2QxAjMw=;
        b=H1UviRQiKggq2JvODx04Xn6tigfT+WLe+2FuRfHL+3Y3E33zsw6Q08yAXQ0PbukC7nLUbF
        l0DrpmUCzaTYZ4v2stUj9SQ82JK42VtVzsX2Jln+KxvNF9VMMILiyzD/N+Gx/MaWjQKHrJ
        XLyejua2/zHsrrBHEjdujnMYWlV2r+8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-CiPMtiWqPZqui8711s-COg-1; Tue, 18 Jan 2022 12:03:58 -0500
X-MC-Unique: CiPMtiWqPZqui8711s-COg-1
Received: by mail-ed1-f72.google.com with SMTP id a8-20020a056402168800b004022fcdeb25so6876154edv.21
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 09:03:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gp9KSX6Flr6j6FmwJ5l+iw44DxlO8pNbZWCP2QxAjMw=;
        b=D0vymQ6CoeZaHW4svKBSEg0yFPdmBI3ii5P764RGA7kzZBqa2vbYizaDWsXZsHmWqn
         nPYxDumws3hZjDBw+/GiysXRQusps8TRkEMYlJoolAt/81PYduJaxSd9e18cl1JOQRYC
         U7h6P5exVYBqB/RC2co8wB1KsBWRJ21dl9QjHnS1yr+KXl81vk8LKyJNqiX4N6/lxa3F
         h5aVSNv+t9pvLgXBG5Xnou5yxGH41AmL0/x9qYs7QF52s6jz33OHT2AkTPLGvb03FKpy
         ENZoT30Q6HW3gnTZnCxbpcgpNqRYuPUTDjsRvsNaKuKIjLhvwg40IEf1I86X67lPWqrv
         hsWQ==
X-Gm-Message-State: AOAM533edVB84SlC224Svh285zEJSagSiJCF2Kl19q9ksvqslpHwIUeV
        xAlk1Tf6w96bQIjx0/V7llOYZdv8kIfPKj5npKweajCyEKg3OmdBCt5MrWg49MHP9zspdaYFdSn
        Us6Hw0Hk+mZuoG6ip
X-Received: by 2002:a05:6402:51c6:: with SMTP id r6mr26442200edd.129.1642525436688;
        Tue, 18 Jan 2022 09:03:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfgfOmVJ8BK0HjVcw/Hr9YnRhWaJmgMtpY0BioTVBV93Ej3a8ugF3NkU9nC+CEupjnMcNFjg==
X-Received: by 2002:a05:6402:51c6:: with SMTP id r6mr26442170edd.129.1642525436411;
        Tue, 18 Jan 2022 09:03:56 -0800 (PST)
Received: from redhat.com ([2.55.154.241])
        by smtp.gmail.com with ESMTPSA id d8sm117917edz.62.2022.01.18.09.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 09:03:55 -0800 (PST)
Date:   Tue, 18 Jan 2022 12:03:41 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: [PATCH v2 2/2] virtio: acknowledge all features before access
Message-ID: <20220118170225.30620-2-mst@redhat.com>
References: <20220118170225.30620-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118170225.30620-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
Cc: "Halil Pasic" <pasic@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

fixup! virtio: acknowledge all features before access
---
 drivers/virtio/virtio.c       | 39 ++++++++++++++++++++---------------
 include/linux/virtio_config.h |  3 ++-
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index d891b0a354b0..d6396be0ea83 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -166,14 +166,13 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
 }
 EXPORT_SYMBOL_GPL(virtio_add_status);
 
-static int virtio_finalize_features(struct virtio_device *dev)
+/* Do some validation, then set FEATURES_OK */
+static int virtio_features_ok(struct virtio_device *dev)
 {
-	int ret = dev->config->finalize_features(dev);
 	unsigned status;
+	int ret;
 
 	might_sleep();
-	if (ret)
-		return ret;
 
 	ret = arch_has_restricted_virtio_memory_access();
 	if (ret) {
@@ -244,17 +243,6 @@ static int virtio_dev_probe(struct device *_d)
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
@@ -265,13 +253,26 @@ static int virtio_dev_probe(struct device *_d)
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
 
@@ -495,7 +496,11 @@ int virtio_device_restore(struct virtio_device *dev)
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
 
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 4d107ad31149..dafdc7f48c01 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -64,8 +64,9 @@ struct virtio_shm_region {
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
-- 
MST

