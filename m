Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA2A31CBE1
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 15:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhBPO1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 09:27:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhBPO1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 09:27:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613485536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vQfUtviC8oIPaLDXCKYPsJ21Sbm2WAMm5gLPlRM/D5c=;
        b=boxoGj7NDFnADAgsOSDbBeTKO4r8FqB8adaYpEDlOziLLHppc6oT1SdINUfRBs21gLvJh4
        FuNbBGrnBtJNZeKh+DQ4K9MW+aV4JZKhO7914rtGvQQqySKagAiScl8TSOPp/hbA6vgtt7
        RlR25ODy4DCDWjyYiOkNfRjIX3PPTBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-REwkdLljP-mPIpEjBgC33w-1; Tue, 16 Feb 2021 09:25:33 -0500
X-MC-Unique: REwkdLljP-mPIpEjBgC33w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2ECB108C2A2;
        Tue, 16 Feb 2021 14:25:14 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4ADE1045D3E;
        Tue, 16 Feb 2021 14:25:12 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for 5.10 v2 3/5] vdpa_sim: store parsed MAC address in a buffer
Date:   Tue, 16 Feb 2021 15:24:37 +0100
Message-Id: <20210216142439.258713-4-sgarzare@redhat.com>
In-Reply-To: <20210216142439.258713-1-sgarzare@redhat.com>
References: <20210216142439.258713-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit cf1a3b35382c10ce315c32bd2b3d7789897fbe13 upstream.

As preparation for the next patches, we store the MAC address,
parsed during the vdpasim_create(), in a buffer that will be used
to fill 'config' together with other configurations.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20201215144256.155342-11-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 6a5603f9d24c..bc27fa485c3e 100644
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
@@ -392,13 +394,13 @@ static struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
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
@@ -532,6 +534,8 @@ static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
 
 	config->mtu = cpu_to_vdpasim16(vdpasim, 1500);
 	config->status = cpu_to_vdpasim16(vdpasim, VIRTIO_NET_S_LINK_UP);
+	memcpy(config->mac, macaddr_buf, ETH_ALEN);
+
 	return 0;
 }
 
-- 
2.29.2

