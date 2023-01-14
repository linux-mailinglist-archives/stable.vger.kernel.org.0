Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B72166AAA6
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 10:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjANJqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 04:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjANJqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 04:46:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E5D86B7
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 01:46:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41CBC601D2
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 09:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352ACC433EF;
        Sat, 14 Jan 2023 09:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673689568;
        bh=YzG8hi6b+PAhXDC8c0SWvDux1lGL5hsJ1GJn+6Lsp+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lKo5HIP5fZz15M2P8yP516L+vHjL+Xr5A7RAVTFJB2WjYYSy9muTjNVVh9vE3aE96
         qWOZe76aEsXaP+IoxmJEIB25FP8cHH7ZZaEmeEpfXJ4VJ+4H8ZISvHJuCNI0AMe/SG
         kjowkEyFSW+CoR2lo8jjhfg9m3MRM6pAg5OMn4Jo=
Date:   Sat, 14 Jan 2023 10:46:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michael Ralston <michael@ralston.id.au>
Cc:     tiwai@suse.de, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ALSA: usb-audio: Drop superfluous interface
 setup at parsing"
Message-ID: <Y8J53eg6vJQl2Rhr@kroah.com>
References: <167362470314207@kroah.com>
 <5498668.31r3eYUQgx@leatherback>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5498668.31r3eYUQgx@leatherback>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 14, 2023 at 05:38:19PM +1100, Michael Ralston wrote:
> This reverts commit ac5e2fb425e1121ceef2b9d1b3ffccc195d55707.
> 
> The commit caused a regression on Behringer UMC404HD (and likely
> others).  As the change was meant only as a minor optimization, it's
> better to revert it to address the regression.
> 
> It appears that the original revert patch had spaces instead of tabs so it 
> would not apply. Hopefully this fixes that. Please forgive my ignorance if I 
> have misunderstood.
> 
> Reported-and-tested-by: Michael Ralston <michael@ralston.id.au>
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com
> Link: https://lore.kernel.org/r/20230104150944.24918-1-tiwai@suse.de
> 
> diff --git a/sound/usb/stream.c b/sound/usb/stream.c
> index f75601ca2d52..f10f4e6d3fb8 100644
> --- a/sound/usb/stream.c
> +++ b/sound/usb/stream.c
> @@ -1222,6 +1222,12 @@ static int __snd_usb_parse_audio_interface(struct 
> snd_usb_audio *chip,

Thanks for the backport, but your email client line-wrapped this line.
I fixed it up by hand, but you might want to fix your client for next
time.

greg k-h
