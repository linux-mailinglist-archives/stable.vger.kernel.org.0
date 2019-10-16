Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98367DA05E
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407245AbfJPWKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407243AbfJPWKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 18:10:44 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3490D2168B;
        Wed, 16 Oct 2019 22:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263844;
        bh=wRPRx59clYqvUpZMC7DRBJZmjJM/PP5JMQYLM6iKfrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a7gwYWoHqwcRdWaqK8CFEiFoOWi4S/TMuYIW1WxYqrMRDPmB7Gwg4WgiIHgBHX/18
         w4tYaVj9aS5w66G631mvEfl7IGp8I9C0kYrP3oJRiHSou2aEgghad5eaKJzxHc1AiK
         kd5XvGsh3b1X+xBh0oTuFcvZVr13SQ5RZK6MOLdg=
Date:   Wed, 16 Oct 2019 15:10:25 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>,
        Richard Leitner <richard.leitner@skidata.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Message-ID: <20191016221025.GA990599@kroah.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191016214907.599726506@linuxfoundation.org>
 <20191016220044.GB11473@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016220044.GB11473@sirena.co.uk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 11:00:44PM +0100, Mark Brown wrote:
> On Wed, Oct 16, 2019 at 02:51:44PM -0700, Greg Kroah-Hartman wrote:
> > From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
> > 
> > commit 694b14554d75f2a1ae111202e71860d58b434a21 upstream.
> > 
> > This control mute/unmute the ADC input of SGTL5000
> > using its CHIP_ANA_CTRL register.
> 
> This seems like a new feature and not an obvious candidate for stable?

there was a long email from Richard that said:
	Upstream commit 631bc8f0134a ("ASoC: sgtl5000: Fix of unmute
	outputs on probe"), which is e9f621efaebd in v5.3 replaced
	snd_soc_component_write with snd_soc_component_update_bits and
	therefore no longer cleared the MUTE_ADC flag. This caused the
	ADC to stay muted and recording doesn't work any longer. This
	patch fixes this problem by adding a Switch control for
	MUTE_ADC.

That's why I took this.  If this isn't true, I'll be glad to drop this.

thanks,

greg k-h
