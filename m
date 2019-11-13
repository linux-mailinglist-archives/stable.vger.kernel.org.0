Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51352FB546
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 17:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfKMQho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 11:37:44 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726410AbfKMQho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 11:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573663062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ElVWHe0E2GsnNdVieMJ9C/aI719WWsQzksx8uzxZwi8=;
        b=OkOzVU8L/ykOVT+cAL6lyn+Mmxe0jyAKIcR675WMCB9i9ug0eYuNq+wuYqJaagk7F4yKln
        lJO96D7CT7i2YQZ3CcoTdNR0286AQO5UpJVG/KZsj6dngIZb/Hs6WASGjJX7n7gLWbSP1l
        vAT2ebsWvmxArEp90iwwHikthVp/PEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-jLDv7rF7OlWr1KL5gY8GiA-1; Wed, 13 Nov 2019 11:37:40 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7210B18C6E8E;
        Wed, 13 Nov 2019 16:37:39 +0000 (UTC)
Received: from [10.36.117.236] (ovpn-117-236.ams2.redhat.com [10.36.117.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3ADA460C88;
        Wed, 13 Nov 2019 16:37:35 +0000 (UTC)
Subject: Re: [PATCH v2] virtio_console: allocate inbufs in add_port() only if
 it is needed
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit@kernel.org>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
References: <20191113150056.9990-1-lvivier@redhat.com>
 <20191113101929-mutt-send-email-mst@kernel.org>
 <20191113102126-mutt-send-email-mst@kernel.org>
From:   Laurent Vivier <lvivier@redhat.com>
Autocrypt: addr=lvivier@redhat.com; prefer-encrypt=mutual; keydata=
 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
 D+Ofp0T3KOr1RUHvCZoLURfFhSQ=
Message-ID: <7bd34d61-146f-8edb-d82d-7285a83437b4@redhat.com>
Date:   Wed, 13 Nov 2019 17:37:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191113102126-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: jLDv7rF7OlWr1KL5gY8GiA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/11/2019 16:22, Michael S. Tsirkin wrote:
> On Wed, Nov 13, 2019 at 10:21:11AM -0500, Michael S. Tsirkin wrote:
>> On Wed, Nov 13, 2019 at 04:00:56PM +0100, Laurent Vivier wrote:
>>> When we hot unplug a virtserialport and then try to hot plug again,
>>> it fails:
>>>
>>> (qemu) chardev-add socket,id=3Dserial0,path=3D/tmp/serial0,server,nowai=
t
>>> (qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
>>>                   chardev=3Dserial0,id=3Dserial0,name=3Dserial0
>>> (qemu) device_del serial0
>>> (qemu) device_add virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,\
>>>                   chardev=3Dserial0,id=3Dserial0,name=3Dserial0
>>> kernel error:
>>>   virtio-ports vport2p2: Error allocating inbufs
>>> qemu error:
>>>   virtio-serial-bus: Guest failure in adding port 2 for device \
>>>                      virtio-serial0.0
>>>
>>> This happens because buffers for the in_vq are allocated when the port =
is
>>> added but are not released when the port is unplugged.
>>>
>>> They are only released when virtconsole is removed (see a7a69ec0d8e4)
>>>
>>> To avoid the problem and to be symmetric, we could allocate all the buf=
fers
>>> in init_vqs() as they are released in remove_vqs(), but it sounds like
>>> a waste of memory.
>>>
>>> Rather than that, this patch changes add_port() logic to ignore ENOSPC
>>> error in fill_queue(), which means queue has already been filled.
>>>
>>> Fixes: a7a69ec0d8e4 ("virtio_console: free buffers after reset")
>>> Cc: mst@redhat.com
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>> ---
>>>
>>> Notes:
>>>     v2: making fill_queue return int and testing return code for -ENOSP=
C
>>>
>>>  drivers/char/virtio_console.c | 24 +++++++++---------------
>>>  1 file changed, 9 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_consol=
e.c
>>> index 7270e7b69262..9e6534fd1aa4 100644
>>> --- a/drivers/char/virtio_console.c
>>> +++ b/drivers/char/virtio_console.c
>>> @@ -1325,24 +1325,24 @@ static void set_console_size(struct port *port,=
 u16 rows, u16 cols)
>>>  =09port->cons.ws.ws_col =3D cols;
>>>  }
>>> =20
>>> -static unsigned int fill_queue(struct virtqueue *vq, spinlock_t *lock)
>>> +static int fill_queue(struct virtqueue *vq, spinlock_t *lock)
>>>  {
>>>  =09struct port_buffer *buf;
>>> -=09unsigned int nr_added_bufs;
>>> +=09int nr_added_bufs;
>>>  =09int ret;
>>> =20
>>>  =09nr_added_bufs =3D 0;
>>>  =09do {
>>>  =09=09buf =3D alloc_buf(vq->vdev, PAGE_SIZE, 0);
>>>  =09=09if (!buf)
>>> -=09=09=09break;
>>> +=09=09=09return -ENOMEM;
>>> =20
>>>  =09=09spin_lock_irq(lock);
>>>  =09=09ret =3D add_inbuf(vq, buf);
>>>  =09=09if (ret < 0) {
>>>  =09=09=09spin_unlock_irq(lock);
>>>  =09=09=09free_buf(buf, true);
>>> -=09=09=09break;
>>> +=09=09=09return ret;
>>>  =09=09}
>>>  =09=09nr_added_bufs++;
>>>  =09=09spin_unlock_irq(lock);
>=20
> So actually, how about handling ENOSPC specially here, and
> returning success? After all queue is full as requested ...

I think it's interesting to return -ENOSPC to manage it as a real error
in virtcons_probe() as in this function the queue should not be already
full (is this right?) and to return the real error code.

Thanks,
Laurent

