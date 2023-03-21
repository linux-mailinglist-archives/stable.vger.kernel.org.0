Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F236C2C7C
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjCUIdd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Mar 2023 04:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCUIdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:33:10 -0400
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7198F457CF;
        Tue, 21 Mar 2023 01:32:27 -0700 (PDT)
Received: by mail-qt1-f179.google.com with SMTP id c10so5751469qtj.10;
        Tue, 21 Mar 2023 01:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679387538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOyQaxzH+yK0JqZ+kzTan/7mbXxIrnhCUyAiLxW4zWU=;
        b=kvkbpWuRz/61VC7EBdlDqgfjj36rEcmkPQjK9ufY13vjdfDZSGIprl+dVc/+Imm2Yg
         uc2VPMZglowBwoTJA6dZ624vyXnlCmaPVe1A5HXYlc/ged+2ZG2FntVKi/2DUsUXB+++
         /bUcgNEU3m0RW9w9HFn6s/IN75+VNJzoUesPsGnri3PCou6QyXyekxXe2gC4vvIv8zBI
         0q5WILhVfoJi7rm05vyRW5MBZHwq0U9EZowBTNweGqoqfQot3+7DjDD6NNGQCe21L0Us
         fXjh1zBEYQmyw4tpRBlo2vUAa7W60Jzqxzt64u0EX6Ftq5rymGWjgdvrRfgiFH12dw+t
         tblQ==
X-Gm-Message-State: AO0yUKXJ6+lfxr1+BXRzTGD6v48iDLRYfft6KPw0ZEqZxmlFzqf/ShGg
        /uTy09DYsPg0yEDR+DUGHRIjS38KMo3Sug==
X-Google-Smtp-Source: AK7set/aNLj4RMmiat/cUTgebHrJkFXIPxIvxDsXdbYaU1lFVS7DNGh72OJSpS5n/gD4CCeMvgioOQ==
X-Received: by 2002:a05:622a:1108:b0:3bf:a5fb:6d6e with SMTP id e8-20020a05622a110800b003bfa5fb6d6emr3542100qty.29.1679387537726;
        Tue, 21 Mar 2023 01:32:17 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id b23-20020ae9eb17000000b0074236d3a149sm9013134qkg.92.2023.03.21.01.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:32:17 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id x198so6396753ybe.9;
        Tue, 21 Mar 2023 01:32:17 -0700 (PDT)
X-Received: by 2002:a25:9e8d:0:b0:a09:314f:a3ef with SMTP id
 p13-20020a259e8d000000b00a09314fa3efmr880305ybq.12.1679387536974; Tue, 21 Mar
 2023 01:32:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230320231310.28841-1-rdunlap@infradead.org> <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
 <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de> <CAMuHMdWyoQ--kc4-JDvcmNeWGZvT+w9UYSW5c7KeGB-bTQjLXg@mail.gmail.com>
In-Reply-To: <CAMuHMdWyoQ--kc4-JDvcmNeWGZvT+w9UYSW5c7KeGB-bTQjLXg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Mar 2023 09:32:05 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXEp2jpmXr7CTai7DU0Gqnadk_D8zPwQmoo+W-12RjfVQ@mail.gmail.com>
Message-ID: <CAMuHMdXEp2jpmXr7CTai7DU0Gqnadk_D8zPwQmoo+W-12RjfVQ@mail.gmail.com>
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

On Tue, Mar 21, 2023 at 9:19 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Mar 21, 2023 at 9:10 AM John Paul Adrian Glaubitz
> <glaubitz@physik.fu-berlin.de> wrote:
> > On Tue, 2023-03-21 at 08:55 +0100, Geert Uytterhoeven wrote:
> > > On Tue, Mar 21, 2023 at 12:13 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> > > > Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
> > > > SYS_SUPPORTS_SMP and SMP.
> > >
> > > Perhaps because these SoCs do not support SMP?
> >
> > Well, there is actually a dual-core 7786 board available, see:
> >
> > > https://www.apnet.co.jp/product/superh/ap-sh4ad-0a.html
> >
> > Quoting:
> >
> > »The SH7786 is equipped with a dual-core SH-4A and has interfaces such as
> >  DDR3 SDRAM, PCI Express, USB, and display unit.«
> >
> > I seem to remember that Oleg Endo had such a dual-core SH4A board.
> >
> > Also, the Sega Saturn had two SH-2 CPUs:
> >
> > > https://en.wikipedia.org/wiki/Sega_Saturn#Technical_specifications
>
> But these are not the Kconfig entries changed by Randy's patch.
>
> > > > kernel/sched/topology.c is only built for CONFIG_SMP and then the NUMA
> > > > code + data inside topology.c is only built when CONFIG_NUMA is
> > > > set/enabled, so these arch/sh/ configs need to select SMP and
> > > > SYS_SUPPORTS_SMP to build the NUMA support.
> > > >
> > > > Fixes this build error in multiple SUPERH configs:
> > > >
> > > > mm/page_alloc.o: In function `get_page_from_freelist':
> > > > page_alloc.c:(.text+0x2ca8): undefined reference to `node_reclaim_distance'
> > > >
> > > > Fixes: 357d59469c11 ("sh: Tidy up dependencies for SH-2 build.")
> > > > Fixes: 9109a30e5a54 ("sh: add support for sh7366 processor")
> > > > Fixes: 55ba99eb211a ("sh: Add support for SH7786 CPU subtype.")
> > > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > >
> > > > --- a/arch/sh/Kconfig
> > > > +++ b/arch/sh/Kconfig
> > > > @@ -442,6 +442,8 @@ config CPU_SUBTYPE_SH7785
> > > >         select CPU_SHX2
> > > >         select ARCH_SPARSEMEM_ENABLE
> > > >         select SYS_SUPPORTS_NUMA
> > > > +       select SYS_SUPPORTS_SMP
> > > > +       select SMP
> > >
> > > SH7785 is single-core.
> > >
> > > >         select PINCTRL
> > > >
> > > >  config CPU_SUBTYPE_SH7786
> > > > @@ -476,6 +478,8 @@ config CPU_SUBTYPE_SH7722
> > > >         select CPU_SHX2
> > > >         select ARCH_SHMOBILE
> > > >         select ARCH_SPARSEMEM_ENABLE
> > > > +       select SYS_SUPPORTS_SMP
> > > > +       select SMP
> > >
> > > SH7722 is single-core.
> > >
> > > >         select SYS_SUPPORTS_NUMA
> > > >         select SYS_SUPPORTS_SH_CMT
> > > >         select PINCTRL
> > > > @@ -486,6 +490,8 @@ config CPU_SUBTYPE_SH7366
> > > >         select CPU_SHX2
> > > >         select ARCH_SHMOBILE
> > > >         select ARCH_SPARSEMEM_ENABLE
> > > > +       select SYS_SUPPORTS_SMP
> > > > +       select SMP
> > >
> > > Dunno about this one (no public info available).
> > >
> > > >         select SYS_SUPPORTS_NUMA
> > > >         select SYS_SUPPORTS_SH_CMT
> > >
> > > Wasn't this fixed by commit 61bb6cd2f765b90c ("mm: move
> > > node_reclaim_distance to fix NUMA without SMP") in v5.16?
> > >
> > > It is not sufficient, after that you run into:
> > >
> > >     mm/slab.c: In function ‘slab_memory_callback’:
> > >     mm/slab.c:1127:23: error: implicit declaration of function
> > > ‘init_cache_node_node’; did you mean ‘drain_cache_node_node’?
> > > [-Werror=implicit-function-declaration]
> > >      1127 |                 ret = init_cache_node_node(nid);
> > >
> > > which you reported before in
> > > https://lore.kernel.org/all/b5bdea22-ed2f-3187-6efe-0c72330270a4@infradead.org/
> >
> > Without the patch, I am getting:
> >
> >   CC      fs/fat/nfs.o
> > mm/slab.c: In function 'slab_memory_callback':
> > mm/slab.c:1127:23: error: implicit declaration of function 'init_cache_node_node'; did you mean 'drain_cache_node_node'? [-Werror=implicit-function-declaration]
> >  1127 |                 ret = init_cache_node_node(nid);
> >       |                       ^~~~~~~~~~~~~~~~~~~~
> >       |                       drain_cache_node_node
>
> Which is a different error than in this patch description?
> I am preparing a fix...

https://lore.kernel.org/67261c513706241d479b8b4cf46eb4e6fb0417ba.1679387262.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
