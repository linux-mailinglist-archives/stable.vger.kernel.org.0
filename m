Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAD023A6F3
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgHCMVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgHCMVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:21:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B7882076E;
        Mon,  3 Aug 2020 12:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457308;
        bh=CDmO9XrYo5F5yWtezrGi445Z+qZ86t9Xk+um3LOorFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gkv9jEVgwdeve58KHqv+ZyRar5HUEvqPq+jYh2J3JUvHqxSVBwYRlJzRCXrROVvUV
         k6ocx+GCVFDc8fPiGZbLCL3hZJ/m4X+IxwysxWm+dPKRSzI4Hqh+e8KJ+CmsVsK5Oy
         wWKAF+2wgnaDHi4tREFw6JnYsohqgLN+kncWdGFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH 5.7 020/120] virtio_balloon: fix up endian-ness for free cmd id
Date:   Mon,  3 Aug 2020 14:17:58 +0200
Message-Id: <20200803121903.833733094@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

commit 168c358af2f8c5a37f8b5f877ba2cc93995606ee upstream.

free cmd id is read using virtio endian, spec says all fields
in balloon are LE. Fix it up.

Fixes: 86a559787e6f ("virtio-balloon: VIRTIO_BALLOON_F_FREE_PAGE_HINT")
Cc: stable@vger.kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Wei Wang <wei.w.wang@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_balloon.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -578,10 +578,14 @@ static int init_vqs(struct virtio_balloo
 static u32 virtio_balloon_cmd_id_received(struct virtio_balloon *vb)
 {
 	if (test_and_clear_bit(VIRTIO_BALLOON_CONFIG_READ_CMD_ID,
-			       &vb->config_read_bitmap))
+			       &vb->config_read_bitmap)) {
 		virtio_cread(vb->vdev, struct virtio_balloon_config,
 			     free_page_hint_cmd_id,
 			     &vb->cmd_id_received_cache);
+		/* Legacy balloon config space is LE, unlike all other devices. */
+		if (!virtio_has_feature(vb->vdev, VIRTIO_F_VERSION_1))
+			vb->cmd_id_received_cache = le32_to_cpu((__force __le32)vb->cmd_id_received_cache);
+	}
 
 	return vb->cmd_id_received_cache;
 }


