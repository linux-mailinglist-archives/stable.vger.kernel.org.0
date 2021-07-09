Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679FD3C253F
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhGINwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:52:23 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:55027 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231454AbhGINwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 09:52:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UfDrXrP_1625838575;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0UfDrXrP_1625838575)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 09 Jul 2021 21:49:36 +0800
Date:   Fri, 9 Jul 2021 21:49:35 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, Nick Terrell <terrelln@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [linux-stable-rc:linux-5.4.y 7045/7049] mipsel-linux-ld:
 decompress.c:undefined reference to `memmove'
Message-ID: <YOhT78jt3rkCmudH@B-P7TQMD6M-0146.local>
References: <202107070120.6dOj1kB7-lkp@intel.com>
 <YOfjmCT6n61Yidvp@B-P7TQMD6M-0146.local>
 <YOf4yZIld6L6XP13@B-P7TQMD6M-0146.local>
 <YOglcE85xuwfD7It@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YOglcE85xuwfD7It@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 12:31:12PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 09, 2021 at 03:20:41PM +0800, Gao Xiang wrote:
> > Hi Greg, stable all,
> > 
> > On Fri, Jul 09, 2021 at 01:50:16PM +0800, Gao Xiang wrote:
> > > On Wed, Jul 07, 2021 at 01:15:28AM +0800, kernel test robot wrote:
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > head:   3909e2374335335c9504467caabc906d3f7487e4
> > > > commit: defcc2b5e54a4724fb5733f802edf5dd596018b6 [7045/7049] lib/lz4: explicitly support in-place decompression
> > > > config: mips-randconfig-r036-20210706 (attached as .config)
> > > > compiler: mipsel-linux-gcc (GCC) 9.3.0
> > > > reproduce (this is a W=1 build):
> > > >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> > > >         chmod +x ~/bin/make.cross
> > > >         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?id=defcc2b5e54a4724fb5733f802edf5dd596018b6
> > > >         git remote add linux-stable-rc https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > >         git fetch --no-tags linux-stable-rc linux-5.4.y
> > > >         git checkout defcc2b5e54a4724fb5733f802edf5dd596018b6
> > > >         # save the attached .config to linux build tree
> > > >         mkdir build_dir
> > > >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross O=build_dir ARCH=mips SHELL=/bin/bash
> > > > 
> > > > If you fix the issue, kindly add following tag as appropriate
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > 
> > > Which is weird, does the preboot environment miss memmove() on mipsel?
> > > Just a guess, I may look into that myself later...
> > > 
> > 
> > After manually checking, I found memmove() for the mips preboot environment
> > was incidentally introduced by commit a510b616131f ("MIPS: Add support for
> > ZSTD-compressed kernels") which wasn't included in v5.4, but included in
> > v5.10 as below (so v5.10.y is fine):
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/mips/boot/compressed?h=v5.10&id=a510b616131f85215ba156ed67e5ed1c0701f80f
> > 
> > And when I applied the following patch partially from the original
> > commit, the compile error with the command lines mentioned above was gone:
> > 
> > diff --git a/arch/mips/boot/compressed/string.c b/arch/mips/boot/compressed/string.c
> > index 43beecc3587c..e9ab7ea592ba 100644
> > --- a/arch/mips/boot/compressed/string.c
> > +++ b/arch/mips/boot/compressed/string.c
> > @@ -27,3 +27,19 @@ void *memset(void *s, int c, size_t n)
> >  		ss[i] = c;
> >  	return s;
> >  }
> > +
> > +void * __weak memmove(void *dest, const void *src, size_t n)
> > +{
> > +	unsigned int i;
> > +	const char *s = src;
> > +	char *d = dest;
> > +
> > +	if ((uintptr_t)dest < (uintptr_t)src) {
> > +		for (i = 0; i < n; i++)
> > +			d[i] = s[i];
> > +	} else {
> > +		for (i = n; i > 0; i--)
> > +			d[i - 1] = s[i - 1];
> > +	}
> > +	return dest;
> > +}
> > 
> > How to backport such commit partially to the v5.4.y stable kernel?
> 
> Please submit it in a format which we can apply it.

I've sent out a patch (although not sure if the exact format like this):
https://lore.kernel.org/r/20210709132408.174206-1-hsiangkao@linux.alibaba.com/

> 
> > ... Also, it would be better to check other mips compile combinations
> > automatically since it's hard for me to check all such combinations
> > one-by-one...
> 
> That's what kernelci is for, can you use that?

I'm not sure how to use kernelci myself, maybe I missed something...

Thanks,
Gao Xiang

> 
> thanks,
> 
> greg k-h
