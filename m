Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682EE1EFB1
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbfEOLeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387403AbfEOLeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:34:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BAA62084A;
        Wed, 15 May 2019 11:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557920050;
        bh=WP096DrFJd9NTFHr7Uf2Je+GPBnpNThOOq/0K7LtHTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eOSF5zw1KGuoFb5enexI+TVaqWbTlkb5lMqo2nY3Lliv0c2i+skuAOnKFIih8bstB
         ugW89mP9FbbfxVLxiEG+qDOpiAmOJkIF83ohTyrsmUyrFnjihxnNEuAuof1JvAtvIp
         ve/7RXtT0g2tZ3Sds43pUWjY5JQb0fU6bfntwf74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.1 42/46] virtio_ring: Fix potential mem leak in virtqueue_add_indirect_packed
Date:   Wed, 15 May 2019 12:57:06 +0200
Message-Id: <20190515090628.890546862@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit df0bfe7501e9319546ea380d39674a4179e059c3 upstream.

'desc' should be freed before leaving from err handing path.

Fixes: 1ce9e6055fa0 ("virtio_ring: introduce packed ring support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_ring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1004,6 +1004,7 @@ static int virtqueue_add_indirect_packed
 
 	if (unlikely(vq->vq.num_free < 1)) {
 		pr_debug("Can't add buf len 1 - avail = 0\n");
+		kfree(desc);
 		END_USE(vq);
 		return -ENOSPC;
 	}


