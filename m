Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991E46C186D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbjCTPYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbjCTPXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3231B30E8A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A60C6158F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A90C433D2;
        Mon, 20 Mar 2023 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325424;
        bh=bwDS73z4NofoRd4cL7Ull7R/3nIOPlDEw9FZHBNDe88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mg2KqC1LYhRMUfv67fZpWE0YKRHm23HMLlbVtOF2RQaYH+xwrNyazQSqqTyeEITnc
         nnmcXildv7vOIVIBRooqbHXQlE8YGaHcGSjqqAqoCAS8YB7clRKdOeL/M1czKbq/SO
         lWlz1CwSYw1mSYqSfugbdRM0eTVpKnEEG3rh5IMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Lei Yang <leiyang@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 042/211] vdpa_sim: not reset state in vdpasim_queue_ready
Date:   Mon, 20 Mar 2023 15:52:57 +0100
Message-Id: <20230320145514.992681787@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Stable-dep-of: b4cca6d48eb3 ("vdpa_sim: set last_used_idx as last_avail_idx in vdpasim_queue_ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index cb88891b44a8c..8839232a3fcbc 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -66,6 +66,7 @@ static void vdpasim_vq_notify(struct vringh *vring)
 static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
+	uint16_t last_avail_idx = vq->vring.last_avail_idx;
 
 	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
@@ -74,6 +75,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 			  (struct vring_used *)
 			  (uintptr_t)vq->device_addr);
 
+	vq->vring.last_avail_idx = last_avail_idx;
 	vq->vring.notify = vdpasim_vq_notify;
 }
 
-- 
2.39.2



