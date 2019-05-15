Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F62F1EF83
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbfEOLba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731386AbfEOLb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34EE20818;
        Wed, 15 May 2019 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919889;
        bh=oIQEaM9ehbUGjQp2n7XmPHer5wa2e7e8ImVmL2y+yzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4KBKLSrNRZjSq8tND2BrWyA4cuhsiDY/TCITx3AyM+fGuQMI39lIQ95OVZHDVYCK
         wJDYN4UN6tE1i25IPk5CryqmMQu22+TBNsAYMjZF0mhXoHS0cdXXJYOkzcN/xVxkE0
         uDdawZuPnJb/D1Ixzb7Kz+zf7fiikzPBv3BoR55k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.0 133/137] virtio_ring: Fix potential mem leak in virtqueue_add_indirect_packed
Date:   Wed, 15 May 2019 12:56:54 +0200
Message-Id: <20190515090703.537212784@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
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
@@ -993,6 +993,7 @@ static int virtqueue_add_indirect_packed
 
 	if (unlikely(vq->vq.num_free < 1)) {
 		pr_debug("Can't add buf len 1 - avail = 0\n");
+		kfree(desc);
 		END_USE(vq);
 		return -ENOSPC;
 	}


