Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 105FB32B05
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 10:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfFCInD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 04:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727710AbfFCInD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 04:43:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BBF32253C;
        Mon,  3 Jun 2019 08:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559551381;
        bh=nP42txCS2kBbqmq6iauy3U0YHR5D12lvEvkBmXGWn2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j+t2/Ry8zNW0f5K2W411VX0/ylz0qplq2WxAae7m3vQoh/NDtpT54w2PGdaMkzbI9
         Wc/DN/EL0zEGpAjbJdUcL5AubT64Fhg032Msgy2zZRkaCEiW013/XmorPVhBfAFAwA
         XUyWf9Z4k8jCs4j8rfGpB6Gnw6v7aA7epOcEMZcM=
Date:   Mon, 3 Jun 2019 10:42:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: caam - fix DKP detection logic
Message-ID: <20190603084257.GA13673@kroah.com>
References: <20190503120548.5576-1-horia.geanta@nxp.com>
 <20190506063944.enwkbljhy42rcaqq@gondor.apana.org.au>
 <VI1PR0402MB3485B440F9D3F033F021307298300@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <VI1PR0402MB348596A1F9AF7B547DC6AB2C98180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190603075215.GA7814@kroah.com>
 <VI1PR0402MB3485DFE0BB41351836D4BF3598140@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR0402MB3485DFE0BB41351836D4BF3598140@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 08:10:15AM +0000, Horia Geanta wrote:
> On 6/3/2019 10:52 AM, Greg Kroah-Hartman wrote:
> > On Thu, May 30, 2019 at 11:36:25AM +0000, Horia Geanta wrote:
> >> On 5/6/2019 11:06 AM, Horia Geanta wrote:
> >>> On 5/6/2019 9:40 AM, Herbert Xu wrote:
> >>>> On Fri, May 03, 2019 at 03:05:48PM +0300, Horia Geantă wrote:
> >>>>> The detection whether DKP (Derived Key Protocol) is used relies on
> >>>>> the setkey callback.
> >>>>> Since "aead_setkey" was replaced in some cases with "des3_aead_setkey"
> >>>>> (for 3DES weak key checking), the logic has to be updated - otherwise
> >>>>> the DMA mapping direction is incorrect (leading to faults in case caam
> >>>>> is behind an IOMMU).
> >>>>>
> >>>>> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")
> >>>>> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> >>>>> ---
> >>>>>
> >>>>> This issue was noticed when testing with previously submitted IOMMU support:
> >>>>> https://patchwork.kernel.org/project/linux-crypto/list/?series=110277&state=*
> >>>>
> >>>> Thanks for catching this Horia!
> >>>>
> >>>> My preference would be to encode this logic separately rather than
> >>>> relying on the setkey test.  How about this patch?
> >>>>
> >>> This is probably more reliable.
> >>>
> >>>> ---8<---
> >>>> The detection for DKP (Derived Key Protocol) relied on the value
> >>>> of the setkey function.  This was broken by the recent change which
> >>>> added des3_aead_setkey.
> >>>>
> >>>> This patch fixes this by introducing a new flag for DKP and setting
> >>>> that where needed.
> >>>>
> >>>> Reported-by: Horia Geantă <horia.geanta@nxp.com>
> >>>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >>> Tested-by: Horia Geantă <horia.geanta@nxp.com>
> >>>
> >> Unfortunately the commit message dropped the tag provided in v1:
> >> Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")
> >>
> >> This fix was merged in v5.2-rc1 (commit 24586b5feaf17ecf85ae6259fe3ea7815dee432d
> >> upstream) but should also be queued up for 5.1.y.
> > 
> > I do not understand, sorry.  What exact patches need to be applied to
> > 5.1.y?
> > 
> Commit 24586b5feaf1 ("crypto: caam - fix DKP detection logic").

But that commit says:
	Fixes: 1b52c40919e6 ("crypto: caam - Forbid 2-key 3DES in FIPS mode")
which is only contained in 5.2-rc1, so why would I want to apply the
first one to 5.1.y?

Still confused,

greg k-h
