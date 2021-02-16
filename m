Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18EC31C964
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 12:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBPLJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 06:09:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230187AbhBPLIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 06:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613473614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IpPnQESKftP4YmMf+TpJQvg8smPe15Q/eS96QieNViM=;
        b=d2duA8GUjYgHLclbFEwC+hB+E8rdlWrZ8piRfI5P50IdsBcgC+AO7HccBRogaRYeHniX0A
        1No3OPNEMQuzStv0c1ygGtFBhrNvbyKvEo593nIQchZciaA3+KJ6z7Lsow08ek6IgG0SY6
        wyrsMrXfRnMPPB4dIb1RMhVI1cdxRU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-ib7Oj_NUMRODwPrYhZOZvA-1; Tue, 16 Feb 2021 06:06:52 -0500
X-MC-Unique: ib7Oj_NUMRODwPrYhZOZvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06BF3107ACF7;
        Tue, 16 Feb 2021 11:06:51 +0000 (UTC)
Received: from gondolin.redhat.com (ovpn-113-145.ams2.redhat.com [10.36.113.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 727F45D9CC;
        Tue, 16 Feb 2021 11:06:49 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] virtio/s390: implement virtio-ccw revision 2 correctly
Date:   Tue, 16 Feb 2021 12:06:45 +0100
Message-Id: <20210216110645.1087321-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

v1->v2:
  tweak patch description and cc:stable

---
 drivers/s390/virtio/virtio_ccw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 5730572b52cd..54e686dca6de 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -117,7 +117,7 @@ struct virtio_rev_info {
 };
 
 /* the highest virtio-ccw revision we support */
-#define VIRTIO_CCW_REV_MAX 1
+#define VIRTIO_CCW_REV_MAX 2
 
 struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
@@ -952,7 +952,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 	u8 old_status = vcdev->dma_area->status;
 	struct ccw1 *ccw;
 
-	if (vcdev->revision < 1)
+	if (vcdev->revision < 2)
 		return vcdev->dma_area->status;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));
-- 
2.26.2

