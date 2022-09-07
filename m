Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945855B0071
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 11:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiIGJ3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 05:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiIGJ3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 05:29:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468F6A3473;
        Wed,  7 Sep 2022 02:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E501DB81B8B;
        Wed,  7 Sep 2022 09:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D9DC433C1;
        Wed,  7 Sep 2022 09:28:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZogZr9A8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662542937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uvCPcOxnUC4wGn1S/Nv7nd9/+PzZUA4XVj1lOT3gFj8=;
        b=ZogZr9A8RtJMjPkzMWOPgXLUIuyAp4smpWeF8UG8T7y3j5NvXCzINOJFhYJuekur2aQ1IV
        Yd2LUGDH40IXxwcgs4ooIw1jgOi+UjSbltY+FwG8OJdhqIGB0CTs4MtoPOdxjXJlEFiAMv
        Zzjbs78gDkMqWX7Ma8bS77RmYVILMN0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7e084ecb (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 7 Sep 2022 09:28:57 +0000 (UTC)
Date:   Wed, 7 Sep 2022 11:28:54 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?utf-8?B?TmlrbMSBdnMgS2/EvGVzxYZpa292cw==?= 
        <89q1r14hd@relay.firefox.com>, Wim Taymans <wtaymans@redhat.com>
Subject: Re: [PATCH] ALSA: usb-audio: Don't refcount multiple accesses on the
 single clock
Message-ID: <YxhkVmiMlKghq+nY@zx2c4.com>
References: <20220905101403.1435037-1-Jason@zx2c4.com>
 <87sfl6jbb3.wl-tiwai@suse.de>
 <CAHmME9oUtVgwtUY5afG5Yed1j6OVKwvLH=keCp63gDSOQRgDSA@mail.gmail.com>
 <87czc7ehqp.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87czc7ehqp.wl-tiwai@suse.de>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 07, 2022 at 10:00:46AM +0200, Takashi Iwai wrote:
> On Mon, 05 Sep 2022 14:16:39 +0200,
> Jason A. Donenfeld wrote:
> > 
> > On Mon, Sep 5, 2022 at 1:44 PM Takashi Iwai <tiwai@suse.de> wrote:
> > > When you load snd-usb-audio with dyndbg=+p option, does it show the
> > > new error message "Mismatched sample rate xxx"?
> > 
> > No.
> 
> What about the patch below?
> 
> 
> Takashi
> 
> -- 8< --
> --- a/sound/usb/endpoint.c
> +++ b/sound/usb/endpoint.c
> @@ -925,6 +925,8 @@ void snd_usb_endpoint_close(struct snd_usb_audio *chip,
>  		endpoint_set_interface(chip, ep, false);
>  
>  	if (!--ep->opened) {
> +		if (ep->clock_ref && !atomic_read(&ep->clock_ref->locked))
> +			ep->clock_ref->rate = 0;
>  		ep->iface = 0;
>  		ep->altsetting = 0;
>  		ep->cur_audiofmt = NULL;

I think this works.

Niklāvs - can you give it a try to and confirm?

Jason
