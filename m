Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE5F58DFEB
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345485AbiHITM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346470AbiHITLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:11:10 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BA432F
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 12:00:04 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id f22so16273268edc.7
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 12:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VVV8GGpoeLc6+MwlCT0V9dvKeeRB3XD+JQNEfU5zFB4=;
        b=XS74q4C+R/RkerpK/v956xeICTISjlZPR7ZGmhz92t1i3i7F2m/3inQg+aj3m+m6dr
         M77s0vBeprURuoen9lVmJrVsTNMEMY6A9xIYseaKhApwnfZEJpAmNH7oRlfDEbFcQVug
         aYGLct1cvKUeJSKUfVfOlQcwDiMP9ep2ky3lI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VVV8GGpoeLc6+MwlCT0V9dvKeeRB3XD+JQNEfU5zFB4=;
        b=Jo2PN06AflDH5b0WWZR3/ulTivLiZmmJE1znnyoF8MVtjoNbT/roI4gys6Sg9HyyvO
         8r05QGV1DaN0p9cqicn7O4CFmi5kuamIk1ryfcAiWddJNIeJHcK/gZyJlpgUgLeC8rDj
         YzOUOD+qP57dob2Od3XDvABNuYju+u7ihPrmHZz7nnwnwJGrCZiodawIePXLwm9KXA+i
         k+qWZPrxaxiIe5OYzAMSUV46Dx+0sz+W2crIsfQ93Hi0R0moAB62U5sYu8eVMsqrEw7O
         rfrFKSId+QFEp0gCzcBp4VDF4RMmr4RWwRwzJrk4z2QBSSR5P6NM7ACvGMfbWquDwfnE
         hy/A==
X-Gm-Message-State: ACgBeo1gip+tU3LX/UQoFvbZ98Ug/u61N82b0xWGjmXv3k1LX2vBha3L
        J7wQBV0pFMQ+1n1aFAzt4vlsJaGaNqVdUcibHIw=
X-Google-Smtp-Source: AA6agR6aklXYy0i3EpFhdRXo0vwQMzIjiduZduJSR4TnUcHtoBmpm4MIOIldqPu7cQt3NlbvyWNHoQ==
X-Received: by 2002:a05:6402:2d1:b0:43c:bb20:71bf with SMTP id b17-20020a05640202d100b0043cbb2071bfmr22941038edx.59.1660071602952;
        Tue, 09 Aug 2022 12:00:02 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id us11-20020a170906bfcb00b00730538b7cf1sm1434324ejb.75.2022.08.09.12.00.02
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 12:00:02 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id q30so15277385wra.11
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 12:00:02 -0700 (PDT)
X-Received: by 2002:a5d:56cf:0:b0:21e:ce64:afe7 with SMTP id
 m15-20020a5d56cf000000b0021ece64afe7mr14879214wrw.281.1660071601819; Tue, 09
 Aug 2022 12:00:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com> <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
In-Reply-To: <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 11:59:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
Message-ID: <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
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

On Tue, Aug 9, 2022 at 11:45 AM David Hildenbrand <david@redhat.com> wrote:
>
> I totally agree with BUG_ON ... but if I get talked to in all-caps on a
> Thursday evening and feel like I just touched the forbidden fruit, I
> have to ask for details about VM_BUG_ON nowadays.
>
> VM_BUG_ON is only active with CONFIG_DEBUG_VM. ... which indicated some
> kind of debugging at least to me. I *know* that Fedora enables it and I
> *know* that this will make Fedora crash.

No.

VM_BUG_ON() has the exact same semantics as BUG_ON. It is literally no
different, the only difference is "we can make the code smaller
because these are less important".

The only possible case where BUG_ON can validly be used is "I have
some fundamental data corruption and cannot possibly return an error".

This kind of "I don't think this can happen" is _never_ an excuse for it.

Honestly, 99% of our existing BUG_ON() ones are completely bogus, and
left-over debug code that wasn't removed because they never triggered.
I've several times considered just using a coccinelle script to remove
every single BUG_ON() (and VM_BUG_ON()) as simply bogus. Because they
are pure noise.

I just tried to find a valid BUG_ON() that would make me go "yeah,
that's actually worth it", and couldn't really find one. Yeah, there
are several ones in the scheduler that make me go "ok, if that
triggers, the machine is dead anyway", so in that sense there are
certainly BUG_ON()s that don't _hurt_.

But as a very good approximation, the rule is "absolutely no new
BUG_ON() calls _ever_". Because I really cannot see a single case
where "proper error handling and WARN_ON_ONCE()" isn't the right
thing.

Now, that said, there is one very valid sub-form of BUG_ON():
BUILD_BUG_ON() is absolutely 100% fine.

                Linus
