Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74805630FF
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 12:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiGAKIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 06:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGAKIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 06:08:44 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438EC14D30;
        Fri,  1 Jul 2022 03:08:43 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id p136so3206726ybg.4;
        Fri, 01 Jul 2022 03:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6i9rjfH3G4VsINLZARCwk6I6fFER2N6iAYbqDz9ALlU=;
        b=cytPxckd4rDinhKxg/CCDo60hAhJynJCv5EPy5twlZYEiy+Kg1x3K6k46ZzCd7JTWQ
         OHhHdSiJi9dSnMeOmp4jqdLkFPav0weA2H+aXVJCjoFwY/RWPak6dGt6wpF5tt9KGLgc
         DyQaAoacTPzil528dHqkxrVlFDnKgdoWs4OmRO1RNJz+sIbd1EHZb7NBXxOVeR36WbNZ
         mMMlX03aDMxS9se6dyi3szg8sQB2sb4umsxpwVcdvRXmNL4sNvezbHhKZ8MH83IbMMgy
         4cxrCJAYoWgKG+mdaUspmpxxGT66ZQVJhab7a6c2Ll560fZIShGLcmoITfphzCaw3dNG
         /1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6i9rjfH3G4VsINLZARCwk6I6fFER2N6iAYbqDz9ALlU=;
        b=bby35xCHwZGvh1BM7dDfL5X9H7KScv+07NQU+Zz9NTRZlneN5D8LA8wY7QZhyXmM+k
         U76E5GHxAhf2etzRrSQPSrf/8+Z/HN6xhXbqM4VMyDh8ru3RW7QEYobi/oIY27BdzGX2
         xAISEDFjrEWh0C3pqcTFkPxHO7z3z+9gqL6BsrU3flnsut6uvNwXV+udMDjIjobfA3N/
         2f2TJScMuaKguSKsvpwkL3XUboFGh+cBNVkAb7NuntdYEVQ5A4Yo30OkPaMVS7bbXei3
         zVbdLcjx1lyx/8VgI+bhQXU1GA/vG4Gu6Y789tHB88Yv48NAIztnwZzqV717WytdhUG1
         g3bA==
X-Gm-Message-State: AJIora/MHsZUvdmC/lvGsdarD9q9mu9q1mfKQONkR7hQ3rvV91ApuxUB
        7o8xhR2nJAbfkI3sA30ShaJezUgJ1KV0P/nytlJH1EQbokm4Dg==
X-Google-Smtp-Source: AGRyM1tin3rcSGQHeGy6u1k9+zpSCrGM2TVhVW6q+f76DChNQmAL0Ovoh0IAEmrL8sY8qjkwcAJdRhiABTEETOYyXzw=
X-Received: by 2002:a25:dd83:0:b0:66c:8d8d:4f5f with SMTP id
 u125-20020a25dd83000000b0066c8d8d4f5fmr14224195ybg.79.1656670122397; Fri, 01
 Jul 2022 03:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220630230107.13438-1-nm@ti.com> <20220701033823.gkp5hfowv7f3eemx@tinsel>
In-Reply-To: <20220701033823.gkp5hfowv7f3eemx@tinsel>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 1 Jul 2022 12:08:05 +0200
Message-ID: <CAHp75VfAMtb1jZHdLsb=TtajGC6WFZ0z-5k31Vy=cG7ytjByTg@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: ti-adc128s052: Fix number of channels when
 device tree is used
To:     Nishanth Menon <nm@ti.com>
Cc:     Javier Martinez Canillas <javier@osg.samsung.com>,
        =?UTF-8?B?TnVubyBTw6E=?= <nuno.sa@analog.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
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

On Fri, Jul 1, 2022 at 5:41 AM Nishanth Menon <nm@ti.com> wrote:
> On 18:01-20220630, Nishanth Menon wrote:

...

> >  static const struct of_device_id adc128_of_match[] = {
> > -     { .compatible = "ti,adc128s052", },
> > -     { .compatible = "ti,adc122s021", },
> > -     { .compatible = "ti,adc122s051", },
> > -     { .compatible = "ti,adc122s101", },
> > -     { .compatible = "ti,adc124s021", },
> > -     { .compatible = "ti,adc124s051", },
> > -     { .compatible = "ti,adc124s101", },
> > +     { .compatible = "ti,adc128s052", .data = 0},
>
> I should probably cast these as .data = (void *)0 thoughts?

The 0 is default. You shouldn't use that in the first place for
something meaningful rather than "no, we have no driver data for this
chip).

-- 
With Best Regards,
Andy Shevchenko
