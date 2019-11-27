Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095C510B2FB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 17:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfK0QMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 11:12:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfK0QMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 11:12:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D95A20684;
        Wed, 27 Nov 2019 16:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574871165;
        bh=6NR44PuhrjoGjvGmuylhFPAC5zEf1CiBlnr3kbxPI6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gXntM1LLDSmzVDF6A446dj/xvVdEsqhpyoZft/VQduQ0xo/G5fw1CtYUlV/JwPV4f
         dnttWv7Xp2i7Dg1y8R3oZOV24Cos82/4KrxPWxIGdFaOamfhPkDVXD+2x5gjUr75Ah
         8lUhsFULU3T48pERZLFYWD0RjcTogWqXv7m/IfQQ=
Date:   Wed, 27 Nov 2019 17:12:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4.y v2] ALSA: hda - Disable audio component for legacy
 Nvidia HDMI codecs
Message-ID: <20191127161243.GA3059210@kroah.com>
References: <20191127153647.24752-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127153647.24752-1-tiwai@suse.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 04:36:47PM +0100, Takashi Iwai wrote:
> commit 5a858e79c911330678b5a9be91a24830e94a0dc9 upstream.
> 
> The old Nvidia chips have multiple HD-audio codecs on the same
> HD-audio controller, and this doesn't work as expected with the current
> audio component binding that is implemented under the one-codec-per-
> controller assumption; at the probe time, the driver leads to several
> kernel WARNING messages.
> 
> For the proper support, we may change the pin2port and port2pin to
> traverse the codec list per the given pin number, but this needs more
> development and testing.
> 
> As a quick workaround, instead, this patch drops the binding in the
> audio side for these legacy chips since the audio component support in
> nouveau graphics driver is still not merged (hence it's basically
> unused).
> 
> [ Unlike the original commit, this patch actually disables the audio
>   component binding for all Nvidia chips, not only for legacy chips.
>   It doesn't matter much, though: nouveau gfx driver still doesn't
>   provide the audio component binding on 5.4.y, so it's only a
>   placeholder for now.  Also, another difference from the original
>   commit is that this removes the nvhdmi_audio_ops and other
>   definitions completely in order to avoid a compile warning due to
>   unused stuff.  -- tiwai ]
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205625
> Fixes: ade49db337a9 ("ALSA: hda/hdmi - Allow audio component for AMD/ATI and Nvidia HDMI")
> Link: https://lore.kernel.org/r/20191122132000.4460-1-tiwai@suse.de
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/patch_hdmi.c | 22 ----------------------
>  1 file changed, 22 deletions(-)

This worked, thanks!

greg k-h
