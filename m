Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BA64E7B73
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiCYWFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 18:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiCYWFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 18:05:11 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679C8139CD4
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 15:03:34 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id qa43so17841392ejc.12
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 15:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3QkuXhB7uf6W60gZWDJ6opx1SFjmEWQp6mnWCLk/yVk=;
        b=V81bw1iGLTqXaYjf0jsGudI2NeIxBtbKHIXsodRWH/kb6aHXXKdpMothCmIcD6Rfoh
         /fz1HWRx8XbZMAnqoaWL21ZRDlx4DYW9SvsheHOi4qGFu+UH1Pw7IcM109+bJ1kvB6MT
         cuSniBp5OIcGWyjJpE0F6/a/QiUmhZEXVvkTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3QkuXhB7uf6W60gZWDJ6opx1SFjmEWQp6mnWCLk/yVk=;
        b=xqJxsemi7FjvQvdHzwgtdu+AfH6a14z/d25QTHnZZP76ysZ7l3dSSVvUZswKZmx7wG
         HDoCbMr6drmV4cIPYkv6K6aE192bQtHK1WjEkh59aayyk6CBxUzvfPqY77B2wN6p3L9o
         CoIN8ztYp+jOiUxpQBOFk/1Y+s3vSiH5ireBXtYxvm9hwURmtEmUfoJlOAXmGj6bffEE
         mdOBWEuummFhexvuVACJgMviyv4BWtY6uEWHFh/G5QUCHypJfSXpzb2bW0mZufVYYxKY
         jg+w4xqyefumtPC4SWNiZHFjaoTT7Oh6OFE1KXwIqPVKoLlBUBOlYFUXNReEMOID1hli
         lztA==
X-Gm-Message-State: AOAM531a4iQ8W5wlEg2CtQmZEtLMKjqgqcJUXrVBbtTlJjMlqug6TsCt
        bZqGT9e/XHTEJ0gPuC+q/JaOPRZcaVgj+59X4mU=
X-Google-Smtp-Source: ABdhPJyVlrb4gRtuuCQZIb63tT6qeIsFzCulqfc5USAJbjyqRPQAYdV9jq1xz2dLKEMnzFkdSE3c7Q==
X-Received: by 2002:a17:907:1c9e:b0:6e0:2fed:869a with SMTP id nb30-20020a1709071c9e00b006e02fed869amr14063450ejc.122.1648245812367;
        Fri, 25 Mar 2022 15:03:32 -0700 (PDT)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id e10-20020a170906748a00b006dfaff31e88sm2826555ejl.125.2022.03.25.15.03.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 15:03:32 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id u3so12543335wrg.3
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 15:03:31 -0700 (PDT)
X-Received: by 2002:a2e:9794:0:b0:249:8488:7dbd with SMTP id
 y20-20020a2e9794000000b0024984887dbdmr9643335lji.176.1648245427344; Fri, 25
 Mar 2022 14:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324055732.GB12078@lst.de> <4386660.LvFx2qVVIh@natalenko.name>
 <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com> <878rsza0ih.fsf@toke.dk>
 <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
 <20220324163132.GB26098@lst.de> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
 <871qyr9t4e.fsf@toke.dk> <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
 <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
 <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
 <298f4f9ccad7c3308d3a1fd8b4b4740571305204.camel@sipsolutions.net>
 <CAHk-=whXAan2ExANMryPSFaBWeyzikPi+fPUseMoVhQAxR7cEA@mail.gmail.com> <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
In-Reply-To: <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 25 Mar 2022 14:56:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJp5xCx0CCrLCzFGZyyABYSNNNa0i=4fN3fBydP7r97w@mail.gmail.com>
Message-ID: <CAHk-=wjJp5xCx0CCrLCzFGZyyABYSNNNa0i=4fN3fBydP7r97w@mail.gmail.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
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

On Fri, Mar 25, 2022 at 2:13 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Well I see now that you said 'cache "writeback"' in (1), and 'flush' in
> (2), so perhaps you were thinking of the same, and I'm just calling it
> "flush" and "invalidate" respectively?

Yeah, so I mentally tend to think of the operations as just
"writeback" (which doesn't invalidate) and "flush" (which is a
writeback-invalidate).

Which explains my word-usage, but isn't great, because it's not
well-defined. And I'm not even consistent about it.

> However, this seems to be the wrong spot to flush (writeback?) the
> cache, as we're trying to get data from the device, not potentially
> overwrite the data that the device wrote because we have a dirty
> cacheline. Hmm. Then again, how could we possibly have a dirty
> cacheline?

So in my model, (1) is the only case where there's actively dirty data
that needs to be written back. That's the "CPU wrote the data to
memory, and wants to transfer it to the device" case.

In (2) and (3), the only question is whether possibly clean cachelines
contain - or will contain - stale data.

And then exactly when you actually invalidate is up to you.

For example, in

 (2) The CPU now wants to see any state written by the device

you have multiple options. You could invalidate any stale cache lines.

Or you could say "We wrote them back and invalidated them in (1), so
we don't need to invalidate them now".

And in

 (3) The CPU looked at the data while it was in flight and is now done with it.

you can (again) decide to do nothing at all, BUT ONLY IF (2) chose
that "invalidate" option. Because if you made your (2) depend on that
"they were already invalidated", then (3) has to invalidate the CPU
caches so that a subsequent (2) will work right.

So these are all somewhat interconnected.

You can do just "writeback" in (1), but then you _have_ to do
"invalidate" in (2), and in that case you don't have to do anything at
all in (3).

Or maybe your CPU only has that "writeback-and-invalidate" operation,
so you decide that (2) should be a no-op, and (3) - which is
presumably less common than (2) - also does that writeback-invalidate
thing.

Or we can also say that (3) is not allowed at all - so the ath9k case
is actively wrong and we should warn about that case - but that again
constrains what you can do in (2) and now that previous optimization
is not valid.

And it's worth noting that if your CPU may do cache fills as a result
of speculative accesses (or just sufficiently out of order), then the
whole argument that "I invalidated those lines earlier, so I don't
need to invalidate them now" is just garbage.

Fun, isn't it?

> Which starts to clarify in my mind why we have a sort of (implied)
> ownership model: if the CPU dirties a cacheline while the device has
> ownership then the cache writeback might overwrite the DMA data.

Right, I think that "if the CPU dirties the cacheline while the device
has ownership, then the data is going to be undefined".

And btw, it does actually potentially happen for real - imagine a user
mmap'ing the IO buffer while IO is in flight. The kernel can't control
for that (well, we can make things read-only, and some uses do), but
then it's often a question of "you have to dirty that area and do the
IO again, because the last attempt sent out undefined data".

And note how this "undefined data" situation can happen even with
coherent IO, so this part isn't even about cache coherency - it's
literally about just about memory accesses being in some undefined
order.

So it *can* be valid to send inconsistent data, but that should be
considered the really odd case.

> So it's
> easier to think of it as "CPU has ownership" and "device has ownership",
> but evidently that simple model breaks down in real-world cases such as
> ath9k where the CPU wants to look, but not write, and the device
> continues doing DMA at the same time.

Yeah, and see above about how the CPU could even write (but honestly,
that isn't valid in the general case, it really requires that kind of
active "we can fix it up later" thing).

> Well if you actually did dirty the cacheline, then you have a bug one
> way or the other, and it's going to be really hard to debug - either you
> lose the CPU write, or you lose the device write, there's no way you're
> not losing one of them?

Again, see above. Losing the CPU write is really bad, because then you
can't even recover by re-doing the operation.

So yes, when looking at only the "single operation" case, it looks
like "lose one or the other". But in the bigger picture, one is more
important than the other.

> So the operations
> (1) dma_sync_single_for_device(DMA_TO_DEVICE)
> (2) dma_sync_single_for_cpu(DMA_FROM_DEVICE)
> (3) dma_sync_single_for_device(DMA_FROM_DEVICE)
>
> really only (1) passes write ownership to the device, but then you can't
> get it back?

Well, you get it back by just checking that the IO is done. Once the
IO is done, the CPU owns the area again.

And the "IO is done" is often some entirely independent status in some
entirely different place.

But it *could* be something that requires a CPU read from that DMA
area. But it's a CPU _read_, so you don't need write ownership for
that.

That's why there is only one DMA_TO_DEVICE, and there are two
DMA_FROM_DEVICE cases.

The DMA_TO_DEVICE cannot have a "let me write in the middle" situation.

But the DMA_FROM_DEVICE has that "let me read in the middle, and
decide if it's done or not", so you can have a looping read, and
that's where (3) comes in.

You can't have a looping write for one operation (but you can
obviously have several independent write operations - that's what the
whole "are you done" is all about)

> But that cannot be true, because ath9k maps the buffer as
> DMA_BIDIRECTIONAL, and then eventually might want to recycle it.

See above. Both cases have "the device is done with this", but they
are fundamentally different situations.

> > That sounds really odd for
> > a "sync" operation. It sounds very reasonable for _allocating_ DMA,
> > but for syncing I'm left scratching my head what the semantics would
> > be.
>
> I agree.
>
> > But yes, if we do and people come up with semantics for it, those
> > semantics should be clearly documented.
>
> I'm not sure? I'm wondering if this isn't just because - like me
> initially - people misunderstood the direction argument, or didn't
> understand it well enough, and then just passed the same value as for
> the map()/unmap()?

Yeah, the solution may well be "grep for it, and pick the right
direction once the docs are clear".

             Linus
