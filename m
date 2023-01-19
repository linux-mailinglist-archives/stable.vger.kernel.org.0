Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD0B673A76
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 14:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjASNhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 08:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjASNha (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 08:37:30 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B36798E6;
        Thu, 19 Jan 2023 05:37:28 -0800 (PST)
Received: from [2a02:8108:963f:de38:4bc7:2566:28bd:b73c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pIV6d-0005xG-34; Thu, 19 Jan 2023 14:37:27 +0100
Message-ID: <2f03bd25-bfa1-a8fe-558e-ae3ce22b97fa@leemhuis.info>
Date:   Thu, 19 Jan 2023 14:37:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH for 6.1 regression] mm, mremap: fix mremap() expanding for
 vma's with vm_ops->close()
Content-Language: en-US, de-DE
To:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        regressions@lists.linux.dev, Fabian Vogt <fvogt@suse.com>,
        =?UTF-8?Q?Jakub_Mat=c4=9bna?= <matenajakub@gmail.com>,
        stable@vger.kernel.org
References: <20230117101939.9753-1-vbabka@suse.cz>
From:   "Linux kernel regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
In-Reply-To: <20230117101939.9753-1-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1674135449;23863f40;
X-HE-SMSGID: 1pIV6d-0005xG-34
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.01.23 11:19, Vlastimil Babka wrote:
> Fabian has reported another regression in 6.1 due to ca3d76b0aa80 ("mm:
> add merging after mremap resize"). The problem is that vma_merge() can
> fail when vma has a vm_ops->close() method, causing is_mergeable_vma()
> test to be negative. This was happening for vma mapping a file from
> fuse-overlayfs, which does have the method. But when we are simply
> expanding the vma, we never remove it due to the "merge" with the added
> area, so the test should not prevent the expansion.
> 
> As a quick fix, check for such vmas and expand them using vma_adjust()
> directly as was done before commit ca3d76b0aa80. For a more robust long
> term solution we should try to limit the check for vma_ops->close only
> to cases that actually result in vma removal, so that no merge would be
> prevented unnecessarily.
> 
> Reported-by: Fabian Vogt <fvogt@suse.com>
> Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359#c35
> Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jakub Matěna <matenajakub@gmail.com>
> Cc: <stable@vger.kernel.org>
> Tested-by: Fabian Vogt <fvogt@suse.com>
> ---

Thx for highlighting it and CCing me.

Quick question: how fast do you think this should head towards mainline?

The patch landed in next today, so that step in the process is already
covered. But is the issue serious enough to say "send this to Linus
after it was a day or two in next, so it can be quickly backported to
stable"?

> Thorsten: this should be added to the previous regression which wasn't
> fully fixed by the previous patch:
> https://linux-regtracking.leemhuis.info/regzbot/regression/20221216163227.24648-1-vbabka@suse.cz/
>  mm/mremap.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> [...]

In that case let me just briefly drop a link to the regression, as
regzbot will notice that and file is as an activity.

https://lore.kernel.org/lkml/20221216163227.24648-1-vbabka@suse.cz/

And simply consider your patch submission as a new report I track
separately:

#regzbot introduced ca3d76b0aa80 ^
https://bugzilla.suse.com/show_bug.cgi?id=1206359#c35
#regzbot title mm, mremap: another issue with mremap not fully fixed
with the previous fix for the regression
#regzbot fix: mm, mremap: fix mremap() expanding for vma's with
vm_ops->close()
#regzbot ignore-activity

Not ideal, but that will make sure it's on regzbot radar (where way too
many dots appear currently, as I'm a bit behind with things... :-/ )

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
