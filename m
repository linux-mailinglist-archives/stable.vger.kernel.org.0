Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BE51CAD75
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgEHNCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729014AbgEHMvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:51:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABC6024964;
        Fri,  8 May 2020 12:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942265;
        bh=tS8yISY2FPSoFA2Xz5HcnvqcY9twKKqKe7VbtyvOpsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rfwt70VbamXErIoLiAdGG8XN1zJ3YuJQ4PXzQ2l7HIUiTpHpO0uDigad6+ESdoOZA
         9D4KYeFMxQlENddr7+hRXK2N5YZDfNIq0M4vZQgL+kdFeGivFixig8i9iSov9BsGPA
         VpBTpwdbRq+inyQyCmFby8u7sJXOJcKYkvYXwujE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ning Bo <n.b@live.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jia He <justin.he@arm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 4.19 01/32] vhost: vsock: kick send_pkt worker once device is started
Date:   Fri,  8 May 2020 14:35:14 +0200
Message-Id: <20200508123035.056580682@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123034.886699170@linuxfoundation.org>
References: <20200508123034.886699170@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia He <justin.he@arm.com>

commit 0b841030625cde5f784dd62aec72d6a766faae70 upstream.

Ning Bo reported an abnormal 2-second gap when booting Kata container [1].
The unconditional timeout was caused by VSOCK_DEFAULT_CONNECT_TIMEOUT of
connecting from the client side. The vhost vsock client tries to connect
an initializing virtio vsock server.

The abnormal flow looks like:
host-userspace           vhost vsock                       guest vsock
==============           ===========                       ============
connect()     -------->  vhost_transport_send_pkt_work()   initializing
   |                     vq->private_data==NULL
   |                     will not be queued
   V
schedule_timeout(2s)
                         vhost_vsock_start()  <---------   device ready
                         set vq->private_data

wait for 2s and failed
connect() again          vq->private_data!=NULL         recv connecting pkt

Details:
1. Host userspace sends a connect pkt, at that time, guest vsock is under
   initializing, hence the vhost_vsock_start has not been called. So
   vq->private_data==NULL, and the pkt is not been queued to send to guest
2. Then it sleeps for 2s
3. After guest vsock finishes initializing, vq->private_data is set
4. When host userspace wakes up after 2s, send connecting pkt again,
   everything is fine.

As suggested by Stefano Garzarella, this fixes it by additional kicking the
send_pkt worker in vhost_vsock_start once the virtio device is started. This
makes the pending pkt sent again.

After this patch, kata-runtime (with vsock enabled) boot time is reduced
from 3s to 1s on a ThunderX2 arm64 server.

[1] https://github.com/kata-containers/runtime/issues/1917

Reported-by: Ning Bo <n.b@live.com>
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jia He <justin.he@arm.com>
Link: https://lore.kernel.org/r/20200501043840.186557-1-justin.he@arm.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vsock.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -499,6 +499,11 @@ static int vhost_vsock_start(struct vhos
 		mutex_unlock(&vq->mutex);
 	}
 
+	/* Some packets may have been queued before the device was started,
+	 * let's kick the send worker to send them.
+	 */
+	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
+
 	mutex_unlock(&vsock->dev.mutex);
 	return 0;
 


