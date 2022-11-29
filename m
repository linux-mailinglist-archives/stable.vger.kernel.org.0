Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A07963BAAE
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 08:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiK2H1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 02:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiK2H1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 02:27:49 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0805658E;
        Mon, 28 Nov 2022 23:27:43 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id n1so11133355ljg.3;
        Mon, 28 Nov 2022 23:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Dml/9oHSBXGehrKnQ+3841cy9PRAO3te2e2VG2uxHo=;
        b=WZQgZtIUnwuDmYfEvqbeiYn1nnpt8Jglx/AnzAGEOmD+sBPAfVOx7BH15zZnCkaFMl
         HsfeiHm9/eQ6O60b208LOFn9nADQLqwkGMqtaHo+Qp34bs5vHEy1Wn+8iNT1CY/vxQnT
         yRyAUf1IRnaOXFfS2bmok/asWkH/qvsbOFM62HeHcLb/y6tNhp9iceyJTB8kl2oxDy4V
         7YU8ps9ymdw8MpkkoE/FnLG2G7RYJkOSx7w7qKP9qH5kazV/v7GC6QsjsqxTx8MTx/i9
         2OxhkE1helxVW1ZHPr1EjG+a2TKET/48S+nTqO4ihjn1TrUPCYvQjL15Hymo3ALiJLMt
         LDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Dml/9oHSBXGehrKnQ+3841cy9PRAO3te2e2VG2uxHo=;
        b=xJDeuY1dbYQsyfwXuCtuB2sF5b62B+eTHdMWhvAzsgyh4kQ61jhuHxs/+Yb5jTM0IN
         E/muZt1hwEFm62EDkbrmmHEoKf/dWSxYl1Zi1DybbO6jCgKhnngPgjDhF/XMdLz2LkFV
         Nc9TgIVvxnN4JU9OqW2o/cqNUO8lMq2Uo2JJiBanSH2R2EYOls9vlvOHtDjz2hyFCwv2
         qeCOO1pP6HNPzHkmpsv9uyTVRGfqXVkKYXSZGKDTj6QdCzYbfROF2jB2Vbb28xbi9pwX
         TA6yVDX433n8QvqzqxnQIjSNy/UIo44zhlzZ7vfvjI5+h/aWsuLjUegwa3U1IM186Qbz
         Xrag==
X-Gm-Message-State: ANoB5pmFaPmItl2q8cchDoacs9u2jIpuzW6Ghc1db6wirK/LLxe9RaH9
        +JI/+GUSgxcYEWH7okbQk88=
X-Google-Smtp-Source: AA0mqf71GEWjA8mSSRLO0geez5HHzxBweLm/s/a+C2ApS7gQ3ym3YutcxieyZEjK73o+1tKF8LLKyw==
X-Received: by 2002:a2e:9789:0:b0:277:41d:6c1e with SMTP id y9-20020a2e9789000000b00277041d6c1emr17031603lji.330.1669706861528;
        Mon, 28 Nov 2022 23:27:41 -0800 (PST)
Received: from grain.localdomain ([5.18.253.97])
        by smtp.gmail.com with ESMTPSA id s30-20020a05651c201e00b0026df5232c7fsm1453905ljo.42.2022.11.28.23.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 23:27:40 -0800 (PST)
Received: by grain.localdomain (Postfix, from userid 1000)
        id D07395A0020; Tue, 29 Nov 2022 10:27:39 +0300 (MSK)
Date:   Tue, 29 Nov 2022 10:27:39 +0300
From:   Cyrill Gorcunov <gorcunov@gmail.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Andrei Vagin <avagin@gmail.com>, kernel@collabora.com,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: set the vma flags dirty before testing if it is
 mergeable
Message-ID: <Y4W0axw0ZgORtfkt@grain>
References: <20221122115007.2787017-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122115007.2787017-1-usama.anjum@collabora.com>
User-Agent: Mutt/2.2.7 (2022-08-07)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 22, 2022 at 04:50:07PM +0500, Muhammad Usama Anjum wrote:
> The VM_SOFTDIRTY should be set in the vma flags to be tested if new
> allocation should be merged in previous vma or not. With this patch,
> the new allocations are merged in the previous VMAs.

Hi Muhammad! Thanks for the patch and sorry for late reply. Here is a moment
I don't understand -- when we test for vma merge we use is_mergeable_vma() helper
which excludes VM_SOFTDIRTY flag from comarision, so setting this flag earlier
should not change the behaviour. Or I miss something obvious?

> I've tested it by reverting the commit 34228d473efe ("mm: ignore
> VM_SOFTDIRTY on VMA merging") and after adding this following patch,
> I'm seeing that all the new allocations done through mmap() are merged
> in the previous VMAs. The number of VMAs doesn't increase drastically
> which had contributed to the crash of gimp. If I run the same test after
> reverting and not including this patch, the number of VMAs keep on
> increasing with every mmap() syscall which proves this patch.

The is_mergeable_vma is key function here, either we should setup VM_SOFTDIRTY
explicitly as your patch does and drop VM_SOFTDIRTY from is_mergeable_vma,
or we continue excluding this flag in such low level helper as is.

> The commit 34228d473efe ("mm: ignore VM_SOFTDIRTY on VMA merging")
> seems like a workaround. But it lets the soft-dirty and non-soft-dirty
> VMA to get merged. It helps in avoiding the creation of too many VMAs.
> But it creates the problem while adding the feature of clearing the
> soft-dirty status of only a part of the memory region.

So you need an extended functionality, could you please put this
changelog snippet somewhere on top? Otherwise srat reading this patch
I simply didn't get what we're trying to achieve.

> 
> Cc: <stable@vger.kernel.org>
> Fixes: d9104d1ca966 ("mm: track vma changes with VM_SOFTDIRTY bit")

Wait, is there some critical bug or error that needs stable@ to be
patched? The way softdirty has been implemented in first place is
to reach minimum needs for dirty page tracking. More precise tracking
(such as partial cleanup of memory region) will require at least other
structures to remember which part of vma is cleared and which one is
dirty after their merge. And I don't think this is possible to implement
without extending vma structure itself (which is big enough already).

Or maybe I'm blind and not see obvious problem here, sorry then :)

> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> We need more testing of this patch.
> 
> While implementing clear soft-dirty bit for a range of address space, I'm
> facing an issue. The non-soft dirty VMA gets merged sometimes with the soft
> dirty VMA. Thus the non-soft dirty VMA become dirty which is undesirable.
>
> When discussed with the some other developers they consider it the
> regression. Why the non-soft dirty page should appear as soft dirty when it
> isn't soft dirty in reality? I agree with them. Should we revert
> 34228d473efe or find a workaround in the IOCTL?

Well, this is not the regression, it is been designed this way because
there is no place to keep subflags on regions covered by one VMA and non
merging them cause vma fragmentation (I've seen massive vma fragmentations
especially in db engines). So no, reverting it is not an option but rather
will cause problems in real applications I fear.

> 
> * Revert may cause the VMAs to expand in uncontrollable situation where the
> soft dirty bit of a lot of memory regions or the whole address space is
> being cleared again and again. AFAIK normal process must either be only
> clearing a few memory regions. So the applications should be okay. There is
> still chance of regressions if some applications are already using the
> soft-dirty bit. I'm not sure how to test it.

Main purpose of this dirty functionality came from containers c/r procedure.
As far as I remember we've been clearing vmas for the whole container, though
it's been a while and i'm not involved into c/r development right now so may
miss something from my memory.

> * Add a flag in the IOCTL to ignore the dirtiness of VMA. The user will
> surely lose the functionality to detect reused memory regions. But the
> extraneous soft-dirty pages would not appear. I'm trying to do this in the
> patch series [1]. Some discussion is going on that this fails with some
> mprotect use case [2]. I still need to have a look at the mprotect selftest
> to see how and why this fails. I think this can be implemented after some
> more work probably in mprotect side.

ioctl might be an option indeed

> 
> [1] https://lore.kernel.org/all/20221109102303.851281-1-usama.anjum@collabora.com/
> [2] https://lore.kernel.org/all/bfcae708-db21-04b4-0bbe-712badd03071@redhat.com/
