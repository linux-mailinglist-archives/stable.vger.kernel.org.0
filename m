Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026BC2A512A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgKCUih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbgKCUig (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B175922226;
        Tue,  3 Nov 2020 20:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435916;
        bh=P1t3xTSBef/ptJcoRxUOYbaDLDAH7WtU9bn53/s+I9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pnpp6dLpCc235FvACi+8wdItA6l7whUYgVsjn8VyGw58XyXg61tEdcVSHfxxrqWxP
         Rg3djkAwWlMQ1TI9OPB6jxkBkUSiKTXNnpQw1JiYoIkpEUtOGGBuG/p1F585bd+Mhe
         7Mc63GDRVCGEd06kI59byOGAxy3S1H6nh6Ib9rpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jasowang@redhat.com,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 038/391] vdpasim: fix MAC address configuration
Date:   Tue,  3 Nov 2020 21:31:29 +0100
Message-Id: <20201103203350.250691382@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit 4a6a42db53aae049a8a64d4b273761bc80c46ebf ]

vdpa_sim generates a ramdom MAC address but it is never used by upper
layers because the VIRTIO_NET_F_MAC bit is not set in the features list.

Because of that, virtio-net always regenerates a random MAC address each
time it is loaded whereas the address should only change on vdpa_sim
load/unload.

Fix that by adding VIRTIO_NET_F_MAC in the features list of vdpa_sim.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Cc: jasowang@redhat.com
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://lore.kernel.org/r/20201029122050.776445-2-lvivier@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 62d6403271450..01ef22d03a8c1 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -60,7 +60,8 @@ struct vdpasim_virtqueue {
 
 static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_F_VERSION_1)  |
-			      (1ULL << VIRTIO_F_ACCESS_PLATFORM);
+			      (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+			      (1ULL << VIRTIO_NET_F_MAC);
 
 /* State of each vdpasim device */
 struct vdpasim {
-- 
2.27.0



