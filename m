Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA4360F5C6
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbiJ0Kxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbiJ0Kxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:53:44 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D104814C5;
        Thu, 27 Oct 2022 03:53:43 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 9FFB83FA55;
        Thu, 27 Oct 2022 10:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1666868021; bh=zNucYYy3VjQEKj8yZ2eMFXotjkia9Wx2c/L4/Yd59Cw=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=XPMvFFGZxXBxIN71ObjM//Ar4Dh3+gqxeI0kTomnuAigiYJ33GQYyPc9RzqOz/QHI
         XC8w9nq07gKNA48XdHIBeY2KfHEYlPa8CMp3c7kDt74Z7GhEUk6BT6SdFehuG1HcMh
         pKD1jCyqTNg3e1ByL1uAtbgg/sMy/C5s7Yum+UEEpKGJlLa6Qi+1n2WLeHH+P1tsV5
         RRpHtQrWhPDQ9xU03P16DNICh9PSlUWBAWhS4dkkaI1z5P/JMRWaZ3UJCPHAWUgk3m
         9iBGeYLZXMyB4X9hgNqbPg8NmudpLOZTUBm8Y24YaQ1KMoz3x/7hoNO+/Ii+paycN8
         MmvpObuEXERZQ==
Message-ID: <cfe65da9-497d-b825-7332-874b6e87c087@marcan.st>
Date:   Thu, 27 Oct 2022 19:53:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>
Cc:     Pekka Paalanen <pekka.paalanen@collabora.com>,
        dri-devel@lists.freedesktop.org, asahi@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221027101327.16678-1-marcan@marcan.st>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are supported
In-Reply-To: <20221027101327.16678-1-marcan@marcan.st>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/10/2022 19.13, Hector Martin wrote:
> Until now, simpledrm unconditionally advertised all formats that can be
> supported natively as conversions. However, we don't actually have a
> full conversion matrix of helpers. Although the list is arguably
> provided to userspace in precedence order, userspace can pick something
> out-of-order (and thus break when it shouldn't), or simply only support
> a format that is unsupported (and thus think it can work, which results
> in the appearance of a hang as FB blits fail later on, instead of the
> initialization error you'd expect in this case).
> 
> Split up the format table into separate ones for each required subset,
> and then pick one based on the native format. Also remove the
> native<->conversion overlap check from the helper (which doesn't make
> sense any more, since the native format is advertised anyway and this
> way RGB565/RGB888 can share a format table), and instead print the same
> message in simpledrm when the native format is not one for which we have
> conversions at all.
> 
> This fixes a real user regression where the ?RGB2101010 support commit
> started advertising it unconditionally where not supported, and KWin
> decided to start to use it over the native format, but also the fixes
> the spurious RGB565/RGB888 formats which have been wrongly
> unconditionally advertised since the dawn of simpledrm.
> 
> Note: this patch is merged because splitting it into two patches, one
> for the helper and one for simpledrm, would regress at the midpoint
> regardless of the order. If simpledrm is changed first, that would break
> working conversions to RGB565/RGB888 (since those share a table that
> does not include the native formats). If the helper is changed first, it
> would start spuriously advertising all conversion formats when the
> native format doesn't have any supported conversions at all.
> 
> Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
> Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB2101010 formats")
> Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  drivers/gpu/drm/drm_format_helper.c | 15 -------
>  drivers/gpu/drm/tiny/simpledrm.c    | 62 +++++++++++++++++++++++++----
>  2 files changed, 55 insertions(+), 22 deletions(-)
> 

To answer some issues that came up on IRC:

Q: Why not move this logic / the tables to the helper?
A: Because simpledrm is the only user so far, and this patch is Cc:
stable because we have an actual regression that broke KDE. I'm going
for the minimal patch that keeps everything that worked to this day
working, and stops advertising things that never worked, no more, no
less. Future refactoring can always happen later (and is probably a good
idea when other drivers start using the helper).

Q: XRGB8888 is supposed to be the only canonical format. Why not just
drop everything but conversions to/from XRGB8888?
A: Because that would regress things that work today, and could break
existing userspace on some platforms. That may be a good idea, but I
think we should fix the bugs first, and leave the discussion of whether
we want to actually remove existing functionality for later.

Q: Why not just add a conversion from XRGB2101010 to XRGB8888?
A: Because that would only fix KDE, and would make it slower vs. not
advertising XRGB2101010 at all (double conversions, plus kernel
conversion can be slower). Plus, it doesn't make any sense as it only
fills in one entry in the conversion matrix. If we wanted to actually
fill out the conversion matrix, and thus support everything simpledrm
has advertised to day correctly, we would need helpers for:

rgb565->rgb888
rgb888->rgb565
rgb565->xrgb2101010
rgb888->xrgb2101010
xrgb2101010->rgb565
xrgb2101010->rgb888
xrgb2101010->xrgb8888

That seems like overkill and unlikely to actually help anyone, it'd just
give userspace more options to shoot itself in the foot with a
sub-optimal format choice. And it's a pile of code.

- Hector
