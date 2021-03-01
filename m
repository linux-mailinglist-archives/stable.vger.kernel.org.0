Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65446328E71
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbhCATbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:31:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241406AbhCAT0p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:26:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17F9F6529C;
        Mon,  1 Mar 2021 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619998;
        bh=mDNce7JorKvDfVda5uTF6y2n3mrETWCjGAl4Rk/5v2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEvH+i5opnELlHC4lL67rs5CbVbCIGHoONNwgZCsIEHbjS0jKM3+NZczNWuS/ON/G
         rZIOQhANVQq7HjO7bJ+frq6a5NE5teTBPjPCv433jq9Ht2evU8GR3kLGYc9zKm6gYd
         FmYVGy+5v0nnlBOfR3jLGVRz0bHWGVe91o2HH0FQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 627/663] virtio/s390: implement virtio-ccw revision 2 correctly
Date:   Mon,  1 Mar 2021 17:14:35 +0100
Message-Id: <20210301161212.872459775@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cornelia Huck <cohuck@redhat.com>

commit 182f709c5cff683e6732d04c78e328de0532284f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/virtio/virtio_ccw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -117,7 +117,7 @@ struct virtio_rev_info {
 };
 
 /* the highest virtio-ccw revision we support */
-#define VIRTIO_CCW_REV_MAX 1
+#define VIRTIO_CCW_REV_MAX 2
 
 struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
@@ -952,7 +952,7 @@ static u8 virtio_ccw_get_status(struct v
 	u8 old_status = vcdev->dma_area->status;
 	struct ccw1 *ccw;
 
-	if (vcdev->revision < 1)
+	if (vcdev->revision < 2)
 		return vcdev->dma_area->status;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));


