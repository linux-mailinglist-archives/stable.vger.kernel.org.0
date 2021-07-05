Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290A33BBB67
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhGEKpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 06:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230482AbhGEKpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 06:45:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D826135B;
        Mon,  5 Jul 2021 10:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625481745;
        bh=lkZrS5o06UXjSJ37hSBIvQE40enYaY6R8KqnS3uULh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0PyK9l6aDTwAUSiBfagKYeF10RsrL5oCiks6wPw+xnxA+aMMht1QYpIWOo1aByvp
         zew65CTx/MBYxS2BCWghXY6yYjdHx6hrd1GWIWQ2kjQwPpofaYfJ+dci6oFcDipZog
         pOIWclWCsdp6POCziiJtXeF0eKjWCUJ9AqJrZi9A=
Date:   Mon, 5 Jul 2021 12:42:21 +0200
From:   'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To:     Andrew Gabbasov <andrew_gabbasov@mentor.com>
Cc:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>
Subject: Re: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and
 driver data cross-references
Message-ID: <YOLiDSs/9+RzMKqE@kroah.com>
References: <20210603171507.22514-1-andrew_gabbasov@mentor.com>
 <20210604110503.GA23002@vmlxhi-102.adit-jv.com>
 <CACCg+XO+D+2SWJq0C=_sWXj53L1fh-wra8dmCb3VQ4bYCZQryA@mail.gmail.com>
 <20210702184957.4479-1-andrew_gabbasov@mentor.com>
 <20210702184957.4479-2-andrew_gabbasov@mentor.com>
 <YOKvz2WzYuV0PaXD@kroah.com>
 <000001d77187$e9782dd0$bc688970$@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000001d77187$e9782dd0$bc688970$@mentor.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 01:24:10PM +0300, Andrew Gabbasov wrote:
> Hello Greg,
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, July 05, 2021 10:08 AM
> > To: Gabbasov, Andrew <Andrew_Gabbasov@mentor.com>
> > Cc: Macpaul Lin <macpaul.lin@mediatek.com>; Eugeniu Rosca <erosca@de.adit-jv.com>; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org; stable@vger.kernel.org; Felipe Balbi <balbi@kernel.org>; Eugeniu Rosca
> > <roscaeugeniu@gmail.com>; Eddie Hung <eddie.hung@mediatek.com>
> > Subject: Re: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and driver data cross-references
> > 
> > On Fri, Jul 02, 2021 at 01:49:57PM -0500, Andrew Gabbasov wrote:
> > > Fixes: 4b187fceec3c ("usb: gadget: FunctionFS: add devices management code")
> > > Fixes: 3262ad824307 ("usb: gadget: f_fs: Stop ffs_closed NULL pointer dereference")
> > > Fixes: cdafb6d8b8da ("usb: gadget: f_fs: Fix use-after-free in ffs_free_inst")
> > > Reported-by: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
> > > Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > > Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > > Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
> > > Link: https://lore.kernel.org/r/20210603171507.22514-1-andrew_gabbasov@mentor.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > (cherry-picked from commit ecfbd7b9054bddb12cea07fda41bb3a79a7b0149)
> > 
> > There is no such commit id in Linus's tree :(
> > 
> > Please resubmit with the correct id.
> 
> This commit is not yet included to the mainline, it only exists in linux-next:
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=ecfbd7b9054bddb12cea07fda41bb3a79a7b0149
> 
> Could you please advise if I need to somehow denote the linux-next repo in the "cherry picked from" line,
> or just remove this line, or so far wait and re-submit the patch after the original commit is merged to Linus' tree?
> BTW, I just noticed that the line contains incorrect "cherry-picked" instead of "cherry picked",
> so I'll have to re-submit the patch anyway 😉

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

Patches have to be in Linus's tree first before we can take it into a
stable tree.  Please feel free to resubmit this once it is in a -rc
release.

thanks,

greg k-h
