Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F13B10B1E9
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 16:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfK0PLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 10:11:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfK0PLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 10:11:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3846220674;
        Wed, 27 Nov 2019 15:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574867463;
        bh=CxoUGXSV4/HkwWXqDfkgy996CG8o/Tko7S0mJ5fn6no=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZeFdg+0jIPTpY21rpOivkILOy1O7qcdlvgMAqfpxOIp3ucnkTDeSKO4Y8cH0LzFw
         NAIUMNvEu5FzvhRR+IhrL+yA1cZC2+wiW1lQYIBgQ9z8BQmMeZ2Uee7kU4oYoeK5fe
         vPJVlZQeo36lO0MAQbRfzvoVd1h1xXG34wsWY+7U=
Date:   Wed, 27 Nov 2019 16:11:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4.y] ALSA: hda - Disable audio component for legacy
 Nvidia HDMI codecs
Message-ID: <20191127151101.GA2752784@kroah.com>
References: <20191127144706.13289-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191127144706.13289-1-tiwai@suse.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 03:47:06PM +0100, Takashi Iwai wrote:
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
> [ Unlike the original subject line, this patch actually disables the
>   audio component binding for all Nvidia chips on 5.4.y, not only for
>   legacy chips, but it doesn't matter much; nouveau gfx driver still
>   doesn't provide the audio component binding, so it's only a
>   placeholder on 5.4.y -- tiwai ]
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205625
> Fixes: ade49db337a9 ("ALSA: hda/hdmi - Allow audio component for AMD/ATI and Nvidia HDMI")
> Link: https://lore.kernel.org/r/20191122132000.4460-1-tiwai@suse.de
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/patch_hdmi.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
> index 78bd2e3722c7..cdacc52a5147 100644
> --- a/sound/pci/hda/patch_hdmi.c
> +++ b/sound/pci/hda/patch_hdmi.c
> @@ -3492,8 +3492,6 @@ static int patch_nvhdmi(struct hda_codec *codec)
>  
>  	codec->link_down_at_suspend = 1;
>  
> -	generic_acomp_init(codec, &nvhdmi_audio_ops, nvhdmi_port2pin);
> -
>  	return 0;
>  }
>  
> -- 
> 2.16.4
> 

This patch adds the build warning:
  CC [M]  sound/pci/hda/patch_hdmi.o
sound/pci/hda/patch_hdmi.c:3465:12: warning: ‘nvhdmi_port2pin’ defined but not used [-Wunused-function]
 3465 | static int nvhdmi_port2pin(struct hda_codec *codec, int port)
      |            ^~~~~~~~~~~~~~~
  LD [M]  sound/pci/hda/snd-hda-codec-hdmi.o

Is that intentional?

Did a different patch fix that issue up?

thanks,

greg k-h
