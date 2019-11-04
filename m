Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4025DEEDC8
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390101AbfKDWJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389452AbfKDWJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:53 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23672205C9;
        Mon,  4 Nov 2019 22:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905392;
        bh=pUXAuHhbZFgiGOo8c2/CTCXAlpeJgcFS7eJ7UugIV0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/UmEb3m2QNHjd21jiomwTBGIVL/s6W/f1+XRUX7LagZaGyB/lxHf74R76pOGx2qo
         SxbemCS5q2432vmmFpAtT00dg/WkIdUK2T9HU3WuOPIht/6IVsvXAab9g32T16sRYc
         77VHtG6Ex8ZB9onWQWO8O0Wbbmim9cC+zIzEi3gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Marvin Liu <yong.liu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.3 129/163] virtio_ring: fix stalls for packed rings
Date:   Mon,  4 Nov 2019 22:45:19 +0100
Message-Id: <20191104212149.645712072@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marvin Liu <yong.liu@intel.com>

commit 40ce7919d8730f5936da2bc8a21b46bd07db6411 upstream.

When VIRTIO_F_RING_EVENT_IDX is negotiated, virtio devices can
use virtqueue_enable_cb_delayed_packed to reduce the number of device
interrupts.  At the moment, this is the case for virtio-net when the
napi_tx module parameter is set to false.

In this case, the virtio driver selects an event offset and expects that
the device will send a notification when rolling over the event offset
in the ring.  However, if this roll-over happens before the event
suppression structure update, the notification won't be sent. To address
this race condition the driver needs to check wether the device rolled
over the offset after updating the event suppression structure.

With VIRTIO_F_RING_PACKED, the virtio driver did this by reading the
flags field of the descriptor at the specified offset.

Unfortunately, checking at the event offset isn't reliable: if
descriptors are chained (e.g. when INDIRECT is off) not all descriptors
are overwritten by the device, so it's possible that the device skipped
the specific descriptor driver is checking when writing out used
descriptors. If this happens, the driver won't detect the race condition
and will incorrectly expect the device to send a notification.

For virtio-net, the result will be a TX queue stall, with the
transmission getting blocked forever.

With the packed ring, it isn't easy to find a location which is
guaranteed to change upon the roll-over, except the next device
descriptor, as described in the spec:

        Writes of device and driver descriptors can generally be
        reordered, but each side (driver and device) are only required to
        poll (or test) a single location in memory: the next device descriptor after
        the one they processed previously, in circular order.

while this might be sub-optimal, let's do exactly this for now.

Cc: stable@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Fixes: f51f982682e2a ("virtio_ring: leverage event idx in packed ring")
Signed-off-by: Marvin Liu <yong.liu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_ring.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1499,9 +1499,6 @@ static bool virtqueue_enable_cb_delayed_
 		 * counter first before updating event flags.
 		 */
 		virtio_wmb(vq->weak_barriers);
-	} else {
-		used_idx = vq->last_used_idx;
-		wrap_counter = vq->packed.used_wrap_counter;
 	}
 
 	if (vq->packed.event_flags_shadow == VRING_PACKED_EVENT_FLAG_DISABLE) {
@@ -1518,7 +1515,9 @@ static bool virtqueue_enable_cb_delayed_
 	 */
 	virtio_mb(vq->weak_barriers);
 
-	if (is_used_desc_packed(vq, used_idx, wrap_counter)) {
+	if (is_used_desc_packed(vq,
+				vq->last_used_idx,
+				vq->packed.used_wrap_counter)) {
 		END_USE(vq);
 		return false;
 	}


