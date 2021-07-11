Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C63C3DB4
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 17:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhGKPr6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 11 Jul 2021 11:47:58 -0400
Received: from esa1.mentor.iphmx.com ([68.232.129.153]:51538 "EHLO
        esa1.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbhGKPr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 11:47:58 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jul 2021 11:47:58 EDT
IronPort-SDR: 0r/OgIl75ZHcK8wxrSlMvY/RtYbSgGHcSexNWRNtk5XKWbzlO/UzHFgwufAIoHc+gdO06/w6GH
 Hhys9/dkPC3MUI6b5axtq/OKU5R/hfg3fEZUYdIsaX3FJVogaVDvnjJ6pvGSCmuhHostzzsAcv
 WuJuGZX4gusb9wgWC/3fch81MbkhG8DcI39Apcm4q26hmwOAbEACAkGtb4oAlp27XexC0ITtJk
 0lJDhLyVCx4z4GG/zaioakaJwuCJ8b8p3vrQB8oFZwehUbtG9I0L25TOY5Yr5K68ftqj1bRRtu
 Uh8=
X-IronPort-AV: E=Sophos;i="5.84,231,1620720000"; 
   d="scan'208";a="65827291"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa1.mentor.iphmx.com with ESMTP; 11 Jul 2021 07:38:05 -0800
IronPort-SDR: DMxmtnnmzBvukntamkj5o3aI9byTsHCH5W4epPaOkgDXh8IshSJueuHpO33SHXmcMiqheeVFag
 B3+17LIlNc2XeZcAlzNmO9Tfn8xSvCei9biJ3953XSD0jHRBY2HTX4CIghCcQAcTotbp3x5rxa
 58ZLnRbqY/ZRovv/wPTGih0d8PX8+fOML+UbKdo/5aGI50uMJRWuqHGgmZc4pL1HzfMfVdl9Ig
 FoXLMB21O08U+or/YIw3HeNNi6Om0Ggja9JdT5DPoS2fApohTaCfhOvjtqYz5Wkx3fQ5xkt18G
 MvA=
From:   Andrew Gabbasov <andrew_gabbasov@mentor.com>
To:     'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
CC:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Felipe Balbi <balbi@kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>
References: <20210603171507.22514-1-andrew_gabbasov@mentor.com> <20210604110503.GA23002@vmlxhi-102.adit-jv.com> <CACCg+XO+D+2SWJq0C=_sWXj53L1fh-wra8dmCb3VQ4bYCZQryA@mail.gmail.com> <20210702184957.4479-1-andrew_gabbasov@mentor.com> <20210702184957.4479-2-andrew_gabbasov@mentor.com> <YOKvz2WzYuV0PaXD@kroah.com> <000001d77187$e9782dd0$bc688970$@mentor.com> <YOLiDSs/9+RzMKqE@kroah.com>
In-Reply-To: <YOLiDSs/9+RzMKqE@kroah.com>
Subject: RE: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and driver data cross-references
Date:   Sun, 11 Jul 2021 18:37:20 +0300
Organization: Mentor Graphics Corporation
Message-ID: <000001d7766a$a755ada0$f60108e0$@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHXb3MiK5x8JbQzK0Wthg8LyVovu6sz6U+AgABMtp+ACb8xgA==
Content-Language: en-us
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-08.mgc.mentorg.com (139.181.222.8) To
 svr-ies-mbx-01.mgc.mentorg.com (139.181.222.1)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

> -----Original Message-----
> From: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
> Sent: Monday, July 05, 2021 1:42 PM
> To: Gabbasov, Andrew <Andrew_Gabbasov@mentor.com>
> Cc: Macpaul Lin <macpaul.lin@mediatek.com>; Eugeniu Rosca <erosca@de.adit-jv.com>; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; stable@vger.kernel.org; Felipe Balbi <balbi@kernel.org>; Eugeniu Rosca
> <roscaeugeniu@gmail.com>; Eddie Hung <eddie.hung@mediatek.com>
> Subject: Re: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and driver data cross-references
> 
> On Mon, Jul 05, 2021 at 01:24:10PM +0300, Andrew Gabbasov wrote:
> > Hello Greg,
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Monday, July 05, 2021 10:08 AM
> > > To: Gabbasov, Andrew <Andrew_Gabbasov@mentor.com>
> > > Cc: Macpaul Lin <macpaul.lin@mediatek.com>; Eugeniu Rosca <erosca@de.adit-jv.com>; linux-usb@vger.kernel.org;
> > > linux-kernel@vger.kernel.org; stable@vger.kernel.org; Felipe Balbi <balbi@kernel.org>; Eugeniu Rosca
> > > <roscaeugeniu@gmail.com>; Eddie Hung <eddie.hung@mediatek.com>
> > > Subject: Re: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and driver data cross-references
> > >
> > > On Fri, Jul 02, 2021 at 01:49:57PM -0500, Andrew Gabbasov wrote:
> > > > Fixes: 4b187fceec3c ("usb: gadget: FunctionFS: add devices management code")
> > > > Fixes: 3262ad824307 ("usb: gadget: f_fs: Stop ffs_closed NULL pointer dereference")
> > > > Fixes: cdafb6d8b8da ("usb: gadget: f_fs: Fix use-after-free in ffs_free_inst")
> > > > Reported-by: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
> > > > Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > > > Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > > > Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
> > > > Link: https://lore.kernel.org/r/20210603171507.22514-1-andrew_gabbasov@mentor.com
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > (cherry-picked from commit ecfbd7b9054bddb12cea07fda41bb3a79a7b0149)
> > >
> > > There is no such commit id in Linus's tree :(
> > >
> > > Please resubmit with the correct id.
> >
> > This commit is not yet included to the mainline, it only exists in linux-next:
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-
> next.git/commit/?id=ecfbd7b9054bddb12cea07fda41bb3a79a7b0149
> >
> > Could you please advise if I need to somehow denote the linux-next repo in the "cherry picked from" line,
> > or just remove this line, or so far wait and re-submit the patch after the original commit is merged to Linus'
> tree?
> > BTW, I just noticed that the line contains incorrect "cherry-picked" instead of "cherry picked",
> > so I'll have to re-submit the patch anyway 😉
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> Patches have to be in Linus's tree first before we can take it into a
> stable tree.  Please feel free to resubmit this once it is in a -rc
> release.

Sorry I was one day early before the commit was included to Linus' tree.
Now it is there and I'm re-submitting the patch, back-ported to v4.14.

Thanks!

Best regards,
Andrew


