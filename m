Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B39824E098
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 21:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgHUTTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 15:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgHUTS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 15:18:59 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80987C061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 12:18:59 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x64so498860lff.0
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 12:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DLc84kj5PHVUSiFGEP5mfzNqVCypKwLtWPaDrgaberY=;
        b=SofWc/w6t4rEsc85RaLfw4+1oCNKhS2jGDmsKj708JnMxQaUL81Q5yOWX5EhAMzU+x
         Cb3KyXSNMzLbsgJPGamhAP2iMjt3UL8rroxFzqL7p6C5UBNeY6HNa3Jd1zJI2GavW46Q
         WhVw+1qcn3yzbaRWJ0lfgO2uTu43gklL+LpRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DLc84kj5PHVUSiFGEP5mfzNqVCypKwLtWPaDrgaberY=;
        b=ANaorccEt+9fbadBRxuJkhxDiZqDiaoVXNkavI/jsEzCnGHv7lExIUiV/N5mrbA87c
         IitKBgYYVZgjvW2TlLE7cudTL/D5wOoVo779gYLa6BIK7xXj702ilWac6m5iv3AjdgKv
         8D2E728LzQgBLrWIrsjONISK0qPabz8YT+y49iBwDxpmgFLSkhNKfxr1oZZi5vsPg1xj
         EOOQo3U9NEk4YvvqE72A3ldSyw43y9po837rKrhQSqehwrqaDtezW5T5/b8LZvCriRY0
         hv6+cAJ5hZTt/MzPTqsQrnW0kTZ2gxWkAI8NEx9ASjq4kK95fLBY5Ky9EzA1nzUEgo9R
         K0gQ==
X-Gm-Message-State: AOAM533Moa+TZOSDGTQ5X/rId6agoxHk5+KKsfc4Oalp/jrglsl04GCK
        smNdLjZ3BmlpnvBg1NnbarDqkdFuGenkfg==
X-Google-Smtp-Source: ABdhPJyr+za7bibgWXjF3d4RCLp9drWwIQU9OOB7DbWy1uyKQQ2OWJPzjYCZ5htY5JIi4wYNvmwD8w==
X-Received: by 2002:ac2:494c:: with SMTP id o12mr1981578lfi.181.1598037537997;
        Fri, 21 Aug 2020 12:18:57 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id d6sm566575ljg.25.2020.08.21.12.18.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 12:18:57 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id v12so1235363lfo.13
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 12:18:57 -0700 (PDT)
X-Received: by 2002:a05:6512:3b7:: with SMTP id v23mr2073008lfp.10.1598037536954;
 Fri, 21 Aug 2020 12:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200821123746.16904-1-joro@8bytes.org>
In-Reply-To: <20200821123746.16904-1-joro@8bytes.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 21 Aug 2020 12:18:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgNEsVwVMwQdHL4O1tDWQa-HcmOv-EmqLTQH+SoC2CkWA@mail.gmail.com>
Message-ID: <CAHk-=wgNEsVwVMwQdHL4O1tDWQa-HcmOv-EmqLTQH+SoC2CkWA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Track page table modifications in __apply_to_page_range()
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Pavel Machek <pavel@ucw.cz>, Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Joerg Roedel <jroedel@suse.de>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 5:38 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Joerg Roedel <jroedel@suse.de>
>
> The __apply_to_page_range() function is also used to change and/or
> allocate page-table pages in the vmalloc area of the address space.
> Make sure these changes get synchronized to other page-tables in the
> system by calling arch_sync_kernel_mappings() when necessary.

I get the strong feeling that these functions should be using a
"struct apply_details *" or something like that (the way the
zap_page_range() code has that "zap_details" thing).

Because adding more and more arguments gets pretty painful after a
while. But maybe the compiler inlining it all makes it a non-issue.

It also strikes me that I think the only architecture that uses the
whole arch_sync_kernel_mappings() thing is now just x86-32.

[ Well, x86-64 still has it, but that's because we undid the 64-bit
removal, but it's on the verge of going away and x86-64 shouldn't
actually _need_ it any more ]

So all of this seems to be purely for 32-bit x86. Which kind of makes
this all fail the smell test.

But the patch does seem to be the minimal fix for a real issue - I'm
just pointing out ugly details, not actual problems with the patch.

IOW, a somewhat reluctant Ack, hoping that this will be cleaned up
some day. Possibly/hopefully because arch_sync_kernel_mappings() just
goes away entirely.

                 Linus
