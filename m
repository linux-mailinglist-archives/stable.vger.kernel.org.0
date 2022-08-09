Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E4358E016
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245309AbiHITVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347080AbiHITVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:21:42 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D5DA8
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 12:21:40 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id tl27so23959464ejc.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 12:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=r+avV5S2drX7G/TFGfNe00g1z/YAKwkOT5Ou5nsHkJY=;
        b=ZIX4nAvOOGcWp15i8uPfVmKtbEGBXCGgBiIwHpC5nNIUBi7Iq5HzVNS9BhUcgOter0
         Oz2pZJ2RXavV4TVExYGzNgrX3BkQJjqumwDM/WFjxr12SCHjp9H48+PjlxSz0os95unt
         CPUV9XF+R7aEo6gt5l06ltaPKhdqQRG3D3AK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=r+avV5S2drX7G/TFGfNe00g1z/YAKwkOT5Ou5nsHkJY=;
        b=E02MlfUnlbHrEWYWdYLxNPoWdHYRnPiBAa5+vJkEhMQ9LIvmHjiNmhYXd+us1vOJVx
         MclUZWbd0bqk+KLwOiWud8iGqaia203k8yWjxUsLs7lQdxCy5zPZ1+YR+e+GhGHfBPbk
         KBDZ5sHGIOfWo7i9S71+CDkrUuFQluSOJ5K1gsAJN1a/gAihybytjH7GSiX95TZcvRw9
         WjPG/VzifunbqoTwEFHln8j+qmaKrajDM9a/mL1lcV6bQwcNjbfP2WXr2RMIocNfT2Om
         wRJABBME1SAuHg+YyHEVIjDjO7MkSCuqOC0SNGFsNcqESvWfhTINVDzIAKDqfyhc7zIA
         bIFQ==
X-Gm-Message-State: ACgBeo1jotiDCoZwvmThwhdHoiwZKhqHpfX2Cfyx759zWU9DcaivaoaY
        jecDRvnxaUYNq1Uwo0n6oeYNAValh8h03AoxBaA=
X-Google-Smtp-Source: AA6agR7OjLy5LRGl4sXXtOiPzkQ3enR6m6QHQG2q4EXdneEqxE6F3GY++Ah16E+PnE4XOIuelQsrWw==
X-Received: by 2002:a17:907:72c8:b0:731:6d1:13f9 with SMTP id du8-20020a17090772c800b0073106d113f9mr13575925ejc.550.1660072898953;
        Tue, 09 Aug 2022 12:21:38 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id mb11-20020a170906eb0b00b0072f4f4dc038sm1433657ejb.42.2022.08.09.12.21.34
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 12:21:36 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id q30so15334389wra.11
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 12:21:34 -0700 (PDT)
X-Received: by 2002:a5d:638b:0:b0:220:6e1a:8794 with SMTP id
 p11-20020a5d638b000000b002206e1a8794mr15428277wru.193.1660072893720; Tue, 09
 Aug 2022 12:21:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com> <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com> <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvKwhrjnFQJ7trT1@nvidia.com>
In-Reply-To: <YvKwhrjnFQJ7trT1@nvidia.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 12:21:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgF7K2gSSpy=m_=K3Nov4zaceUX9puQf1TjkTJLA2XC_g@mail.gmail.com>
Message-ID: <CAHk-=wgF7K2gSSpy=m_=K3Nov4zaceUX9puQf1TjkTJLA2XC_g@mail.gmail.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>
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

On Tue, Aug 9, 2022 at 12:09 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>  Since BUG_ON crashes the machine and Linus says that crashing the
>  machine is bad, WARN_ON will also crash the machine if you set the
>  panic_on_warn parameter, so it is also bad, thus we shouldn't use
>  anything.

If you set 'panic_on_warn' you get to keep both pieces when something breaks.

The thing is, there are people who *do* want to stop immediately when
something goes wrong in the kernel.

Anybody doing large-scale virtualization presumably has all the
infrastructure to get debug info out of the virtual environment.

And people who run controlled loads in big server machine setups and
have a MIS department to manage said machines typically also prefer
for a machine to just crash over continuing.

So in those situations, a dead machine is still a dead machine, but
you get the information out, and panic_on_warn is fine, because panic
and reboot is fine.

And yes, that's actually a fairly common case. Things like syzkaller
etc *wants* to abort on the first warning, because that's kind of the
point.

But while that kind of virtualized automation machinery is very very
common, and is a big deal, it's by no means the only deal, and the
most important thing to the point where nothing else matters.

And if you are *not* in a farm, and if you are *not* using
virtualization, a dead machine is literally a useless brick. Nobody
has serial lines on individual machines any more. In most cases, the
hardware literally doesn't even exist any more.

So in that situation, you really cannot afford to take the approach of
"just kill the machine". If you are on a laptop and are doing power
management code, you generally cannot do that in a virtual
environment, and you already have enough problems with suspend and
resume being hard to debug, without people also going "oh, let's just
BUG_ON() and kill the machine".

Because the other side of that "we have a lot of machine farms doing
automated testing" is that those machine farms do not generally find a
lot of the exciting cases.

Almost every single merge window, I end up having to bisect and report
an oops or a WARN_ON(), because I actually run on real hardware. And
said problem was never seen in linux-next.

So we have two very different cases: the "virtual machine with good
logging where a dead machine is fine" - use 'panic_on_warn'. And the
actual real hardware with real drivers, running real loads by users.

Both are valid. But the second case means that BUG_ON() is basically
_never_ valid.

              Linus
