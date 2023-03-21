Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4396C2CC6
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjCUIne convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Mar 2023 04:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjCUInd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:43:33 -0400
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1086C4391C;
        Tue, 21 Mar 2023 01:42:59 -0700 (PDT)
Received: by mail-qt1-f179.google.com with SMTP id t9so16957711qtx.8;
        Tue, 21 Mar 2023 01:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679388169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iK/sUmy+uYhum5gWxh+OskUEG9MJUSbdKMs8GiRoDEA=;
        b=2mr/Yl9a7W5ge6l7VYQ+2YTc3f6II/EJPIm02IvHR0zA4I1EBAOpty2cb9vCqjdjIa
         z9RqgrJuA8cd8ty8hYKkK0lY0OMDyUHGMUMB6qTu19gjSLWomp+9kIXFjGZG6rR5B0zF
         Iwh8tOEunPZ3/lVe+MV1kjvX7DXaW5Z1y5+71y5Vd0ldSNiyq3ez3axVpp2IuiGRbr8L
         FdEXOQ8Uy1bjLQ8lR7AiT4mKKlVThh4YBQrWnhKe2vEgrIDBnBU6p9xN5kKQMghf6Oqg
         d7wPFJZ+CS0BW2QYQS6eUwq2g/E10aFw0trdRgMovq81kBdA6rNLMur6+e+hsFC0bBjg
         U+eQ==
X-Gm-Message-State: AO0yUKUioH7FNo7oKnuhK2MxhmqVfnv3Qu/LkY1U/JoIxKtnLqG1fl9k
        pPmu2S2xY5D5OmN+PGaHa8Cyhs1XrA6fiw==
X-Google-Smtp-Source: AK7set8zcFcPFYMXR1676wnY/uqv2LKnwfFwC19F1xiLF0fxOYp8iBz2ktCItNtcrB75rMmsnx/SRA==
X-Received: by 2002:a05:622a:15cb:b0:3e3:7d35:7899 with SMTP id d11-20020a05622a15cb00b003e37d357899mr3078700qty.43.1679388169352;
        Tue, 21 Mar 2023 01:42:49 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id e14-20020a05620a014e00b0073b45004754sm8974446qkn.34.2023.03.21.01.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:42:49 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id e71so16181898ybc.0;
        Tue, 21 Mar 2023 01:42:48 -0700 (PDT)
X-Received: by 2002:a05:6902:1023:b0:b6b:841a:aae4 with SMTP id
 x3-20020a056902102300b00b6b841aaae4mr689181ybt.12.1679388168489; Tue, 21 Mar
 2023 01:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230320231310.28841-1-rdunlap@infradead.org> <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
 <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
In-Reply-To: <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Mar 2023 09:42:37 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW-oxpoHubUJUpsjG9aXtQ3MMwAopN-hS+Mf0gN1udhig@mail.gmail.com>
Message-ID: <CAMuHMdW-oxpoHubUJUpsjG9aXtQ3MMwAopN-hS+Mf0gN1udhig@mail.gmail.com>
Subject: Re: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Adrian,

On Tue, Mar 21, 2023 at 9:10 AM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On Tue, 2023-03-21 at 08:55 +0100, Geert Uytterhoeven wrote:
> > On Tue, Mar 21, 2023 at 12:13 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> > > Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
> > > SYS_SUPPORTS_SMP and SMP.
> >
> > Perhaps because these SoCs do not support SMP?
>
> Well, there is actually a dual-core 7786 board available, see:
>
> > https://www.apnet.co.jp/product/superh/ap-sh4ad-0a.html
>
> Quoting:
>
> »The SH7786 is equipped with a dual-core SH-4A and has interfaces such as
>  DDR3 SDRAM, PCI Express, USB, and display unit.«

SH7786 is dual-core...

> FWIW, I just realized we need this for config CPU_SUBTYPE_SH7786 as well.

... and CPU_SUBTYPE_SH7786 selects CPU_SHX3, which selects
SYS_SUPPORTS_SMP and SYS_SUPPORTS_NUMA in turn.
So everything is fine for SH7786.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
