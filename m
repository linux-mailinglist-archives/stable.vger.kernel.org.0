Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69BD59078F
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 22:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiHKUub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 16:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHKUu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 16:50:29 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C54FB840
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:50:28 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z20so22502652edb.9
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=e1x0MTjrSOgrGHOWzAckTlqNox//QChLMoeIA7WfW2k=;
        b=UM5HmGuT0UAQsAFcoKMwyI8nZDiKol+BUXRUdnq8zJ4U+h7fJJGG0ljyHZKPGxHQIk
         QymPhO/p9bi/puHLK5lylYclq9Aedf/pFx6fK9vFtGJUUdpVEoBktF+S4XqGMofgQAbc
         IguFfv3HIUbZTLU8zWkXKHsX/D2250fzoKz1k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=e1x0MTjrSOgrGHOWzAckTlqNox//QChLMoeIA7WfW2k=;
        b=BwD9d5VzU/4E63/NUZLziaSVmS6hSvwl5Fiixc47XmSOaQbw1bpb8ukgBlS0lC8b/t
         zfHTLxfkuClaTPmZEEqPQwW6FIFlhyrRCe5ubLpeLYGsLT+hJfi88zgXrkMdjpCKIj6B
         VGE/ariTKmfLJix71vZpgPlHReJ/2+vQjFEBJ1h575jRC1l1jh4ybte59Uc7wYySJ9NG
         /cRHHGD43ka5DoJSvEKvdNk3YZhAeRNbdz23B65kXCLR7NuYUSqZiaz82W7DHXpliY2+
         SbmgXjuZBbRkP8R8zue3bT3e45uGjSxmh6GDbt2dT8K61UJwxsdgs/2QuoyAsv5H9Bii
         MQ2A==
X-Gm-Message-State: ACgBeo1jDu/J8d3gH5OC1Ye6Vra6BgUsO9AneGFGkcu4VvynqY4SOvwH
        JPZcVS8yI7EWTfJeerxTRvJXZP996gziUJKz
X-Google-Smtp-Source: AA6agR7qTY9338yiRVpT+e2zE0SSjCCSgb9dF+eHS4UNQ7fdvi6e2Lvt4TtwkzMxe9qwizwKBpNOeg==
X-Received: by 2002:aa7:c30c:0:b0:440:a189:541d with SMTP id l12-20020aa7c30c000000b00440a189541dmr831072edq.64.1660251026719;
        Thu, 11 Aug 2022 13:50:26 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id h26-20020a17090619da00b00734bfab4d59sm52995ejd.170.2022.08.11.13.50.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 13:50:26 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id v5so10011181wmj.0
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:50:26 -0700 (PDT)
X-Received: by 2002:a05:600c:4ed0:b0:3a3:3ef3:c8d1 with SMTP id
 g16-20020a05600c4ed000b003a33ef3c8d1mr6769254wmq.154.1660250605443; Thu, 11
 Aug 2022 13:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com> <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com> <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
In-Reply-To: <YvSsKcAXISmshtHo@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Aug 2022 13:43:09 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
Message-ID: <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
Subject: Re: [PATCH] sched/all: Change BUG_ON() instances to WARN_ON()
To:     Ingo Molnar <mingo@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 12:13 AM Ingo Molnar <mingo@kernel.org> wrote:
>
> By using a WARN_ON() we at least give the user a chance to report
> any bugs triggered here - instead of getting silent hangs.
>
> None of these WARN_ON()s are supposed to trigger, ever - so we ignore
> cases where a NULL check is done via a BUG_ON() and we let a NULL
> pointer through after a WARN_ON().

May I suggest going one step further, and making these WARN_ON_ONCE() instead.

From personal experience, once some scheduler bug (or task struct
corruption) happens, ti often *keeps* happening, and the logs just
fill up with more and more data, to the point where you lose sight of
the original report (and the machine can even get unusable just from
the logging).

WARN_ON_ONCE() can help that situation.

Now, obviously

 (a) WARN_ON_ONCE *can* also result in less information, and maybe
there are situations where having more - possibly different - cases of
the same thing triggering could be useful.

 (b) WARN_ON_ONCE historically generated a bit bigger code than
WARN_ON simply due to the extra "did this already trigger" check.

I *think* (b) is no longer true, and it's just a flag these days, but
I didn't actually check.

so it's not like there aren't potential downsides, but in general I
think the sanest and most natural thing is to have BUG_ON() translate
to WARN_ON_ONCE().

For the "reboot-on-warn" people, it ends up being the same thing. And
for the rest of us, the "give me *one* warning" can end up making the
reporting a lot easier.

Obviously, with the "this never actually happens", the whole "once or
many times" is kind of moot. But if it never happens at all, to the
point where it doesn't even add a chance of helping debugging, maybe
the whole test should be removed entirely...

           Linus
