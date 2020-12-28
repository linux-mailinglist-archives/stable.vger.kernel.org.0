Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0DA2E4029
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439174AbgL1OWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502618AbgL1OWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3C6222B30;
        Mon, 28 Dec 2020 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165316;
        bh=RnWXGoe3rqK+CbVc7vEq6fNA0KGY+rq+NBemDoqYrDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNSlv7laGr9RWpBcYC7Jo6OdBqZ/LDWgvUaL8ieY7StV5GgjDQcOQviI6bLur5Y4+
         vXqZvrvwkPu05PPLhWS9HYEgX1j/HaBIU4xWb8rCNuo7UPuFBu4EMUY8rw5CC+ZrlF
         DdVc4JdsbRAlOJwe2nGgSxsrIgIpRbtMqoWSLR8A=
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
Subject: [PATCH 5.10 490/717] virtio_net: Fix error code in probe()
Date:   Mon, 28 Dec 2020 13:48:08 +0100
Message-Id: <20201228125044.440786954@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 21b71148c5324..34bb95dd92392 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3072,6 +3072,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 			dev_err(&vdev->dev,
 				"device MTU appears to have changed it is now %d < %d",
 				mtu, dev->min_mtu);
+			err = -EINVAL;
 			goto free;
 		}
 
-- 
2.27.0



