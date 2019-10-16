Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66FEDA213
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 01:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391247AbfJPXX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 19:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfJPXX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 19:23:59 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1F8B20872;
        Wed, 16 Oct 2019 23:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571268238;
        bh=igapbZGpLlKRzBdYxMTU1tCbvC2o5pyly0l6ltnqaAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1qbmwoid57B9hFBwPWg+OWygSZUrw22vI6dINmFlY7wSMOPDtrFUs06xMuHrOfJyL
         QZ7ZMEaGtm0XtCgt0z7sZQ+Tz85DuNq0ousESvViYgloWYilcgjXv2frZXWpVq8rgk
         0qbasP5hiEQXf1i2A/Dp9WOzrwqDSIwtOfSZQ0kM=
Date:   Wed, 16 Oct 2019 16:23:58 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Richard Leitner <richard.leitner@skidata.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Message-ID: <20191016232358.GA994597@kroah.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191016214907.599726506@linuxfoundation.org>
 <20191016220044.GB11473@sirena.co.uk>
 <20191016221025.GA990599@kroah.com>
 <20191016223518.GC11473@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016223518.GC11473@sirena.co.uk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 11:35:18PM +0100, Mark Brown wrote:
> On Wed, Oct 16, 2019 at 03:10:25PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Oct 16, 2019 at 11:00:44PM +0100, Mark Brown wrote:
> > > On Wed, Oct 16, 2019 at 02:51:44PM -0700, Greg Kroah-Hartman wrote:
> > > > From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> 
> > > > commit 694b14554d75f2a1ae111202e71860d58b434a21 upstream.
> 
> > > > This control mute/unmute the ADC input of SGTL5000
> > > > using its CHIP_ANA_CTRL register.
> 
> > > This seems like a new feature and not an obvious candidate for stable?
> 
> > there was a long email from Richard that said:
> > 	Upstream commit 631bc8f0134a ("ASoC: sgtl5000: Fix of unmute
> > 	outputs on probe"), which is e9f621efaebd in v5.3 replaced
> > 	snd_soc_component_write with snd_soc_component_update_bits and
> > 	therefore no longer cleared the MUTE_ADC flag. This caused the
> > 	ADC to stay muted and recording doesn't work any longer. This
> > 	patch fixes this problem by adding a Switch control for
> > 	MUTE_ADC.
> 
> > That's why I took this.  If this isn't true, I'll be glad to drop this.
> 
> That's probably not an appropriate fix for stable - it's going to add a
> new control which users will need to manually set (or hope their
> userspace automatically figures out that it should set for them, more
> advanced userspaces like PulseAudio should) which isn't a drop in fix. 
> You could either drop the backport that was done for zero cross or take
> a new patch that clears the MUTE_ADC flag (rather than punting to
> userspace to do so), or just be OK with what you've got at the minute
> which might be fine given the lack of user reports.

Ok, I'll gladly go drop it, thanks!

greg k-h
