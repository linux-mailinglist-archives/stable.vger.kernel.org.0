Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9027C321600
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBVMPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230321AbhBVMPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E852564E44;
        Mon, 22 Feb 2021 12:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996051;
        bh=U6UJ3Wi8upIgMqpYP1SxDIhxzYJNtHBuwr0OCk9/ZOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5HKCAASO98gATQB10xpD4nciPzaw4RFIwcKO4UbvvDRgEvtk0EpZJO15ZVw4DO2w
         t8ern8x0RX6oyFTb+izLwUEHwuTNel6az1OIbEzJBzomWjpPdPpKfqHNU+cmKaz7Tt
         RGOmWbyBqxIRg2zeY+qb0FRa9hscB1ur55xf+1sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 03/29] vdpa_sim: store parsed MAC address in a buffer
Date:   Mon, 22 Feb 2021 13:12:57 +0100
Message-Id: <20210222121020.153222666@linuxfoundation.org>
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

commit cf1a3b35382c10ce315c32bd2b3d7789897fbe13 upstream.

As preparation for the next patches, we store the MAC address,
parsed during the vdpasim_create(), in a buffer that will be used
to fill 'config' together with other configurations.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201215144256.155342-11-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -42,6 +42,8 @@ static char *macaddr;
 module_param(macaddr, charp, 0);
 MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
 
+u8 macaddr_buf[ETH_ALEN];
+
 struct vdpasim_virtqueue {
 	struct vringh vring;
 	struct vringh_kiov iov;
@@ -392,13 +394,13 @@ static struct vdpasim *vdpasim_create(st
 		goto err_iommu;
 
 	if (macaddr) {
-		mac_pton(macaddr, vdpasim->config.mac);
-		if (!is_valid_ether_addr(vdpasim->config.mac)) {
+		mac_pton(macaddr, macaddr_buf);
+		if (!is_valid_ether_addr(macaddr_buf)) {
 			ret = -EADDRNOTAVAIL;
 			goto err_iommu;
 		}
 	} else {
-		eth_random_addr(vdpasim->config.mac);
+		eth_random_addr(macaddr_buf);
 	}
 
 	for (i = 0; i < dev_attr->nvqs; i++)
@@ -532,6 +534,8 @@ static int vdpasim_set_features(struct v
 
 	config->mtu = cpu_to_vdpasim16(vdpasim, 1500);
 	config->status = cpu_to_vdpasim16(vdpasim, VIRTIO_NET_S_LINK_UP);
+	memcpy(config->mac, macaddr_buf, ETH_ALEN);
+
 	return 0;
 }
 


