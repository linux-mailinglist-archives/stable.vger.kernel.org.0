Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFF732CE2E
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 09:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhCDINt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 03:13:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236327AbhCDINd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 03:13:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35F8E64EA4;
        Thu,  4 Mar 2021 08:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614845572;
        bh=Dh3Ev/dCrImACq8JWfEYsh8ZVySaYfX1dN8xgdk2QZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PzL/jrBFNamXglkuTttehjc037jgOVP78DjEl4JCAMSuM9evF4NuYe6gpNi3zQwgC
         S3XjEOft2/H6asBQ90PjwSc0jn+ad5gfHzi8k9PAcMNTHELD0YqASMox8Cts467AWM
         0V9mcIf7Kj35A+xu31euLYR0L64XA+fbAenzdTMw=
Date:   Thu, 4 Mar 2021 09:12:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Yoo, Jae Hyun" <jae.hyun.yoo@intel.com>
Cc:     Joel Stanley <joel@jms.id.au>,
        John Wang <wangzhiqiang.bj@bytedance.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Vernon Mauery <vernon.mauery@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 055/247] soc: aspeed: snoop: Add clock control logic
Message-ID: <YECWglSMg0EKAhgd@kroah.com>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161034.369309830@linuxfoundation.org>
 <CACPK8XeoKfNCR9diNZoLCM04=G9BRVxY_VZhXr+XQcpq2+rCdQ@mail.gmail.com>
 <BY5PR11MB38788139CE6E4BA6A667CB84D2999@BY5PR11MB3878.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR11MB38788139CE6E4BA6A667CB84D2999@BY5PR11MB3878.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 12:09:21AM +0000, Yoo, Jae Hyun wrote:
> > -----Original Message-----
> > From: Joel Stanley <joel@jms.id.au>
> > Sent: Monday, March 1, 2021 2:44 PM
> > To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; John Wang
> > <wangzhiqiang.bj@bytedance.com>; Yoo, Jae Hyun
> > <jae.hyun.yoo@intel.com>
> > Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>;
> > stable@vger.kernel.org; Vernon Mauery <vernon.mauery@linux.intel.com>;
> > Sasha Levin <sashal@kernel.org>
> > Subject: Re: [PATCH 4.19 055/247] soc: aspeed: snoop: Add clock control logic
> > 
> > On Mon, 1 Mar 2021 at 16:37, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Jae Hyun Yoo <jae.hyun.yoo@intel.com>
> > >
> > > [ Upstream commit 3f94cf15583be554df7aaa651b8ff8e1b68fbe51 ]
> > >
> > > If LPC SNOOP driver is registered ahead of lpc-ctrl module, LPC SNOOP
> > > block will be enabled without heart beating of LCLK until lpc-ctrl
> > > enables the LCLK. This issue causes improper handling on host
> > > interrupts when the host sends interrupt in that time frame.
> > > Then kernel eventually forcibly disables the interrupt with dumping
> > > stack and printing a 'nobody cared this irq' message out.
> > >
> > > To prevent this issue, all LPC sub-nodes should enable LCLK
> > > individually so this patch adds clock control logic into the LPC SNOOP
> > > driver.
> > 
> > Jae, John; with this backported do we need to also provide a corresponding
> > device tree change for the stable tree, otherwise this driver will no longer
> > probe?
> 
> Right. The second patch
> https://lore.kernel.org/linux-arm-kernel/20201208091748.1920-2-wangzhiqiang.bj@bytedance.com/
> John submitted should be applied to stable tree too to make this module be probed
> correctly.

Now queued up, thanks.

greg k-h
