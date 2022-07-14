Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556805746B9
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 10:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiGNI3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 04:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiGNI3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 04:29:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723471276C;
        Thu, 14 Jul 2022 01:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19F13B82333;
        Thu, 14 Jul 2022 08:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A93C34114;
        Thu, 14 Jul 2022 08:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657787337;
        bh=QgGlUGH09m1ow96tpVo/G0/pJ6m+yCM3+utyiDzLGfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FPbOsX15+v1QIDpDgYGb+3Id7i8q0/LE5fv8jpKTyv2i7Z5WdcWEhWtgJDPLqA6K6
         8p4+RlYVUxgPs+lbbCaRqtTcFhSr0fUgEYhQyqQU7X8KAHvo5aG6XU4uiAPNxvGGnY
         yFuCuwoIBp1dNHEdcgo1lPhbnszrbJaWk0TE8etg=
Date:   Thu, 14 Jul 2022 10:28:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     kernel test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable@vger.kernel.org
Subject: Re: [linux-stable-rc:linux-5.10.y 7082/7120]
 arch/x86/kernel/head_64.o: warning: objtool: xen_hypercall_mmu_update():
 can't find starting instruction
Message-ID: <Ys/TxoePQHvaYWcs@kroah.com>
References: <202207130531.SkRjrrn8-lkp@intel.com>
 <Ys9MKAriCchlEO8S@decadent.org.uk>
 <Ys+8ZYxkDmSCcDWv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys+8ZYxkDmSCcDWv@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 08:49:09AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Jul 14, 2022 at 12:50:16AM +0200, Ben Hutchings wrote:
> > On Wed, Jul 13, 2022 at 05:38:47AM +0800, kernel test robot wrote:
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > head:   53b881e19526bcc3e51d9668cab955c80dcf584c
> > > commit: 7575d3f3bbd1c68d6833b45d1b98ed182832bd44 [7082/7120] x86: Use return-thunk in asm code
> > > config: x86_64-rhel-8.3-syz (https://download.01.org/0day-ci/archive/20220713/202207130531.SkRjrrn8-lkp@intel.com/config)
> > > compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> > > reproduce (this is a W=1 build):
> > >         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=7575d3f3bbd1c68d6833b45d1b98ed182832bd44
> > >         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > >         git fetch --no-tags linux-stable-rc linux-5.10.y
> > >         git checkout 7575d3f3bbd1c68d6833b45d1b98ed182832bd44
> > >         # save the config file
> > >         mkdir build_dir && cp config build_dir/.config
> > >         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/
> > > 
> > > If you fix the issue, kindly add following tag where applicable
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > 
> > > All warnings (new ones prefixed by >>):
> > > 
> > > >> arch/x86/kernel/head_64.o: warning: objtool: xen_hypercall_mmu_update(): can't find starting instruction
> > > 
> > > -- 
> > > 0-DAY CI Kernel Test Service
> > > https://01.org/lkp
> > 
> > Please add the following patch to fix this.  This would also be
> > needed for 5.15-stable.
> > 
> > Ben.
> > 
> > From: Ben Hutchings <ben@decadent.org.uk>
> > Date: Thu, 14 Jul 2022 00:39:33 +0200
> > Subject: [PATCH] x86/xen: Fix initialisation in hypercall_page after rethunk
> > 
> > The hypercall_page is special and the RETs there should not be changed
> > into rethunk calls (but can have SLS mitigation).  Change the initial
> > instructions to ret + int3 padding, as was done in upstream commit
> > 5b2fc51576ef "x86/ibt,xen: Sprinkle the ENDBR".
> > 
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  arch/x86/xen/xen-head.S | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> > index 38b73e7e54ba..2a3ef5fcba34 100644
> > --- a/arch/x86/xen/xen-head.S
> > +++ b/arch/x86/xen/xen-head.S
> > @@ -69,9 +69,9 @@ SYM_CODE_END(asm_cpu_bringup_and_idle)
> >  SYM_CODE_START(hypercall_page)
> >  	.rept (PAGE_SIZE / 32)
> >  		UNWIND_HINT_FUNC
> > -		.skip 31, 0x90
> >  		ANNOTATE_UNRET_SAFE
> > -		RET
> > +		ret
> > +		.skip 31, 0xcc
> >  	.endr
> >  
> >  #define HYPERCALL(n) \
> > 
> > 
> 
> That's really odd, I swear I tried this myself:
> 	https://lore.kernel.org/r/Ys2jlGMqAe6+h1SX@kroah.com
> 
> I'll go queue this up and see if that solves the issue on my side.  But
> see Boris's comment about how this shouldn't be an issue in the end.

Ah, yes, it does fix that warning, but causes this new one:
	arch/x86/kernel/head_64.o: warning: objtool: .text+0x5: unreachable instruction

I'll keep your patch here, as it makes sense, but it does just exchange
one warning for another one...

thanks,

greg k-h
