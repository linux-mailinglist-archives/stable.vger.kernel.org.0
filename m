Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7996C16F3
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjCTPKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbjCTPKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:10:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C192ED56
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81C55B80EAC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA57C433D2;
        Mon, 20 Mar 2023 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324692;
        bh=zBd9sjDCoANVOwPTT3mhfS52iw+TZmSDobc0Z9n/7Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ckb3w6mY621oo8PzL9vaomdQAaPr6Uh+hpbD/uS1KNgOLBmyfO6KsDiziDg5EbhCX
         X9FXEUZRDj3kWPhFwx6GTT3U9SpIgg9l8BwDC625QoTkTqmIELQwvI46G5QJm42VXV
         wnIkZda06HnOsYMWJLs03eNRXls8UY41j4xFOe7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Lei Yang <leiyang@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/115] vdpa_sim: not reset state in vdpasim_queue_ready
Date:   Mon, 20 Mar 2023 15:53:50 +0100
Message-Id: <20230320145450.165728219@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit 0e84f918fac8ae61dcb790534fad5e3555ca2930 ]

vdpasim_queue_ready calls vringh_init_iotlb, which resets split indexes.
But it can be called after setting a ring base with
vdpasim_set_vq_state.

Fix it by stashing them. They're still resetted in vdpasim_vq_reset.

This was discovered and tested live migrating the vdpa_sim_net device.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Message-Id: <20230118164359.1523760-2-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 4d9e3fdae5f6c..eeda45fbba258 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -65,6 +65,7 @@ static void vdpasim_vq_notify(struct vringh *vring)
 static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
+	uint16_t last_avail_idx = vq->vring.last_avail_idx;
 
 	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
@@ -73,6 +74,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 			  (struct vring_used *)
 			  (uintptr_t)vq->device_addr);
 
+	vq->vring.last_avail_idx = last_avail_idx;
 	vq->vring.notify = vdpasim_vq_notify;
 }
 
-- 
2.39.2



