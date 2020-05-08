Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0B31CAA29
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 13:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEHL7y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 8 May 2020 07:59:54 -0400
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:52692
        "EHLO mail.corsac.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgEHL7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 07:59:54 -0400
X-Greylist: delayed 10338 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2020 07:59:52 EDT
Received: from scapa.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e20:6af7:28ff:fe8d:2119])
        by mail.corsac.net (Postfix) with ESMTPS id D6CD08E
        for <stable@vger.kernel.org>; Fri,  8 May 2020 13:59:21 +0200 (CEST)
Received: from corsac (uid 1000)
        (envelope-from corsac@debian.org)
        id a00a4
        by scapa.corsac.net (DragonFly Mail Agent v0.12);
        Fri, 08 May 2020 13:59:21 +0200
Message-ID: <177a9ed3375957e40b295e20bb6b42663a784a74.camel@debian.org>
Subject: Re: [PATCH] drm/atomic: Take the atomic toys away from X
From:   Yves-Alexis Perez <corsac@debian.org>
To:     Greg KH <greg@kroah.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>,
        Adam Jackson <ajax@redhat.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Rob Clark <robdclark@gmail.com>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
Date:   Fri, 08 May 2020 13:59:17 +0200
In-Reply-To: <20200508095426.GA3778290@kroah.com>
References: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
         <20190905185318.31363-1-daniel.vetter@ffwll.ch>
         <2a05f4c4362d386d298a06a67f2f528ef603a734.camel@debian.org>
         <20200508095426.GA3778290@kroah.com>
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Fri, 2020-05-08 at 11:54 +0200, Greg KH wrote:
> > Hi Daniel and Greg (especially). It seems that this patch was never
> > applied to
> > stable, maybe it fell through the cracks?
> 
> What patch is "this patch"?

Sorry, the patch was in the mail I was replying to:

commit 26b1d3b527e7bf3e24b814d617866ac5199ce68d
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Sep 5 20:53:18 2019 +0200

    drm/atomic: Take the atomic toys away from X

> 
> > It doesn't apply as-is in 4.19 branch but a small change in the context
> > makes
> > it apply. I'm experiencing issues with lightdm and vt-switch in Debian
> > Buster
> > (which has a 4.19 kernel) so I'd appreciate if the patch was included in
> > at
> > least that release.
> 
> What is the git commit id of the patch in Linus's tree?  If you have a
> working backport, that makes it much easier than hoping I can fix it
> up...

The commit id is in Linus tree is 26b1d3b527e7bf3e24b814d617866ac5199ce68d. To
apply properly 69fdf4206a8ba91a277b3d50a3a05b71247635b2 would need to be
cherry-picked as well but it wasn't marked for stable so I didn't bother and
only fixed the context. Here's the backport to 4.19, compile and runtime
tested. It does fix the issue for me (like it did on mainline).

So I guess
Tested-By: Yves-Alexis Perez <corsac@debian.org>

commit 8a99914f7b539542622dc571c82d6cd203bddf64
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Sep 5 20:53:18 2019 +0200

    drm/atomic: Take the atomic toys away from X
    
    The -modesetting ddx has a totally broken idea of how atomic works:
    - doesn't disable old connectors, assuming they get auto-disable like
      with the legacy setcrtc
    - assumes ASYNC_FLIP is wired through for the atomic ioctl
    - not a single call to TEST_ONLY
    
    Iow the implementation is a 1:1 translation of legacy ioctls to
    atomic, which is a) broken b) pointless.
    
    We already have bugs in both i915 and amdgpu-DC where this prevents us
    from enabling neat features.
    
    If anyone ever cares about atomic in X we can easily add a new atomic
    level (req->value == 2) for X to get back the shiny toys.
    
    Since these broken versions of -modesetting have been shipping,
    there's really no other way to get out of this bind.
    
    v2:
    - add an informational dmesg output (Rob, Ajax)
    - reorder after the DRIVER_ATOMIC check to avoid useless noise (Ilia)
    - allow req->value > 2 so that X can do another attempt at atomic in
      the future
    
    v3: Go with paranoid, insist that the X should be first (suggested by
    Rob)
    
    Cc: Ilia Mirkin <imirkin@alum.mit.edu>
    References: https://gitlab.freedesktop.org/xorg/xserver/issues/629
    References: https://gitlab.freedesktop.org/xorg/xserver/merge_requests/180
    References: abbc0697d5fb ("drm/fb: revert the i915 Actually configure
untiled displays from master")
    Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com> (v1)
    Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com> (v1)
    Cc: Michel Dänzer <michel@daenzer.net>
    Cc: Alex Deucher <alexdeucher@gmail.com>
    Cc: Adam Jackson <ajax@redhat.com>
    Acked-by: Adam Jackson <ajax@redhat.com>
    Cc: Sean Paul <sean@poorly.run>
    Cc: David Airlie <airlied@linux.ie>
    Cc: Rob Clark <robdclark@gmail.com>
    Acked-by: Rob Clark <robdclark@gmail.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
    Link: 
https://patchwork.freedesktop.org/patch/msgid/20190905185318.31363-1-daniel.vetter@ffwll.ch

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index ba129b64b61f..b92682f037b2 100644
- --- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -321,7 +321,12 @@ drm_setclientcap(struct drm_device *dev, void *data,
struct drm_file *file_priv)
 	case DRM_CLIENT_CAP_ATOMIC:
 		if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
 			return -EINVAL;
- -		if (req->value > 1)
+		/* The modesetting DDX has a totally broken idea of atomic. */
+		if (current->comm[0] == 'X' && req->value == 1) {
+			pr_info("broken atomic modeset userspace detected,
disabling atomic\n");
+			return -EOPNOTSUPP;
+		}
+		if (req->value > 2)
 			return -EINVAL;
 		file_priv->atomic = req->value;
 		file_priv->universal_planes = req->value;


- -- 
Yves-Alexis
-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8vi34Qgfo83x35gF3rYcyPpXRFsFAl61SZUACgkQ3rYcyPpX
RFvPfwgAzMyFqiV592RBKu4tx5Ivqa4EC/1OdR8DojyQlw4AP0bYc+4O67xYbvt5
r4JXuGbSu+jW/29V+2t8ZlLi4S7bAvAo2DEhuBdGVzdmD4gM9EC+69oqVeZWWZTm
VUldLrRO8BoPxv14lX/K/kU/o5Pv8ivRoEKs385JU2p1AxNGJI2UUmIXKGtk7Cu/
Fu/flH627RHjTRk2QYsemqHqSAONaHYuSiYm783hz4wYiPOZQdGvS+ifHwMAhUqh
scaCxv+pBOxaLuZAfUXFjDX+qAcuJCxaP9bT4soweIpYqjzcAdBSmny0+OLOnie/
HcBzKwpgitKR/cVadZgb0US1oHeo2A==
=l8z1
-----END PGP SIGNATURE-----
