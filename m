Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5F3248E60
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 21:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgHRTCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 15:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgHRTCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 15:02:03 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F6FC061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 12:02:02 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f26so22627364ljc.8
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 12:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nQVuZWCOnlFwQnX2Zqx0X5sy3pLItQeKoPELobHQVGQ=;
        b=OdFylsapCoULupAOYKw2uxh3CBvd6ctb0Q+oE4KHDc7exoz8gPT0JzpVzCs2UFYloZ
         pdfG98SZ4TKORf3pZEGIPjJidGca60aMQLOi2nen+7fHRK9fQJKdqmCu+AFXvUdhjWjx
         E0UpiJcscdcfZTXaD9DYNr+NvdEPSVQoYZIRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nQVuZWCOnlFwQnX2Zqx0X5sy3pLItQeKoPELobHQVGQ=;
        b=XYeR0uh4kIObFZEV3K+YH+BWI4mK42ofY+F3zLve6R0KzNLXo8+6dMQghgrJAOAeY2
         bS3KQFto5LutiknVUm35cv9ZNqikpRA+lJpcRDMXIH0/K0F5Cd5pKyGJcnevQ6R8H++f
         Iv+7UOvYs9K/arLbWC8DT0WWpbf+AsIy6Ok/cnoxWo0kY3rYa1z0VfEhrvP2CTfnCt37
         WaJ3oxpfqxhFwo1gdpnCZXBct+m7Mn46o7c6vAfeblYtNI/jtEsaKo7IwzOPojlWgQBH
         R90x6t5/ehDMwrbIrVvrdm14EKqu3ujb0rqANStAHwT9lUzj4F+TuOjnKVsf8/qrVQmn
         L1qQ==
X-Gm-Message-State: AOAM531IHAbAqNBknJhq9EI3e0e8BVhOnM0ERyn1oT4yh2O8NQb4OzQE
        GDaV09oldL2qJbJOmigh74CYupD5n58jrQ==
X-Google-Smtp-Source: ABdhPJwKMXV8M+VyU3R+sfryMBwxmRxM3xQRqKeCOWpjZTzl1gpRtWOI9k/O5G5bSEw8ZhEwS97aSQ==
X-Received: by 2002:a2e:a54f:: with SMTP id e15mr9391185ljn.115.1597777320885;
        Tue, 18 Aug 2020 12:02:00 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id m142sm6739849lfa.47.2020.08.18.12.01.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 12:01:59 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id g6so22591147ljn.11
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 12:01:59 -0700 (PDT)
X-Received: by 2002:a2e:7615:: with SMTP id r21mr9769511ljc.371.1597777319256;
 Tue, 18 Aug 2020 12:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200815043041.132195-1-shy828301@gmail.com>
In-Reply-To: <20200815043041.132195-1-shy828301@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 18 Aug 2020 12:01:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjbaptBBKYS+XdCgdjU_RbFPaAd8EkT6_Un6CtNmezt9A@mail.gmail.com>
Message-ID: <CAHk-=wjbaptBBKYS+XdCgdjU_RbFPaAd8EkT6_Un6CtNmezt9A@mail.gmail.com>
Subject: Re: [v3 PATCH] mm/memory.c: skip spurious TLB flush for retried page fault
To:     Yang Shi <shy828301@gmail.com>
Cc:     Yu Xu <xuyu@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 2:04 PM Yang Shi <shy828301@gmail.com> wrote:
>
> We could just skip the spurious TLB flush to mitigate the regression.

Ok, this patch I will apply.

I still hope that arm64 fixes (maybe already fixed) their spurious TLB
function, and I think we should rename it to make sure everybody
understands it's local, but in the meantime this patch hides the
regression and isn't wrong.

Thanks,

                Linus
