Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC837953B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 19:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhEJRRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 13:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEJRRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 13:17:52 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BFEC061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 10:16:47 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id h202so22611117ybg.11
        for <stable@vger.kernel.org>; Mon, 10 May 2021 10:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PpOkt0ElCphGo2kwCiXD7cgewiK52gxKiOZlKtvjMsM=;
        b=NScMccGGbdnt2x0pRivH/YyoIpsom5IGF+Cczk/qMObXl1jX1R3FKiAHPisPSC/g2d
         LstDx3W5FCb0FQTZJNuv/jWHDl7LzSzZZusccfblbBVQm8e3SO4/6T3ai/AuEMUI7oBA
         gwztu66tpd1gdBuYpWYIBvo/SOWHOpQjEsoOkkkMcUY4fekxJqATdxTAmbNfXAc167DC
         bjCDB68VJiy9xEeOf+TEFa1omo9XIwhnr4aPCzJGXHZL6hIS7+NJt4idKV6LsaGBjpLc
         QA8fhnIsG3rjM7Za3tXg9n1DiyIM+Xu2dczcg0n6Y6L4KbVo2bzBGdJhHsa48zzg+muy
         2q3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PpOkt0ElCphGo2kwCiXD7cgewiK52gxKiOZlKtvjMsM=;
        b=Rcwc9qD6LjoUP2HDgncQLesZ1791Dn/0dlwaQjIxeOkLQCX53GATQhF6f3Ci0IcUdj
         wamVcQaGtVSrtBjtfF9Jp4RXQP+UthNbXlAene0B2hWZotNn7+zmr1/jM35BjRPDdmOi
         lnDQt5kr0fNBtT9j0EjeMSGWIzti7ilSSGjTMcSanWNbN7eYMMScYRTfPCkLCBHmwOGq
         Wwdujcb6Mz1OmTappN8ivetZ4RaVGVG2ZSuRwcniE2P0zqBddt7gS7Xj9a/dl3M6p/kY
         ghH6yV8OUIsHSdRwV8lCeUPvsxR0PENKiqjIIkyDG9Fp+g6iIjK3hvlSwDDAK1G6suzC
         VJFQ==
X-Gm-Message-State: AOAM532SFudrb6RRLK9LN3d1at+jHk7n6+MCD0sdvLM9wngKCiPHvPVO
        HzFROMR56u9IT6tDP+BIdZlS7we5xmCwlT0CFyTBMg==
X-Google-Smtp-Source: ABdhPJyeQ92c3lR8Dg9fGvXXku3eqm0RAwwB+GSccJZTMx5U4cv+3hhjp/bWKHTiEd55C4FyD2A/CsTGsA1qbF0dV/g=
X-Received: by 2002:a25:2d64:: with SMTP id s36mr35311357ybe.412.1620667006738;
 Mon, 10 May 2021 10:16:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210506212025.815380-1-pcc@google.com> <20210508173009.781b8a401fefc2ab71cb3907@linux-foundation.org>
In-Reply-To: <20210508173009.781b8a401fefc2ab71cb3907@linux-foundation.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 10 May 2021 10:16:37 -0700
Message-ID: <CAMn1gO6M1tQGx1M6HjZ-5Bw_66zFZFw-xSAOOZjeSo09gYV2qg@mail.gmail.com>
Subject: Re: [PATCH] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        George Popescu <georgepope@android.com>,
        Elena Petrova <lenaptr@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 8, 2021 at 5:30 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu,  6 May 2021 14:20:25 -0700 Peter Collingbourne <pcc@google.com> wrote:
>
> > These tests deliberately access these arrays out of bounds,
> > which will cause the dynamic local bounds checks inserted by
> > CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
> > problem, access the arrays via volatile pointers, which will prevent
> > the compiler from being able to determine the array bounds.
>
> Huh.  Is this use of volatile the official way of suppressing the
> generation of the checking code or is it just something which happened
> to work?  I'm wondering if this workaround should be formalized in some
> fashion (presumably a wrapper) rather than mysteriously and
> unexplainedly open-coding it like this.

I would consider it the official way in the sense that the compiler
must assume that the pointer that it loads from the address of "array"
has an arbitrary value due to the volatile qualifier, and the array
bounds stuff follows from that. Actually I don't think the compiler is
powerful enough yet to look through the store and load of "array", but
if it were, I think that would be the right way to suppress the
analysis.

Is the comment that I added in v2 not enough here?

Peter
