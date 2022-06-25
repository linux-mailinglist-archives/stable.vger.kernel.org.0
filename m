Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808B055AAEE
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiFYOYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiFYOYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:24:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABA3E0A8;
        Sat, 25 Jun 2022 07:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7324360ECC;
        Sat, 25 Jun 2022 14:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161ABC3411C;
        Sat, 25 Jun 2022 14:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656167043;
        bh=DaVURzrOH5h1D0JiTA3enJZHN2QsAdolonR8vVq6jXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RuOYMNCR+DLojIQVmZvrx3TkwCdcKmgJCDZB2RtzXBiBQ0Rz0brn+XJ58DCUqmnzX
         twXof/3PPAl7O/BEPTGcALg5FoA3kKVMRtncQA9jsXmN0U41lSCIIrpMUF6VdMQfyS
         0ZjBz63gOxZzvPEjFQ3FklJOfa3J+YlRBk4/saB8=
Date:   Sat, 25 Jun 2022 16:24:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Feiyang Chen <chris.chenfeiyang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        loongarch@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [External] Re: [PATCH] page-flags.h: Fix a missing header
 include of static_keys.h
Message-ID: <YrcagBzn4agIFwHO@kroah.com>
References: <20220625080423.2797-1-chenfeiyang@loongson.cn>
 <CAMZfGtWT7oPq6bD_fRn2gVNX8Lj3=ev21EAoaCCPeq-P_NYF0g@mail.gmail.com>
 <CAAhV-H5K9LG5P6WYJ+64-fi+s=TZbbJQG9E0vHJwOf9Pai5z4w@mail.gmail.com>
 <CAMZfGtVq0VwMETGdzAXLkjes8W0gVBw=r0Xk5rpPnhe7x6tRiw@mail.gmail.com>
 <CAAhV-H4T3ixOWB67XOij3P1xvM+_BUu+THLGtx-VvrCYUgjZyw@mail.gmail.com>
 <YrcWosmEcADSWax+@kroah.com>
 <CAAhV-H44Cs0jf=RUboGSLvmWtCwjBQa-QLy7tPq7XoOZ9jomUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H44Cs0jf=RUboGSLvmWtCwjBQa-QLy7tPq7XoOZ9jomUA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 25, 2022 at 10:17:36PM +0800, Huacai Chen wrote:
> Hi, Greg,
> 
> On Sat, Jun 25, 2022 at 10:07 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Jun 25, 2022 at 10:00:43PM +0800, Huacai Chen wrote:
> > > Hi, Muchun,
> > >
> > > On Sat, Jun 25, 2022 at 7:17 PM Muchun Song <songmuchun@bytedance.com> wrote:
> > > >
> > > > On Sat, Jun 25, 2022 at 5:04 PM Huacai Chen <chenhuacai@kernel.org> wrote:
> > > > >
> > > > > Hi, Muchun,
> > > > >
> > > > > On Sat, Jun 25, 2022 at 4:50 PM Muchun Song <songmuchun@bytedance.com> wrote:
> > > > > >
> > > > > > On Sat, Jun 25, 2022 at 4:04 PM Feiyang Chen
> > > > > > <chris.chenfeiyang@gmail.com> wrote:
> > > > > > >
> > > > > > > The page-flags.h header relies on static keys since commit
> > > > > > > a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled
> > > > > > > with a static_key"), so make sure to include the header to avoid
> > > > > > > compilation errors.
> > > > > > >
> > > > > > > Fixes: a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> > > > > > > ---
> > > > > > >  include/linux/page-flags.h | 1 +
> > > > > > >  1 file changed, 1 insertion(+)
> > > > > > >
> > > > > > > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > > > > > > index e66f7aa3191d..147b336c7a35 100644
> > > > > > > --- a/include/linux/page-flags.h
> > > > > > > +++ b/include/linux/page-flags.h
> > > > > > > @@ -11,6 +11,7 @@
> > > > > > >  #include <linux/mmdebug.h>
> > > > > > >  #ifndef __GENERATING_BOUNDS_H
> > > > > > >  #include <linux/mm_types.h>
> > > > > > > +#include <linux/static_key.h>
> > > > > >
> > > > > > I did not include this. The change makes sense to me. But I am
> > > > > > curious what configs cause the compiling error. Would you mind
> > > > > > sharing the config with us?
> > > > > We found this problem when we add
> > > > > ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP to LoongArch. Since this isn't
> > > >
> > > > Good news to me. I would love to hear more archs support for HVO (HugeTLB
> > > > Vmemmap Optimization).
> > > >
> > > > > upstream yet, we cannot give such a config now (the default config of
> > > > > X86 and ARM64 is just OK).
> > > >
> > > > All right. In this case, the "Cc: stable@vger.kernel.org" is unnecessary.
> > > Maybe make randconfig will have problems on X86/ARM64, so backporting
> > > to 5.18 seems reasonable.
> >
> > Unless it is proven to be needed, there is no need to backport it.
> OK, we will try "make randconfig". And if it isn't needed, should we
> send V2 to remove Cc stable?

If it isn't needed now, no need to send it at all.  Only submit it when
there is a patch that requires it.

thanks,

greg k-h
