Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2D22B4468
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 14:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgKPNHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 08:07:41 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:52326 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgKPNHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 08:07:41 -0500
Date:   Mon, 16 Nov 2020 13:07:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1605532056; bh=8oVEkWwUGCZq1VBwSHjSrKA6sbt5877cWkL9X4cTHoA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Kq1bYk8/r3uZv2QoQqriIJn223K57uI2nZgMyAzeEM1UVUQpxzjk2Fm/p5mD4BQ8a
         naNL+VRGgo7TEiN05NwbLucBTFoBhfdEe0C0l523jPXkrXJZR47DcNddBpsGu9d4An
         RazR0OnVsm/rRa5F4xGu2BSpeTAtSOio+lWWEkicfI/mlr3KU/Gsl8xGOwR7lthVF5
         LY81/L7421PqAPkHBMFwdkxChMQthTe7l8LmsNAZUKykllsHMZRd5d7HRy3SiSNC0b
         4KvGcwB7iZjfVAKbvJZVfIef9BUIgC6iCnChOEnxc28zjgQ6ndwS4c1JnwPXcH0f/z
         AuImkK3WzdeKQ==
To:     "Michael S. Tsirkin" <mst@redhat.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Christoph Hellwig <hch@infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Amit Shah <amit@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        virtualization@lists.linux-foundation.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation for rproc serial
Message-ID: <u9RJBckNwnezQttAPrOyEqDYKu0rnhedUZYGpaS83qg@cp3-web-024.plabs.ch>
In-Reply-To: <20201116071910-mutt-send-email-mst@kernel.org>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch> <20201116091950.GA30524@infradead.org> <20201116071910-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 16 Nov 2020 07:25:31 -0500

> On Mon, Nov 16, 2020 at 09:19:50AM +0000, Christoph Hellwig wrote:
>> I just noticed this showing up in Linus' tree and I'm not happy.
>
> Are you sure? I think it's in next.

Nope, it goes to fixes since it just fixes the regression introduced
in 5.7.
That's why it's not about any refactoring or rethinking the whole
model.

>> This whole model of the DMA subdevices in remoteproc is simply broken.
>>
>> We really need to change the virtio code pass an expicit DMA device (
>> similar to what e.g. the USB and RDMA code does), instead of faking up
>> devices with broken adhoc inheritance of DMA properties and magic poking
>> into device parent relationships.

But lots of subsystems like netdev for example uses dev->parent for
DMA operations. I know that their pointers go directly to the
platform/PCI/etc. device, but still.

The only reason behind "fake" DMA devices for rproc is to be able to
reserve DMA memory through the Device Tree exclusively for only one
virtio dev like virtio_console or virtio_rpmsg_bus. That's why
they are present, are coercing DMA caps from physical dev
representor, and why questinable dma_declare_coherent_memory()
is still here and doesn't allow to build rproc core as a module.
I agree that this is not the best model obviously, and we should take
a look at it.

> OK but we do have a regression since 5.7 and this looks like
> a fix appropriate for e.g. stable, right?
>
>> Bjorn, I thought you were going to look into this a while ago?
>>
>>
>> On Wed, Nov 04, 2020 at 03:31:36PM +0000, Alexander Lobakin wrote:
>>> Since commit 086d08725d34 ("remoteproc: create vdev subdevice with
>>> specific dma memory pool"), every remoteproc has a DMA subdevice
>>> ("remoteprocX#vdevYbuffer") for each virtio device, which inherits
>>> DMA capabilities from the corresponding platform device. This allowed
>>> to associate different DMA pools with each vdev, and required from
>>> virtio drivers to perform DMA operations with the parent device
>>> (vdev->dev.parent) instead of grandparent (vdev->dev.parent->parent).
>>>
>>> virtio_rpmsg_bus was already changed in the same merge cycle with
>>> commit d999b622fcfb ("rpmsg: virtio: allocate buffer from parent"),
>>> but virtio_console did not. In fact, operations using the grandparent
>>> worked fine while the grandparent was the platform device, but since
>>> commit c774ad010873 ("remoteproc: Fix and restore the parenting
>>> hierarchy for vdev") this was changed, and now the grandparent device
>>> is the remoteproc device without any DMA capabilities.
>>> So, starting v5.8-rc1 the following warning is observed:
>>>
>>> [    2.483925] ------------[ cut here ]------------
>>> [    2.489148] WARNING: CPU: 3 PID: 101 at kernel/dma/mapping.c:427 0x8=
0e7eee8
>>> [    2.489152] Modules linked in: virtio_console(+)
>>> [    2.503737]  virtio_rpmsg_bus rpmsg_core
>>> [    2.508903]
>>> [    2.528898] <Other modules, stack and call trace here>
>>> [    2.913043]
>>> [    2.914907] ---[ end trace 93ac8746beab612c ]---
>>> [    2.920102] virtio-ports vport1p0: Error allocating inbufs
>>>
>>> kernel/dma/mapping.c:427 is:
>>>
>>> WARN_ON_ONCE(!dev->coherent_dma_mask);
>>>
>>> obviously because the grandparent now is remoteproc dev without any
>>> DMA caps:
>>>
>>> [    3.104943] Parent: remoteproc0#vdev1buffer, grandparent: remoteproc=
0
>>>
>>> Fix this the same way as it was for virtio_rpmsg_bus, using just the
>>> parent device (vdev->dev.parent, "remoteprocX#vdevYbuffer") for DMA
>>> operations.
>>> This also allows now to reserve DMA pools/buffers for rproc serial
>>> via Device Tree.
>>>
>>> Fixes: c774ad010873 ("remoteproc: Fix and restore the parenting hierarc=
hy for vdev")
>>> Cc: stable@vger.kernel.org # 5.1+
>>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>>> ---
>>>  drivers/char/virtio_console.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_consol=
e.c
>>> index a2da8f768b94..1836cc56e357 100644
>>> --- a/drivers/char/virtio_console.c
>>> +++ b/drivers/char/virtio_console.c
>>> @@ -435,12 +435,12 @@ static struct port_buffer *alloc_buf(struct virti=
o_device *vdev, size_t buf_size
>>>  =09=09/*
>>>  =09=09 * Allocate DMA memory from ancestor. When a virtio
>>>  =09=09 * device is created by remoteproc, the DMA memory is
>>> -=09=09 * associated with the grandparent device:
>>> -=09=09 * vdev =3D> rproc =3D> platform-dev.
>>> +=09=09 * associated with the parent device:
>>> +=09=09 * virtioY =3D> remoteprocX#vdevYbuffer.
>>>  =09=09 */
>>> -=09=09if (!vdev->dev.parent || !vdev->dev.parent->parent)
>>> +=09=09buf->dev =3D vdev->dev.parent;
>>> +=09=09if (!buf->dev)
>>>  =09=09=09goto free_buf;
>>> -=09=09buf->dev =3D vdev->dev.parent->parent;
>>>
>>>  =09=09/* Increase device refcnt to avoid freeing it */
>>>  =09=09get_device(buf->dev);
>>> --
>>> 2.29.2
>>>
>>>
>> ---end quoted text---

Thanks,
Al

