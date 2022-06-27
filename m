Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6927355D390
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbiF0Lil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbiF0Lhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:37:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2DAAE5A;
        Mon, 27 Jun 2022 04:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0919B81122;
        Mon, 27 Jun 2022 11:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D64FC341C7;
        Mon, 27 Jun 2022 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329666;
        bh=16JjpVXHZCyYFsraGSL4Rx88z3LBUJXQcEOatPLGges=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fxo0xatd79irMTjGtc2bX3SSN4plo7doTBUV/Mv1UFwcy0DNYnNd4eItpdTJuzYDn
         5dAWMBF2UjHYXuLZ+CIdELny2liEO0VA4Q4YJYPgu/E9k8hAEzbycfXq8RFMuBCFx5
         eXtufcM+5Z0flKA7mC7BDY59Gfu8RdrirAWT0h34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/135] virtio_net: fix xdp_rxq_info bug after suspend/resume
Date:   Mon, 27 Jun 2022 13:21:20 +0200
Message-Id: <20220627111940.279565138@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
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
index 73aba760e10c..468d0ffc266b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2431,7 +2431,6 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 static void virtnet_freeze_down(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int i;
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
@@ -2439,14 +2438,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
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
@@ -2454,7 +2447,7 @@ static int init_vqs(struct virtnet_info *vi);
 static int virtnet_restore_up(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int err, i;
+	int err;
 
 	err = init_vqs(vi);
 	if (err)
@@ -2463,15 +2456,9 @@ static int virtnet_restore_up(struct virtio_device *vdev)
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



