Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3002E48F0C1
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 21:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbiANUJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 15:09:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbiANUJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 15:09:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642190960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=thU4qAN6AqgkO3iygUwszvm6XkxjVvqIM4JafM153Ro=;
        b=VBu/tbUPLpDNyyBkzSerTHwYDuMEsoVOFBBzJb3iGhNlxxNwdEiEJI6FnY2klPsuZVNec9
        JTJKG1Hgf4VOvWNK4Mme9VbpiyK2m0jP9Em5b3RCmiekoidP12YT0nhRm00aC5R+r17gfQ
        Ve1RxEHI6ZjMHTQxNIYUmXqr1bGIlgc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-PKNpu-2dPPSVlmgXUjuF0Q-1; Fri, 14 Jan 2022 15:09:19 -0500
X-MC-Unique: PKNpu-2dPPSVlmgXUjuF0Q-1
Received: by mail-wm1-f71.google.com with SMTP id v185-20020a1cacc2000000b0034906580813so8651224wme.1
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 12:09:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=thU4qAN6AqgkO3iygUwszvm6XkxjVvqIM4JafM153Ro=;
        b=jz4tMbURNwHfrdn7Uwihf73T5IY90XXJIRfhKW6iPApnHzxKCdU6Qa1h5TSelN3jQL
         ywDqdoK83YSQBo2/Wx8ovKN0be4l7tluVm1Zp4g7GqidwfOFjtTT1FfC7TDmTNkReh/l
         Gf5tcB1EbQrKb4WFGq8fGrXYt2peIZsKlP/tCvm1YOVzQgHk6KItzJ/wK1sF1eW/vKtC
         iJXEQaCsIa+K5L2Evos7qRR97HkE8t24KTuLbD9InBa0idQWS36zCSBdzc6J9dMLTylo
         rhcDjGWuwsV3JCqdi4f8DF1DXR6MOpSu8dxW7q4zULetKHhLDM55a6+Mpm2chPKqv2H+
         hK+A==
X-Gm-Message-State: AOAM533so5JLT+LwTyLr85C/6tJzv6/fQhUHR2xW7eNcCUNJWP69PgWr
        JNNpjSIXzrXVNqdu/pbS9s8c7sTkV0Hen8SXawNNKEWiIOMBK9nkKgZ4tLfvcZ5+Ezdlj3nnxZv
        PdhET+JIx76d4rO1s
X-Received: by 2002:a1c:f414:: with SMTP id z20mr9703382wma.17.1642190957957;
        Fri, 14 Jan 2022 12:09:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEuXU7Zkd1anD16Nt37T1Zc+NsfqyKtrzn9R+BerhveX99jnGTLsev2YBwd+P+dVVUjg2/0A==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr9703360wma.17.1642190957631;
        Fri, 14 Jan 2022 12:09:17 -0800 (PST)
Received: from redhat.com ([2.55.154.210])
        by smtp.gmail.com with ESMTPSA id h14sm6071433wrz.31.2022.01.14.12.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 12:09:17 -0800 (PST)
Date:   Fri, 14 Jan 2022 15:09:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio: acknowledge all features before access
Message-ID: <20220114200744.150325-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The feature negotiation was designed in a way that
makes it possible for devices to know which config
fields will be accessed by drivers.

This is broken since commit 404123c2db79 ("virtio: allow drivers to
validate features") with fallout in at least block and net.
We have a partial work-around in commit 2f9a174f918e ("virtio: write
back F_VERSION_1 before validate") which at least lets devices
find out which format should config space have, but this
is a partial fix: guests should not access config space
without acknowledging features since otherwise we'll never
be able to change the config space format.

As a side effect, this also reduces the amount of hypervisor accesses -
we now only acknowledge features once unless we are clearing any
features when validating.

Cc: stable@vger.kernel.org
Fixes: 404123c2db79 ("virtio: allow drivers to validate features")
Fixes: 2f9a174f918e ("virtio: write back F_VERSION_1 before validate")
Cc: "Halil Pasic" <pasic@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Halil, I thought hard about our situation with transitional and
today I finally thought of something I am happy with.
Pls let me know what you think. Testing on big endian would
also be much appreciated!

 drivers/virtio/virtio.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index d891b0a354b0..2ed6e2451fd8 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -168,12 +168,10 @@ EXPORT_SYMBOL_GPL(virtio_add_status);
 
 static int virtio_finalize_features(struct virtio_device *dev)
 {
-	int ret = dev->config->finalize_features(dev);
 	unsigned status;
+	int ret;
 
 	might_sleep();
-	if (ret)
-		return ret;
 
 	ret = arch_has_restricted_virtio_memory_access();
 	if (ret) {
@@ -244,17 +242,6 @@ static int virtio_dev_probe(struct device *_d)
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
@@ -265,10 +252,22 @@ static int virtio_dev_probe(struct device *_d)
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
+		if (features != dev->features) {
+			err = dev->config->finalize_features(dev);
+			if (err)
+				goto err;
+		}
 	}
 
 	err = virtio_finalize_features(dev);
@@ -495,6 +494,10 @@ int virtio_device_restore(struct virtio_device *dev)
 	/* We have a driver! */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
 
+	ret = dev->config->finalize_features(dev);
+	if (ret)
+		goto err;
+
 	ret = virtio_finalize_features(dev);
 	if (ret)
 		goto err;
-- 
MST

