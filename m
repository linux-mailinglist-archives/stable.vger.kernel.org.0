Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E749100694
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 14:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfKRNgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 08:36:20 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55228 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfKRNgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 08:36:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id z26so17385021wmi.4;
        Mon, 18 Nov 2019 05:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ICoZyr3X+VsofrtI0L0z7PjIiWh5QpcA81Yo9AVGZNI=;
        b=TZF7c92tUCBoyjtaDI2+7q+Eie4Cbxr6nDst6dVIR7Y1p/y7hugd2KrlyaB8E6uV0Y
         qQcxkhTWJVXAxmuajuZeaW5Gq5r3gg4cpmvq3GBmzRkJRVmlRGFHSNODUpquLygCA52/
         VyGhmcchZ9Lx+a56RQpH35Rp0BWctnPqtJrRkC10JFM5bBqmPKFYgWJyRLJzWsRwIlge
         OYWz+/AeHciygjmK2HDy1tx6/umHQwpaT8rVz+IEHAQdaSYVXM2Ir/q911Bu75QaetVD
         AiScJZVlzCGzGVxqPPAGaD4SZnAN/uCAGa6xd5udqTt3dP65u1KkI0MpKe4TzwpnQTgO
         QHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ICoZyr3X+VsofrtI0L0z7PjIiWh5QpcA81Yo9AVGZNI=;
        b=eBcRf0BI7jn19/ARezmsivsSVkSm9BAXGUkviuaqaUkJahNkCFie7YgavA/43KpgWH
         U6B6ys2r5ZfY8W9Fc7Av6eHDxCBJ5el0GLNTEBbBJI3rjyAgDgBj56SphK8QySNEjVrn
         nyZBbccnL8hLFqH/u+w8bQDY1RhGs8WoCRdUvpvSDSVdOERDMwqMdRC2JhcP0fx+tHk0
         f3FVy9w1scBQFVJOk4tjkhYl/pM6rocqqXCrH676JTJSmRNyIt9UaF10YzGhIS+4iGJR
         7afFVAboMXE0gpuJLdVpsAf0FURGud+s/Ttv1+0Hoq4L/vflu0Gc1Cfh4rKkupi4/qt5
         DAXw==
X-Gm-Message-State: APjAAAW3KF7974oU5wv9c6qqAIhLD2kfOXIhDsL4waVtzWicUpC9uux4
        ey8V4WtDBeRXELse9ZDeKrJx474Rzp8=
X-Google-Smtp-Source: APXvYqzx7j+WVMQ0sAzmd1Bv05Nq8OLaYPYCBonDSP517gSvheC3dqNpHHb3HJMp9ndsdJR1wtjxRg==
X-Received: by 2002:a1c:7d47:: with SMTP id y68mr29143250wmc.157.1574084177630;
        Mon, 18 Nov 2019 05:36:17 -0800 (PST)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id j12sm3459171wrb.82.2019.11.18.05.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:36:15 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:36:14 +0100
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     nouveau@lists.freedesktop.org, Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jerry Zuo <Jerry.Zuo@amd.com>,
        Sean Paul <seanpaul@chromium.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@redhat.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Juston Li <juston.li@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Nouveau] [PATCH 3/3] drm/nouveau/kms/nv50-: Limit MST BPC to 8
Message-ID: <20191118133614.GE2246533@ulmo>
References: <20191115210728.3467-1-lyude@redhat.com>
 <20191115210728.3467-4-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Content-Disposition: inline
In-Reply-To: <20191115210728.3467-4-lyude@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 04:07:20PM -0500, Lyude Paul wrote:
> Noticed this while working on some unrelated CRC stuff. Currently,
> userspace has very little support for BPCs higher than 8. While this
> doesn't matter for most things, on MST topologies we need to be careful
> about ensuring that we do our best to make any given display
> configuration fit within the bandwidth restraints of the topology, since
> otherwise less people's monitor configurations will work.
>=20
> Allowing for BPC settings higher than 8 dramatically increases the
> required bandwidth for displays in most configurations, and consequently
> makes it a lot less likely that said display configurations will pass
> the atomic check.
>=20
> In the future we want to fix this correctly by making it so that we
> adjust the bpp for each display in a topology to be as high as possible,
> while making sure to lower the bpp of each display in the event that we
> run out of bandwidth and need to rerun our atomic check. But for now,
> follow the behavior that both i915 and amdgpu are sticking to.
>=20
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 232c9eec417a ("drm/nouveau: Use atomic VCPI helpers for MST")
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: David Airlie <airlied@redhat.com>
> Cc: Jerry Zuo <Jerry.Zuo@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Juston Li <juston.li@intel.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Sean Paul <seanpaul@chromium.org>
> Cc: <stable@vger.kernel.org> # v5.1+
> ---
>  drivers/gpu/drm/nouveau/dispnv50/disp.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl3Snk4ACgkQ3SOs138+
s6Fi2RAApHjuN6J8fn0XmvXm7CFGwT84x9lf01uGyvRtrhJ7ULOpVbTfcHXk1SL8
Ip8eaNj04DbxO73u9G+2lJkIXmVbyOKxZwCpi9A/UAAoXIspnzZZ6nCWy6124Iqm
qpawUa+0q4uz8A/VdALzp60ZilNvX4pZn+mNPbK2V9lrG28vLx0iS6xc+BkMRC4Y
rkDmXsdUNiCbVs8OsSK7bBCE3c+g7Z8Hu6z5h5O8yxcG2JDTVLAPindmyZ83Q0qT
yqSqqi72QycmqyQ9prZylChv7/z/s7HNp6rMtGG6oCGwguZlwKdIz/Ko01hEKxbd
OuX3vhGDe2bhAr/QowPbL4b5ST8ZmeyJ37lldmZAihWEK+BAQHESX/NoaWqDoctc
NRIPdzWXvF2VCEy3rLNuUd24ugv+kW9zOYv0ezBoCqq2VZuxSC5Q4rQRFH94oQQ1
OHvPgNRe6P4ZX8gLiZmDdTzQsgJntf/2npXLlJv8muRDuCWqC/d8kGc9xFINqsok
pPOBq5OhavcKXVO41RRju8ZqVpy0y+YYqWDynpr97SMTtp11HN3vcrZiB117xllh
Fv5rY400AGDpwsaeH/eRm2a+T0Ov2DkegEPFu0IjCuKJ9xMV5RxftSw3HD/7M5hC
w+hD4Ixncpohqgaml6M7U/gUIJdafT6N7D8S4LlTcKhvsDFSpVU=
=Mrw/
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
