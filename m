Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13D431CBEA
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 15:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhBPO1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 09:27:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230267AbhBPO1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 09:27:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613485570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NsfAQuQEXLoLRBbDa4M48z/HfNRahv2joJ6WWM+PrFI=;
        b=aRSxkFCzo/Tw3sIVSIYXXolEoMH+jlDHRZiQqfnSYJ3QXS5Vlx0rBXdHdpIRfEfzRtMvHd
        6YXEgbP9Mnt3+9eEZr2jiEyPM+vhlyeWiCKFEG1S7XmFcMgUOg5yfbEPPEkALnkEjYABFl
        L1DzDdYrKaGMKb3fukWVOQPVoGy2h8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-1PI4taZjMv6-EvsIEXcjRg-1; Tue, 16 Feb 2021 09:26:07 -0500
X-MC-Unique: 1PI4taZjMv6-EvsIEXcjRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BE8E423C3;
        Tue, 16 Feb 2021 14:25:39 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20AA01981B;
        Tue, 16 Feb 2021 14:25:37 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for 5.10 v2 5/5] vdpa_sim: add get_config callback in vdpasim_dev_attr
Date:   Tue, 16 Feb 2021 15:24:39 +0100
Message-Id: <20210216142439.258713-6-sgarzare@redhat.com>
In-Reply-To: <20210216142439.258713-1-sgarzare@redhat.com>
References: <20210216142439.258713-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 65b709586e222fa6ffd4166ac7fdb5d5dad113ee upstream.

The get_config callback can be used by the device to fill the
config structure.
The callback will be invoked in vdpasim_get_config() before copying
bytes into caller buffer.

Move vDPA-net config updates from vdpasim_set_features() in the
new vdpasim_net_get_config() callback.
This is safe since in vdpa_get_config() we already check that
.set_features() callback is called before .get_config().

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201215144256.155342-13-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 35 +++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index d9c494455156..f2ad450db547 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -69,9 +69,12 @@ static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
 			      (1ULL << VIRTIO_NET_F_MAC);
 
+struct vdpasim;
+
 struct vdpasim_dev_attr {
 	size_t config_size;
 	int nvqs;
+	void (*get_config)(struct vdpasim *vdpasim, void *config);
 };
 
 /* State of each vdpasim device */
@@ -524,8 +527,6 @@ static u64 vdpasim_get_features(struct vdpa_device *vdpa)
 static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
-	struct virtio_net_config *config =
-		(struct virtio_net_config *)vdpasim->config;
 
 	/* DMA mapping must be done by driver */
 	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
@@ -533,16 +534,6 @@ static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
 
 	vdpasim->features = features & vdpasim_features;
 
-	/* We generally only know whether guest is using the legacy interface
-	 * here, so generally that's the earliest we can set config fields.
-	 * Note: We actually require VIRTIO_F_ACCESS_PLATFORM above which
-	 * implies VIRTIO_F_VERSION_1, but let's not try to be clever here.
-	 */
-
-	config->mtu = cpu_to_vdpasim16(vdpasim, 1500);
-	config->status = cpu_to_vdpasim16(vdpasim, VIRTIO_NET_S_LINK_UP);
-	memcpy(config->mac, macaddr_buf, ETH_ALEN);
-
 	return 0;
 }
 
@@ -595,8 +586,13 @@ static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	if (offset + len < vdpasim->dev_attr.config_size)
-		memcpy(buf, vdpasim->config + offset, len);
+	if (offset + len > vdpasim->dev_attr.config_size)
+		return;
+
+	if (vdpasim->dev_attr.get_config)
+		vdpasim->dev_attr.get_config(vdpasim, vdpasim->config);
+
+	memcpy(buf, vdpasim->config + offset, len);
 }
 
 static void vdpasim_set_config(struct vdpa_device *vdpa, unsigned int offset,
@@ -739,12 +735,23 @@ static const struct vdpa_config_ops vdpasim_net_batch_config_ops = {
 	.free                   = vdpasim_free,
 };
 
+static void vdpasim_net_get_config(struct vdpasim *vdpasim, void *config)
+{
+	struct virtio_net_config *net_config =
+		(struct virtio_net_config *)config;
+
+	net_config->mtu = cpu_to_vdpasim16(vdpasim, 1500);
+	net_config->status = cpu_to_vdpasim16(vdpasim, VIRTIO_NET_S_LINK_UP);
+	memcpy(net_config->mac, macaddr_buf, ETH_ALEN);
+}
+
 static int __init vdpasim_dev_init(void)
 {
 	struct vdpasim_dev_attr dev_attr = {};
 
 	dev_attr.nvqs = VDPASIM_VQ_NUM;
 	dev_attr.config_size = sizeof(struct virtio_net_config);
+	dev_attr.get_config = vdpasim_net_get_config;
 
 	vdpasim_dev = vdpasim_create(&dev_attr);
 
-- 
2.29.2

