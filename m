Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E354E6CC4
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 08:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730752AbfJ1HOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 03:14:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32493 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730715AbfJ1HOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 03:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572246839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gF7SCUNNkREDqMPabWX15Cl/xUWOTTN3vml4/5CORAM=;
        b=IDbqdbrBFW6fPEdNNbt3S1V91E/yQ7jWhwRWw2lcCp/Gjxp8/R1Cwaz9/wsZ9N6Tg1ry0n
        uosGleQIzvLuhbUiOCUpcftsHj/AbzWJWWdeHRnPBnReUcI8+jKx6KhxG5UbKN3f94rMQ/
        mdRwyHTyiWzO4uYSjEEUi5AVizCetfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-tcVWAHiHOTGi6qxv19Hl2g-1; Mon, 28 Oct 2019 03:13:55 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED404800D41;
        Mon, 28 Oct 2019 07:13:54 +0000 (UTC)
Received: from [10.72.12.88] (ovpn-12-88.pek2.redhat.com [10.72.12.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84B035DA32;
        Mon, 28 Oct 2019 07:13:49 +0000 (UTC)
Subject: Re: [PATCH] virtio_ring: fix stalls for packed rings
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Marvin Liu <yong.liu@intel.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20191027100705.11644-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <efe3c06f-0a80-c266-c7fc-ac33901f51c7@redhat.com>
Date:   Mon, 28 Oct 2019 15:13:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191027100705.11644-1-mst@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: tcVWAHiHOTGi6qxv19Hl2g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2019/10/27 =E4=B8=8B=E5=8D=886:08, Michael S. Tsirkin wrote:
> From: Marvin Liu <yong.liu@intel.com>
>
> When VIRTIO_F_RING_EVENT_IDX is negotiated, virtio devices can
> use virtqueue_enable_cb_delayed_packed to reduce the number of device
> interrupts.  At the moment, this is the case for virtio-net when the
> napi_tx module parameter is set to false.
>
> In this case, the virtio driver selects an event offset and expects that
> the device will send a notification when rolling over the event offset
> in the ring.  However, if this roll-over happens before the event
> suppression structure update, the notification won't be sent. To address
> this race condition the driver needs to check wether the device rolled
> over the offset after updating the event suppression structure.
>
> With VIRTIO_F_RING_PACKED, the virtio driver did this by reading the
> flags field of the descriptor at the specified offset.
>
> Unfortunately, checking at the event offset isn't reliable: if
> descriptors are chained (e.g. when INDIRECT is off) not all descriptors
> are overwritten by the device, so it's possible that the device skipped
> the specific descriptor driver is checking when writing out used
> descriptors. If this happens, the driver won't detect the race condition
> and will incorrectly expect the device to send a notification.
>
> For virtio-net, the result will be a TX queue stall, with the
> transmission getting blocked forever.
>
> With the packed ring, it isn't easy to find a location which is
> guaranteed to change upon the roll-over, except the next device
> descriptor, as described in the spec:
>
>          Writes of device and driver descriptors can generally be
>          reordered, but each side (driver and device) are only required t=
o
>          poll (or test) a single location in memory: the next device desc=
riptor after
>          the one they processed previously, in circular order.
>
> while this might be sub-optimal, let's do exactly this for now.
>
> Cc: stable@vger.kernel.org
Fixes: f51f982682e2a ("virtio_ring: leverage event idx in packed ring")
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Marvin Liu <yong.liu@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> So this is what I have in my tree now - this is just Marvin's patch
> with a tweaked description.
>
>
>   drivers/virtio/virtio_ring.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index bdc08244a648..a8041e451e9e 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1499,9 +1499,6 @@ static bool virtqueue_enable_cb_delayed_packed(stru=
ct virtqueue *_vq)
>   =09=09 * counter first before updating event flags.
>   =09=09 */
>   =09=09virtio_wmb(vq->weak_barriers);
> -=09} else {
> -=09=09used_idx =3D vq->last_used_idx;
> -=09=09wrap_counter =3D vq->packed.used_wrap_counter;
>   =09}
>  =20
>   =09if (vq->packed.event_flags_shadow =3D=3D VRING_PACKED_EVENT_FLAG_DIS=
ABLE) {
> @@ -1518,7 +1515,9 @@ static bool virtqueue_enable_cb_delayed_packed(stru=
ct virtqueue *_vq)
>   =09 */
>   =09virtio_mb(vq->weak_barriers);
>  =20
> -=09if (is_used_desc_packed(vq, used_idx, wrap_counter)) {
> +=09if (is_used_desc_packed(vq,
> +=09=09=09=09vq->last_used_idx,
> +=09=09=09=09vq->packed.used_wrap_counter)) {
>   =09=09END_USE(vq);
>   =09=09return false;
>   =09}

