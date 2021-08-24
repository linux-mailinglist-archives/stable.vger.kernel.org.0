Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DF63F544D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhHXAzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233650AbhHXAyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:54:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C35A2613AD;
        Tue, 24 Aug 2021 00:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766447;
        bh=ZMwVgeO8BXE4Vr6cAm+FMEPjYDhem2FmGyPCWR+8u7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CveqHbIBU+nK7i3HfUx5EWwECbr77OEZfl0K0WvEMKop7yo2pn6HppsNG0PjlZjdj
         RDOdHmKivJTaNGqdLmQavX+SHMAA0GAxR6hHtNvfEbInMrPFHVB6Af9GM6l67Qaipq
         BNvm7n1MlkNnsiSfSPQjlIIXnHNJNwvB06leBW20ClIrQgCrAFS6bQ0UmoFVYPuw9s
         y/x7I7SUDrNf6PNDF0FUhO8Rcmcl5AJhy0rPMRa1jkZN5nQyF3OcGVr61TnpnbKlDE
         MsSE7XL0nVcbTZ1Qyj1xshE1eNXZ6hUtv96h0+0hXDzCOnymuju6rDiWOpLSPgB3S2
         bN0Ipq5oH/0og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.13 08/26] virtio_vdpa: reject invalid vq indices
Date:   Mon, 23 Aug 2021 20:53:38 -0400
Message-Id: <20210824005356.630888-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit cb5d2c1f6cc0e5769099a7d44b9d08cf58cae206 ]

Do not call vDPA drivers' callbacks with vq indicies larger than what
the drivers indicate that they support.  vDPA drivers do not bounds
check the indices.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/20210701114652.21956-1-vincent.whitchurch@axis.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_vdpa.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e28acf482e0c..e9b9dd03f44a 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -149,6 +149,9 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	if (!name)
 		return NULL;
 
+	if (index >= vdpa->nvqs)
+		return ERR_PTR(-ENOENT);
+
 	/* Queue shouldn't already be set up. */
 	if (ops->get_vq_ready(vdpa, index))
 		return ERR_PTR(-ENOENT);
-- 
2.30.2

