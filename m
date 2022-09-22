Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1D5E6D78
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 22:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiIVU7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 16:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiIVU7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 16:59:53 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E3D2B25F;
        Thu, 22 Sep 2022 13:59:51 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id q11so7079515qkc.12;
        Thu, 22 Sep 2022 13:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=rWCJQafKC5srG5W+g/FDRgvvE8Of+cROu+pWkLvdSiw=;
        b=Y8APGnFcacZwnXOqualGrMnLCYo1wvUvXYBDIwpWwT8A+4DFU52KXs6kXYHr5Eckba
         xQHyiv/z+vz97Sbz/ILM5hDaG4jvsLp1otGc2EYn9pkdoVOGZoarp5lvFhllS365ZZOo
         2Bn0AjMlJKJOKtTcIkaRJW9ZFQsP08xaBLy9j3yicBvjsnFHL/mvTPpsxRjTP0EMztSn
         VkFWTJx+DqHSX0lwLNzHWl5mnsdHvZcKWs8vfBPmOcueD5E2B3GW29ILwuKAbAROWLvA
         HzFWi3UFnDhq1rp99gI8eA6zPk8LVRdRPiWtaNWjZhMYVQNGcWnPyMzTpEXZI65nSYem
         X7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=rWCJQafKC5srG5W+g/FDRgvvE8Of+cROu+pWkLvdSiw=;
        b=0SlRyRahPgdkWoDcKeZK7M0fQ7+gZXNgMZy9hFrb1/gKvXarrLKvQVmrC/NaFg/woF
         QjMs80v+XRI401cro9eeomphjR8QPKHn5f0B2MADBRUcZ58DPLM1Ap8aOjh5s6LqqUmr
         CD6dN0LC4h1yp17idhWx9Want5V9sgsETttlz/QzZTyhnccYO99rRg4bu3+UdCPdysMl
         zt1lI1PgWKC8RBdLOI/o9D/5X5zC0ogKM4AghDWLH18rPu9stoz85QKT5uoeI/u7bS9Y
         6Brjy6eexDOFqZ4z9/f+CGDs3gd/6d4DQELWySvdjIbULqGnborfVh8WINX0Tcm4Q8WM
         M85Q==
X-Gm-Message-State: ACrzQf0xIgR0fZcIQjOB4+8IWvZawUhN1sTCxjY4gp/LGxAYF5VanYol
        tgerGHxugEijn4cgH5uL1al06paEKUu3abjF9ps=
X-Google-Smtp-Source: AMsMyM77i6N0lhLTuSbbf2dZRYbwCRxgSVll80ZFP+hwBNEp4Gw+WC4zaRTP1a1cI7K6j+0woN8tF8qYXten+qGTF30=
X-Received: by 2002:a05:620a:4454:b0:6ce:bfbf:7e3f with SMTP id
 w20-20020a05620a445400b006cebfbf7e3fmr3567761qkp.748.1663880390542; Thu, 22
 Sep 2022 13:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220922200035.94823-1-mike.travis@hpe.com>
In-Reply-To: <20220922200035.94823-1-mike.travis@hpe.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 22 Sep 2022 23:59:13 +0300
Message-ID: <CAHp75VeVKUxnERF0bA_ivBuvb9JsME3b4MgX=TxHhtvghF1w6A@mail.gmail.com>
Subject: Re: [PATCH v2] x86/platform/uv: Dont use smp_processor_id while preemptible
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        stable@vger.kernel.org, Andy Shevchenko <andy@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
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

On Thu, Sep 22, 2022 at 11:01 PM Mike Travis <mike.travis@hpe.com> wrote:
>
> To avoid a "BUG: using smp_processor_id() in preemptible" debug warning
> message, disable preemption around use of the processor id.  This code
> sequence merely decides which portal that this CPU uses to read the RTC.
> It does this to avoid thrashing the cache but even if preempted it still
> reads the same time from the single RTC clock.

...

> Signed-off-by: Mike Travis <mike.travis@hpe.com>
> Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
> Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
> Cc: stable@vger.kernel.org

No kernel version? No Fixes tag?

...

> -               offset = (uv_blade_processor_id() * L1_CACHE_BYTES) % PAGE_SIZE;
> +               offset = (uv_cpu_blade_processor_id(cpu) * L1_CACHE_BYTES) % PAGE_SIZE;

Perhaps it can be transformed to use offset_in_page() at the same time.

-- 
With Best Regards,
Andy Shevchenko
