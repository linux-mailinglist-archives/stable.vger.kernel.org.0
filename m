Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8654E55D536
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbiF0LZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiF0LZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:25:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68D3659B;
        Mon, 27 Jun 2022 04:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9237761359;
        Mon, 27 Jun 2022 11:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92065C341C7;
        Mon, 27 Jun 2022 11:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329104;
        bh=IUTMOUZQBaEKK+FbjIuRCLQ5gadokMU3chQGYhcUoXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4AM+4XpQH5cByrVzQ+rTzHML/Ei2KhD2rABS+u5lUR45MrSjajns4fb7WWNb5nfn
         GlGu7Vg8+uVNM7fX4ufS8HCt9Cni8bwwBj+FtI9A6AvQonIzopTM7GfLYqW2Ln7eka
         sBgEDniUxGnnGQ7Mf+kPlIQAg1gCZKoog4v9kzfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/102] virtio_net: fix xdp_rxq_info bug after suspend/resume
Date:   Mon, 27 Jun 2022 13:21:03 +0200
Message-Id: <20220627111935.016599779@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit 8af52fe9fd3bf5e7478da99193c0632276e1dfce ]

The following sequence currently causes a driver bug warning
when using virtio_net:

  # ip link set eth0 up
  # echo mem > /sys/power/state (or e.g. # rtcwake -s 10 -m mem)
  <resume>
  # ip link set eth0 down

  Missing register, driver bug
  WARNING: CPU: 0 PID: 375 at net/core/xdp.c:138 xdp_rxq_info_unreg+0x58/0x60
  Call trace:
   xdp_rxq_info_unreg+0x58/0x60
   virtnet_close+0x58/0xac
   __dev_close_many+0xac/0x140
   __dev_change_flags+0xd8/0x210
   dev_change_flags+0x24/0x64
   do_setlink+0x230/0xdd0
   ...

This happens because virtnet_freeze() frees the receive_queue
completely (including struct xdp_rxq_info) but does not call
xdp_rxq_info_unreg(). Similarly, virtnet_restore() sets up the
receive_queue again but does not call xdp_rxq_info_reg().

Actually, parts of virtnet_freeze_down() and virtnet_restore_up()
are almost identical to virtnet_close() and virtnet_open(): only
the calls to xdp_rxq_info_(un)reg() are missing. This means that
we can fix this easily and avoid such problems in the future by
just calling virtnet_close()/open() from the freeze/restore handlers.

Aside from adding the missing xdp_rxq_info calls the only difference
is that the refill work is only cancelled if netif_running(). However,
this should not make any functional difference since the refill work
should only be active if the network interface is actually up.

Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20220621114845.3650258-1-stephan.gerhold@kernkonzept.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cbe47eed7cc3..ad9064df3deb 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2366,7 +2366,6 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 static void virtnet_freeze_down(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int i;
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
@@ -2374,14 +2373,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	netif_tx_lock_bh(vi->dev);
 	netif_device_detach(vi->dev);
 	netif_tx_unlock_bh(vi->dev);
-	cancel_delayed_work_sync(&vi->refill);
-
-	if (netif_running(vi->dev)) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
-		}
-	}
+	if (netif_running(vi->dev))
+		virtnet_close(vi->dev);
 }
 
 static int init_vqs(struct virtnet_info *vi);
@@ -2389,7 +2382,7 @@ static int init_vqs(struct virtnet_info *vi);
 static int virtnet_restore_up(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int err, i;
+	int err;
 
 	err = init_vqs(vi);
 	if (err)
@@ -2398,15 +2391,9 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	virtio_device_ready(vdev);
 
 	if (netif_running(vi->dev)) {
-		for (i = 0; i < vi->curr_queue_pairs; i++)
-			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
-				schedule_delayed_work(&vi->refill, 0);
-
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
-			virtnet_napi_tx_enable(vi, vi->sq[i].vq,
-					       &vi->sq[i].napi);
-		}
+		err = virtnet_open(vi->dev);
+		if (err)
+			return err;
 	}
 
 	netif_tx_lock_bh(vi->dev);
-- 
2.35.1



