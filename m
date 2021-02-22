Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1811B321601
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhBVMPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhBVMPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB6DA64E2E;
        Mon, 22 Feb 2021 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996056;
        bh=caBomS7bWdy579qeovr/GI6YRE02FIOHJwofYCiet2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YavS27gCmNZR/6Evp1l40cHlCYF0Zi0+c1u19kk9+j6IHFolNeAzvVzJUI4gg3lFN
         1xjLnsLj66feCt/QhIIbG440eFGT4DJW95vOigllhBCE8E+MlldzI59+dZtPkS8Qx9
         wL1/zoOqX8+ycahpbGcMWrVJtuSp7Gdxlk25fkzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 05/29] vdpa_sim: add get_config callback in vdpasim_dev_attr
Date:   Mon, 22 Feb 2021 13:12:59 +0100
Message-Id: <20210222121021.019351925@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

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
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -69,9 +69,12 @@ static u64 vdpasim_features = (1ULL << V
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
@@ -524,8 +527,6 @@ static u64 vdpasim_get_features(struct v
 static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
-	struct virtio_net_config *config =
-		(struct virtio_net_config *)vdpasim->config;
 
 	/* DMA mapping must be done by driver */
 	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
@@ -533,16 +534,6 @@ static int vdpasim_set_features(struct v
 
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
 
@@ -595,8 +586,13 @@ static void vdpasim_get_config(struct vd
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
@@ -739,12 +735,23 @@ static const struct vdpa_config_ops vdpa
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
 


