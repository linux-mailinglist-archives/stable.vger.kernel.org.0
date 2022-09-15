Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E955B9D17
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 16:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIOO2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 10:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiIOO2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 10:28:42 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A135240
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 07:28:40 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id g8so12387636iob.0
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 07:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KtQFZOFBGfReOT4PyVcCqUxuwysJzdpXzUpAFXXSsm8=;
        b=ZtwBg3j2+UTYxCTGpE9vIi7qb9nvEVTN9GgtoGIWDISAGX173WGrV57o4SkZuB5jgd
         Qq5HOTTPjw/XceIxfJ6rjVsXXlUmzEd1CHaHwwAlT7hYZjhL8GV5ysMuEHka9VnWGALT
         /v+25s7bylAhRtnprJUpvNOfcC2nAV6oCx7WoRflyj6LeHbWqwyYGRbx9ErxaWYnqoJX
         zy6naD5HAsoZL+IRAN6tkBWwJf4Qq4dk7wfAxMIq3SNhXGwDS5rC85HZrm/+1mUMtpMm
         olX4qLVVsfyAmCsDiZvJYpOD1/EOy4nYLankZWXQjS81zmEUosjezXqrHQovV/24Su4D
         0HpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KtQFZOFBGfReOT4PyVcCqUxuwysJzdpXzUpAFXXSsm8=;
        b=RvMVlGOA1VtRPEFsm4p1/bq3r06OKLNHx7qOk44AIXRVL8nMqbGu3jV3emkBH4YYU+
         p5Av/YKRGx96OJL/bxwSgxcZJAh2zbw7xXoftLOdg7Pqv+9/bnWTOhyfR4I853McS9Vj
         RvO9BQqrJY3mOO/HIZdznbNESkmrIfDZgJuimuz945fSsq1EBgiaAtOlO2RYaYnAvGe9
         Wy1VQZ5CBOvQkT46M0GxpOeEnDYyLz51iPpLBPfg+ZaYfLddnspWyae+q7Fft5A7LKZ/
         nuQWjny/+E7XHwI/ZOTsmsyBmoP9RE8uOdsmqIej0wnF4biHt3E+VvE+VrTMlRQjCAbb
         5Zxg==
X-Gm-Message-State: ACrzQf0gqT30tsr4Ju/ezKcIxdOOjUxGbfOLmpt6LbUHCCFv4rMk1tna
        EA3LGQTGw8pe3jV0ffTGsKOJOc6Y4CXcXZ+ArJqtxw==
X-Google-Smtp-Source: AMsMyM7RNd+SogihFGt+6ConsQRcrm4C6RswRSSEv4ZQyHpiU5OeZh8/cgLqlPqFB9yCZsgq0aheVcBOZi7v2rNFVHo=
X-Received: by 2002:a6b:c991:0:b0:6a1:29b1:20b with SMTP id
 z139-20020a6bc991000000b006a129b1020bmr1581iof.2.1663252119482; Thu, 15 Sep
 2022 07:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez2sDEaDpiHBQJcDqPtvpCYK1JjLD=Jp8rE9ODnFW-MbRg@mail.gmail.com>
 <YyMGKaTbIbw/nrsE@kroah.com>
In-Reply-To: <YyMGKaTbIbw/nrsE@kroah.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 15 Sep 2022 16:28:03 +0200
Message-ID: <CAG48ez3jVqsZBQA4rYaBiCJENwZy9obZEVCxFa4pRXt6DYT_KA@mail.gmail.com>
Subject: Re: I botched the b67fbebd4cf9 (VM_PFNMAP TLB flush) stable backport,
 how do I have to fix it?
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hugh Dickins <hughd@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Sep 15, 2022 at 1:01 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Sep 15, 2022 at 12:48:44PM +0200, Jann Horn wrote:
> > Hi!
> >
> > Hugh reached out to me and let me know (in nicer words) that I botched
> > my attempt to re-implement b67fbebd4cf9 for the stable backport; the
> > backport is an incomplete fix (because I forgot that in
> > unmap_region(), "vma" is just one of potentially several VMAs).
> >
> > What should the commit message for fixing that look like? And should
> > we first revert the botched backport and then do a correct backport on
> > top of that, or should I write a single fix commit?
>
> Which every you want is fine with me, I can easily add 1 or 2 patches :)
>
> If you want do the revert now, and get a release out with that, and then
> do a "better" patch later, that's fine too, just let me know what you
> want to do.

Ok, I just sent you a fixup patch that should apply cleanly to the
affected stable trees ("[PATCH stable 4.9-5.15] mm: Fix TLB flush for
not-first PFNMAP mappings in unmap_region()").

@Hugh: Can you maybe take a look and let me know if this looks reasonable now?
