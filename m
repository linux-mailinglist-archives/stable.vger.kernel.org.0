Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF9B57450A
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 08:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiGNG1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 02:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGNG1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 02:27:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEC6CE03;
        Wed, 13 Jul 2022 23:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A924B8236E;
        Thu, 14 Jul 2022 06:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C77BC34115;
        Thu, 14 Jul 2022 06:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657780062;
        bh=xabvHW7Yl6E9/kXioSdSRfN7xOeaPfq01JHLUVr5mjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jOdvNOrcXuR1OceEyDp7VbkU0GvaXx98iK+S+tAh/w/TfdVglWbIUwu5x8v0jGIKn
         /VsWucoDpo6fXCiOIt0ef8HuA1raH9gXj6ujebYyGdumsylpCvNIJpbb7QbPqzeLDO
         K/h368OTqgyFByCZR6ujIEXl1BHrqoa4mZsIRBAE=
Date:   Thu, 14 Jul 2022 08:27:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ben Hutchings <bwh@kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [linux-stable-rc:linux-5.10.y 7114/7120] arch/x86/kernel/kvm.o:
 warning: objtool: __raw_callee_save___kvm_vcpu_is_preempted()+0x12: 'naked'
 return found in RETHUNK build
Message-ID: <Ys+3WixImdEkyzm8@kroah.com>
References: <202207130605.fX0cfbtW-lkp@intel.com>
 <d76cd438d325e874ededc4f58818f7edae6edd68.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d76cd438d325e874ededc4f58818f7edae6edd68.camel@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 12:31:03AM +0200, Ben Hutchings wrote:
> On Wed, 2022-07-13 at 06:39 +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > head:   53b881e19526bcc3e51d9668cab955c80dcf584c
> > commit: 892f1f2b8631df5bdd0baba6e1ee3fa6eff396d0 [7114/7120] x86/retbleed: Add fine grained Kconfig knobs
> > config: x86_64-rhel-8.3-syz (https://download.01.org/0day-ci/archive/20220713/202207130605.fX0cfbtW-lkp@intel.com/config)
> > compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> > reproduce (this is a W=1 build):
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=892f1f2b8631df5bdd0baba6e1ee3fa6eff396d0
> >         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >         git fetch --no-tags linux-stable-rc linux-5.10.y
> >         git checkout 892f1f2b8631df5bdd0baba6e1ee3fa6eff396d0
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/
> > 
> > If you fix the issue, kindly add following tag where applicable
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > > > arch/x86/kernel/kvm.o: warning: objtool: __raw_callee_save___kvm_vcpu_is_preempted()+0x12: 'naked' return found in RETHUNK build
> > 
> 
> 5.10-stable will need this fix that was already included in 5.15-
> stable:
> 
> commit edbaf6e5e93acda96aae23ba134ef3c1466da3b5
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Thu Jun 30 12:19:47 2022 +0200
>  
>     x86, kvm: use proper ASM macros for kvm_vcpu_is_preempted
> 

Ah, thanks, I forgot I had fixed that already!  Now queued up.

greg k-h
