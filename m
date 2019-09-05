Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15B5AA59F
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 16:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfIEOTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 10:19:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:13359 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbfIEOTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 10:19:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 07:19:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="212795299"
Received: from rweigelx-mobl1.ger.corp.intel.com (HELO [10.252.40.21]) ([10.252.40.21])
  by fmsmga002.fm.intel.com with ESMTP; 05 Sep 2019 07:19:35 -0700
Subject: Re: [PATCH 1/3] drm/atomic: Take the atomic toys away from X
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>,
        Adam Jackson <ajax@redhat.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <ed222af0-4d87-88eb-1de0-4020a7cf6cf3@linux.intel.com>
Date:   Thu, 5 Sep 2019 16:19:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190903190642.32588-1-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 03-09-2019 om 21:06 schreef Daniel Vetter:
> The -modesetting ddx has a totally broken idea of how atomic works:
> - doesn't disable old connectors, assuming they get auto-disable like
>   with the legacy setcrtc
> - assumes ASYNC_FLIP is wired through for the atomic ioctl
> - not a single call to TEST_ONLY
>
> Iow the implementation is a 1:1 translation of legacy ioctls to
> atomic, which is a) broken b) pointless.
>
> We already have bugs in both i915 and amdgpu-DC where this prevents us
> from enabling neat features.
>
> If anyone ever cares about atomic in X we can easily add a new atomic
> level (req->value == 2) for X to get back the shiny toys.
>
> Since these broken versions of -modesetting have been shipping,
> there's really no other way to get out of this bind.
>
> References: https://gitlab.freedesktop.org/xorg/xserver/issues/629
> References: https://gitlab.freedesktop.org/xorg/xserver/merge_requests/180
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Michel Dänzer <michel@daenzer.net>
> Cc: Alex Deucher <alexdeucher@gmail.com>
> Cc: Adam Jackson <ajax@redhat.com>
> Cc: Sean Paul <sean@poorly.run>
> Cc: David Airlie <airlied@linux.ie>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/drm_ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> index 2c120c58f72d..1cb7b4c3c87c 100644
> --- a/drivers/gpu/drm/drm_ioctl.c
> +++ b/drivers/gpu/drm/drm_ioctl.c
> @@ -334,6 +334,9 @@ drm_setclientcap(struct drm_device *dev, void *data, struct drm_file *file_priv)
>  		file_priv->universal_planes = req->value;
>  		break;
>  	case DRM_CLIENT_CAP_ATOMIC:
> +		/* The modesetting DDX has a totally broken idea of atomic. */
> +		if (strstr(current->comm, "X"))
> +			return -EOPNOTSUPP;
>  		if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
>  			return -EOPNOTSUPP;
>  		if (req->value > 1)

Good riddance!

Missing one more:
commit abbc0697d5fbf53f74ce0bcbe936670199764cfa
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Apr 24 16:33:29 2019 +1000

    drm/fb: revert the i915 Actually configure untiled displays from master
   
    This code moved in here in master, so revert it the same way.
   
    This is the same revert as 9fa246256e09 ("Revert "drm/i915/fbdev:
    Actually configure untiled displays"") in drm-fixes.
   
    Signed-off-by: Dave Airlie <airlied@redhat.com>

Can we unrevert that now?

With that fixed, on the whole series:

Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

