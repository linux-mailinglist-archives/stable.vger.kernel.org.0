Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D8D44492B
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 20:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhKCTy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 15:54:58 -0400
Received: from mout.gmx.net ([212.227.15.19]:47615 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhKCTy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 15:54:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635969135;
        bh=FtOL8XmqDS1wLfeizbwtBWc/x+j5u2WFuRH/u2pOQXY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=kw4F9dtHAhduvVf0SV6QfP/XOKBnH+CbyQV6rxz3NnRVn7lXEWB4HvfwHb9gtPx34
         tR+7N/AYSYQgZGdDyiOU1cIaXppexqsKGxldsoYCBVsWzO1R/H4+5wwGX+UK6u/twm
         YWM4a5tfaoSv7PKifB5wf50zG7Hh6wonxxc/jSdI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.223.42.226]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1M4axg-1miung46XG-001lEI; Wed, 03 Nov 2021 20:52:15 +0100
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 260D48009A; Wed,  3 Nov 2021 20:52:13 +0100 (CET)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Erhard F." <erhard_f@mailbox.org>, Huang Rui <ray.huang@amd.com>,
        nouveau@lists.freedesktop.org
Subject: Re: [PATCH 5.10 32/77] drm/ttm: fix memleak in ttm_transfered_destroy
References: <20211101082511.254155853@linuxfoundation.org>
        <20211101082518.624936309@linuxfoundation.org>
Date:   Wed, 03 Nov 2021 20:52:13 +0100
In-Reply-To: <20211101082518.624936309@linuxfoundation.org> (Greg
        Kroah-Hartman's message of "Mon, 1 Nov 2021 10:17:20 +0100")
Message-ID: <871r3x2f0y.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UysYFhltgoAvMidN4mGrSc1JaIBcLgXEQv1Z7ixnmXoDaSvGNnZ
 pYGq/YV2rMATmZSFwFCpJjT2w7PJUWuyZDeXxSuqQAvG6P9V24KFMUaijstkxir3se5FuRU
 m7esFvzKhx7FH7FA9o+GHt2kIBL/0LQaYmU3h2p176mefCwrdK999zdeuagakTgVAxLOFeu
 BdKOxMEkWTOblxmkWWSWg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rfxMpj4gZLI=:QqForyq+zs9hzal1s4WBRh
 XUquGTDNHFE4XSgR5ct/MH7l7aK/wj1YbPdppVi+itixjm4gtuALIjvqYK4Chvt0MEqUovgte
 ytGhOok++ZyAg3WyovuzuyAMe4i7lSRFicYNPDH1qihpGt7Yy+2WFLcfexe9iNUo6MdEW6UNF
 mGbQlIeLq63VUz8dnMiLRfmfj3G8WjxCmhABIZ2IetptVD1rfbtbSAGW/I6tW8gmQ850ww3MY
 hfm5GSDSHkeWjwrAr+9dwNYPBtAkNCKrp1GNc+LAu/Qum/d0OlIny/j1kmkBn7wyZjMUO4xvI
 EojReBDhPxRRG8polUTyj4b6YyvsAD6CT7m+jpYFj1zmkuEu+NCwKMbAssr/w24a9cmxfyiN7
 D/D2YCatoFT5Iamc/0lbOax6I/V1GUmzjqw6YXGsnUVIGuth7xU1UfxO7p2LvidPQfXfQGCWZ
 xfxkbrpy16FJ2W4Xrj/CZpQ43Q89jGg58KU1vz1hPFum/qOYs7Ze4IqwQRmRCOJQqH4vwylYp
 oDXUF1VCSveWULK646xMBbnXY3lRJiI9ZHiZJg2k9nmy9KW1zSTE/pvI49fMVti81QaqJaxfj
 9u/pWTzvGiOXr6pvTWoW/RZrwDJFqxIuWz2HHwYrjH1CtRe5fYK/8HMyCEtkpRCuKQuDrh55L
 D5atHDrxgcvzogL2ZxSL2uAmfLyK+caQQaELsc8BZUvk1zOU9o09uI2N8dFMO7eARZSVY1M5X
 AJgCs4t8Ii6kZ4T2IJc4rQ9drIwJkIQTo4qIN85aDmTHwqkkY7Aij94AgRxn/5RYXYslJ0yEM
 vmVH9TGTtGzNTxxx6J1Yc7V8zDL4/PXdEH9xdvjtMAR/3Kcl9tfPb0QfwHZy31TJ/cBgIC5dj
 2rGc0lT6YwdWsEq+dU6qix513cCHbtGHngSvuw5NQCnNsfLeO8jNwl3EK/LxUZaLttke4UkqE
 5c2RtxD6engsQxyo9EApmITJw3eccHxketg6cOY55nIJFBbTBiTCFopd/J8dKOtfBOWkyjdx8
 msRCIG8vGoiBbH+LNTUFTci1sw2NQ9r+ywwE1eZlsMRCS7PnWiPSgbH+k0ThSEWl4lkwSVcqK
 fnuCQr/l8b2BaY=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-11-01 10:17 +0100, Greg Kroah-Hartman wrote:

> From: Christian K=F6nig <christian.koenig@amd.com>
>
> commit 0db55f9a1bafbe3dac750ea669de9134922389b5 upstream.
>
> We need to cleanup the fences for ghost objects as well.
>
> Signed-off-by: Christian K=F6nig <christian.koenig@amd.com>
> Reported-by: Erhard F. <erhard_f@mailbox.org>
> Tested-by: Erhard F. <erhard_f@mailbox.org>
> Reviewed-by: Huang Rui <ray.huang@amd.com>
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D214029
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=3D214447
> CC: <stable@vger.kernel.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20211020173211.2247-1=
-christian.koenig@amd.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
> @@ -322,6 +322,7 @@ static void ttm_transfered_destroy(struc
>  	struct ttm_transfer_obj *fbo;
>=20=20
>  	fbo =3D container_of(bo, struct ttm_transfer_obj, base);
> +	dma_resv_fini(&fbo->base.base._resv);
>  	ttm_bo_put(fbo->bo);
>  	kfree(fbo);
>  }

Alas, this innocuous looking commit causes one of my systems to lock up
as soon as run startx.  This happens with the nouveau driver, two other
systems with radeon and intel graphics are not affected.  Also I only
noticed it in 5.10.77.  Kernels 5.15 and 5.14.16 are not affected, and I
do not use 5.4 anymore.

I am not familiar with nouveau's ttm management and what has changed
there between 5.10 and 5.14, but maybe one of their developers can shed
a light on this.

Cheers,
       Sven
