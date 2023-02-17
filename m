Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B8E69A8D1
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 11:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjBQKFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 05:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjBQKFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 05:05:15 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB821604CF
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 02:05:12 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id l16so404770pgt.5
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 02:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xgo06j9ahnzor5Mr6mVoN2N31xaczjU8L11cr2e3IBE=;
        b=i7htHyT0x/ZVkHVFb7jVG7XxuWs0FA9xl+1C1AipGHVQ3ak+FpFRGJp/CeoDZaWj8Q
         G4rs+DEZIQZe0xXmgSz3fOx6Y1BK0tecqpI/9D3xtiNxk7fvST2VboeM6hyBRn4QhLUO
         LVE4dGTvgCBjF/tl9wourWjp84dvb2RHT8m9jhxMLn9mZIQpjw4h0MldRKnKURuKr0Jo
         UlJtuc8neVHymBEYzUJEPYEyQngNZH6iwQ5eflG1rPFzVhNI4AJSIU+A4yav6BEhjtyp
         WkS5HYEqjhE+DuqF2s5h0Hfvz3QFiV6WoHgfvny2YUvKp9Y/Y4Q8My6bEuDI932nlGux
         epOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xgo06j9ahnzor5Mr6mVoN2N31xaczjU8L11cr2e3IBE=;
        b=77fiUE2hhA1GkREB6eWSNyemk0jrFWCM3JwEDiNxCACXiqg6D3nOfTgBc+ghyHDG0u
         AqtKC3+5YJR5qsgp3v11JLTyloUGXKzwC+DB1O3OrRgdLBq12VBIWboMkITKYowxV0Ww
         j1Asq1nBC+OyBTtIjl9HWdZq2xH3gOEbLsHLS2ADj0164yPMscTIhAeitwpa/Puo2U+S
         CLTPJOrPKLCAi/f9Pr1W/aUWgxcqkdR9k/9BzEPSC64RAaTWDMJ7+WJP9qsgPTdt0212
         IzuYYU+/Nzn5rjq+OthkZmzH1mrjF5nazPYnQzFYUFabGs4xdnqUKqpOFd0Vqf//M1XR
         5MIA==
X-Gm-Message-State: AO0yUKXnAYQJZuv8KKSTe3oFkHbCR+E0qhtVfC9SFyMhqFH7x3vxjvMH
        QlySXDDMGHadxAEmlTmGm2Ju7ger+NToJOCYEzc=
X-Google-Smtp-Source: AK7set+RWZOPMzd39MoBeQ74y8NdaYRMTr1w1yYrhc2pNVe/5/Nxb18l5XRIKUqk3HkhJK85HyHSrVeDTQt/adskIaU=
X-Received: by 2002:a65:6050:0:b0:4f1:1bbc:be70 with SMTP id
 a16-20020a656050000000b004f11bbcbe70mr687528pgp.6.1676628312200; Fri, 17 Feb
 2023 02:05:12 -0800 (PST)
MIME-Version: 1.0
References: <20230214015214.747873-1-pcc@google.com> <Y+vKyZQVeofdcX4V@arm.com>
 <CAMn1gO4mKL4od8_4+RH9T2C+6+-7=rsdLrSNpghsbMyoVExCjA@mail.gmail.com>
In-Reply-To: <CAMn1gO4mKL4od8_4+RH9T2C+6+-7=rsdLrSNpghsbMyoVExCjA@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Fri, 17 Feb 2023 11:05:01 +0100
Message-ID: <CA+fCnZeK4d7CvaHxCR0oUfZMXbh5-x9H3cL_8Rk9ZqnRryOqBw@mail.gmail.com>
Subject: Re: [PATCH] arm64: Reset KASAN tag in copy_highpage with HW tags only
To:     Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     =?UTF-8?B?UXVuLXdlaSBMaW4gKOael+e+pOW0tCk=?= 
        <Qun-wei.Lin@mediatek.com>,
        =?UTF-8?B?R3Vhbmd5ZSBZYW5nICjmnajlhYnkuJop?= 
        <guangye.yang@mediatek.com>, linux-mm@kvack.org,
        =?UTF-8?B?Q2hpbndlbiBDaGFuZyAo5by16Yym5paHKQ==?= 
        <chinwen.chang@mediatek.com>, kasan-dev@googlegroups.com,
        ryabinin.a.a@gmail.com, linux-arm-kernel@lists.infradead.org,
        vincenzo.frascino@arm.com, will@kernel.org, eugenis@google.com,
        =?UTF-8?B?S3Vhbi1ZaW5nIExlZSAo5p2O5Yag56mOKQ==?= 
        <Kuan-Ying.Lee@mediatek.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 5:44 AM Peter Collingbourne <pcc@google.com> wrote:
>
> On Tue, Feb 14, 2023 at 9:54 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> > On Mon, Feb 13, 2023 at 05:52:14PM -0800, Peter Collingbourne wrote:
> > > During page migration, the copy_highpage function is used to copy the
> > > page data to the target page. If the source page is a userspace page
> > > with MTE tags, the KASAN tag of the target page must have the match-all
> > > tag in order to avoid tag check faults during subsequent accesses to the
> > > page by the kernel. However, the target page may have been allocated in
> > > a number of ways, some of which will use the KASAN allocator and will
> > > therefore end up setting the KASAN tag to a non-match-all tag. Therefore,
> > > update the target page's KASAN tag to match the source page.
> > >
> > > We ended up unintentionally fixing this issue as a result of a bad
> > > merge conflict resolution between commit e059853d14ca ("arm64: mte:
> > > Fix/clarify the PG_mte_tagged semantics") and commit 20794545c146 ("arm64:
> > > kasan: Revert "arm64: mte: reset the page tag in page->flags""), which
> > > preserved a tag reset for PG_mte_tagged pages which was considered to be
> > > unnecessary at the time. Because SW tags KASAN uses separate tag storage,
> > > update the code to only reset the tags when HW tags KASAN is enabled.
> >
> > Does KASAN_SW_TAGS work together with MTE?
>
> Yes, it works fine. One of my usual kernel patch tests runs an
> MTE-utilizing userspace program under a kernel with KASAN_SW_TAGS.
>
> > In theory they should but I
> > wonder whether we have other places calling page_kasan_tag_reset()
> > without the kasan_hw_tags_enabled() check.
>
> It's unclear to me whether any of the other references are
> specifically related to KASAN_HW_TAGS or not. Because KASAN_SW_TAGS
> also uses all-ones as a match-all tag, I wouldn't expect calling
> page_kasan_tag_reset() to cause any problems aside from false
> negatives.

All the other page_kasan_tag_reset() are related to both SW and HW_TAGS.
