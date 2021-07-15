Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC323C9E26
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 14:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhGOMEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232003AbhGOMEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 386DD611AD;
        Thu, 15 Jul 2021 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626350497;
        bh=bvioZ2SUemkybSffe93+DiVDPw02jQlhXZRvrQVmXE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LzVt2L2+QbfBOtyG9/41D+3Iqb66JILbJJDS0h3sGdRRUhoRd/5iZbb4i0a0WKvCd
         O0lU79n4DRs7uLTVHFMSNXzqk7sNsgEwcXsu1QaQdkaizYFff+Y3ze7uHECpCAMbD3
         TH8B7suedWu9aHiE7T9vV1PEjHCiWM50ZTkWdYw4=
Date:   Thu, 15 Jul 2021 14:01:32 +0200
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
Message-ID: <YPAjnCXOBK5CFfHu@kroah.com>
References: <CACCg+XO+D+2SWJq0C=_sWXj53L1fh-wra8dmCb3VQ4bYCZQryA@mail.gmail.com>
 <20210702184957.4479-1-andrew_gabbasov@mentor.com>
 <20210702184957.4479-2-andrew_gabbasov@mentor.com>
 <YOKvz2WzYuV0PaXD@kroah.com>
 <000001d77187$e9782dd0$bc688970$@mentor.com>
 <YOLiDSs/9+RzMKqE@kroah.com>
 <000001d7766a$a755ada0$f60108e0$@mentor.com>
 <20210711155130.16305-1-andrew_gabbasov@mentor.com>
 <YOsXQfWvIPXUydFv@kroah.com>
 <000001d77674$0fd59b20$2f80d160$@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d77674$0fd59b20$2f80d160$@mentor.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 11, 2021 at 07:44:41PM +0300, Andrew Gabbasov wrote:
> Hello Greg,
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Sunday, July 11, 2021 7:07 PM
> > To: Gabbasov, Andrew <Andrew_Gabbasov@mentor.com>
> > Cc: Macpaul Lin <macpaul.lin@mediatek.com>; Eugeniu Rosca <erosca@de.adit-jv.com>; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org; stable@vger.kernel.org; Felipe Balbi <balbi@kernel.org>; Eugeniu Rosca
> > <roscaeugeniu@gmail.com>; Eddie Hung <eddie.hung@mediatek.com>
> > Subject: Re: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and driver data cross-references
> > 
> > On Sun, Jul 11, 2021 at 10:51:30AM -0500, Andrew Gabbasov wrote:
> > > commit ecfbd7b9054bddb12cea07fda41bb3a79a7b0149 upstream.
> > >
> 
> [ skipped ]
> 
> > > Fixes: 4b187fceec3c ("usb: gadget: FunctionFS: add devices management code")
> > > Fixes: 3262ad824307 ("usb: gadget: f_fs: Stop ffs_closed NULL pointer dereference")
> > > Fixes: cdafb6d8b8da ("usb: gadget: f_fs: Fix use-after-free in ffs_free_inst")
> > > Reported-by: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
> > > Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > > Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > > Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
> > > Link: https://lore.kernel.org/r/20210603171507.22514-1-andrew_gabbasov@mentor.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > [agabbasov: Backported to earlier mount API, resolved context conflicts]
> > > ---
> > >  drivers/usb/gadget/function/f_fs.c | 67 ++++++++++++++----------------
> > >  1 file changed, 32 insertions(+), 35 deletions(-)
> > 
> > I also need a 4.19 version of this commit, as you do not want to upgrade
> > to a newer kernel and regress.  Can you also provide that?
> 
> If I correctly understand, this particular file has a very minor difference
> between 4.14 and 4.19. So, this same patch for 4.14 can be just applied / cherry-picked
> cleanly on top of latest stable 4.19.

Now queued up, thanks.

greg k-h
