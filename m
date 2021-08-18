Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005C83F050A
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 15:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbhHRNlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 09:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbhHRNlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 09:41:02 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A957C0612A4
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 06:40:17 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id e13-20020a9d63cd0000b02904fa42f9d275so3572793otl.1
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 06:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92kjzJHPbu8CdHkXkohUqea/s0XZxMJWcWOY/L8K0Q0=;
        b=eqlv99p38UbOHhb+iaqlx8R7pajxw88f0tDyRo/zUVE14LEO4nwE2X3XKvBkTLTGo9
         fvZ1OU5V9As8yW7DKQiDEIcigagyaC8S/UD1sEutBruhxBh268wCIylG2YzXXgG3Z7AT
         bSKuRtM+aMBRCld1BcmNLRbNFDaH5uXdhOs2UyOOCAjv8KdUznngHKeegRULI8Dzwhgw
         83/pzM0Hy3rY6gc9LoeNVduSmNCBEvcklG+qOxxJbJXVD0fp5sIDxOdfVTx0mvdN16A5
         3M7ncvOWOapHbHzd6Cxc7trD4qzvbv6XgEZdYKhUgI+M9hg/mGxjGUC+YoFplWTrRaHs
         qvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92kjzJHPbu8CdHkXkohUqea/s0XZxMJWcWOY/L8K0Q0=;
        b=ojEf8J7xvRDos8/Xk4PXoVAViiXyApFUHuhVx2p259J3ImzeuOakflZCExiqNqAPDv
         7HGDOabkykw4i5XdHtInDgkpfiuxwf3El4xiyo5L/VvQ4Oh7OxrZQyrciN1icFzBCEIl
         d5xv31eAO2xoUIN/y0VEiwEiQHBEMnCX1lwzwvLVdKi1bunDBW4cb3CA4tjfP4389kX4
         PRurIQPHO571ZbBv39PVtspTDrruuR+J/XVMbOUJ6CPah0oeLQu5fB8xNyn3y54lgEkU
         KPvzpp3xBiz4JrGoxXt9bt8PuRwtezHVV33xab9PvKQNARes48WAKZmabzkuyebKUuPu
         +Aag==
X-Gm-Message-State: AOAM5314Xnh/kJATaQNNwwYFfPk1NnbMZGhz0n6yrKMlecipxWi/hW8g
        YGsYjN8omaXz/7CZ2OMAb+uQ8n/uhhrnWewfAYBcaw==
X-Google-Smtp-Source: ABdhPJypTijaCEpAT80SQ6v46jAeX/zU9T+cs9V7Lj3fV7JwJH8rlSesYnznhG565RDZRzgFMQJ7ljRZ5rCVraf86LQ=
X-Received: by 2002:a05:6830:3114:: with SMTP id b20mr3849263ots.17.1629294016304;
 Wed, 18 Aug 2021 06:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210818130300.2482437-1-elver@google.com>
In-Reply-To: <20210818130300.2482437-1-elver@google.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 18 Aug 2021 15:40:04 +0200
Message-ID: <CANpmjNPX0SANJ6oDoxDecMfvbZXFhk4qCuaYPyWT1M8FNpy_vw@mail.gmail.com>
Subject: Re: [PATCH] kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE
To:     elver@google.com, akpm@linux-foundation.org
Cc:     glider@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kasan-dev@googlegroups.com,
        Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Cc Jann

On Wed, 18 Aug 2021 at 15:03, Marco Elver <elver@google.com> wrote:
>
> Originally the addr != NULL check was meant to take care of the case
> where __kfence_pool == NULL (KFENCE is disabled). However, this does not
> work for addresses where addr > 0 && addr < KFENCE_POOL_SIZE.
>
> This can be the case on NULL-deref where addr > 0 && addr < PAGE_SIZE or
> any other faulting access with addr < KFENCE_POOL_SIZE. While the kernel
> would likely crash, the stack traces and report might be confusing due
> to double faults upon KFENCE's attempt to unprotect such an address.
>
> Fix it by just checking that __kfence_pool != NULL instead.
>
> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
> Reported-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
> Signed-off-by: Marco Elver <elver@google.com>
> Cc: <stable@vger.kernel.org>    [5.12+]
> ---
>  include/linux/kfence.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> index a70d1ea03532..3fe6dd8a18c1 100644
> --- a/include/linux/kfence.h
> +++ b/include/linux/kfence.h
> @@ -51,10 +51,11 @@ extern atomic_t kfence_allocation_gate;
>  static __always_inline bool is_kfence_address(const void *addr)
>  {
>         /*
> -        * The non-NULL check is required in case the __kfence_pool pointer was
> -        * never initialized; keep it in the slow-path after the range-check.
> +        * The __kfence_pool != NULL check is required to deal with the case
> +        * where __kfence_pool == NULL && addr < KFENCE_POOL_SIZE. Keep it in
> +        * the slow-path after the range-check!
>          */
> -       return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && addr);
> +       return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && __kfence_pool);
>  }

Jann, I recall discussing this check somewhere around:
https://lore.kernel.org/linux-doc/CAG48ez0D1+hStZaDOigwbqNqFHJAJtXK+8Nadeuiu1Byv+xp5A@mail.gmail.com/

I think you pointed out initially that we need another check, but
somehow that turned into '&& addr' -- I think that's what we ended up
with because of worry about another memory load, which is clearly
wrong as that only works if addr==NULL. Simply checking
__kfence_pool!=NULL is enough. I also checked codegen, and the
compiler is smart enough to not reload the global __kfence_pool.

Wanted to call it out, just in case you see something even more
efficient (probably the only way to do better is to get rid of the 2nd
branch, which I don't think is possible). :-)

Thanks,
-- Marco
