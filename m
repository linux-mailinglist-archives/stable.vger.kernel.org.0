Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163E152C023
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 19:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbiERQy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 12:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbiERQy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 12:54:27 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC96E201339;
        Wed, 18 May 2022 09:54:26 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n6so1487419wms.0;
        Wed, 18 May 2022 09:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d+efCMwKCzHZq8Cl4KmFkQrrYv15aDwHBzF5AWLwbrQ=;
        b=BTUPgo2TYfQstCyPN/R6x1aykj9j6m5rB8Vuha4hP1qaqIly6dQzMUsF9xE4NjgDS7
         n1rcSMUUFNNWE1/7MF/LWhO/fPaw0ag2EUoRupuVFOdwfYFc8wjnFSofmM1DTRFRAvwL
         JIbcmyY+aIxmF5RmnRIDA8Kjd1yUwg6n2ISpI4Pxqho8mdYUnYy3ZlFMFnEoXgSCIlQE
         VIFzy00TcWJim0W0rpiNuORehXcqJavFvbh/QJcgDtfj/sMyBqKXv6uhGgGzxk1FSIH5
         0wJZtcuhhb2VKr+9ChMK8ozkPzOEKKF6UsNxaZAsgmkp8X4S6lu3mg8eCmLylSoc/CrP
         5Lgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+efCMwKCzHZq8Cl4KmFkQrrYv15aDwHBzF5AWLwbrQ=;
        b=HioN/1b+jUA42i9JTEXBlSZW4Gh1wUm5NgVzCvVtgAOGjFb2J/TCB8MF3il+O+wvyo
         uWbhWkm5ogJPJIdMQWIBmY6anhmLmtfq7W4Hi1XdnILLMuQAtXA8wAF4T9jMZbMcAV4g
         XbxztP9OXUYkFrxuuzbuEaruRkjOOTbmtKPeVW/ORfROt3DobhG3R6A3ew+3nLUdVKs8
         sg6rg4Y6AiAL4h8d87vNQHbEA7g6xQ2FDBsjBUp4AeBRDQET8BqA7vgWGn2Y0b2tGjqz
         u9BVMlEtHs+VvIT+HS1fHPY4agS/WQw+Je+zPJ7XKAjdlW+aTQjLAG/WIpEp4KobkY4V
         Cx0w==
X-Gm-Message-State: AOAM530K5e/e3IcrbMst7BjtQL9FEtRUj6ECSdjVUFN0ePlBjiNsyeRx
        Ve5CS4TzPOzi8uQekUZU3nLBzFUEM1NJqMiGJ6A=
X-Google-Smtp-Source: ABdhPJwsmW1zEelH5GRS1C+E3xvDp9JY6q7yKWyFAiKimoF0qGrsYKQ84uSTu7oWtrR95xweNlKokZFAlQfBrnxlTpM=
X-Received: by 2002:a05:600c:35cc:b0:394:7e9e:bd1f with SMTP id
 r12-20020a05600c35cc00b003947e9ebd1fmr779204wmq.95.1652892865360; Wed, 18 May
 2022 09:54:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220417181538.57fa1303@blackhole> <CA+E=qVeX2aU0hiDMxLXzVk-YiMsqKKFKpm=cc=72joMhZmNV1g@mail.gmail.com>
 <CA+E=qVdEtx8wVbcrMQYGB1ur1ykvNRp1L174mVSMkB0zeOPYNQ@mail.gmail.com> <20220428175759.13f75c21@blackhole.lan>
In-Reply-To: <20220428175759.13f75c21@blackhole.lan>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Wed, 18 May 2022 09:53:58 -0700
Message-ID: <CA+E=qVcNasK=q8o0g1teqK3+cD3aywy+1bgtTJC4VvaZvfZtGA@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: fix anx6345 power up sequence
To:     Torsten Duwe <duwe@lst.de>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thierry Reding <treding@nvidia.com>,
        Lyude Paul <lyude@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Geyer <harald@ccbib.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 8:58 AM Torsten Duwe <duwe@lst.de> wrote:
>
> On Mon, 18 Apr 2022 17:25:57 -0700
> Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>
> > On Sun, Apr 17, 2022 at 11:52 AM Vasily Khoruzhick
> > <anarsoul@gmail.com> wrote:
>
> > > The change looks good to me, but I'll need some time to actually
> > > test it. If you don't hear from me for longer than a week please
> > > ping me.
> >
> > Your change doesn't fix the issue for me. Running "xrandr --output
> > eDP-1 --off; xrandr --output eDP-1 --auto" in a loop triggers the
> > issue pretty quickly even with the patch.
>
> Nope, even that works fine here. Side question: how do you initially
> power on the eDP bridge? Could there be any leftovers from that
> mechanism? I use a hacked-up U-Boot with a procedure similar to the
> kernel driver as fixed by this change.
>
> But the main question is: does this patch in any way worsen the
> situation on the pinebook?

I don't think it worsens anything, but according to the datasheet the
change makes no sense. Could you try increasing T2 instead of changing
the power sequence?

>         Torsten
