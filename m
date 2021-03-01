Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09403328A26
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239474AbhCASNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhCASGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:06:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76F416509F;
        Mon,  1 Mar 2021 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620043;
        bh=VASjeEJi0qWw/zRtese4yceTqBsdK7bRG7QiZA5eEA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgbMFUT3GVOOHz7//MIykUtpU/oBq8ee7jLUhxHbgAyv8DoMXGm6/HnFBy04lBPL1
         FjsYWcHpViU4S2cjxdMQEJWsUD9yNgJiX4Z97T5AhGg/Zt0a4b6mv5uNlXp2EfeyKJ
         jiGLUEzteUoJRQGJWdQfP0ImFJbBeCtZnYgKdd4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>
Subject: [PATCH 5.11 002/775] vdpa/mlx5: fix param validation in mlx5_vdpa_get_config()
Date:   Mon,  1 Mar 2021 17:02:50 +0100
Message-Id: <20210301161201.815806758@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit dcfde1635e764fd69cc756c7780d144e288608e9 upstream.

It's legal to have 'offset + len' equal to
sizeof(struct virtio_net_config), since 'ndev->config' is a
'struct virtio_net_config', so we can safely copy its content under
this condition.

Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20210208161741.104939-1-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1820,7 +1820,7 @@ static void mlx5_vdpa_get_config(struct
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 
-	if (offset + len < sizeof(struct virtio_net_config))
+	if (offset + len <= sizeof(struct virtio_net_config))
 		memcpy(buf, (u8 *)&ndev->config + offset, len);
 }
 


