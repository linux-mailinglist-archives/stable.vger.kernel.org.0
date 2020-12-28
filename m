Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D362E432F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407075AbgL1Pd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407018AbgL1NxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BB2822583;
        Mon, 28 Dec 2020 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163540;
        bh=NL/llxcaFjnXWr1uNTIGnR162QIbsvB+qULrRl+eU2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDbFZFE56UU6dLTlmHD7wZxVxeT+ndhPK3+hLWzW61mudCVVUbkDveY3ozfwa8lKY
         KMMOxe7uNvKf1XWo59mbfEvn2a99ozIiympyjVDSAeS3PNuPdmf/WR1onTUdQccssb
         Tvex73HkfKRLf6ByBhETxe/BsGqp7VnMVh5bknRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Robert Buhren <robert.buhren@sect.tu-berlin.de>,
        Felicitas Hetzelt <file@sect.tu-berlin.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 304/453] virtio_net: Fix error code in probe()
Date:   Mon, 28 Dec 2020 13:49:00 +0100
Message-Id: <20201228124951.836754240@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 411ea23a76526e6efed0b601abb603d3c981b333 ]

Set a negative error code intead of returning success if the MTU has
been changed to something invalid.

Fixes: fe36cbe0671e ("virtio_net: clear MTU when out of range")
Reported-by: Robert Buhren <robert.buhren@sect.tu-berlin.de>
Reported-by: Felicitas Hetzelt <file@sect.tu-berlin.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X8pGVJSeeCdII1Ys@mwanda
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 99e1a7bc06886..7cc8f405be1ad 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3114,6 +3114,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 			dev_err(&vdev->dev,
 				"device MTU appears to have changed it is now %d < %d",
 				mtu, dev->min_mtu);
+			err = -EINVAL;
 			goto free;
 		}
 
-- 
2.27.0



