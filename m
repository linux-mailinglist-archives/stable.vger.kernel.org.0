Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D944611FB
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 11:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhK2KY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 05:24:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234761AbhK2KWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 05:22:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638181178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vq5DQSO3sLOi0I9wK0ib09zdcTrJy3BhcIWabUvofWE=;
        b=HfXQlHAUGEgMLhU/6q1troBLYXMDiLAHDDTBvcPmNx/GAQtRCkCA1xeSR5VxWjh6CvYf0p
        F9UtCtn+xi+QvmmFMoxZ7QsazvM/M/hUkl7Vs6ovBle3wqwrkVK4WU7F1mmBzbRQbA0jsa
        yvq1M8ji3QFt76D1hPNYuhgrBjPkweg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-J-ZNw3zrMguvejTjfJMKdA-1; Mon, 29 Nov 2021 05:19:36 -0500
X-MC-Unique: J-ZNw3zrMguvejTjfJMKdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F3751006AAC;
        Mon, 29 Nov 2021 10:19:35 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.39.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AF2C60854;
        Mon, 29 Nov 2021 10:19:24 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     stable@vger.kernel.org
Cc:     mst@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        jasowang@redhat.com, gregkh@linuxfoundation.org,
        pasic@linux.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4.9] vhost/vsock: fix incorrect used length reported to the guest
Date:   Mon, 29 Nov 2021 11:19:23 +0100
Message-Id: <20211129101923.30978-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 49d8c5ffad07ca014cfae72a1b9b8c52b6ad9cb8 upstream.

The "used length" reported by calling vhost_add_used() must be the
number of bytes written by the device (using "in" buffers).

In vhost_vsock_handle_tx_kick() the device only reads the guest
buffers (they are all "out" buffers), without writing anything,
so we must pass 0 as "used length" to comply virtio spec.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Cc: stable@vger.kernel.org
Reported-by: Halil Pasic <pasic@linux.ibm.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20211122163525.294024-2-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 2ac966400c42..e282e8174a5d 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -406,7 +406,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		else
 			virtio_transport_free_pkt(pkt);
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + len);
+		vhost_add_used(vq, head, 0);
 		added = true;
 	}
 
-- 
2.31.1

