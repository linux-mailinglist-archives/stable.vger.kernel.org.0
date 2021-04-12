Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB835BFB9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbhDLJG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239790AbhDLJED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5398F613BF;
        Mon, 12 Apr 2021 09:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218087;
        bh=8GGaWlDTtN8a8qBRL4YeSAbuZaUIrvv/aQg57BrhTQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnhOm6cj3Rvsa6dU8vfnecsvIb5FGr3gnDBkqEenMM9uQlOIMoECUHIR+dJEm3ska
         fylOpHEAyf9gssIxWxMzb/+mcad8Fg4FBhTtnil8Yd+PjBUWlhXOWKfGY7HiXsX9hu
         ULd5v/h7ZcvXzKKFAH6spaJueiJN+CWxEQ1nz3rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.11 067/210] vdpa/mlx5: Fix suspend/resume index restoration
Date:   Mon, 12 Apr 2021 10:39:32 +0200
Message-Id: <20210412084018.231654829@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

commit bc04d93ea30a0a8eb2a2648b848cef35d1f6f798 upstream.

When we suspend the VM, the VDPA interface will be reset. When the VM is
resumed again, clear_virtqueues() will clear the available and used
indices resulting in hardware virqtqueue objects becoming out of sync.
We can avoid this function alltogether since qemu will clear them if
required, e.g. when the VM went through a reboot.

Moreover, since the hw available and used indices should always be
identical on query and should be restored to the same value same value
for virtqueues that complete in order, we set the single value provided
by set_vq_state(). In get_vq_state() we return the value of hardware
used index.

Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20210408091047.4269-6-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_
 		return;
 	}
 	mvq->avail_idx = attr.available_index;
+	mvq->used_idx = attr.used_index;
 }
 
 static void suspend_vqs(struct mlx5_vdpa_net *ndev)
@@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct
 		return -EINVAL;
 	}
 
+	mvq->used_idx = state->avail_index;
 	mvq->avail_idx = state->avail_index;
 	return 0;
 }
@@ -1443,7 +1445,11 @@ static int mlx5_vdpa_get_vq_state(struct
 	 * that cares about emulating the index after vq is stopped.
 	 */
 	if (!mvq->initialized) {
-		state->avail_index = mvq->avail_idx;
+		/* Firmware returns a wrong value for the available index.
+		 * Since both values should be identical, we take the value of
+		 * used_idx which is reported correctly.
+		 */
+		state->avail_index = mvq->used_idx;
 		return 0;
 	}
 
@@ -1452,7 +1458,7 @@ static int mlx5_vdpa_get_vq_state(struct
 		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
 		return err;
 	}
-	state->avail_index = attr.available_index;
+	state->avail_index = attr.used_index;
 	return 0;
 }
 
@@ -1540,16 +1546,6 @@ static void teardown_virtqueues(struct m
 	}
 }
 
-static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
-{
-	int i;
-
-	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
-		ndev->vqs[i].avail_idx = 0;
-		ndev->vqs[i].used_idx = 0;
-	}
-}
-
 /* TODO: cross-endian support */
 static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
 {
@@ -1785,7 +1781,6 @@ static void mlx5_vdpa_set_status(struct
 	if (!status) {
 		mlx5_vdpa_info(mvdev, "performing device reset\n");
 		teardown_driver(ndev);
-		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status = 0;
 		ndev->mvdev.mlx_features = 0;


