Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39D52AAC62
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 18:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgKHRAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 12:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgKHRAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 12:00:00 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCAD820731;
        Sun,  8 Nov 2020 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604854798;
        bh=/3pNTmN6DjO114ELWmZPyPaEIJmZESt2gO8P0PPsx4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FkSdDNil3jhDNfIfQeFOAhCCLgGgclWaPVNlhSogK6IBnqAt0ofBL/f57dPc4oK+g
         YcPzilzdpWC1HWRxJ4MFnZrch/bBWg+UJT5N9BBJ8rB5CQ9mj+zfvQQAKxMH34DbnX
         MAGyWtvlhEPyZyao/0oTbIZ4jZda3YbcuR8gp5G4=
Date:   Sun, 8 Nov 2020 18:00:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Rojewski, Cezary" <cezary.rojewski@intel.com>
Cc:     "Gorski, Mateusz" <mateusz.gorski@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ASoC: Intel: Skylake: Add alternative topology binary
 name
Message-ID: <20201108170059.GA18354@kroah.com>
References: <20201103141047.15053-1-mateusz.gorski@linux.intel.com>
 <20201103153541.GC3267686@kroah.com>
 <d6006431-420f-55c7-0f78-977507e11fcf@linux.intel.com>
 <20201104115810.GA1694250@kroah.com>
 <0f6a673556974a289c2b81f3a8cc7536@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f6a673556974a289c2b81f3a8cc7536@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 08, 2020 at 04:17:16PM +0000, Rojewski, Cezary wrote:
> On 2020-11-04 12:58 PM, Greg KH wrote:
> > On Wed, Nov 04, 2020 at 12:46:36PM +0100, Gorski, Mateusz wrote:
> >>
> >>>> [ Upstream commit 1b290ef023b3eeb4f4688b582fecb773915ef937 ]
> >>>>
> >>>> Add alternative topology binary file name based on used machine driver
> >>>> and fallback to use this name after failed attempt to load topology file
> >>>> with name based on NHLT.
> >>>> This change addresses multiple issues with current mechanism, for
> >>>> example - there are devices without NHLT table, and that currently
> >>>> results in tplg_name being empty.
> ...
> 
> >>> What problems are people facing, and what kernel(s) are you asking for
> >>> this to be ported to, and why can't people just use 5.8 or newer if they
> >>> have this new hardware?
> >>>
> >>
> >> I forgot to add - I wanted this change to be merged to stable 5.4 kernel.
> >> Please let me know if I should resend this patch with this information
> >> included.
> >>
> >> As for the user issues - topology binary file name is currently created
> >> according to information from NHLT. The problem is, that some laptops (for
> >> example Dell XPS 13) do not have NHLT at all. This results in topology
> >> binary name being empty (" ").
> >> This patch adds alternative name based on loaded machine driver.
> >>
> >> It applies not only to new hardware, please note that the mentioned Dell XPS
> >> 13 is based on Kabylake. This issue existed on upstream from the beginning
> >> of Skylake driver and was only recently addressed.
> > 
> > When was that laptop released and is this the only change that is needed
> > in order for the 5.4.y kernel to work properly on it?
> > 
> 
> Sorry for the late answer, Greg. To address your concerns and questions
> let me elaborate:
> 
> Indeed, this change is not the only one required to enable DMIC + HDA
> configuration for customers. The following series is essential:
> 
> [PATCH 0/7] ASoC: Intel: Skylake: Fix HDaudio and Dmic
> https://lore.kernel.org/alsa-devel/20200305145314.32579-1-cezary.rojewski@intel.com/

Great, then they should just use a newer kernel version.  It's crazy to
think that you can go back in time and get older kernels working for
newer hardware :)

thanks,

greg k-h
