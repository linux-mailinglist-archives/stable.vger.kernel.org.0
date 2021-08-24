Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC753F54BE
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhHXA43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234350AbhHXAza (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C25B46147F;
        Tue, 24 Aug 2021 00:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766480;
        bh=MfxQUixaNveeg5Rc43ZBxvP6pdrnZIwt6nbzLKYpHJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSIWRQatQ7cZr5esBolbWWUYokcQ/ClE3C1pLdEbDkXeCC1323o0j+19zzyHHrBwD
         4g4203mEWcsg1QzIY46fnCcjqfM5Iov+wwPavxccNoE6DOmaC0k3CLjXKNaxlWRxrp
         fcri0v4TUgRn2oRxybnvT1/LxWTsSzKNycrY5Yd9ZxzTmLn5MhD7cOFt2SID6AQYXB
         oW8QMfxWIvvp0x3XgLjDZBk+DHHdyy6aUO5PxpAIyg2bZDPlcbI4YSnjovOyq/0/nq
         kN+KnvE3NLRrwKWtGNQ4ylSc1acNo7CGws1q5uAzZSh8Kg/koxrsQFNAA/jPK3n34P
         oBJSy5cJ9X+XA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 06/18] virtio_vdpa: reject invalid vq indices
Date:   Mon, 23 Aug 2021 20:54:20 -0400
Message-Id: <20210824005432.631154-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
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
index 4a9ddb44b2a7..3f95dedccceb 100644
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

