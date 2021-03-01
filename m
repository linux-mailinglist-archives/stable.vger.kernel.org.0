Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF270327B5D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhCAJ6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:58:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:59170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhCAJ5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 04:57:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DB4BAAE03;
        Mon,  1 Mar 2021 09:56:23 +0000 (UTC)
Subject: Re: [PATCH] drm/gem: add checks of drm_gem_object->funcs
To:     =?UTF-8?Q?Pavel_Turinsk=c3=bd?= <ledoian@kam.mff.cuni.cz>,
        airlied@linux.ie, daniel@ffwll.ch,
        Alexander Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
References: <20210228161022.53468-1-ledoian@kam.mff.cuni.cz>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <e7f0747c-cb10-692a-aa36-194efcab49ef@suse.de>
Date:   Mon, 1 Mar 2021 10:56:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210228161022.53468-1-ledoian@kam.mff.cuni.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5rzwza5zwjgSSgTgCDrDCKBOl7FLnC4qh"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5rzwza5zwjgSSgTgCDrDCKBOl7FLnC4qh
Content-Type: multipart/mixed; boundary="776yVYzRqTk0UYi04kjKkAqXozinKJY0p";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: =?UTF-8?Q?Pavel_Turinsk=c3=bd?= <ledoian@kam.mff.cuni.cz>,
 airlied@linux.ie, daniel@ffwll.ch,
 Alexander Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc: dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
 "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
Message-ID: <e7f0747c-cb10-692a-aa36-194efcab49ef@suse.de>
Subject: Re: [PATCH] drm/gem: add checks of drm_gem_object->funcs
References: <20210228161022.53468-1-ledoian@kam.mff.cuni.cz>
In-Reply-To: <20210228161022.53468-1-ledoian@kam.mff.cuni.cz>

--776yVYzRqTk0UYi04kjKkAqXozinKJY0p
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

(cc'ing amd devs)

Hi

Am 28.02.21 um 17:10 schrieb Pavel Turinsk=C3=BD:
> The checks were removed in commit d693def4fd1c ("drm: Remove obsolete G=
EM
> and PRIME callbacks from struct drm_driver") and can lead to following
> kernel oops:

Thanks for reporting. All drivers are supposed to set the funcs pointer=20
in their GEM objects. This looks like a radeon bug. Adding the AMD devs.

Best regards
Thomas

>=20
> [  139.449098] BUG: kernel NULL pointer dereference, address: 000000000=
0000008
> [  139.449110] #PF: supervisor read access in kernel mode
> [  139.449113] #PF: error_code(0x0000) - not-present page
> [  139.449116] PGD 0 P4D 0
> [  139.449121] Oops: 0000 [#1] PREEMPT SMP PTI
> [  139.449126] CPU: 4 PID: 1181 Comm: Xorg Not tainted 5.11.2LEdoian #2=

> [  139.449130] Hardware name: Gigabyte Technology Co., Ltd. To be fille=
d by O.E.M./Z77-DS3H, BIOS F4 04/25/2012
> [  139.449133] RIP: 0010:drm_gem_handle_create_tail+0xcb/0x190 [drm]
> [  139.449185] Code: 00 48 89 ef e8 06 b4 49 f7 45 85 e4 78 77 48 8d 6b=
 18 4c 89 ee 48 89 ef e8 c2 f5 00 00 89 c2 85 c0 75 3e 48 8b 83 40 01 00 =
00 <48> 8b 40 0
> 8 48 85 c0 74 0f 4c 89 ee 48 89 df e8 71 5d 87 f7 85 c0
> [  139.449190] RSP: 0018:ffffbe21c194bd28 EFLAGS: 00010246
> [  139.449194] RAX: 0000000000000000 RBX: ffff9da9b3caf078 RCX: 0000000=
000000000
> [  139.449197] RDX: 0000000000000000 RSI: ffffffffc039b893 RDI: 0000000=
000000000
> [  139.449199] RBP: ffff9da9b3caf090 R08: 0000000000000040 R09: ffff9da=
983b911c0
> [  139.449202] R10: ffff9da984749e00 R11: ffff9da9859bfc38 R12: 0000000=
000000007
> [  139.449204] R13: ffff9da9859bfc00 R14: ffff9da9859bfc50 R15: ffff9da=
9859bfc38
> [  139.449207] FS:  00007f6332a56900(0000) GS:ffff9daea7b00000(0000) kn=
lGS:0000000000000000
> [  139.449211] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  139.449214] CR2: 0000000000000008 CR3: 00000001319b8005 CR4: 0000000=
0001706e0
> [  139.449217] Call Trace:
> [  139.449224]  drm_gem_prime_fd_to_handle+0xff/0x1d0 [drm]
> [  139.449274]  ? drm_prime_destroy_file_private+0x20/0x20 [drm]
> [  139.449323]  drm_ioctl_kernel+0xac/0xf0 [drm]
> [  139.449363]  drm_ioctl+0x20f/0x3b0 [drm]
> [  139.449403]  ? drm_prime_destroy_file_private+0x20/0x20 [drm]
> [  139.449454]  radeon_drm_ioctl+0x49/0x80 [radeon]
> [  139.449500]  __x64_sys_ioctl+0x84/0xc0
> [  139.449507]  do_syscall_64+0x33/0x40
> [  139.449514]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  139.449522] RIP: 0033:0x7f63330fbe6b
> [  139.449526] Code: ff ff ff 85 c0 79 8b 49 c7 c4 ff ff ff ff 5b 5d 4c=
 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f =
05 <48> 3d 01 f
> 0 ff ff 73 01 c3 48 8b 0d d5 af 0c 00 f7 d8 64 89 01 48
> [  139.449529] RSP: 002b:00007fff1e9c4438 EFLAGS: 00000246 ORIG_RAX: 00=
00000000000010
> [  139.449534] RAX: ffffffffffffffda RBX: 00007fff1e9c447c RCX: 00007f6=
3330fbe6b
> [  139.449537] RDX: 00007fff1e9c447c RSI: 00000000c00c642e RDI: 0000000=
000000012
> [  139.449539] RBP: 00000000c00c642e R08: 00007fff1e9c4520 R09: 00007f6=
3331c7a60
> [  139.449542] R10: 00007f6329fb9ab0 R11: 0000000000000246 R12: 000055f=
69810ad40
> [  139.449544] R13: 0000000000000012 R14: 0000000000100000 R15: 00007ff=
f1e9c4c20
> [  139.449549] Modules linked in: 8021q garp mrp bridge stp llc nls_iso=
8859_1 vfat fat fuse btrfs blake2b_generic xor raid6_pq libcrc32c crypto_=
user tun i2c_de
> v it87 hwmon_vid snd_seq snd_hda_codec_realtek snd_hda_codec_generic le=
dtrig_audio sg snd_hda_codec_hdmi virtio_balloon snd_hda_intel virtio_con=
sole snd_intel_
> dspcfg soundwire_intel virtio_pci soundwire_generic_allocation soundwir=
e_cadence virtio_blk snd_hda_codec intel_rapl_msr btusb intel_rapl_common=
 virtio_net btr
> tl net_failover uvcvideo snd_usb_audio snd_hda_core btbcm x86_pkg_temp_=
thermal failover soundwire_bus btintel intel_powerclamp snd_soc_core core=
temp snd_usbmid
> i_lib iTCO_wdt videobuf2_vmalloc bluetooth intel_pmc_bxt snd_hwdep kvm_=
intel videobuf2_memops snd_rawmidi snd_compress videobuf2_v4l2 ac97_bus s=
nd_pcm_dmaengin
> e iTCO_vendor_support crct10dif_pclmul at24 crc32_pclmul videobuf2_comm=
on snd_seq_device mei_hdcp snd_pcm ghash_clmulni_intel kvm videodev aesni=
_intel crypto_s
> imd snd_timer snd cryptd mc ecdh_generic
> [  139.449642]  glue_helper rfkill soundcore joydev mousedev rapl ecc i=
ntel_cstate r8169 i2c_i801 intel_uncore atl1c realtek irqbypass mdio_devr=
es mei_me libph
> y i2c_smbus mei mac_hid lpc_ich ext4 crc32c_generic crc16 mbcache jbd2 =
dm_mod ata_generic pata_acpi uas usb_storage sr_mod crc32c_intel serio_ra=
w cdrom xhci_pc
> i pata_jmicron xhci_pci_renesas radeon usbhid i915 intel_gtt nouveau mx=
m_wmi wmi video i2c_algo_bit drm_ttm_helper ttm drm_kms_helper syscopyare=
a sysfillrect s
> ysimgblt fb_sys_fops cec drm agpgart
> [  139.449707] CR2: 0000000000000008
> [  139.449710] ---[ end trace f5ce5774498d18e1 ]---
>=20
> Signed-off-by: Pavel Turinsk=C3=BD <ledoian@kam.mff.cuni.cz>
> Fixes: d693def4fd1c ("drm: Remove obsolete GEM and PRIME callbacks from=
 struct drm_driver")
> Cc: stable@vger.kernel.org
> ---
>=20
> This is a very symptomatic patch around issue I ran into. I do not know=
 if the
> funcs property should ever be NULL. I basically restored all the checks=
 that
> were removed in the mentioned commit. Unfortunately, I do not understan=
d drm
> nor will I have time to delve into it in forseeable future.
>=20
>   drivers/gpu/drm/drm_gem.c   | 20 ++++++++++----------
>   drivers/gpu/drm/drm_prime.c |  2 +-
>   2 files changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 92f89cee213e..451f290c737c 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -249,7 +249,7 @@ drm_gem_object_release_handle(int id, void *ptr, vo=
id *data)
>   	struct drm_file *file_priv =3D data;
>   	struct drm_gem_object *obj =3D ptr;
>  =20
> -	if (obj->funcs->close)
> +	if (obj->funcs && obj->funcs->close)
>   		obj->funcs->close(obj, file_priv);
>  =20
>   	drm_gem_remove_prime_handles(obj, file_priv);
> @@ -401,7 +401,7 @@ drm_gem_handle_create_tail(struct drm_file *file_pr=
iv,
>   	if (ret)
>   		goto err_remove;
>  =20
> -	if (obj->funcs->open) {
> +	if (obj->funcs && obj->funcs->open) {
>   		ret =3D obj->funcs->open(obj, file_priv);
>   		if (ret)
>   			goto err_revoke;
> @@ -977,7 +977,7 @@ drm_gem_object_free(struct kref *kref)
>   	struct drm_gem_object *obj =3D
>   		container_of(kref, struct drm_gem_object, refcount);
>  =20
> -	if (WARN_ON(!obj->funcs->free))
> +	if (!obj->funcs || WARN_ON(!obj->funcs->free))
>   		return;
>  =20
>   	obj->funcs->free(obj);
> @@ -1079,7 +1079,7 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, =
unsigned long obj_size,
>  =20
>   	vma->vm_private_data =3D obj;
>  =20
> -	if (obj->funcs->mmap) {
> +	if (obj->funcs && obj->funcs->mmap) {
>   		ret =3D obj->funcs->mmap(obj, vma);
>   		if (ret) {
>   			drm_gem_object_put(obj);
> @@ -1087,7 +1087,7 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, =
unsigned long obj_size,
>   		}
>   		WARN_ON(!(vma->vm_flags & VM_DONTEXPAND));
>   	} else {
> -		if (obj->funcs->vm_ops)
> +		if (obj->funcs && obj->funcs->vm_ops)
>   			vma->vm_ops =3D obj->funcs->vm_ops;
>   		else {
>   			drm_gem_object_put(obj);
> @@ -1188,13 +1188,13 @@ void drm_gem_print_info(struct drm_printer *p, =
unsigned int indent,
>   	drm_printf_indent(p, indent, "imported=3D%s\n",
>   			  obj->import_attach ? "yes" : "no");
>  =20
> -	if (obj->funcs->print_info)
> +	if (obj->funcs && obj->funcs->print_info)
>   		obj->funcs->print_info(p, indent, obj);
>   }
>  =20
>   int drm_gem_pin(struct drm_gem_object *obj)
>   {
> -	if (obj->funcs->pin)
> +	if (obj->funcs && obj->funcs->pin)
>   		return obj->funcs->pin(obj);
>   	else
>   		return 0;
> @@ -1202,7 +1202,7 @@ int drm_gem_pin(struct drm_gem_object *obj)
>  =20
>   void drm_gem_unpin(struct drm_gem_object *obj)
>   {
> -	if (obj->funcs->unpin)
> +	if (obj->funcs && obj->funcs->unpin)
>   		obj->funcs->unpin(obj);
>   }
>  =20
> @@ -1210,7 +1210,7 @@ int drm_gem_vmap(struct drm_gem_object *obj, stru=
ct dma_buf_map *map)
>   {
>   	int ret;
>  =20
> -	if (!obj->funcs->vmap)
> +	if (!obj->funcs || !obj->funcs->vmap)
>   		return -EOPNOTSUPP;
>  =20
>   	ret =3D obj->funcs->vmap(obj, map);
> @@ -1227,7 +1227,7 @@ void drm_gem_vunmap(struct drm_gem_object *obj, s=
truct dma_buf_map *map)
>   	if (dma_buf_map_is_null(map))
>   		return;
>  =20
> -	if (obj->funcs->vunmap)
> +	if (obj->funcs && obj->funcs->vunmap)
>   		obj->funcs->vunmap(obj, map);
>  =20
>   	/* Always set the mapping to NULL. Callers may rely on this. */
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 7db55fce35d8..1566dcf417e2 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -620,7 +620,7 @@ struct sg_table *drm_gem_map_dma_buf(struct dma_buf=
_attachment *attach,
>   	if (WARN_ON(dir =3D=3D DMA_NONE))
>   		return ERR_PTR(-EINVAL);
>  =20
> -	if (WARN_ON(!obj->funcs->get_sg_table))
> +	if (!obj->funcs || WARN_ON(!obj->funcs->get_sg_table))
>   		return ERR_PTR(-ENOSYS);
>  =20
>   	sgt =3D obj->funcs->get_sg_table(obj);
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--776yVYzRqTk0UYi04kjKkAqXozinKJY0p--

--5rzwza5zwjgSSgTgCDrDCKBOl7FLnC4qh
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmA8ukYFAwAAAAAACgkQlh/E3EQov+Ab
txAA0e3VYz4K8bPfzDTff9LMvvGLgiv98+srqSycEmvZRcevXb7oNo0Gsn6txNR9mrV2WqlYKhuW
tPeRRERrwumrBv0ASIJ1oiRqZFWC5iIrKLUDAzwtoQQs79D61+KsKe0rUk4QHazWXZoObGUgE8vN
0i8GRrq1sVrG1RKn/B72f8OVmGsLnqvftDnd7V2BUovWol2ihRXm5rnXfU2chSiHHBuWY0QrzciC
ZoGmUdF5I7AQ9eXZAq61+vyOlZUBuKy7zd0MtA+TJryxcFBMq24ZfB/CMyCCbrMhWyb88fAWBsGQ
ep8Cfg/9px3gc816KjkavKGDX7KFep8FoeiQBjLbKS6BSlzlDyMbC/Kd31rVOp7NK3Z7GQ2TiDX1
7tHqIeS4vKjfuySnIS8mJpG5qgKpwIDs/UhvCC/QfGklE2gf/40Rj8IjTfd3VSU3/L5P7Y+t+b+b
/UBTwvKGFp1sH3aGCs9+rFhnv+t4yQN0U9JWvRWweWo2Y8d/KlztgHH4gMkFWyJJwwj1Rdru12q6
REh3nAg6aziXFerbzCNBoz4qJlnsZzgedPJjBkmQVYc2Lo07AlGSWTK3CEK47uj5vslAD5DGlN8A
43f/54mKWivLMu/eNiMK0bZVl5pZw0MpGQc2rAyxrI9hWre+eWqzDElkFHGIV4V1cspVeQW5kY/3
f/s=
=viSC
-----END PGP SIGNATURE-----

--5rzwza5zwjgSSgTgCDrDCKBOl7FLnC4qh--
