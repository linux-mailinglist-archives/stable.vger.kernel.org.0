Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EDF5606D3
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 18:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiF2Q7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 12:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiF2Q7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 12:59:40 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A721107
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 09:59:39 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id t25so29102708lfg.7
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 09:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=534o96K+HtJxuaFavGV3IgmBObFgbJ+GOTeCO07YsEs=;
        b=ktQ2IPhMiOrRUfEfnOZFDO2UHiqD5R9off5vo2NolrYg0wVVahY4fUkgFzgjYHE1nU
         9OU0kHyuEFneCut9p/1MC4eZjZpdFHk86Kyh5M19BB4VdUwn8LhwNGOe0IygkjlSjp+o
         UXfgvOHBDmo1HxChZjcABi/oGm8aMQreiW21Yvj0V4Oeby3hpvXiqZX8skzW6hGKLb+D
         wD/HROhCVqP3dF5N7bX6OACJKM6Syhh7Cq2Hak7kGnabBgbXZGpg0joVnmWWAtHDZH7S
         Jf9MeqjfjH6Kiq4j6Kak9SZWF0BSOqw3vz3Ooh53b8XOug/MLFJFo0p1Hu6TSWcm1Fhz
         IBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=534o96K+HtJxuaFavGV3IgmBObFgbJ+GOTeCO07YsEs=;
        b=U4DOptw0Xn1AxFLpkQG1jyrz7BW5PvnYT168H7l7PGjp4Dlo1KtgJpODOcqh7/pF8L
         YDwfndFfo/xP0AeQkrq7pxwVw1/LzVwTbbnrFhXgenJNP6HyhlMZi+jd39IT1Syz56N7
         Uc8qGv+KRTI3hSUfCYsf/ug8pvF1+cqOzhlHiuC7Cdlxwdu+SYWGueohGaH1uS6NLJcv
         dAZeRA9xeu5CEOruVE7erSiTbtT9XVD5d+EGo08ICLn4+sV0keg3LjVqoEXD4trR2qcP
         CKlF30VH41iKp+2JLAio9e9k47IWx9LlfN+iDYgNiZlzRqWZEZp0BpzRysnFHFPxDHjM
         LZVw==
X-Gm-Message-State: AJIora+EVxzBhKvNkkxn1qnxht6H0cqhEhdH9pC2M4hseAxiIoUNkaH2
        Xr8vlFt5Mp9LXuIGACiwrhH96xwLmCFl/15pS2jy7w==
X-Google-Smtp-Source: AGRyM1tEwXYmLhImHx4/hcXAfpxfegIwVjIMDc2lDGMK5VwpNQjWFlGcJaVWV3chEbEeKSZvcET9jArZasXRPasprsw=
X-Received: by 2002:ac2:4d22:0:b0:47f:65b5:35ec with SMTP id
 h2-20020ac24d22000000b0047f65b535ecmr2861553lfk.432.1656521977609; Wed, 29
 Jun 2022 09:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220627111927.641837068@linuxfoundation.org> <20220627111929.368555413@linuxfoundation.org>
 <6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com> <CAKwvOdm8UiY8CsqNgyoq4MdC2TbBj-1+cRE+fWZ9+vVBxNZz_Q@mail.gmail.com>
 <20220629053854.GA16297@lst.de>
In-Reply-To: <20220629053854.GA16297@lst.de>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 29 Jun 2022 09:59:25 -0700
Message-ID: <CAKwvOd=S05LN=bDXcWpkpz1NG+C=M4Hd0HW0xcP_hrSsf8Mb9Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 57/60] modpost: fix section mismatch check for
 exported init/exit sections
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, Christoph Hellwig <hch@lst.de>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Jun 28, 2022 at 12:11:50PM -0700, Nick Desaulniers wrote:
> > Maybe let's check with Christoph if it's ok to backport bf22c9ec39da
> > to stable 5.10 and 5.4?
>
> I'd be fine with that, but in the end it is something for the relevant
> maintainers to decide.

$ ./scripts/get_maintainer.pl -f drivers/gpu/drm/drm_crtc_helper_internal.h
Maarten Lankhorst <maarten.lankhorst@linux.intel.com> (maintainer:DRM
DRIVERS AND MISC GPU PATCHES)
Maxime Ripard <mripard@kernel.org> (maintainer:DRM DRIVERS AND MISC GPU PATCHES)
Thomas Zimmermann <tzimmermann@suse.de> (maintainer:DRM DRIVERS AND
MISC GPU PATCHES)
David Airlie <airlied@linux.ie> (maintainer:DRM DRIVERS)
Daniel Vetter <daniel@ffwll.ch> (maintainer:DRM DRIVERS)
dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
linux-kernel@vger.kernel.org (open list)

Maarten, Maxime, Thomas, David, or Daniel,
Is it ok to backport
commit bf22c9ec39da ("drm: remove drm_fb_helper_modinit")
to 5.10.y and 5.4.y to fix the modpost warning reported by Florian in
https://lore.kernel.org/stable/6cd16364-f0cd-b3f3-248f-4b6d585d05ef@gmail.com/ ?
-- 
Thanks,
~Nick Desaulniers
