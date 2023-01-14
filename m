Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D8266AA09
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 09:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjANIIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 03:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjANIIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 03:08:40 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBF83AA7;
        Sat, 14 Jan 2023 00:08:36 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 207so1619112pfv.5;
        Sat, 14 Jan 2023 00:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lZpVju+c3esZJi64lpN19QBiN5Ioh9BTNl6Imk6TaQ8=;
        b=YDkbWirrjszTbCxF/w/+kgQBI26iQK/PpN2Pj1Xd/qpJUr7uC2C4Umt1nkDmVNgYL5
         +9EUfTmXyOCKO0w5Vcz+epHNUSG0dYzldYoPrNt3zofsDpl8OqfyLXstSE83vcrQrp/R
         fcm99IgQuqOctaqqAvPUkEpTaPp5ihSVcF/ltgxGCuOLMAeOpc9JFZP7zTl3f/iDX3ok
         EEdVj7+U+7o3c1Q/R59Vmm8ZK2QLM0qTgw68UfqgcYzLsF/pUDLgnctlcFqNdgVAXeih
         B5+mRish2KwjD7u7UO7r3lOyM9OmYRPjZefar17SYM27x2c0wZSnkvLu9kM7i5fUKwvs
         lRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lZpVju+c3esZJi64lpN19QBiN5Ioh9BTNl6Imk6TaQ8=;
        b=0WVsymijaNQoFrIyhavW0yE9DCOAeQkLVnmiV+GPd80TfZd7H20fRJ/6jVmKvgxEvc
         2bu1H98SZ+49SDwVOUrlCLD9ks2V7R9SPH4Y7hkXv0SIC/mWx8WnGv5odKtax5DzCh/I
         qNTnlAryj5GB/4kRC2ZbUwilFBoco/KktqfE2i0kaXjaz5oez9Ts9asUY27GR6e4Bfrg
         p1Aa1loTFdGUVT3SZwLtwUfgz8u/+DjEYb/k/3P5Rxbh+U/Zxugovtqagh9WRhA3a+Ju
         TKPXC1uDt2MrjZ3wvzPDp6PPLe8VxQjT8viLCeIDIMIuCVroGlvm6wvJsm9ugwh3sOwq
         1Uvw==
X-Gm-Message-State: AFqh2kqZNQvCoAgEUQ5+I4n4kbRHksHGjc88z91bDtbGVh4SM4Kphn7u
        z3BTcR9Bt/eoQBNMzuC6XkF4hZ93rcnCwyRRx8Y=
X-Google-Smtp-Source: AMrXdXsQsL3B/zYKPN9dUrbznfzAi6Xw7QwAsjh0FukLj4SuwnfW4cuGgva6gqrtIhvo+T9gnxMqe+jDFz37FYZX5gc=
X-Received: by 2002:a63:ee0f:0:b0:4a5:c88:55c2 with SMTP id
 e15-20020a63ee0f000000b004a50c8855c2mr2584926pgi.530.1673683715615; Sat, 14
 Jan 2023 00:08:35 -0800 (PST)
MIME-Version: 1.0
References: <20230113173345.9692-1-vbabka@suse.cz> <3e419e8e-cdd7-eaf5-0572-ae5c44d7b68e@suse.cz>
In-Reply-To: <3e419e8e-cdd7-eaf5-0572-ae5c44d7b68e@suse.cz>
From:   Pedro Falcato <pedro.falcato@gmail.com>
Date:   Sat, 14 Jan 2023 08:08:24 +0000
Message-ID: <CAKbZUD2SDT8afg9k2jOhXCU8W64j__1DGTcXNxbzS-=j+-4HPg@mail.gmail.com>
Subject: Re: [PATCH for 6.1 regression] Revert "mm/compaction: fix set skip in fast_find_migrateblock"
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        regressions@leemhuis.info, Jiri Slaby <jirislaby@kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Chuyi Zhou <zhouchuyi@bytedance.com>, stable@vger.kernel.org
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

On Sat, Jan 14, 2023 at 6:51 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 1/13/23 18:33, Vlastimil Babka wrote:
> > This reverts commit 7efc3b7261030da79001c00d92bc3392fd6c664c.
> >
> > We have got openSUSE reports (Link 1) for 6.1 kernel with khugepaged
> > stalling CPU for long periods of time. Investigation of tracepoint data
> > shows that compaction is stuck in repeating fast_find_migrateblock()
> > based migrate page isolation, and then fails to migrate all isolated
> > pages. Commit 7efc3b726103 ("mm/compaction: fix set skip in
> > fast_find_migrateblock") was suspected as it was merged in 6.1 and in
> > theory can indeed remove a termination condition for
> > fast_find_migrateblock() under certain conditions, as it removes a place
> > that always marks a scanned pageblock from being re-scanned. There are
> > other such places, but those can be skipped under certain conditions,
> > which seems to match the tracepoint data.
> >
> > Testing of revert also appears to have resolved the issue, thus revert
> > the commit until a more robust solution for the original problem is
> > developed.
> >
> > It's also likely this will fix qemu stalls with 6.1 kernel reported in
> > Link 2, but that is not yet confirmed.
> >
> > Link: https://bugzilla.suse.com/show_bug.cgi?id=1206848
> > Link: https://lore.kernel.org/kvm/b8017e09-f336-3035-8344-c549086c2340@kernel.org/
> > Fixes: 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
> > Cc: <stable@vger.kernel.org>
>
> Oops, forgot:
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>
> > ---
> >  mm/compaction.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index ca1603524bbe..8238e83385a7 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -1839,6 +1839,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
> >                                       pfn = cc->zone->zone_start_pfn;
> >                               cc->fast_search_fail = 0;
> >                               found_block = true;
> > +                             set_pageblock_skip(freepage);
> >                               break;
> >                       }
> >               }
>

Vlastimil,

Thank you so much for looking into this. I've been daily driving it
for the past half day and it seems to have fixed my QEMU issues.
Of course, I don't have exactly a test suite for this but I've tried
everything and I can't get any of the original problems to show up.

That being said,
Tested-by: Pedro Falcato <pedro.falcato@gmail.com>

I'll report back if QEMU freezes the system again.

-- 
Pedro
