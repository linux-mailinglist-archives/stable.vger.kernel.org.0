Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2B5632C24
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 19:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiKUScr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 13:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiKUScp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 13:32:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9A0D0DD8
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 10:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669055521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HKC6PzeRn6bPjEwwYUvrQnoSSD38TBwL6brYXNQ38R8=;
        b=hFt9gHc3vxwslBRw8P9VnrCXMlACTeDdSSsHfsFhtoN0IGQ7GPGnrTwUb3XZtXQ6Ad+jug
        YfQ1tVjL69WWXU8BSZH/xijZCWTWlcyrXK2HHVMqM6JRYbBOXSUlpLHpNVP2712TvofrPk
        EPplZSSCKrQFuyl+ICZVKwHxxutYHtM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-370-mfqKfLbnNfWiwNEJb9__tA-1; Mon, 21 Nov 2022 13:31:59 -0500
X-MC-Unique: mfqKfLbnNfWiwNEJb9__tA-1
Received: by mail-qk1-f198.google.com with SMTP id bp10-20020a05620a458a00b006fa29f253dcso16565942qkb.11
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 10:31:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKC6PzeRn6bPjEwwYUvrQnoSSD38TBwL6brYXNQ38R8=;
        b=OEvwKYZY7mBAEf9cywAAX5vBCbPwzJTtWpRlLSfvVVI0dz7ggZpSe4fVAGnoMIf72R
         MqJTVEPWE3pyiMxVpX3wEEBZrcLmDVhkVgN8S6B1fcxzpxxR+qTuz00UF0NeSLkibaI1
         IUjjei7MzPl3l8w7xR2S843VXNq53HOl3ARBIEycBGavWKKnaruybDSuzBwZt7au3ISm
         B23W3GgBoee2xI6pfe9+v1CQAgD38W1SZMikIooky19D5g1tAAr07wTJSv0fIW2/M+0r
         6VwnIPNFFXiZGZDdtaMA0692qWkqyUpgdjyiq23Kz9JRu+evFdqQfUqahZD+/uc6gEyy
         q9tA==
X-Gm-Message-State: ANoB5pkyWWEb43IQERohw+jKMFz+7ckvscdjwe04lHNPu22u8Wd4Q0rA
        zfqlA0vHg0LZkAVr/twcXUJJlxMoZOdKdWugyrRKmC7UEynYbSfSq3PwBUWGFLk1gUcEw9eDAYR
        n0zPdO8KVrUz945/K
X-Received: by 2002:a37:5841:0:b0:6ec:b463:3b88 with SMTP id m62-20020a375841000000b006ecb4633b88mr17087698qkb.720.1669055518892;
        Mon, 21 Nov 2022 10:31:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6xzjkUosYgVU21fd/euPs0iKKvIcKvKxOuaD7CQ/FP4vPZ/uZb2xfuhRFr7numHkNx2q/57w==
X-Received: by 2002:a37:5841:0:b0:6ec:b463:3b88 with SMTP id m62-20020a375841000000b006ecb4633b88mr17087671qkb.720.1669055518522;
        Mon, 21 Nov 2022 10:31:58 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id r13-20020a05620a298d00b006eee3a09ff3sm8695375qkp.69.2022.11.21.10.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 10:31:58 -0800 (PST)
Date:   Mon, 21 Nov 2022 13:31:57 -0500
From:   Peter Xu <peterx@redhat.com>
To:     hev <r@hev.cc>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "David S . Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 04/47] LoongArch: Set _PAGE_DIRTY only if _PAGE_WRITE is
 set in {pmd,pte}_mkdirty()
Message-ID: <Y3vEHRiIFCSk8vRG@x1n>
References: <20221117042532.4064448-1-chenhuacai@loongson.cn>
 <Y3ZPRx/VUoVvujNa@x1n>
 <Y3aDQKwGDLXtWRJu@x1n>
 <CAHirt9itKO_K_HPboXh5AyJtt16Zf0cD73PtHvM=na39u_ztxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHirt9itKO_K_HPboXh5AyJtt16Zf0cD73PtHvM=na39u_ztxA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 19, 2022 at 10:20:20PM +0800, hev wrote:
> Hi, Peter,

Hev,

> 
> On Fri, Nov 18, 2022 at 2:53 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Thu, Nov 17, 2022 at 10:12:07AM -0500, Peter Xu wrote:
> > > Hi, Huacai,
> > >
> > > On Thu, Nov 17, 2022 at 12:25:32PM +0800, Huacai Chen wrote:
> > > > Now {pmd,pte}_mkdirty() set _PAGE_DIRTY bit unconditionally, this causes
> > > > random segmentation fault after commit 0ccf7f168e17bb7e ("mm/thp: carry
> > > > over dirty bit when thp splits on pmd").
> > > >
> > > > The reason is: when fork(), parent process use pmd_wrprotect() to clear
> > > > huge page's _PAGE_WRITE and _PAGE_DIRTY (for COW);
> > >
> > > Is it safe to drop dirty bit when wr-protect?  It means the mm can reclaim
> > > the page directly assuming the page contains rubbish.
> > >
> > > Consider after fork() and memory pressure kicks the kswapd, I don't see
> > > anything stops the kswapd from recycling the pages and lose the data in
> > > both processes.
> >
> > Feel free to ignore this question..  I think I got an answer from Hev (and
> > I then got a follow up question):
> >
> > https://lore.kernel.org/all/Y3Z9Zf0jARMOkFBq@x1n/
> >
> > >
> > > > then pte_mkdirty() set
> > > > _PAGE_DIRTY as well as _PAGE_MODIFIED while splitting dirty huge pages;
> > > > once _PAGE_DIRTY is set, there will be no tlb modify exception so the COW
> > > > machanism fails; and at last memory corruption occurred between parent
> > > > and child processes.
> > > >
> > > > So, we should set _PAGE_DIRTY only when _PAGE_WRITE is set in {pmd,pte}_
> > > > mkdirty().
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Peter Xu <peterx@redhat.com>
> > > > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > > > ---
> > > > Note: CC sparc maillist because they have similar issues.
> > >
> > > I also had a look on sparc64, it seems to not do the same as loongarch
> > > here (not removing dirty in wr-protect):
> > >
> > > static inline pmd_t pmd_wrprotect(pmd_t pmd)
> > > {
> > >       pte_t pte = __pte(pmd_val(pmd));
> > >
> > >       pte = pte_wrprotect(pte);
> > >
> > >       return __pmd(pte_val(pte));
> > > }
> > >
> > > static inline pte_t pte_wrprotect(pte_t pte)
> > > {
> > >       unsigned long val = pte_val(pte), tmp;
> > >
> > >       __asm__ __volatile__(
> > >       "\n661: andn            %0, %3, %0\n"
> > >       "       nop\n"
> > >       "\n662: nop\n"
> > >       "       nop\n"
> > >       "       .section        .sun4v_2insn_patch, \"ax\"\n"
> > >       "       .word           661b\n"
> > >       "       sethi           %%uhi(%4), %1\n"
> > >       "       sllx            %1, 32, %1\n"
> > >       "       .word           662b\n"
> > >       "       or              %1, %%lo(%4), %1\n"
> > >       "       andn            %0, %1, %0\n"
> > >       "       .previous\n"
> > >       : "=r" (val), "=r" (tmp)
> > >       : "0" (val), "i" (_PAGE_WRITE_4U | _PAGE_W_4U),
> > >         "i" (_PAGE_WRITE_4V | _PAGE_W_4V));
> > >
> > >       return __pte(val);
> > > }
> >
> > (Same here; I just overlooked what does _PAGE_W_4U meant..)
> >
> > >
> > > >
> > > >  arch/loongarch/include/asm/pgtable.h | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
> > > > index 946704bee599..debbe116f105 100644
> > > > --- a/arch/loongarch/include/asm/pgtable.h
> > > > +++ b/arch/loongarch/include/asm/pgtable.h
> > > > @@ -349,7 +349,9 @@ static inline pte_t pte_mkclean(pte_t pte)
> > > >
> > > >  static inline pte_t pte_mkdirty(pte_t pte)
> > > >  {
> > > > -   pte_val(pte) |= (_PAGE_DIRTY | _PAGE_MODIFIED);
> > > > +   pte_val(pte) |= _PAGE_MODIFIED;
> > > > +   if (pte_val(pte) & _PAGE_WRITE)
> > > > +           pte_val(pte) |= _PAGE_DIRTY;
> > >
> > > I'm not sure whether mm has rule to always set write bit then set dirty
> > > bit, need to be careful here because the outcome may differ when use:
> > >
> > >   pte_mkdirty(pte_mkwrite(pte))
> > >   (expected)
> > >
> > > VS:
> > >
> > >   pte_mkwrite(pte_mkdirty(pte))
> > >   (dirty not set)
> > >
> > > I had a feeling I miss some arch-specific details here on why loongarch
> > > needs such implementation, but I can't quickly tell.
> >
> > After a closer look I think it's fine for loongarch as pte_mkwrite will
> > also set the dirty bit unconditionally, so at least the two ways will still
> > generate the same pte (DIRTY+MODIFIED+WRITE).
> >
> > But this whole thing is still confusing to me.  It'll still be great if
> > anyone can help explain why the _DIRTY cannot be set only in pte_mkwrite()
> > if that's the solo place in charge of "whether the pte is writable".
> >
> > The other follow up question is: how do we mark "this pte contains valid
> > data" (the common definition of "dirty bit"), while "this pte is not
> > writable" on loongarch?
> >
> > It can happen when we're installing a page with non-zero data meanwhile
> > wr-protected.  That's actually a valid case for userfaultfd wr-protect mode
> > where user specified UFFDIO_COPY ioctl with flag UFFDIO_COPY_MODE_WP, where
> > we'll install a non-zero page from user buffer but don't grant write bit.
> >
> > From code-wise, I think it can be done currently with this on loongarch:
> >
> >   pte_wrprotect(pte_mkwrite(pte_mkdirty(pte)))
> >
> > Where pte_wrprotect(pte_mkwrite(pte)) is not a no-op but applying MODIFIED.
> 
> We would like to note that on LoongArch (for misunderstanding naming):
> * _PAGE_DIRTY meaning hardware writable.
> * _PAGE_WRITE meaning software writable.
> * _PAGE_MODIFIED meaning software dirty, this page contains updated valid data.
> 
> PTE APIs:
> * pte_mkwrite: Allow to write, only needs set _PAGE_WRITE.
> * pte_mkdirty: Mark as dirty, only needs set _PAGE_MODIFIED.
> * pte_dirty: Test is dirty, only test _PAGE_MODIFIED.
> * pte_wrprotect: Clear both writable, force to raise exception to
> handle_mm_fault.
> 
> If a pte is only set _PAGE_WRITE without _PAGE_DIRTY by pte_mkwrite,
> then a write memory access will cause mmu exception, and the
> (_PAGE_DIRTY|_PAGE_MODIFIED) will be set in this exception handler. I
> think the _PAGE_DIRTY is also possible to set in pte_mkwrite for
> speedup, then _PAGE_MODIFIED must be set at the same time. To avoid
> the page data being modified but not detected by pte_dirty. (Current
> code may needs to fix
> 
> pte_mkdirty mark pte as dirty is the main function, It can also make
> pte writeable by hardware(_PAGE_DIRTY) for speedup (too) if and only
> if the pte is writable(_PAGE_WRITE). (mkdirty sets _PAGE_DIRTY
> unconditionally is the root cause of the huge page COW issue.

Yes, and that's why Huacai's patch can fix this issue for Loongarch, but
sparc64 still suffers from it so far.

> 
> For write-protection, pte_wrprotect will clear both writable(software
> and hardware) in pte to force a MMU exception to handle_mm_fault.
> 
> So yeah, the pte marked as dirty(_PAGE_MODIFIED) and without any
> writable in the following code:
> 
>   pte_wrprotect(pte_mkwrite(pte_mkdirty(pte)))

Thanks for the further explanation, Hev.

I think so far I keep the questioning on whether it's a good optimization
to apply _DIRTY in pte_mkdirty here.

Since we have pte_mkwrite() API after all, even if there's an optimization
IMHO it should be done by the kernel generic code already, I don't
immediately see why it needs to be arch-specific.  IOW, I'm not sure
whether such optimization for loongarch will bring any real performance
benefit?

The thing is, generic mm code should already have called pte_mkwrite()
along with pte_mkdirty() when proper, so _DIRTY will be properly applied
even if pte_mkdirty() only applies _MODIFIED in loongarch code without
extra mmu faults - if you see the code base that's really the major cases,
except a few very special conditions where we want to only set _MODIFIED
but may want to keep the pte read-only, but in that case it's never wise to
set _DIRTY in pte_mkdirty anyway.

I just don't know whether there's anything else I could have overlooked, so
maybe removing "set _DIRTY" in pte_mkdirty() will regress in some other way.

For now, I think I'll go ahead and try to propose another trivial fix for
the pmd split generic code so we'll have the pte_mkdirty back (I think I
need to reorder pte_wrprotect() so that it needs to appear after
pte_mkdirty()) but hopefully also work for sparc64; loongarch will also
benefit if before this patch lands.

(Sorry to be off-topic on this thread)

-- 
Peter Xu

