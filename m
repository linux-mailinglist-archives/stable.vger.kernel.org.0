Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B810EA198F
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 14:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfH2MF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 08:05:56 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:65318 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2MF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 08:05:56 -0400
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x7TC5iwG013612;
        Thu, 29 Aug 2019 21:05:45 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x7TC5iwG013612
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1567080345;
        bh=D5ma9hHuV51Cm80nQhVdgIbo5oDeArkTtfTdAKQ5QQY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jqvg/34rpVZnw+w4eg1NrCRB2sZCHZOwbBnCBZ7crBipWvlQSJy8kIv2ZbyKjFAgp
         cW/74ivpRPTN085F8exvSN7GkyNEwkDOunwuiMZIUx54CIiOEMxgxRHpQhAgUagaXx
         Qt7rL8v8DLPg0Nk1Ocg2zQgFZsQXCcwjQssS2bjUpxEIFw89bf9d3NwCRxAPeNr2zn
         R7mrFcGFGmxHj47EJexWkZWq1wsCbw3iFIuyScLvKq111w89BQftSXfeBZIWWz6+uL
         bL47fxBdZ3aAO5ZLIJ4Xn5Q9OpuPRUDyVn8EOp7+ynnbsZB8Cq/aEcNHt24HW30++t
         kqZwoQcLNeDpA==
X-Nifty-SrcIP: [209.85.221.174]
Received: by mail-vk1-f174.google.com with SMTP id b144so722964vkf.4;
        Thu, 29 Aug 2019 05:05:45 -0700 (PDT)
X-Gm-Message-State: APjAAAXxdIvFH4/0EtG2ZxmqNdezxT56L2j1wt2Tb1+5lcFAVrkhQzEC
        tC+myeklUSTcgUr8A5TG+CzeDvzgy0+K5zqME30=
X-Google-Smtp-Source: APXvYqxzuSapFfYDGD/rytZneXNG/wxpyJgRofZTC8oZ80f0AhtRUF2GHJXXVbqSdRkVjZllJn0+Rm55UHNC6NbectE=
X-Received: by 2002:a1f:5d83:: with SMTP id r125mr989710vkb.64.1567080343899;
 Thu, 29 Aug 2019 05:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190829104928.27404-1-yamada.masahiro@socionext.com> <CAPDyKFooFQgBgK3N1Ob9rsT_7-5kqC9i7PeMxkkeAbnDP+Fwnw@mail.gmail.com>
In-Reply-To: <CAPDyKFooFQgBgK3N1Ob9rsT_7-5kqC9i7PeMxkkeAbnDP+Fwnw@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 29 Aug 2019 21:05:06 +0900
X-Gmail-Original-Message-ID: <CAK7LNASDfJQrMq4jjwDjrQF-4E9A_BZtgh+K-duTAo8zRVZA0g@mail.gmail.com>
Message-ID: <CAK7LNASDfJQrMq4jjwDjrQF-4E9A_BZtgh+K-duTAo8zRVZA0g@mail.gmail.com>
Subject: Re: [PATCH 1/3] mmc: sdhci-cadence: enable v4_mode to fix ADMA 64-bit addressing
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Piotr Sroka <piotrs@cadence.com>,
        "# 4.0+" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 8:48 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Thu, 29 Aug 2019 at 12:49, Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > The IP datasheet says this controller is compatible with SD Host
> > Specification Version v4.00.
> >
> > As it turned out, the ADMA of this IP does not work with 64-bit mode
> > when it is in the Version 3.00 compatible mode; it understands the
> > old 64-bit descriptor table (as defined in SDHCI v2), but the ADMA
> > System Address Register (SDHCI_ADMA_ADDRESS) cannot point to the
> > 64-bit address.
> >
> > I noticed this issue only after commit bd2e75633c80 ("dma-contiguous:
> > use fallback alloc_pages for single pages"). Prior to that commit,
> > dma_set_mask_and_coherent() returned the dma address that fits in
> > 32-bit range, at least for the default arm64 configuration
> > (arch/arm64/configs/defconfig). Now the host->adma_addr exceeds the
> > 32-bit limit, causing the real problem for the Socionext SoCs.
> > (As a side-note, I was also able to reproduce the issue for older
> > kernels by turning off CONFIG_DMA_CMA.)
> >
> > Call sdhci_enable_v4_mode() to fix this.
> >
> > I think it is better to back-port this, but only possible for v4.20+.
> >
> > When this driver was merged (v4.10), the v4 mode support did not exist.
> > It was added by commit b3f80b434f72 ("mmc: sdhci: Add sd host v4 mode")
> > i.e. v4.20.
> >
> > Cc: <stable@vger.kernel.org> # v4.20+
> > Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
>
> Applied for fixes, by adding below tag, thanks!
>
> Fixes: b3f80b434f72 ("mmc: sdhci: Add sd host v4 mode")

This is not a bug commit.





-- 
Best Regards
Masahiro Yamada
