Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1F256539B
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiGDLeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbiGDLeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:34:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914D8FD06
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:34:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DA23615F9
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30178C3411E;
        Mon,  4 Jul 2022 11:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656934461;
        bh=qH5KoEx/9E8fKdxaGyf0L0pJ7tl//JkpSRjrrX6wJi4=;
        h=Subject:To:Cc:From:Date:From;
        b=WE4WgOqOGi9iNSmTjaJ4kRwEJGFYPlop+pmOhvVx0OMV6Bcyv1g7DQBdyRPWadbpB
         q2H2PCWnpj9cSQ1HngimK24jAO+zZLd1hCvc/p51jMbYy3u76QXJVeKAfCxq//rFTr
         SzI6DoWLRemZRZZzjVPUPctLJms/8A4KIJ1bkwEs=
Subject: FAILED: patch "[PATCH] virtio-net: fix race between ndo_open() and" failed to apply to 4.14-stable tree
To:     jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:34:05 +0200
Message-ID: <1656934445160138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 50c0ada627f56c92f5953a8bf9158b045ad026a1 Mon Sep 17 00:00:00 2001
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 17 Jun 2022 15:29:49 +0800
Subject: [PATCH] virtio-net: fix race between ndo_open() and
 virtio_device_ready()

We currently call virtio_device_ready() after netdev
registration. Since ndo_open() can be called immediately
after register_netdev, this means there exists a race between
ndo_open() and virtio_device_ready(): the driver may start to use the
device before DRIVER_OK which violates the spec.

Fix this by switching to use register_netdevice() and protect the
virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
only be called after virtio_device_ready().

Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20220617072949.30734-1-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index db05b5e930be..8a5810bcb839 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (vi->has_rss || vi->has_rss_hash_report)
 		virtnet_init_default_rss(vi);
 
-	err = register_netdev(dev);
+	/* serialize netdev register + virtio_device_ready() with ndo_open() */
+	rtnl_lock();
+
+	err = register_netdevice(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
+		rtnl_unlock();
 		goto free_failover;
 	}
 
 	virtio_device_ready(vdev);
 
+	rtnl_unlock();
+
 	err = virtnet_cpu_notif_add(vi);
 	if (err) {
 		pr_debug("virtio_net: registering cpu notifier failed\n");

