Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD581DFB12
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 23:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388036AbgEWVAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 17:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387965AbgEWVAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 17:00:30 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C424BC061A0E
        for <stable@vger.kernel.org>; Sat, 23 May 2020 14:00:29 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id r125so8448590lff.13
        for <stable@vger.kernel.org>; Sat, 23 May 2020 14:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6LCUZQUt7fK9jsVHmaPDEWqGwDeFrykYKW4+UzG+7dk=;
        b=Ttyq4t2RYlc7VkIgBqRmB6HEqT35p5TVbfANPsZMmOoSCGDAviFQgTbjwvypWX17ea
         bnHb/kyrmC59RmCMDkDGB4KSnOST0YX6fasd/AMXwSyhYLGUjrNN9aUbTRa0KtUEpKQS
         oZM/DShfaWEtIbkH/Oaj7eM189YRlblF7FOW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6LCUZQUt7fK9jsVHmaPDEWqGwDeFrykYKW4+UzG+7dk=;
        b=VR8VUFwP34S6WETR1jn2WGXxU0GtSf5ERlh+LkEPnHhyqA9Q/XbOtRjoL6BM0vGv9O
         CAMpbhdLJ7yj96pIFpQIxexPIfo6G3qiuEVufsohhDYhTm5kwwJWFCR+bPVWewynaQqI
         P4aekyEmgifkZCdGi9cQQiC3S91KcWFH9zunhRvzfQF7ECZjzjUsLDcaqRUM3YXy0ibi
         8qTV6F54Ln+Yk5ivJVrE5lHlkX2sH6ZNkNgpU8vyi2QGd84QC6w8aY8p/atoHETiAoUZ
         lGnwYo+yl3M0hz2rTsnUJ4y8AwAOwUPCF8/4ioAlOKcVsV7fnCa8u12lD7hDo2dJLe7L
         ogFA==
X-Gm-Message-State: AOAM531u2aHV8YSPTPC3t3H4J+suwFh/H5+khccoMCnW04gVh0cRjOpx
        V628V5YwhpY5EAwUCA6BUUVKnIbiCYM=
X-Google-Smtp-Source: ABdhPJwyL2FQdtsENN93G6oUAXTYOq1I8Ade7Z1nEdais6vq6rKj04TZu6KYR4i0eSH+y2owtyIQwg==
X-Received: by 2002:a05:6512:104c:: with SMTP id c12mr10724511lfb.200.1590267624674;
        Sat, 23 May 2020 14:00:24 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id u20sm3180664ljk.103.2020.05.23.14.00.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 14:00:23 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id x22so8493624lfd.4
        for <stable@vger.kernel.org>; Sat, 23 May 2020 14:00:23 -0700 (PDT)
X-Received: by 2002:a05:6512:62:: with SMTP id i2mr10465106lfo.152.1590267622861;
 Sat, 23 May 2020 14:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200523195718.1479419-1-rppt@linux.ibm.com>
In-Reply-To: <20200523195718.1479419-1-rppt@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 23 May 2020 14:00:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjW8QoT9Kawf1tkQdqsAJdLQakj_fh_XS6SeQO990DdtQ@mail.gmail.com>
Message-ID: <CAHk-=wjW8QoT9Kawf1tkQdqsAJdLQakj_fh_XS6SeQO990DdtQ@mail.gmail.com>
Subject: Re: [PATCH] sparc32: fix page table traversal in srmmu_nocache_init()
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Anatoly Pugachev <matorola@gmail.com>,
        mm-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 23, 2020 at 12:57 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> Remove __nocache_fix() for p4d_offset() and pud_offset() and keep it only
> for PUD and lower levels.

Davem - I took this directly, since it's a fix for the patch Andrew
sent and I merged that way. Just so you know.

             Linus
