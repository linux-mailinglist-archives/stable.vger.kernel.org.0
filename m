Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337FF431B87
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhJRNdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232450AbhJRNbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:31:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1880D6128E;
        Mon, 18 Oct 2021 13:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563729;
        bh=1ADLGrEstFCqSsIQZXS9I2KSEQd1t78SzVMETSn9TUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrdD8MjRKFkpw39VDjAQVu9kjMj/rHBgWh0Ys40mmmlX8yNmXLS2Al9HhoTQ0EqN+
         n2hYGPVr+yFXOQtu8yxjjIdHr7sWFRuufM9KifkkI6UcJtd/Z1gQeVUoZuC5Cptf2z
         YA+tjUDZrnRTF7n34WjinHqa1Mo44qsZdWpjKqwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        markver@us.ibm.com, Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 4.19 24/50] virtio: write back F_VERSION_1 before validate
Date:   Mon, 18 Oct 2021 15:24:31 +0200
Message-Id: <20211018132327.338374122@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

commit 2f9a174f918e29608564c7a4e8329893ab604fb4 upstream.

The virtio specification virtio-v1.1-cs01 states: "Transitional devices
MUST detect Legacy drivers by detecting that VIRTIO_F_VERSION_1 has not
been acknowledged by the driver."  This is exactly what QEMU as of 6.1
has done relying solely on VIRTIO_F_VERSION_1 for detecting that.

However, the specification also says: "... the driver MAY read (but MUST
NOT write) the device-specific configuration fields to check that it can
support the device ..." before setting FEATURES_OK.

In that case, any transitional device relying solely on
VIRTIO_F_VERSION_1 for detecting legacy drivers will return data in
legacy format.  In particular, this implies that it is in big endian
format for big endian guests. This naturally confuses the driver which
expects little endian in the modern mode.

It is probably a good idea to amend the spec to clarify that
VIRTIO_F_VERSION_1 can only be relied on after the feature negotiation
is complete. Before validate callback existed, config space was only
read after FEATURES_OK. However, we already have two regressions, so
let's address this here as well.

The regressions affect the VIRTIO_NET_F_MTU feature of virtio-net and
the VIRTIO_BLK_F_BLK_SIZE feature of virtio-blk for BE guests when
virtio 1.0 is used on both sides. The latter renders virtio-blk unusable
with DASD backing, because things simply don't work with the default.
See Fixes tags for relevant commits.

For QEMU, we can work around the issue by writing out the feature bits
with VIRTIO_F_VERSION_1 bit set.  We (ab)use the finalize_features
config op for this. This isn't enough to address all vhost devices since
these do not get the features until FEATURES_OK, however it looks like
the affected devices actually never handled the endianness for legacy
mode correctly, so at least that's not a regression.

No devices except virtio net and virtio blk seem to be affected.

Long term the right thing to do is to fix the hypervisors.

Cc: <stable@vger.kernel.org> #v4.11
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 82e89ea077b9 ("virtio-blk: Add validation for block size in config space")
Fixes: fe36cbe0671e ("virtio_net: clear MTU when out of range")
Reported-by: markver@us.ibm.com
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20211011053921.1198936-1-pasic@linux.ibm.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -222,6 +222,17 @@ static int virtio_dev_probe(struct devic
 		driver_features_legacy = driver_features;
 	}
 
+	/*
+	 * Some devices detect legacy solely via F_VERSION_1. Write
+	 * F_VERSION_1 to force LE config space accesses before FEATURES_OK for
+	 * these when needed.
+	 */
+	if (drv->validate && !virtio_legacy_is_little_endian()
+			  && device_features & BIT_ULL(VIRTIO_F_VERSION_1)) {
+		dev->features = BIT_ULL(VIRTIO_F_VERSION_1);
+		dev->config->finalize_features(dev);
+	}
+
 	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
 		dev->features = driver_features & device_features;
 	else


