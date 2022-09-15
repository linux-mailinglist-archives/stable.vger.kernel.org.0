Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF105BA03C
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 19:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIOREH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 13:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiIOREG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 13:04:06 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1884F5F107
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 10:04:06 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id t62so2984517oie.10
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 10:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date;
        bh=nR7moy+6AnHFSjASieWYlFaU2wfVao8bXo1NNJy6/a0=;
        b=RatrqtWlXr8/HkO9fl3mtDPKoRfHHRpm/x9cYh+meDI0Ylg5zhgDf87WWJ7B4kqFrP
         wEBD8SYaDOIRoYYTKR6FmMD2Xk+6nT++jeOOPq5ZpPL6DC8rDeRZXAq0wVwztle3xg4B
         3lWKuSrn3q5B5C5vu3TnAM//z4sSh3c3+/k3mrDCXuNV7Qz0bkyjkpiBkPYi1qXXX9gP
         xP4sKwLjvs/0+f0nEn/RNE30nwwVnuiZrJevRYsNdt+EVWEuYu4QdK8aJwK0znfF7h/H
         s8+0aM8U8ei2tQdPZ3Bwaa2N7r5GGpGqoRjueB6gLqTN2UGnihrFGaMnKhR0cxJlmM6Q
         E6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=nR7moy+6AnHFSjASieWYlFaU2wfVao8bXo1NNJy6/a0=;
        b=TbQaJMgIItak+D+rGIf9HXk/T+G8bVmPEgBqDiCO4Ztg/UIwEfOF+taOKKGIGkQ1r6
         L9FV1WLmwZxgzTpd+Em3t0wo0Xt/96jCpzeZKgKR3mHHbHkLwUb+EpzUALZZ0JT7lZ04
         /3KAiPSyUWbzTMeQiDW47EfdEJgWsaa2pKb5+oZUAkABrWMju8u2VYEJf244lWY4gI4t
         rEIDGwlA6ZXemQnll1MLOC3DNYoO3pZ0FksO1ka7+Q6aggThbYzYMVtwL/ZHq8Q+UIlU
         NsdiZ7S+4aSKZuxyQ3REWZwWBCkQzPdwkJP1uw3ClLZxkfkhNwppWIKUgCY2cqZUEJEp
         bZog==
X-Gm-Message-State: ACrzQf3ERjQEWmlEbi8nJ6CkP6irA5OrFJ1crbIhwqy9WhoJiYIDjKrt
        YBQLTdGNi58Gz23A7A6/72Mqiw==
X-Google-Smtp-Source: AMsMyM6wZBxiuZ2UT+IYApPXtXjouVLPNZ7DVtmkZMjs4wDxWOSRke5uPEFYd4RDWMcYFM47zvcgtg==
X-Received: by 2002:a05:6808:14c8:b0:350:4b77:7bf3 with SMTP id f8-20020a05680814c800b003504b777bf3mr807256oiw.52.1663261445213;
        Thu, 15 Sep 2022 10:04:05 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id j11-20020aca3c0b000000b003449ff2299esm8019064oia.4.2022.09.15.10.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 10:04:04 -0700 (PDT)
Date:   Thu, 15 Sep 2022 10:03:42 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Jann Horn <jannh@google.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>,
        stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: Re: I botched the b67fbebd4cf9 (VM_PFNMAP TLB flush) stable backport,
 how do I have to fix it?
In-Reply-To: <CAG48ez3jVqsZBQA4rYaBiCJENwZy9obZEVCxFa4pRXt6DYT_KA@mail.gmail.com>
Message-ID: <ffd75-1b37-7325-4fa2-39c49b79606e@google.com>
References: <CAG48ez2sDEaDpiHBQJcDqPtvpCYK1JjLD=Jp8rE9ODnFW-MbRg@mail.gmail.com> <YyMGKaTbIbw/nrsE@kroah.com> <CAG48ez3jVqsZBQA4rYaBiCJENwZy9obZEVCxFa4pRXt6DYT_KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Sep 2022, Jann Horn wrote:
> On Thu, Sep 15, 2022 at 1:01 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Sep 15, 2022 at 12:48:44PM +0200, Jann Horn wrote:
> > > Hi!
> > >
> > > Hugh reached out to me and let me know (in nicer words) that I botched
> > > my attempt to re-implement b67fbebd4cf9 for the stable backport; the
> > > backport is an incomplete fix (because I forgot that in
> > > unmap_region(), "vma" is just one of potentially several VMAs).
> > >
> > > What should the commit message for fixing that look like? And should
> > > we first revert the botched backport and then do a correct backport on
> > > top of that, or should I write a single fix commit?
> >
> > Which every you want is fine with me, I can easily add 1 or 2 patches :)
> >
> > If you want do the revert now, and get a release out with that, and then
> > do a "better" patch later, that's fine too, just let me know what you
> > want to do.
> 
> Ok, I just sent you a fixup patch that should apply cleanly to the
> affected stable trees ("[PATCH stable 4.9-5.15] mm: Fix TLB flush for
> not-first PFNMAP mappings in unmap_region()").
> 
> @Hugh: Can you maybe take a look and let me know if this looks reasonable now?

Yes, that one looks fine to me, thanks Jann.  I would not have liked it
if Peter had chosen that way for upstream, but there's good reason to
avoid using tlb_end_vma() in these backports, and good reason to avoid
cluttering up free_pgtables().  No way great: this way good enough, thanks.

Hugh
