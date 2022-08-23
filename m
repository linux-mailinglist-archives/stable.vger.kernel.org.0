Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB34E59D5C3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241402AbiHWIgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243861AbiHWIeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:34:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9400A75CC9;
        Tue, 23 Aug 2022 01:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C138961344;
        Tue, 23 Aug 2022 08:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2E3C433C1;
        Tue, 23 Aug 2022 08:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242600;
        bh=3LxpO6UANFpzcH7sgn+B4QCjOOt7xt8SeRhvBqmqGg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xf/q/vXISXBnlvHXyQV9StakO9oUjFQHcwAcQsdcgqP4TuWsw0nYa/cJsqjmhIePE
         uezhEbZH1Ifgy0o25txG42kq+nnmxAru+hUICZfmONQ/GnVWDd/Oqs/LFq4NJ+dfBd
         fN5Xj2xn+M4+bUxB2QuS3ujt2JvzqtUc2VkmiG3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, gautam.dawar@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH 5.19 143/365] vdpa_sim_blk: set number of address spaces and virtqueue groups
Date:   Tue, 23 Aug 2022 10:00:44 +0200
Message-Id: <20220823080124.214187072@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit 19cd4a5471b8eaa4bd161b0fdb4567f2fc88d809 upstream.

Commit bda324fd037a ("vdpasim: control virtqueue support") added two
new fields (nas, ngroups) to vdpasim_dev_attr, but we forgot to
initialize them for vdpa_sim_blk.

When creating a new vdpa_sim_blk device this causes the kernel
to panic in this way:
    $ vdpa dev add mgmtdev vdpasim_blk name blk0
    BUG: kernel NULL pointer dereference, address: 0000000000000030
    ...
    RIP: 0010:vhost_iotlb_add_range_ctx+0x41/0x220 [vhost_iotlb]
    ...
    Call Trace:
     <TASK>
     vhost_iotlb_add_range+0x11/0x800 [vhost_iotlb]
     vdpasim_map_range+0x91/0xd0 [vdpa_sim]
     vdpasim_alloc_coherent+0x56/0x90 [vdpa_sim]
     ...

This happens because vdpasim->iommu[0] is not initialized when
dev_attr.nas is 0.

Let's fix this issue by initializing both (nas, ngroups) to 1 for
vdpa_sim_blk.

Fixes: bda324fd037a ("vdpasim: control virtqueue support")
Cc: gautam.dawar@xilinx.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20220621151323.190431-1-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -34,7 +34,11 @@
 #define VDPASIM_BLK_CAPACITY	0x40000
 #define VDPASIM_BLK_SIZE_MAX	0x1000
 #define VDPASIM_BLK_SEG_MAX	32
+
+/* 1 virtqueue, 1 address space, 1 virtqueue group */
 #define VDPASIM_BLK_VQ_NUM	1
+#define VDPASIM_BLK_AS_NUM	1
+#define VDPASIM_BLK_GROUP_NUM	1
 
 static char vdpasim_blk_id[VIRTIO_BLK_ID_BYTES] = "vdpa_blk_sim";
 
@@ -260,6 +264,8 @@ static int vdpasim_blk_dev_add(struct vd
 	dev_attr.id = VIRTIO_ID_BLOCK;
 	dev_attr.supported_features = VDPASIM_BLK_FEATURES;
 	dev_attr.nvqs = VDPASIM_BLK_VQ_NUM;
+	dev_attr.ngroups = VDPASIM_BLK_GROUP_NUM;
+	dev_attr.nas = VDPASIM_BLK_AS_NUM;
 	dev_attr.config_size = sizeof(struct virtio_blk_config);
 	dev_attr.get_config = vdpasim_blk_get_config;
 	dev_attr.work_fn = vdpasim_blk_work;


