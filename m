Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1334169FA64
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 18:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjBVRsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 12:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjBVRsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 12:48:50 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8365D3C29;
        Wed, 22 Feb 2023 09:48:49 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D37341EC068B;
        Wed, 22 Feb 2023 18:48:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677088127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YYGd1/7vqe10rF+vcDRqtwVcW/I/owGJcKgIDAKClwA=;
        b=RQ8PzH7OFVY1JUBazOB+WDFbSKLYsormUu+IbuEaEexJkr1dzOPfepuU92jthLNYI4IGPe
        UMVW/3cFCVHxaNELouQRnqPtKVwIw4Ksv8TzrJ4hzvB9vQ0QQUNbwdjlUn8iH2akMwjzbZ
        aeolUyAmBOZ22Z794oFfFD2aOYh76Yk=
Date:   Wed, 22 Feb 2023 18:48:41 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/ZVaBKwbWUbF7u+@zn.tnic>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <Y/YJisQdorH1aAKV@zn.tnic>
 <CACYkzJ4cSA5xFScgS=WTc6tPis-vUCtYkh3LyEr8EkXoDCm-uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACYkzJ4cSA5xFScgS=WTc6tPis-vUCtYkh3LyEr8EkXoDCm-uA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 09:16:21AM -0800, KP Singh wrote:
> Thanks for iterating. I think your commit description and rewrite
> omits a few key subtleties which I have tried to reinforce in both the
> commit log and the comments.
> 
> Q: What does STIBP have to do with IBRS?
> A: Setting the IBRS bit implicitly enables STIBP / some form of cross
> thread protection.

That belongs in the docs, if you want to explain this properly.

> Q: Why does it work with eIBRS?
> A: Because we set the IBRS bit once and leave it set when using eIBRS

Also docs.

> I think this subtlety should be reinforced in the commit description
> and code comments so that we don't get it wrong again. Your commit
> does answer this one (thanks!)

Commit messages are fine when explaining *why* a change is being done.
What is even finer is when you put a lenghtier explanation in our
documentation so that people can actually find it. Finding text in
commit messages is harder...

> Q: Why does it not work with the way the kernel currently implements
> legacy IBRS?
> A: Because the kernel clears the bit on returning to user space.

From the commit message:

    However, on return to userspace, the IBRS bit is cleared for performance
    reasons. That leaves userspace threads vulnerable to cross-thread
    predictions influence against which STIBP protects.

> The reason why I refactored this into a separate helper was to
> document the subtleties I mentioned above and anchor them to one place
> as the function is used in 2 places. But this is a maintainer's
> choice, so it's your call :)

The less code gets added in that thing, the better. Not yet another
helper pls.
 
> I do agree with Pawan that it's worth adding a pr_info about what the
> kernel is doing about STIBP.

STIBP status gets dumped through stibp_state().

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
