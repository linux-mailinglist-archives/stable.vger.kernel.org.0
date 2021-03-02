Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF68632AEFC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhCCANF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:13:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1442171AbhCBLMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 06:12:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614683453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=26no2Euxz229uNPGGSPMIPv1BH7z3aczHK5kuw4J2TA=;
        b=L69F0w4ft/K1J7P8DFOXVyAZjMXs4bnhWOWKVWFwA1t5jQFCzAjmWKHA8JwKiBa7nM18AW
        6WldZfR99tpEyGtPyb8GWwL0mjKpuaNYLDvGsjU03KDAd3WrBNzMgaXbaumfElfUoIDBTW
        BVeiUoojvoRjPFaOFgjqVliFt1JJNvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-fvgA2PVvOTm2kQpONBOZgA-1; Tue, 02 Mar 2021 06:10:51 -0500
X-MC-Unique: fvgA2PVvOTm2kQpONBOZgA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26E1918B9ECD;
        Tue,  2 Mar 2021 11:10:50 +0000 (UTC)
Received: from gondolin.redhat.com (ovpn-113-150.ams2.redhat.com [10.36.113.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 152A162665;
        Tue,  2 Mar 2021 11:10:48 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     stable@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14.y] virtio/s390: implement virtio-ccw revision 2 correctly
Date:   Tue,  2 Mar 2021 12:10:46 +0100
Message-Id: <20210302111046.1409359-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[backport of commit 182f709c5cff683e6732d04c78e328de0532284f to
 4.14-stable; context diff in second hunk]

CCW_CMD_READ_STATUS was introduced with revision 2 of virtio-ccw,
and drivers should only rely on it being implemented when they
negotiated at least that revision with the device.

However, virtio_ccw_get_status() issued READ_STATUS for any
device operating at least at revision 1. If the device accepts
READ_STATUS regardless of the negotiated revision (which some
implementations like QEMU do, even though the spec currently does
not allow it), everything works as intended. While a device
rejecting the command should also be handled gracefully, we will
not be able to see any changes the device makes to the status,
such as setting NEEDS_RESET or setting the status to zero after
a completed reset.

We negotiated the revision to at most 1, as we never bumped the
maximum revision; let's do that now and properly send READ_STATUS
only if we are operating at least at revision 2.

Cc: stable@vger.kernel.org
Fixes: 7d3ce5ab9430 ("virtio/s390: support READ_STATUS command for virtio-ccw")
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20210216110645.1087321-1-cohuck@redhat.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/virtio/virtio_ccw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index f9cf676a0469..56794b13bb12 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -106,7 +106,7 @@ struct virtio_rev_info {
 };
 
 /* the highest virtio-ccw revision we support */
-#define VIRTIO_CCW_REV_MAX 1
+#define VIRTIO_CCW_REV_MAX 2
 
 struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
@@ -911,7 +911,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 	u8 old_status = *vcdev->status;
 	struct ccw1 *ccw;
 
-	if (vcdev->revision < 1)
+	if (vcdev->revision < 2)
 		return *vcdev->status;
 
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
-- 
2.26.2

