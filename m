Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FC1381FD2
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 18:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhEPQbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 12:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhEPQbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 12:31:15 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDBEC061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 09:30:00 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i22so5225268lfl.10
        for <stable@vger.kernel.org>; Sun, 16 May 2021 09:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/R9Qr6+/6sFoQl5yNw/F4q+YIrslCfIrvlQKzEQ7uV4=;
        b=N2UVhTNGZMyzWf6qLU5oMZhVxFwGPlAr3ekqRRh0qA4cjX3welqaug5f9jww8+3muV
         aJvtJUPR4ofRYghH/Om9C2/p3O0tML8hV2kB4drt8IUPuxCK5XJLGBzSH+pfY0EWzhXP
         6d4+uYwXD63VUbcCgoSExEC3f6ElqddJ3cV9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/R9Qr6+/6sFoQl5yNw/F4q+YIrslCfIrvlQKzEQ7uV4=;
        b=ruKMpe+3DKH+T2EN93bSFGwdE0Ufemc5/u1rm0d155LvFf2VbafGBQVGGf5PTq+xu8
         gD2ks5UiyR5KJbUn+g5ffvZ3PLhXk5rrR24J+byL5Pz/o93oOrznh7pCjzSzzJ3QmEx9
         HwVdo4UkQaswKd0xnQ7gDEci8EXtWA4RdyDnsUqufAN7KgtixNllw2oYyWh+gYu99s/F
         C6dhsqUIbGdXLkwM/a9SikxybORMhCqy4elOXU59NxOt7QyJgtz5MaDX6lvNsb+V3h77
         NMa8CNP9Ehgl+pWdMyx/wwsN/PWv4OB7s7Hp0DyAWzl8oqoLM0NGt7NPeb05zuRB915B
         aNZA==
X-Gm-Message-State: AOAM533M4Ab1qYvuYh5+kSNfr4GnpYVX6aKSTTK0051xzZvN0/9zgbjs
        iEPz5joLLnVKrLytdtUynHGOgKFs2E9kOrK1hTU=
X-Google-Smtp-Source: ABdhPJwETwV6d3dSyCyNzPw0i0J51WFCzVBffQUUisrr9fmVGFpG/ENbEF/gEZpJIzo0uQPxK8Bwgw==
X-Received: by 2002:a05:6512:3081:: with SMTP id z1mr10548239lfd.199.1621182598600;
        Sun, 16 May 2021 09:29:58 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id h19sm1695810lfc.56.2021.05.16.09.29.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 May 2021 09:29:58 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id 131so4343801ljj.3
        for <stable@vger.kernel.org>; Sun, 16 May 2021 09:29:57 -0700 (PDT)
X-Received: by 2002:a05:651c:333:: with SMTP id b19mr44407079ljp.61.1621182597625;
 Sun, 16 May 2021 09:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210516121844.2860628-1-willy@infradead.org>
In-Reply-To: <20210516121844.2860628-1-willy@infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 16 May 2021 09:29:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
Message-ID: <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 5:19 AM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> 32-bit architectures which expect 8-byte alignment for 8-byte integers and
> need 64-bit DMA addresses (arm, mips, ppc) had their struct page
> inadvertently expanded in 2019.  When the dma_addr_t was added, it forced
> the alignment of the union to 8 bytes, which inserted a 4 byte gap between
> 'flags' and the union.

So I already have this in my tree, but this stable submission made me go "Hmm".

Why do we actually want a full 64-bit DMA address on 32-bit architectures here?

It strikes me that the address is page-aligned, and I suspect we could
just use a 32-bit "DMA page frame number" instead in 'struct page'?

So instead of that odd

+       if (sizeof(dma_addr_t) > sizeof(unsigned long))
+               ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;

maybe we could just do effectively

        ret + (dma_addr_t)page->dma_frame_nr << PAGE_SHIFT;

and simplify this all. We could do it on 64-bit too, just to not have
any opdd special cases (even if we'd have the full 64 bits available).

Hmm?

                Linus
