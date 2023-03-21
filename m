Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5063C6C2C06
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 09:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCUILt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Mar 2023 04:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjCUILc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 04:11:32 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451A328E67;
        Tue, 21 Mar 2023 01:11:06 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1peX4c-002AdC-6o; Tue, 21 Mar 2023 09:10:26 +0100
Received: from p57bd9952.dip0.t-ipconnect.de ([87.189.153.82] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1peX4b-0013m5-VS; Tue, 21 Mar 2023 09:10:26 +0100
Message-ID: <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        linux-sh@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 21 Mar 2023 09:10:25 +0100
In-Reply-To: <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
References: <20230320231310.28841-1-rdunlap@infradead.org>
         <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.153.82
X-ZEDAT-Hint: PO
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Geert!

On Tue, 2023-03-21 at 08:55 +0100, Geert Uytterhoeven wrote:
> On Tue, Mar 21, 2023 at 12:13 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> > Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
> > SYS_SUPPORTS_SMP and SMP.
> 
> Perhaps because these SoCs do not support SMP?

Well, there is actually a dual-core 7786 board available, see:

> https://www.apnet.co.jp/product/superh/ap-sh4ad-0a.html

Quoting:

»The SH7786 is equipped with a dual-core SH-4A and has interfaces such as
 DDR3 SDRAM, PCI Express, USB, and display unit.«

I seem to remember that Oleg Endo had such a dual-core SH4A board.

Also, the Sega Saturn had two SH-2 CPUs:

> https://en.wikipedia.org/wiki/Sega_Saturn#Technical_specifications

> > kernel/sched/topology.c is only built for CONFIG_SMP and then the NUMA
> > code + data inside topology.c is only built when CONFIG_NUMA is
> > set/enabled, so these arch/sh/ configs need to select SMP and
> > SYS_SUPPORTS_SMP to build the NUMA support.
> > 
> > Fixes this build error in multiple SUPERH configs:
> > 
> > mm/page_alloc.o: In function `get_page_from_freelist':
> > page_alloc.c:(.text+0x2ca8): undefined reference to `node_reclaim_distance'
> > 
> > Fixes: 357d59469c11 ("sh: Tidy up dependencies for SH-2 build.")
> > Fixes: 9109a30e5a54 ("sh: add support for sh7366 processor")
> > Fixes: 55ba99eb211a ("sh: Add support for SH7786 CPU subtype.")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> 
> > --- a/arch/sh/Kconfig
> > +++ b/arch/sh/Kconfig
> > @@ -442,6 +442,8 @@ config CPU_SUBTYPE_SH7785
> >         select CPU_SHX2
> >         select ARCH_SPARSEMEM_ENABLE
> >         select SYS_SUPPORTS_NUMA
> > +       select SYS_SUPPORTS_SMP
> > +       select SMP
> 
> SH7785 is single-core.
> 
> >         select PINCTRL
> > 
> >  config CPU_SUBTYPE_SH7786
> > @@ -476,6 +478,8 @@ config CPU_SUBTYPE_SH7722
> >         select CPU_SHX2
> >         select ARCH_SHMOBILE
> >         select ARCH_SPARSEMEM_ENABLE
> > +       select SYS_SUPPORTS_SMP
> > +       select SMP
> 
> SH7722 is single-core.
> 
> >         select SYS_SUPPORTS_NUMA
> >         select SYS_SUPPORTS_SH_CMT
> >         select PINCTRL
> > @@ -486,6 +490,8 @@ config CPU_SUBTYPE_SH7366
> >         select CPU_SHX2
> >         select ARCH_SHMOBILE
> >         select ARCH_SPARSEMEM_ENABLE
> > +       select SYS_SUPPORTS_SMP
> > +       select SMP
> 
> Dunno about this one (no public info available).
> 
> >         select SYS_SUPPORTS_NUMA
> >         select SYS_SUPPORTS_SH_CMT
> 
> Wasn't this fixed by commit 61bb6cd2f765b90c ("mm: move
> node_reclaim_distance to fix NUMA without SMP") in v5.16?
> 
> It is not sufficient, after that you run into:
> 
>     mm/slab.c: In function ‘slab_memory_callback’:
>     mm/slab.c:1127:23: error: implicit declaration of function
> ‘init_cache_node_node’; did you mean ‘drain_cache_node_node’?
> [-Werror=implicit-function-declaration]
>      1127 |                 ret = init_cache_node_node(nid);
> 
> which you reported before in
> https://lore.kernel.org/all/b5bdea22-ed2f-3187-6efe-0c72330270a4@infradead.org/

Without the patch, I am getting:

  CC      fs/fat/nfs.o
mm/slab.c: In function 'slab_memory_callback':
mm/slab.c:1127:23: error: implicit declaration of function 'init_cache_node_node'; did you mean 'drain_cache_node_node'? [-Werror=implicit-function-declaration]
 1127 |                 ret = init_cache_node_node(nid);
      |                       ^~~~~~~~~~~~~~~~~~~~
      |                       drain_cache_node_node

with make sh7785lcr_defconfig and CONFIG_NUMA=y.

With the patch, it builds fine for me.

FWIW, I just realized we need this for config CPU_SUBTYPE_SH7786 as well.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
