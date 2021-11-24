Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7E745CBF6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 19:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244016AbhKXSWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 13:22:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350417AbhKXSWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 13:22:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03EAA60F42;
        Wed, 24 Nov 2021 18:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637777947;
        bh=ES6k5Wd84kFrCJIg6ITA2DWapXLfqUgbhOKtax/30js=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7+YHq5xAxeg62uKinnmQpztuk9c5UmGP2E8eGrssn9fqYhSLwUS3YnmeUlk/TBgT
         fHn12XF9LqquyTOehIMOfx0hJhSmAcBcyMkbtv5tdTXCrNfHQbQwMtxzUCvjphyrA4
         w+k7wkMXwmqFBOmHQPJ9JJ6dXfMy3uQB4SzmWEXA=
Date:   Wed, 24 Nov 2021 19:19:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Scott Bruce <smbruce@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: WIP 5.15.5-rc1 build failure in sound/soc/sof/intel/hda-dai.c
Message-ID: <YZ6CGCn0cZ6Rr8gp@kroah.com>
References: <CAPOoXdHhLdkP9KE4_9pPzUTdpFbN15wQp9SshJfvz1SxZWsRbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPOoXdHhLdkP9KE4_9pPzUTdpFbN15wQp9SshJfvz1SxZWsRbA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 08:57:39AM -0800, Scott Bruce wrote:
> It looks like the current work in progress branch for 5.15.5-rc1
> picked up fe1bda72c1e8 "ASoC: SOF: Intel: hda-dai: fix potential
> locking issue" without also picking 868ddfcef31f "ALSA: hda:
> hdac_ext_stream: fix potential locking issues" from master. This
> causes builds to fail on x86_64 using clang:
> 
>   ...
>   CC [M]  drivers/misc/eeprom/at25.o
>   CC [M]  drivers/block/pktcdvd.o
>   LTO [M] sound/soc/codecs/snd-soc-max98088.lto.o
> sound/soc/sof/intel/hda-dai.c:111:4: error: implicit declaration of
> function 'snd_hdac_ext_stream_decouple_locked'
> [-Werror,-Wimplicit-function-declaration]
>                         snd_hdac_ext_stream_decouple_locked(bus, res, true);
>                         ^
> sound/soc/sof/intel/hda-dai.c:111:4: note: did you mean
> 'snd_hdac_ext_stream_decouple'?
> ./include/sound/hdaudio_ext.h:91:6: note:
> 'snd_hdac_ext_stream_decouple' declared here
> void snd_hdac_ext_stream_decouple(struct hdac_bus *bus,
>      ^
> 1 error generated.
> make[4]: *** [scripts/Makefile.build:277: sound/soc/sof/intel/hda-dai.o] Error 1
> make[3]: *** [scripts/Makefile.build:540: sound/soc/sof/intel] Error 2
> make[2]: *** [scripts/Makefile.build:540: sound/soc/sof] Error 2
> make[2]: *** Waiting for unfinished jobs....
>   AR      drivers/misc/cb710/built-in.a
>   CC [M]  drivers/misc/cb710/core.o
>   CC [M]  net/netfilter/xt_nfacct.o
>   ...
> 
> After cherry-picking the second commit (868ddfcef31f) builds complete normally.

Now added, thanks.

> In case it's relevant there's a third commit in this same series
> that's also not included: 1465d06a6d85, "ALSA: hda: hdac_stream: fix
> potential locking issue in snd_hdac_stream_assign()".

I've queued that up now as well, thanks!

greg k-h
