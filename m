Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF4A157927
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgBJNNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgBJMin (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:43 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A27620842;
        Mon, 10 Feb 2020 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338323;
        bh=woBNc1etvzbOqdR0JwFBLJUqICi0lJEjoZkrPEyPtC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3hv8ir6Y1iosLB+s4CYHNcUlxstrxg5r2Dq/bWhCxG+N7qUS6f0G5ZX4fu7uCaCw
         lIuXh+XOrDQQjLK2tWNdqbB4Cb38Hkti9pLZG9pQbZ9qKOJYoPa+cGAkTf3zBsmnWt
         uA1qW/yLi+nqzcbcTRpjxXhpCPIbs3KC4SIYc0Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Liang Li <liang.z.li@intel.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.4 256/309] virtio-balloon: Fix memory leak when unloading while hinting is in progress
Date:   Mon, 10 Feb 2020 04:33:32 -0800
Message-Id: <20200210122431.167308054@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit 6c22dc61c76b7e7d355f1697ba0ecf26d1334ba6 upstream.

When unloading the driver while hinting is in progress, we will not
release the free page blocks back to MM, resulting in a memory leak.

Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Wei Wang <wei.w.wang@intel.com>
Cc: Liang Li <liang.z.li@intel.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200205163402.42627-2-david@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_balloon.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -967,6 +967,10 @@ static void remove_common(struct virtio_
 		leak_balloon(vb, vb->num_pages);
 	update_balloon_size(vb);
 
+	/* There might be free pages that are being reported: release them. */
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
+		return_free_pages_to_mm(vb, ULONG_MAX);
+
 	/* Now we reset the device so we can clean up the queues. */
 	vb->vdev->config->reset(vb->vdev);
 


