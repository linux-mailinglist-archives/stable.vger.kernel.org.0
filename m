Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA63731FB05
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 15:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhBSOgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 09:36:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:40484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231307AbhBSOfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 09:35:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 98F54ACBF;
        Fri, 19 Feb 2021 14:34:59 +0000 (UTC)
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, gregkh@linuxfoundation.org
Cc:     Felipe Balbi <balbi@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        dri-devel@lists.freedesktop.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>
References: <20210219134014.7775-1-tzimmermann@suse.de>
 <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
Message-ID: <1169bf2d-ce01-9852-edd3-7d2df037012b@suse.de>
Date:   Fri, 19 Feb 2021 15:34:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="e5TjXblEt0QA7wvb8WniYELW6owEZUCgC"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e5TjXblEt0QA7wvb8WniYELW6owEZUCgC
Content-Type: multipart/mixed; boundary="IAtRXO9qa9m2QnvBEETOocAbF4KoRxjgu";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
 daniel@ffwll.ch, airlied@linux.ie, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, sumit.semwal@linaro.org, gregkh@linuxfoundation.org
Cc: Felipe Balbi <balbi@kernel.org>,
 Mathias Nyman <mathias.nyman@linux.intel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Oliver Neukum <oneukum@suse.com>, Johan Hovold <johan@kernel.org>,
 dri-devel@lists.freedesktop.org, Alan Stern <stern@rowland.harvard.edu>,
 stable@vger.kernel.org, "Ahmed S. Darwish" <a.darwish@linutronix.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Christoph Hellwig <hch@lst.de>
Message-ID: <1169bf2d-ce01-9852-edd3-7d2df037012b@suse.de>
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
References: <20210219134014.7775-1-tzimmermann@suse.de>
 <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
In-Reply-To: <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>

--IAtRXO9qa9m2QnvBEETOocAbF4KoRxjgu
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 19.02.21 um 14:45 schrieb Christian K=C3=B6nig:
> Well as far as I can see this is a relative clear NAK.
>=20
> When a device can't do DMA and has no DMA mask then why it is requestin=
g=20
> an sg-table in the first place?
>=20
> The problem is rather in drm_gem_prime_import_dev() which always tries =

> to create an sg-table to get a GEM object, even when the device doesn't=
=20
> support DMA at all.

Sure, that's the clean solution. But it also needs a bit of work on the=20
way the importing works. Our generic code assumes that an SG table is=20
being used. Most driver's memory managers as well, I guess.

The regressing patch has already been in upstream kernels for a while.=20
The fix at hand is backport-able at least.

Can we add a TODO item for the real thing?

Best regards
Thomas

>=20
> Regards,
> Christian.
>=20
> Am 19.02.21 um 14:40 schrieb Thomas Zimmermann:
>> Fixes a regression for udl and probably other USB-based drivers where
>> joining and mirroring displays fails.
>>
>> Joining displays requires importing a dma_buf from another DRM driver.=

>> These devices don't support DMA and therefore have no DMA mask. Trying=

>> to map imported buffers from a DMA-able memory zone fails with an erro=
r.
>> An example is shown below.
>>
>> [=C2=A0=C2=A0 60.050199] ------------[ cut here ]------------
>> [=C2=A0=C2=A0 60.055092] WARNING: CPU: 0 PID: 1403 at kernel/dma/mappi=
ng.c:190=20
>> dma_map_sg_attrs+0x8f/0xc0
>> [=C2=A0=C2=A0 60.064331] Modules linked in: af_packet(E) rfkill(E) dmi=
_sysfs(E)=20
>> intel_rapl_msr(E) intel_rapl_common(E) snd_hda_codec_realtek(E)=20
>> snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_codec_hdmi(E)=20
>> x86_pkg_temp_thermal(E) intel_powerclam)
>> [=C2=A0=C2=A0 60.064801]=C2=A0 wmi(E) video(E) btrfs(E) blake2b_generi=
c(E)=20
>> libcrc32c(E) crc32c_intel(E) xor(E) raid6_pq(E) sg(E) dm_multipath(E) =

>> dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) msr(E)=20
>> efivarfs(E)
>> [=C2=A0=C2=A0 60.170778] CPU: 0 PID: 1403 Comm: Xorg.bin Tainted: G   =
        =20
>> E=C2=A0=C2=A0=C2=A0 5.11.0-rc5-1-default+ #747
>> [=C2=A0=C2=A0 60.179841] Hardware name: Dell Inc. OptiPlex 9020/0N4YC8=
, BIOS A24=20
>> 10/24/2018
>> [=C2=A0=C2=A0 60.187145] RIP: 0010:dma_map_sg_attrs+0x8f/0xc0
>> [=C2=A0=C2=A0 60.191822] Code: 4d 85 ff 75 2b 49 89 d8 44 89 e1 44 89 =
f2 4c 89=20
>> ee 48 89 ef e8 62 30 00 00 85 c0 78 36 5b 5d 41 5c 41 5d 41 5e 41 5f=20
>> c3 0f 0b <0f> 0b 31 c0 eb ed 49 8d 7f 50 e8 72 f5 2a 00 49 8b 47 50 49=
=20
>> 89 d8
>> [=C2=A0=C2=A0 60.210770] RSP: 0018:ffffc90001d6fc18 EFLAGS: 00010246
>> [=C2=A0=C2=A0 60.216062] RAX: 0000000000000000 RBX: 0000000000000020 R=
CX:=20
>> ffffffffb31e677b
>> [=C2=A0=C2=A0 60.223274] RDX: dffffc0000000000 RSI: ffff888212c10600 R=
DI:=20
>> ffff8881b08a9488
>> [=C2=A0=C2=A0 60.230501] RBP: ffff8881b08a9030 R08: 0000000000000020 R=
09:=20
>> ffff888212c10600
>> [=C2=A0=C2=A0 60.237710] R10: ffffed10425820df R11: 0000000000000001 R=
12:=20
>> 0000000000000000
>> [=C2=A0=C2=A0 60.244939] R13: ffff888212c10600 R14: 0000000000000008 R=
15:=20
>> 0000000000000000
>> [=C2=A0=C2=A0 60.252155] FS:=C2=A0 00007f08ac2b2f00(0000) GS:ffff8887c=
be00000(0000)=20
>> knlGS:0000000000000000
>> [=C2=A0=C2=A0 60.260333] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000=
080050033
>> [=C2=A0=C2=A0 60.266150] CR2: 000055831c899be8 CR3: 000000015372e006 C=
R4:=20
>> 00000000001706f0
>> [=C2=A0=C2=A0 60.273369] Call Trace:
>> [=C2=A0=C2=A0 60.275845]=C2=A0 drm_gem_map_dma_buf+0xb4/0x120
>> [=C2=A0=C2=A0 60.280089]=C2=A0 dma_buf_map_attachment+0x15d/0x1e0
>> [=C2=A0=C2=A0 60.284688]=C2=A0 drm_gem_prime_import_dev.part.0+0x5d/0x=
140
>> [=C2=A0=C2=A0 60.289984]=C2=A0 drm_gem_prime_fd_to_handle+0x213/0x280
>> [=C2=A0=C2=A0 60.294931]=C2=A0 ? drm_prime_destroy_file_private+0x30/0=
x30
>> [=C2=A0=C2=A0 60.300224]=C2=A0 drm_ioctl_kernel+0x131/0x180
>> [=C2=A0=C2=A0 60.304291]=C2=A0 ? drm_setversion+0x230/0x230
>> [=C2=A0=C2=A0 60.308366]=C2=A0 ? drm_prime_destroy_file_private+0x30/0=
x30
>> [=C2=A0=C2=A0 60.313659]=C2=A0 drm_ioctl+0x2f1/0x500
>> [=C2=A0=C2=A0 60.317118]=C2=A0 ? drm_version+0x150/0x150
>> [=C2=A0=C2=A0 60.320903]=C2=A0 ? lock_downgrade+0xa0/0xa0
>> [=C2=A0=C2=A0 60.324806]=C2=A0 ? do_vfs_ioctl+0x5f4/0x680
>> [=C2=A0=C2=A0 60.328694]=C2=A0 ? __fget_files+0x13e/0x210
>> [=C2=A0=C2=A0 60.332591]=C2=A0 ? ioctl_fiemap.isra.0+0x1a0/0x1a0
>> [=C2=A0=C2=A0 60.337102]=C2=A0 ? __fget_files+0x15d/0x210
>> [=C2=A0=C2=A0 60.340990]=C2=A0 __x64_sys_ioctl+0xb9/0xf0
>> [=C2=A0=C2=A0 60.344795]=C2=A0 do_syscall_64+0x33/0x80
>> [=C2=A0=C2=A0 60.348427]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa=
9
>> [=C2=A0=C2=A0 60.353542] RIP: 0033:0x7f08ac7b53cb
>> [=C2=A0=C2=A0 60.357168] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 =
b5 e8 1c=20
>> ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00=20
>> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 ba 0c 00 f7 d8 64 89=
=20
>> 01 48
>> [=C2=A0=C2=A0 60.376108] RSP: 002b:00007ffeabc89fc8 EFLAGS: 00000246 O=
RIG_RAX:=20
>> 0000000000000010
>> [=C2=A0=C2=A0 60.383758] RAX: ffffffffffffffda RBX: 00007ffeabc8a00c R=
CX:=20
>> 00007f08ac7b53cb
>> [=C2=A0=C2=A0 60.390970] RDX: 00007ffeabc8a00c RSI: 00000000c00c642e R=
DI:=20
>> 000000000000000d
>> [=C2=A0=C2=A0 60.398221] RBP: 00000000c00c642e R08: 000055831c691d00 R=
09:=20
>> 000055831b2ec010
>> [=C2=A0=C2=A0 60.405446] R10: 00007f08acf6ada0 R11: 0000000000000246 R=
12:=20
>> 000055831c691d00
>> [=C2=A0=C2=A0 60.412667] R13: 000000000000000d R14: 00000000007e9000 R=
15:=20
>> 0000000000000000
>> [=C2=A0=C2=A0 60.419903] irq event stamp: 672893
>> [=C2=A0=C2=A0 60.423441] hardirqs last=C2=A0 enabled at (672913):=20
>> [<ffffffffb31b796d>] console_unlock+0x44d/0x500
>> [=C2=A0=C2=A0 60.432230] hardirqs last disabled at (672922):=20
>> [<ffffffffb31b7963>] console_unlock+0x443/0x500
>> [=C2=A0=C2=A0 60.441021] softirqs last=C2=A0 enabled at (672940):=20
>> [<ffffffffb46003dd>] __do_softirq+0x3dd/0x554
>> [=C2=A0=C2=A0 60.449634] softirqs last disabled at (672931):=20
>> [<ffffffffb44010f2>] asm_call_irq_on_stack+0x12/0x20
>> [=C2=A0=C2=A0 60.458871] ---[ end trace f2f88696eb17806c ]---
>>
>> For the fix, we don't call dma_map_sgtable() for devices without the
>> DMA mask. Drivers for such devices have to map the imported buffer int=
o
>> kernel address space and perfom the copy operation in software.
>>
>> Tested by joining/mirroring displays of udl and radeon un der Gnome/X1=
1.
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB=20
>> devices")
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Johan Hovold <johan@kernel.org>
>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Cc: Oliver Neukum <oneukum@suse.com>
>> Cc: Felipe Balbi <balbi@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: <stable@vger.kernel.org> # v5.10+
>> ---
>> =C2=A0 drivers/gpu/drm/drm_prime.c | 27 ++++++++++++++++++---------
>> =C2=A0 1 file changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c=

>> index 2a54f86856af..d5a39fe76b78 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -603,10 +603,15 @@ EXPORT_SYMBOL(drm_gem_map_detach);
>> =C2=A0=C2=A0 * @attach: attachment whose scatterlist is to be returned=

>> =C2=A0=C2=A0 * @dir: direction of DMA transfer
>> =C2=A0=C2=A0 *
>> - * Calls &drm_gem_object_funcs.get_sg_table and then maps the=20
>> scatterlist. This
>> - * can be used as the &dma_buf_ops.map_dma_buf callback. Should be=20
>> used together
>> + * Calls &drm_gem_object_funcs.get_sg_table and, if possible, maps=20
>> the scatterlist.
>> + * This can be used as the &dma_buf_ops.map_dma_buf callback. Should =

>> be used together
>> =C2=A0=C2=A0 * with drm_gem_unmap_dma_buf().
>> =C2=A0=C2=A0 *
>> + * Devices on some peripheral busses, such as USB, cannot use DMA. In=
=20
>> this case,
>> + * pages in the scatterlist remain unmapped. Drivers for such devices=
=20
>> should acquire
>> + * a mapping with dma_buf_vmap() and implement copy operation via=20
>> bus-specific
>> + * interfaces.
>> + *
>> =C2=A0=C2=A0 * Returns:sg_table containing the scatterlist to be retur=
ned;=20
>> returns ERR_PTR
>> =C2=A0=C2=A0 * on error. May return -EINTR if it is interrupted by a s=
ignal.
>> =C2=A0=C2=A0 */
>> @@ -627,12 +632,14 @@ struct sg_table *drm_gem_map_dma_buf(struct=20
>> dma_buf_attachment *attach,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(sgt))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return sgt;
>>
>> -=C2=A0=C2=A0=C2=A0 ret =3D dma_map_sgtable(attach->dev, sgt, dir,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DMA_ATTR_SKIP_CPU_SYNC);
>> -=C2=A0=C2=A0=C2=A0 if (ret) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sg_free_table(sgt);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(sgt);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sgt =3D ERR_PTR(ret);
>> +=C2=A0=C2=A0=C2=A0 if (attach->dev->dma_mask) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D dma_map_sgtable(at=
tach->dev, sgt, dir,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DMA_ATTR_SKIP_C=
PU_SYNC);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sg=
_free_table(sgt);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kf=
ree(sgt);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sg=
t =3D ERR_PTR(ret);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return sgt;
>> @@ -654,7 +661,9 @@ void drm_gem_unmap_dma_buf(struct=20
>> dma_buf_attachment *attach,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!sgt)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>
>> -=C2=A0=C2=A0=C2=A0 dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_=
SKIP_CPU_SYNC);
>> +=C2=A0=C2=A0=C2=A0 if (attach->dev->dma_mask)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dma_unmap_sgtable(attach->=
dev, sgt, dir,=20
>> DMA_ATTR_SKIP_CPU_SYNC);
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sg_free_table(sgt);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(sgt);
>> =C2=A0 }
>> --=20
>> 2.30.0
>>
>=20
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--IAtRXO9qa9m2QnvBEETOocAbF4KoRxjgu--

--e5TjXblEt0QA7wvb8WniYELW6owEZUCgC
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmAvzJEFAwAAAAAACgkQlh/E3EQov+CD
EQ/5AYEhp3ZU5p9YkoMRaq89F7+MCaGbSYCQEuVKKKuj//y+er4t4P2JYW0Y3+iC/VoLf9xgiBQZ
bIonqHxEvNjWPDRl/g9yX8LkIHqvRwM01oME/a0sG1Mf6nBqqDrfTTDnjjZMFwG0xID7OD9Skihg
R6ZcTarGb/TLy7S1EpOXnpfGLYC+Q6EDcj1bBwhYz5ASagUH/9aDlVuc6nTILLl+Nui2M6uZeEmm
qq/qmLKU/sGWe8eV50iumttUkVVP2KOleAOCsQ81utjn62j4/D2mF2fCddsWUdijBxl+GYn9QfEX
WkcolFaXvmCUuilX6Fy8KrOAtTugyy49WE2DZecRP9P75nOOdH3K2wSSSZOognV+9l8/bon6Qk6x
PywvzoR9efiI42GZ7q32tgUQL+t1BkMoohIL7MWpd6P5q6nrDQfMXXx055pDFEZv1krJmPjubFSO
GH8vfz9LsM1O2RiFiB3LRo0QIRE6+qFZt0GDHHybWyOMte5DC2xtLfk+gvk4cNY20V2ZltkJZb/3
iAvSxqjT/ZjulCdRdwZGWWRxHcpCUP4XF6jc6kE8+ASAGITIu0uB/ZItrSRCvHAmVES72Y63NQxz
T6MztNzPDCH61rsiBPBkPBeDNv1JUwyzdSfUb6DlTocNQgjpycgbWh4URNgb2yjuAlFdMZCERXk3
ScQ=
=7GsR
-----END PGP SIGNATURE-----

--e5TjXblEt0QA7wvb8WniYELW6owEZUCgC--
