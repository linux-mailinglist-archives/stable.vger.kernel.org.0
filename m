Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AF6566B14
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiGEMEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiGEMCc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B7B18388;
        Tue,  5 Jul 2022 05:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E94306173E;
        Tue,  5 Jul 2022 12:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2662C341C7;
        Tue,  5 Jul 2022 12:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022543;
        bh=v40g/hBBeQmr4W1jpD2WWBoeCsbWUBpQuUMf2B4Nk+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EM5zKQ8KrIxl0wAgM0T/5Rt/gc87j2mAFwdlpSXG1QSCk7IAR7Xqesrym0Q8794Sk
         d2xVtxaayPomn/ztJPyANnUBAXZeaDTncxs0Yag67GX/X7qdBA8JShcOd+JUkzTo3R
         PRyqGz42hSIoX+GiPeusMNkLj+8qTwRIpIPZqMno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 4.19 15/33] caif_virtio: fix race between virtio_device_ready() and ndo_open()
Date:   Tue,  5 Jul 2022 13:58:07 +0200
Message-Id: <20220705115607.156060173@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jason Wang <jasowang@redhat.com>

commit 11a37eb66812ce6a06b79223ad530eb0e1d7294d upstream.

We currently depend on probe() calling virtio_device_ready() -
which happens after netdev
registration. Since ndo_open() can be called immediately
after register_netdev, this means there exists a race between
ndo_open() and virtio_device_ready(): the driver may start to use the
device (e.g. TX) before DRIVER_OK which violates the spec.

Fix this by switching to use register_netdevice() and protect the
virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
only be called after virtio_device_ready().

Fixes: 0d2e1a2926b18 ("caif_virtio: Introduce caif over virtio")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20220620051115.3142-3-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/caif/caif_virtio.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -727,13 +727,21 @@ static int cfv_probe(struct virtio_devic
 	/* Carrier is off until netdevice is opened */
 	netif_carrier_off(netdev);
 
+	/* serialize netdev register + virtio_device_ready() with ndo_open() */
+	rtnl_lock();
+
 	/* register Netdev */
-	err = register_netdev(netdev);
+	err = register_netdevice(netdev);
 	if (err) {
+		rtnl_unlock();
 		dev_err(&vdev->dev, "Unable to register netdev (%d)\n", err);
 		goto err;
 	}
 
+	virtio_device_ready(vdev);
+
+	rtnl_unlock();
+
 	debugfs_init(cfv);
 
 	return 0;


