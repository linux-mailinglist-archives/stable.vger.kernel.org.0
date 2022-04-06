Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F8B4F5F77
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 15:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiDFNOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 09:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbiDFNNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 09:13:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB5824BD4C;
        Tue,  5 Apr 2022 20:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C12E86182C;
        Wed,  6 Apr 2022 03:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9887FC385A0;
        Wed,  6 Apr 2022 03:08:14 +0000 (UTC)
Date:   Tue, 5 Apr 2022 23:08:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 000/599] 5.10.110-rc1 review
Message-ID: <20220405230812.2feca4ed@gandalf.local.home>
In-Reply-To: <20220405225212.061852f9@gandalf.local.home>
References: <20220405070258.802373272@linuxfoundation.org>
        <20220406010749.GA1133386@roeck-us.net>
        <20220406023025.GA1926389@roeck-us.net>
        <20220405225212.061852f9@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Apr 2022 22:52:12 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 5 Apr 2022 19:30:25 -0700
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > > s390 tests crashed. Other failed qemu tests did not compile.    
> > 
> > Bisect points to commit 93fe2389e6fd ("tracing: Have TRACE_DEFINE_ENUM
> > affect trace event types as well"). Bisect log attached. Reverting the
> > offending patch fixes the problem. Copying Steven for comments/input.  
> 
> Do you have this commit?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=795301d3c2899
> 

OK, I see what happened. I wrote that patch because a new event appeared
that used enums in the field format that gets exposed to user space. This
patch is only needed for events that do that. Which until this release,
nothing did.

That patch was then flagged as something to backport (but it was never
tagged as stable, so this was one of the "AUTOSEL" backports). And it
should have only been backported if any of these new events were also
backported. Otherwise, the patch is useless.

When this patch was in linux-next, it caused s390 and powerpc to crash. I
found the issue and fixed it with the linked patch above, and even added a
"Fixes" tag to tie the two commits together.

Both of problem patch and the fix went into mainline in the same pull
request.

Here's a thought, if you decide to backport a patch to stable, and you see
that there's another commit with a "Fixes" tag to the automatically
selected commit. DO NOT BACKPORT IF THE FIXES PATCH FAILS TO GO BACK TOO!

This never should have been backported without the fix. Please revert that
patch for any stable release that the fixes patch fails to apply.

-- Steve
