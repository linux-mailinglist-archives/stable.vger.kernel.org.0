Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2976969FC5F
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 20:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjBVTmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 14:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbjBVTmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 14:42:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061B93B87B
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 11:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2ECCB812A7
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 19:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6102FC433EF
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 19:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677094953;
        bh=vl0l+s6Au0VrCtGm/qqHU/k7GVH6k2EtTrSSl0Zhot0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Yk+DlKsiRE7rGOCKMcCbNlDGXkQwNGhHhS3qB7cXl7+ma0lsx+0Oh0CO4oqYLM85f
         uQBF38sle1jARH+1oUArrynMRWXUPA0PGoPXP05LLigHitm7xMBwS0k18U9SVjOynt
         QTo788wbKbeaAQ38E86o3WKKcYWOlB1QHmiiV2T1vMuZos1nPkUgc7MDd7lZ5sph5K
         h5o84NGOZN3p6fr15f10t1joOhD/KXzeHuBtyYbE/gI2wYudN13QlJqlGeBhV45DiV
         9tILw5ICf5LQh9PsxWGUBM24qmH7sMq2niohlSYYbI4n4XY9L6QcOv5wIcVCgIZJM/
         1MNzkFAP/97vQ==
Received: by mail-lj1-f169.google.com with SMTP id t14so6287574ljd.5
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 11:42:33 -0800 (PST)
X-Gm-Message-State: AO0yUKXXxhC8QKub1JWRMA6vewayjxIhRtfINizUspLjX2HeUa1/iO15
        5d4ItoIHXbYeEWZPLeo965P/YyBlAJHX204c7K+gig==
X-Google-Smtp-Source: AK7set+EnDQ5ZGD9YF1803eOIardxXn8qqmslC28OZkVXj4gOrukCpvFPR+mCaohzwS1cm99m6zxj6fd/cGZXNhTiTo=
X-Received: by 2002:a17:906:938b:b0:8a5:c8bd:4ac4 with SMTP id
 l11-20020a170906938b00b008a5c8bd4ac4mr7737884ejx.15.1677094930921; Wed, 22
 Feb 2023 11:42:10 -0800 (PST)
MIME-Version: 1.0
References: <20230221184908.2349578-1-kpsingh@kernel.org> <Y/YJisQdorH1aAKV@zn.tnic>
 <CACYkzJ4cSA5xFScgS=WTc6tPis-vUCtYkh3LyEr8EkXoDCm-uA@mail.gmail.com> <Y/ZVaBKwbWUbF7u+@zn.tnic>
In-Reply-To: <Y/ZVaBKwbWUbF7u+@zn.tnic>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 22 Feb 2023 11:41:59 -0800
X-Gmail-Original-Message-ID: <CACYkzJ4WigzaOCR4V9=e60ka=NNncWRB-j78DLRuzdSOZXvwrA@mail.gmail.com>
Message-ID: <CACYkzJ4WigzaOCR4V9=e60ka=NNncWRB-j78DLRuzdSOZXvwrA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy IBRS
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?UTF-8?Q?Jos=C3=A9_Oliveira?= <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 9:48 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Feb 22, 2023 at 09:16:21AM -0800, KP Singh wrote:
> > Thanks for iterating. I think your commit description and rewrite
> > omits a few key subtleties which I have tried to reinforce in both the
> > commit log and the comments.
> >
> > Q: What does STIBP have to do with IBRS?
> > A: Setting the IBRS bit implicitly enables STIBP / some form of cross
> > thread protection.
>
> That belongs in the docs, if you want to explain this properly.
>
> > Q: Why does it work with eIBRS?
> > A: Because we set the IBRS bit once and leave it set when using eIBRS
>
> Also docs.
>
> > I think this subtlety should be reinforced in the commit description
> > and code comments so that we don't get it wrong again. Your commit
> > does answer this one (thanks!)
>
> Commit messages are fine when explaining *why* a change is being done.
> What is even finer is when you put a lenghtier explanation in our
> documentation so that people can actually find it. Finding text in
> commit messages is harder...

Sure, I think the docs do already cover it, but I sort of disagree
with your statement around the commit message. I feel the more context
you can add in the commit message, the better it is. When I am looking
at the change log, it would be helpful to have the information that I
mentioned in the Q&A. Small things like, "eIBRS needs the IBRS bit set
which also enables cross-thread protections" is a very important
context for this patch IMHO. Without this one is just left head
scratching and scrambling to read lengthy docs and processor manuals.

But again, totally your call. Others, feel free to chime in.

>
> > Q: Why does it not work with the way the kernel currently implements
> > legacy IBRS?
> > A: Because the kernel clears the bit on returning to user space.
>
> From the commit message:
>
>     However, on return to userspace, the IBRS bit is cleared for performance
>     reasons. That leaves userspace threads vulnerable to cross-thread
>     predictions influence against which STIBP protects.

This sort of loosely implies that the IBRS bit also enables
cross-thread protections. Can you atleast add this one explicitly?

"Setting the IBRS bit also enables cross thread protections"

>
> > The reason why I refactored this into a separate helper was to
> > document the subtleties I mentioned above and anchor them to one place
> > as the function is used in 2 places. But this is a maintainer's
> > choice, so it's your call :)
>
> The less code gets added in that thing, the better. Not yet another
> helper pls.

Sure, your call.

>
> > I do agree with Pawan that it's worth adding a pr_info about what the
> > kernel is doing about STIBP.
>
> STIBP status gets dumped through stibp_state().

Not at the stage when the kernel decides to drop the STIBP protection
when eIBRS is enabled. If we had this information when we had a
positive POC, it would have been much easier to figure out what's
going on here.

- KP

>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
