Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3A66C224E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCTUNk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Mar 2023 16:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjCTUNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:13:40 -0400
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DCE14230;
        Mon, 20 Mar 2023 13:13:39 -0700 (PDT)
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.95)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1peLsv-0008lQ-JN; Mon, 20 Mar 2023 21:13:37 +0100
Received: from p57bd9952.dip0.t-ipconnect.de ([87.189.153.82] helo=[192.168.178.81])
          by inpost2.zedat.fu-berlin.de (Exim 4.95)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1peLsv-0038P7-Bz; Mon, 20 Mar 2023 21:13:37 +0100
Message-ID: <c9a748cb2ee6145a3ffe85ca55a28b990f6be68c.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 6/7 v4] sh: fix Kconfig entry for NUMA => SMP
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Date:   Mon, 20 Mar 2023 21:13:36 +0100
In-Reply-To: <2186c0e97e6747e71ebceade317f88a7cc016772.camel@physik.fu-berlin.de>
References: <20230306040037.20350-1-rdunlap@infradead.org>
         <20230306040037.20350-7-rdunlap@infradead.org>
         <2186c0e97e6747e71ebceade317f88a7cc016772.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.153.82
X-ZEDAT-Hint: PO
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Randy!

On Sun, 2023-03-19 at 21:20 +0100, John Paul Adrian Glaubitz wrote:
> On Sun, 2023-03-05 at 20:00 -0800, Randy Dunlap wrote:
> > Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
> > SYS_SUPPORTS_SMP and SMP.
> > 
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
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> > Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> > Cc: Rich Felker <dalias@libc.org>
> > Cc: linux-sh@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > ---
> > v2: skipped
> > v3: skipped
> > v4: refresh & resend
> > 
> >  arch/sh/Kconfig |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff -- a/arch/sh/Kconfig b/arch/sh/Kconfig
> > --- a/arch/sh/Kconfig
> > +++ b/arch/sh/Kconfig
> > @@ -477,6 +477,8 @@ config CPU_SUBTYPE_SH7722
> >  	select CPU_SHX2
> >  	select ARCH_SHMOBILE
> >  	select ARCH_SPARSEMEM_ENABLE
> > +	select SYS_SUPPORTS_SMP
> > +	select SMP
> >  	select SYS_SUPPORTS_NUMA
> >  	select SYS_SUPPORTS_SH_CMT
> >  	select PINCTRL
> > @@ -487,6 +489,8 @@ config CPU_SUBTYPE_SH7366
> >  	select CPU_SHX2
> >  	select ARCH_SHMOBILE
> >  	select ARCH_SPARSEMEM_ENABLE
> > +	select SYS_SUPPORTS_SMP
> > +	select SMP
> >  	select SYS_SUPPORTS_NUMA
> >  	select SYS_SUPPORTS_SH_CMT
> >  
> 
> It seems that we need this change for these configurations as well:
> 
> - config CPU_SHX3
> - config CPU_SUBTYPE_SH7785
> 
> Although I can trigger a build failure for CPU_SUBTYPE_SH7785 only when
> setting CONFIG_NUMA=y:
> 
>   CC      net/ipv6/addrconf_core.o
> mm/slab.c: In function 'slab_memory_callback':
> mm/slab.c:1127:23: error: implicit declaration of function 'init_cache_node_node'; did you mean 'drain_cache_node_node'? [-Werror=implicit-function-declaration]
>  1127 |                 ret = init_cache_node_node(nid);
>       |                       ^~~~~~~~~~~~~~~~~~~~
>       |                       drain_cache_node_node
> 
> I would expect this error to be reproducible for CPU_SHX3 as well when
> CONFIG_NUMA=y but CONFIG_SMP=n. But for some reason, I am not seeing
> the error then.

Can you make this change for config CPU_SUBTYPE_SH7785 as well?

Then the change should be fine.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
