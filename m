Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBD43BA41F
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 20:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhGBTAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 15:00:08 -0400
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:9662 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhGBTAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 15:00:08 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jul 2021 15:00:08 EDT
IronPort-SDR: 2u/tDuPx+OtzPgBuHaH85sAfoUHyFKi3dRfj4zWG/yvIo4UDhZ/6CZdFd19ae9flh6K31QIy32
 uuTSl5QsgPPsBcGf78DdB8dW2+RwME4luY6pcPD0lnh17s71EbxaFchfylfDAW3gcedJZLD/Q1
 g1spN57bVfGJNvVf8mI1lP1aXJwmsB+E1vK2OFrElUf6Mnvy9llf4l9Nvas63oS0n1VxX/V606
 l94bJiuJZsZTg9AqFe9+IAkdrK5OpauSFrs/Z5LT/cQVf4L+KegfktK5Ye24v9KWKV0bnnLAIs
 YSE=
X-IronPort-AV: E=Sophos;i="5.83,319,1616486400"; 
   d="scan'208";a="63097658"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 02 Jul 2021 10:50:28 -0800
IronPort-SDR: 1cCgpck76aZwU8ttF9Ytuqri9zCgnn4leh+ChPWJMAoHVxuR5ZVFsXVtoqrNf3oenztA5tNjSb
 VBVnHUfvEWZ1bGAeuVtF6GL2FGNkQs5mjhUvAV8mU2v7VzmKrzYpGdI+JUBT9su8WzIaxI7jDA
 Vn1kcCUl6D9pV10K7mQZvY1gL2oVsAdOngJ+eAe4jlxP93TXuI40rLW0pIvK15Gx8zHzpPGKCi
 DY3St/pdUyE4aBrpadiw5nxZ3BgZuUjixFVZOLZggnRSrF6Yllnn8xwdNGCZ6k0aU/3jbDTnv6
 eNo=
From:   Andrew Gabbasov <andrew_gabbasov@mentor.com>
To:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>
Subject: Re: [PATCH] usb: gadget: f_fs: Fix setting of device and driver data cross-references
Date:   Fri, 2 Jul 2021 13:49:56 -0500
Message-ID: <20210702184957.4479-1-andrew_gabbasov@mentor.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <CACCg+XO+D+2SWJq0C=_sWXj53L1fh-wra8dmCb3VQ4bYCZQryA@mail.gmail.com>
References: <20210603171507.22514-1-andrew_gabbasov@mentor.com> <20210604110503.GA23002@vmlxhi-102.adit-jv.com> <CACCg+XO+D+2SWJq0C=_sWXj53L1fh-wra8dmCb3VQ4bYCZQryA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: svr-ies-mbx-06.mgc.mentorg.com (139.181.222.6) To
 svr-ies-mbx-01.mgc.mentorg.com (139.181.222.1)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> -----Original Message-----
> From: Macpaul Lin <macpaul@gmail.com>
> Sent: Friday, July 02, 2021 6:02 PM
> To: Eugeniu Rosca <erosca@de.adit-jv.com>; stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Felipe Balbi <balbi@kernel.org>; Gabbasov, Andrew
> <Andrew_Gabbasov@mentor.com>; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Eugeniu Rosca
> <roscaeugeniu@gmail.com>; Macpaul Lin <macpaul.lin@mediatek.com>; Eddie Hung <eddie.hung@mediatek.com>
> Subject: Re: [PATCH] usb: gadget: f_fs: Fix setting of device and driver data cross-references
> 
> Eugeniu Rosca <erosca@de.adit-jv.com> wrote:
> >
> > Hello,
> >
> > On Thu, Jun 03, 2021 at 12:15:07PM -0500, Andrew Gabbasov wrote:
> > > FunctionFS device structure 'struct ffs_dev' and driver data structure
> > > 'struct ffs_data' are bound to each other with cross-reference pointers
> > > 'ffs_data->private_data' and 'ffs_dev->ffs_data'. While the first one
> > > is supposed to be valid through the whole life of 'struct ffs_data'
> > > (and while 'struct ffs_dev' exists non-freed), the second one is cleared
> > > in 'ffs_closed()' (called from 'ffs_data_reset()' or the last
> > > 'ffs_data_put()'). This can be called several times, alternating in
> > > different order with 'ffs_free_inst()', that, if possible, clears
> > > the other cross-reference.
> > >
> 
> [Skip some comment...]
> 
> > I confirm there are at least two KASAN use-after-free issues
> > consistently/100% reproducible on v5.13-rc4-88-gf88cd3fb9df2:
> >
> > https://gist.github.com/erosca/b5976a96789e574b319cb9e076938b5c
> > https://gist.github.com/erosca/4ded55ed32f0133bc2f4ccfe821c7776
> >
> > These two can no longer be seen after the patch is applied.
> >
> > In addition, below static analysis tools did not spot any regressions:
> > cppcheck 2.4, smatch v0.5.0-7445-g58776ae33ae8, make W=1, coccicheck
> >
> > Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> >
> > --
> > Best regards,
> > Eugeniu Rosca
> 
> It like there is similar issue on kernel-4.14 reported by our customer
> (Android).
> The back trace are similar.
> It looks like this patch has fixed issue existed in earlier kernels.
> Could Engeniu and Andrew help to comment if this fix is suggested to be pick to
> stable-tree? I've tried to port it onto kernel-4.14, kernel-4.19, and
> kernel-5.10.
> But it seems there is some revise work to do.
> If the origin issue affect multiple LTS kernel versions, then it will
> be better to be
> cherry-pick to stable-tree after it has been merged.
> Thanks!
> 
> --
> Best regards,
> Macpaul Lin

Hello!

Originally this issue was discovered exactly in v4.14 (non-Android),
and the fix was developed for that version and later forward-ported to
latest mainline 5.13. So, indeed, it makes sense to apply the fix
to stable versions (after it has been merged to mainline).

I'm submitting the same patch, back-ported to stable/linux-4.14.y.
It can also be applied to linux-4.19.y. While original 5.13 fix is
applicable to linux-5.10.y.

Thanks!

Best regards,
Andrew Gabbasov

