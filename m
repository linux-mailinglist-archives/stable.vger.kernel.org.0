Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738099706F
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 05:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfHUDkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 23:40:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:8304 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727172AbfHUDkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 23:40:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 20:40:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,410,1559545200"; 
   d="asc'?scan'208";a="169288711"
Received: from zhen-hp.sh.intel.com (HELO zhen-hp) ([10.239.13.116])
  by orsmga007.jf.intel.com with ESMTP; 20 Aug 2019 20:40:23 -0700
Date:   Wed, 21 Aug 2019 11:35:56 +0800
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Don't deballoon unused ggtt
 drm_mm_node in linux guest
Message-ID: <20190821033556.GA11927@zhen-hp.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
References: <1566279978-9659-1-git-send-email-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1566279978-9659-1-git-send-email-xiong.y.zhang@intel.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019.08.20 13:46:17 +0800, Xiong Zhang wrote:
> The following call trace may exist in linux guest dmesg when guest i915
> driver is unloaded.
> [   90.776610] [drm:vgt_deballoon_space.isra.0 [i915]] deballoon space: r=
ange [0x0 - 0x0] 0 KiB.
> [   90.776621] BUG: unable to handle kernel NULL pointer dereference at 0=
0000000000000c0
> [   90.776691] IP: drm_mm_remove_node+0x4d/0x320 [drm]
> [   90.776718] PGD 800000012c7d0067 P4D 800000012c7d0067 PUD 138e4c067 PM=
D 0
> [   90.777091] task: ffff9adab60f2f00 task.stack: ffffaf39c0fe0000
> [   90.777142] RIP: 0010:drm_mm_remove_node+0x4d/0x320 [drm]
> [   90.777573] Call Trace:
> [   90.777653]  intel_vgt_deballoon+0x4c/0x60 [i915]
> [   90.777729]  i915_ggtt_cleanup_hw+0x121/0x190 [i915]
> [   90.777792]  i915_driver_unload+0x145/0x180 [i915]
> [   90.777856]  i915_pci_remove+0x15/0x20 [i915]
> [   90.777890]  pci_device_remove+0x3b/0xc0
> [   90.777916]  device_release_driver_internal+0x157/0x220
> [   90.777945]  driver_detach+0x39/0x70
> [   90.777967]  bus_remove_driver+0x51/0xd0
> [   90.777990]  pci_unregister_driver+0x23/0x90
> [   90.778019]  SyS_delete_module+0x1da/0x240
> [   90.778045]  entry_SYSCALL_64_fastpath+0x24/0x87
> [   90.778072] RIP: 0033:0x7f34312af067
> [   90.778092] RSP: 002b:00007ffdea3da0d8 EFLAGS: 00000206
> [   90.778297] RIP: drm_mm_remove_node+0x4d/0x320 [drm] RSP: ffffaf39c0fe=
3dc0
> [   90.778344] ---[ end trace f4b1bc8305fc59dd ]---
>=20
> Four drm_mm_node are used to reserve guest ggtt space, but some of them
> may be skipped and not initialised due to space constraints in
> intel_vgt_balloon(). If drm_mm_remove_node() is called with
> uninitialized drm_mm_node, the above call trace occurs.
>=20
> This patch check drm_mm_node's validity before calling
> drm_mm_remove_node().
>=20
> Fixes: ff8f797557c7("drm/i915: return the correct usable aperture size un=
der gvt environment")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_vgpu.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_vgpu.c b/drivers/gpu/drm/i915/i915=
_vgpu.c
> index bf2b837..d2fd66f 100644
> --- a/drivers/gpu/drm/i915/i915_vgpu.c
> +++ b/drivers/gpu/drm/i915/i915_vgpu.c
> @@ -119,6 +119,9 @@ static struct _balloon_info_ bl_info;
>  static void vgt_deballoon_space(struct i915_ggtt *ggtt,
>  				struct drm_mm_node *node)
>  {
> +	if (!node->allocated)
> +		return;
> +
>  	DRM_DEBUG_DRIVER("deballoon space: range [0x%llx - 0x%llx] %llu KiB.\n",
>  			 node->start,
>  			 node->start + node->size,

Searching shows this is pretty old one and also with r-b from Chris,
but be ignored that nobody picked this up..

I think I hit this once too and tried to fix it another way,
but this looks simpler to me.

Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXuabgHDW6LPt9CICxBBozTXgYJwUCXVy8HAAKCRCxBBozTXgY
J7xcAJ9iqr4h7QnTx9tzdFbWg4y/mhDMZgCdHJaG2eTRmA8W3tkLza74nJ3bEiM=
=RYoi
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
