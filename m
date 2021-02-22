Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AD53211A9
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 08:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhBVHzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 02:55:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:47738 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230264AbhBVHzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 02:55:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95EB5ACF6;
        Mon, 22 Feb 2021 07:54:24 +0000 (UTC)
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
To:     =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>,
        daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sumit.semwal@linaro.org, christian.koenig@amd.com,
        gregkh@linuxfoundation.org
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
 <79e272cb-b010-cb8d-57d3-71999164291a@tronnes.org>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <823e5782-7dd0-d864-02b5-4c1e6edd0528@suse.de>
Date:   Mon, 22 Feb 2021 08:54:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <79e272cb-b010-cb8d-57d3-71999164291a@tronnes.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n0R7oFBPwnJJ2u7rrKI6Dv8v4KmpRpmpu"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n0R7oFBPwnJJ2u7rrKI6Dv8v4KmpRpmpu
Content-Type: multipart/mixed; boundary="eLFgykq6Ybles7SOOzhWnBgecEQNqe833";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>, daniel@ffwll.ch,
 airlied@linux.ie, maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 sumit.semwal@linaro.org, christian.koenig@amd.com, gregkh@linuxfoundation.org
Cc: Felipe Balbi <balbi@kernel.org>,
 Mathias Nyman <mathias.nyman@linux.intel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Oliver Neukum <oneukum@suse.com>, Johan Hovold <johan@kernel.org>,
 dri-devel@lists.freedesktop.org, Alan Stern <stern@rowland.harvard.edu>,
 stable@vger.kernel.org, "Ahmed S. Darwish" <a.darwish@linutronix.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Christoph Hellwig <hch@lst.de>
Message-ID: <823e5782-7dd0-d864-02b5-4c1e6edd0528@suse.de>
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
References: <20210219134014.7775-1-tzimmermann@suse.de>
 <79e272cb-b010-cb8d-57d3-71999164291a@tronnes.org>
In-Reply-To: <79e272cb-b010-cb8d-57d3-71999164291a@tronnes.org>

--eLFgykq6Ybles7SOOzhWnBgecEQNqe833
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 20.02.21 um 14:02 schrieb Noralf Tr=C3=B8nnes:
>=20
>=20
> Den 19.02.2021 14.40, skrev Thomas Zimmermann:
>> Fixes a regression for udl and probably other USB-based drivers where
>> joining and mirroring displays fails.
>>
>> Joining displays requires importing a dma_buf from another DRM driver.=

>> These devices don't support DMA and therefore have no DMA mask. Trying=

>> to map imported buffers from a DMA-able memory zone fails with an erro=
r.
>> An example is shown below.
>>
>> [   60.050199] ------------[ cut here ]------------
>> [   60.055092] WARNING: CPU: 0 PID: 1403 at kernel/dma/mapping.c:190 d=
ma_map_sg_attrs+0x8f/0xc0
>> [   60.064331] Modules linked in: af_packet(E) rfkill(E) dmi_sysfs(E) =
intel_rapl_msr(E) intel_rapl_common(E) snd_hda_codec_realtek(E) snd_hda_c=
odec_generic(E) ledtrig_audio(E) snd_hda_codec_hdmi(E) x86_pkg_temp_therm=
al(E) intel_powerclam)
>> [   60.064801]  wmi(E) video(E) btrfs(E) blake2b_generic(E) libcrc32c(=
E) crc32c_intel(E) xor(E) raid6_pq(E) sg(E) dm_multipath(E) dm_mod(E) scs=
i_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) msr(E) efivarfs(E)
>> [   60.170778] CPU: 0 PID: 1403 Comm: Xorg.bin Tainted: G            E=
    5.11.0-rc5-1-default+ #747
>> [   60.179841] Hardware name: Dell Inc. OptiPlex 9020/0N4YC8, BIOS A24=
 10/24/2018
>> [   60.187145] RIP: 0010:dma_map_sg_attrs+0x8f/0xc0
>> [   60.191822] Code: 4d 85 ff 75 2b 49 89 d8 44 89 e1 44 89 f2 4c 89 e=
e 48 89 ef e8 62 30 00 00 85 c0 78 36 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f=
 0b <0f> 0b 31 c0 eb ed 49 8d 7f 50 e8 72 f5 2a 00 49 8b 47 50 49 89 d8
>> [   60.210770] RSP: 0018:ffffc90001d6fc18 EFLAGS: 00010246
>> [   60.216062] RAX: 0000000000000000 RBX: 0000000000000020 RCX: ffffff=
ffb31e677b
>> [   60.223274] RDX: dffffc0000000000 RSI: ffff888212c10600 RDI: ffff88=
81b08a9488
>> [   60.230501] RBP: ffff8881b08a9030 R08: 0000000000000020 R09: ffff88=
8212c10600
>> [   60.237710] R10: ffffed10425820df R11: 0000000000000001 R12: 000000=
0000000000
>> [   60.244939] R13: ffff888212c10600 R14: 0000000000000008 R15: 000000=
0000000000
>> [   60.252155] FS:  00007f08ac2b2f00(0000) GS:ffff8887cbe00000(0000) k=
nlGS:0000000000000000
>> [   60.260333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   60.266150] CR2: 000055831c899be8 CR3: 000000015372e006 CR4: 000000=
00001706f0
>> [   60.273369] Call Trace:
>> [   60.275845]  drm_gem_map_dma_buf+0xb4/0x120
>> [   60.280089]  dma_buf_map_attachment+0x15d/0x1e0
>> [   60.284688]  drm_gem_prime_import_dev.part.0+0x5d/0x140
>> [   60.289984]  drm_gem_prime_fd_to_handle+0x213/0x280
>> [   60.294931]  ? drm_prime_destroy_file_private+0x30/0x30
>> [   60.300224]  drm_ioctl_kernel+0x131/0x180
>> [   60.304291]  ? drm_setversion+0x230/0x230
>> [   60.308366]  ? drm_prime_destroy_file_private+0x30/0x30
>> [   60.313659]  drm_ioctl+0x2f1/0x500
>> [   60.317118]  ? drm_version+0x150/0x150
>> [   60.320903]  ? lock_downgrade+0xa0/0xa0
>> [   60.324806]  ? do_vfs_ioctl+0x5f4/0x680
>> [   60.328694]  ? __fget_files+0x13e/0x210
>> [   60.332591]  ? ioctl_fiemap.isra.0+0x1a0/0x1a0
>> [   60.337102]  ? __fget_files+0x15d/0x210
>> [   60.340990]  __x64_sys_ioctl+0xb9/0xf0
>> [   60.344795]  do_syscall_64+0x33/0x80
>> [   60.348427]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> I'm working on a USB display driver and got the same splat (although
> from i915_gem_map_dma_buf) and silenced it using:
>=20
> 	ret =3D dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
>=20
> But I understand now that this is not the solution.
>=20
> Since the USB host controller can do DMA, would the following be an
> acceptable solution?

Not all controllers can do DMA AFAIK, so it's maybe not reliable. I'll=20
send out another patch to address the issue later today.

Best regards
Thomas

>=20
> static struct drm_gem_object *gud_gem_prime_import(struct drm_device
> *drm, struct dma_buf *dma_buf)
> {
> 	struct usb_device *usb =3D gud_to_usb_device(to_gud_device(drm));
>=20
> 	drm_dbg_prime(drm, "usb->bus->controller=3D%s\n",
> dev_name(usb->bus->controller));
>=20
> 	return drm_gem_prime_import_dev(drm, dma_buf, usb->bus->controller);
> }
>=20
> static const struct drm_driver gud_drm_driver =3D {
> 	.gem_prime_import	=3D gud_gem_prime_import,
> };
>=20
>=20
> Noralf.
>=20
>> [   60.353542] RIP: 0033:0x7f08ac7b53cb
>> [   60.357168] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c f=
f ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f=
 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 ba 0c 00 f7 d8 64 89 01 48
>> [   60.376108] RSP: 002b:00007ffeabc89fc8 EFLAGS: 00000246 ORIG_RAX: 0=
000000000000010
>> [   60.383758] RAX: ffffffffffffffda RBX: 00007ffeabc8a00c RCX: 00007f=
08ac7b53cb
>> [   60.390970] RDX: 00007ffeabc8a00c RSI: 00000000c00c642e RDI: 000000=
000000000d
>> [   60.398221] RBP: 00000000c00c642e R08: 000055831c691d00 R09: 000055=
831b2ec010
>> [   60.405446] R10: 00007f08acf6ada0 R11: 0000000000000246 R12: 000055=
831c691d00
>> [   60.412667] R13: 000000000000000d R14: 00000000007e9000 R15: 000000=
0000000000
>> [   60.419903] irq event stamp: 672893
>> [   60.423441] hardirqs last  enabled at (672913): [<ffffffffb31b796d>=
] console_unlock+0x44d/0x500
>> [   60.432230] hardirqs last disabled at (672922): [<ffffffffb31b7963>=
] console_unlock+0x443/0x500
>> [   60.441021] softirqs last  enabled at (672940): [<ffffffffb46003dd>=
] __do_softirq+0x3dd/0x554
>> [   60.449634] softirqs last disabled at (672931): [<ffffffffb44010f2>=
] asm_call_irq_on_stack+0x12/0x20
>> [   60.458871] ---[ end trace f2f88696eb17806c ]---
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
>> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devic=
es")
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
>>   drivers/gpu/drm/drm_prime.c | 27 ++++++++++++++++++---------
>>   1 file changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c=

>> index 2a54f86856af..d5a39fe76b78 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -603,10 +603,15 @@ EXPORT_SYMBOL(drm_gem_map_detach);
>>    * @attach: attachment whose scatterlist is to be returned
>>    * @dir: direction of DMA transfer
>>    *
>> - * Calls &drm_gem_object_funcs.get_sg_table and then maps the scatter=
list. This
>> - * can be used as the &dma_buf_ops.map_dma_buf callback. Should be us=
ed together
>> + * Calls &drm_gem_object_funcs.get_sg_table and, if possible, maps th=
e scatterlist.
>> + * This can be used as the &dma_buf_ops.map_dma_buf callback. Should =
be used together
>>    * with drm_gem_unmap_dma_buf().
>>    *
>> + * Devices on some peripheral busses, such as USB, cannot use DMA. In=
 this case,
>> + * pages in the scatterlist remain unmapped. Drivers for such devices=
 should acquire
>> + * a mapping with dma_buf_vmap() and implement copy operation via bus=
-specific
>> + * interfaces.
>> + *
>>    * Returns:sg_table containing the scatterlist to be returned; retur=
ns ERR_PTR
>>    * on error. May return -EINTR if it is interrupted by a signal.
>>    */
>> @@ -627,12 +632,14 @@ struct sg_table *drm_gem_map_dma_buf(struct dma_=
buf_attachment *attach,
>>   	if (IS_ERR(sgt))
>>   		return sgt;
>>
>> -	ret =3D dma_map_sgtable(attach->dev, sgt, dir,
>> -			      DMA_ATTR_SKIP_CPU_SYNC);
>> -	if (ret) {
>> -		sg_free_table(sgt);
>> -		kfree(sgt);
>> -		sgt =3D ERR_PTR(ret);
>> +	if (attach->dev->dma_mask) {
>> +		ret =3D dma_map_sgtable(attach->dev, sgt, dir,
>> +				      DMA_ATTR_SKIP_CPU_SYNC);
>> +		if (ret) {
>> +			sg_free_table(sgt);
>> +			kfree(sgt);
>> +			sgt =3D ERR_PTR(ret);
>> +		}
>>   	}
>>
>>   	return sgt;
>> @@ -654,7 +661,9 @@ void drm_gem_unmap_dma_buf(struct dma_buf_attachme=
nt *attach,
>>   	if (!sgt)
>>   		return;
>>
>> -	dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
>> +	if (attach->dev->dma_mask)
>> +		dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
>> +
>>   	sg_free_table(sgt);
>>   	kfree(sgt);
>>   }
>> --
>> 2.30.0
>>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--eLFgykq6Ybles7SOOzhWnBgecEQNqe833--

--n0R7oFBPwnJJ2u7rrKI6Dv8v4KmpRpmpu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmAzYy8FAwAAAAAACgkQlh/E3EQov+D0
cBAAzxnhLDizBkiZQ/SCBUQaRqbnJ9iJLT1HySO/RVfw4BDkXi/0itLlVyzzX+4U2f4qwz6+sXWI
qP1GqbdmTR/qGTvUVYx1UFbN2EXCc1HkDoCcaTdKK1afPlhYYKW41z7FvNlMS/L09vALveBqIXP3
bgciAKRzcZZM7/1OaHEOWyEbFMW1MAbFHH7maoA8M37oqWlwdLTEnyht5iG7G7UV09xJRj0fpjWp
VY7EaupcfYbqlJHBudd/Ih5KfAnb6+3sPeJnDYsRYt059CQ5Ub1bObL1oSwqfFv/VmsSahOlz82W
Qb6FKyg3CRGU5/li7avYu7WGWjbbjBpTRA8TSjV7kjCOcTzZCYM9HHnsZERkGeaFWqWgJZV2RtKl
0lynQLoWxbwCECSgzapHr6e3OnF8419UKJ55c0dCcRWCxHV+wv3hQ5h8I3d912Qnb4Jm5VZN4Jrh
3PVDHeZ1RaFnGh/rfeXSrroHLjrEirY4miqfkKnH2f2jDRhFiGwodwsNZWTRX3HryLVNsvCLl/Th
dnhxasKCS0P+ToY4/ny8d6tnXnMND+ZvB/O1ZWZ0Km6qVIDc7g9q2DJjAc5GH+s4TcLa9e05nThP
I7lKme0sWP8xN7nh7u9xmuRQFL7VBGPkuE5WXKeDyOnujBBeTXlzSHGfK8KkDmpRdPElN9IHGyXa
Q5o=
=7Rq2
-----END PGP SIGNATURE-----

--n0R7oFBPwnJJ2u7rrKI6Dv8v4KmpRpmpu--
