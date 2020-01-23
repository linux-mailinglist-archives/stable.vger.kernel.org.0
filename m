Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23726146216
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 07:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgAWGnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 01:43:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:34540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAWGnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 01:43:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1835217F4;
        Thu, 23 Jan 2020 06:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579761788;
        bh=xAQZj9tFY1FT0CiNNJlEJTsbJX8801qGcsw3AFIuivc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w1p1nQD4PvUFTg70UDMsv9EfZ/21Xb6vHclyPaNttcT2tmD7Nkl/6CbAKlx5qkAJ9
         IW/7KPBbFReuNQLWbmkkfVtwEjSBeCcX1Uj/WQPg0Pb6f9RjRKYTpfjwtVmqj2VStA
         cn5Mk5b6cLr/6f3zZXgg4BX7uMkzS9J9srW/Y6Cg=
Date:   Thu, 23 Jan 2020 07:43:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        ALSA development <alsa-devel@alsa-project.org>,
        Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Takashi Iwai <tiwai@suse.de>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: topology: fix
 soc_tplg_fe_link_create() - link->dobj initialization order
Message-ID: <20200123064306.GA124954@kroah.com>
References: <20200122190752.3081016-1-perex@perex.cz>
 <26ae4dbd-b1b8-c640-0dc0-d8c2bbe666e2@linux.intel.com>
 <20200122202530.GG3833@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122202530.GG3833@sirena.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 08:25:30PM +0000, Mark Brown wrote:
> On Wed, Jan 22, 2020 at 01:28:57PM -0600, Pierre-Louis Bossart wrote:
> > On 1/22/20 1:07 PM, Jaroslav Kysela wrote:
> 
> > > The code which checks the return value for snd_soc_add_dai_link() call
> > > in soc_tplg_fe_link_create() moved the snd_soc_add_dai_link() call before
> > > link->dobj members initialization.
> 
> > > While it does not affect the latest kernels, the old soc-core.c code
> > > in the stable kernels is affected. The snd_soc_add_dai_link() function uses
> > > the link->dobj.type member to check, if the link structure is valid.
> 
> > > Reorder the link->dobj initialization to make things work again.
> > > It's harmless for the recent code (and the structure should be properly
> > > initialized before other calls anyway).
> 
> > > The problem is in stable linux-5.4.y since version 5.4.11 when the
> > > upstream commit 76d270364932 was applied.
> 
> > I am not following. Is this a fix for linux-5.4-y only, or is it needed on
> > Mark's tree? In the latter case, what is broken? We've been using Mark's
> > tree without issues, wondering what we missed?
> 
> He's saying it's a fix for stable but it's just a cleanup and robustness
> improvement in current kernels - when the patch 76d270364932 (ASoC:
> topology: Check return value for snd_soc_add_dai_link()) was backported
> by the bot the bot missed some other context which triggered bugs.
> 
> Copying in Sasha and Greg for stable (not sure if the list works by
> itself).

How this was marked-up is fine, our scripts can easily handle it,
thanks.

greg k-h
