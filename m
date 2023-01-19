Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E0C673CC5
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 15:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjASOt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 09:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjASOtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 09:49:17 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55767AF;
        Thu, 19 Jan 2023 06:49:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 13B49208B8;
        Thu, 19 Jan 2023 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674139754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPS4obwwsmfPtCuVpCuOX+Y34p5KNkQnrFysGNasucA=;
        b=SXEWsqfCR02LELaF+lEocgRPIQEH0/KaC1PeLFzh7CwYvNJYGyNgbf7C47jaQjlRBmjuLv
        lKxNBfOt22gvtIjJqCcTDyk2yxWnOXXwbl22RcLQB+YDfzjm3wxgytxod2acEX+DZgct7i
        XZjWUySRyc/P9OmK2OuXKljEgWSTlH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674139754;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPS4obwwsmfPtCuVpCuOX+Y34p5KNkQnrFysGNasucA=;
        b=0uH9M1oLQ4hpPtsy4jOkl/VNbFm+mHAJY9ZowysrEtElD8Qzzn2wo7oy2HW+PZ/FNC+rUl
        amKX1wOF2qY4A9Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E841E139ED;
        Thu, 19 Jan 2023 14:49:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NTwpOGlYyWPlMQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 19 Jan 2023 14:49:13 +0000
Message-ID: <f58d5183-5dfc-c908-ac9a-baf9339c9387@suse.cz>
Date:   Thu, 19 Jan 2023 15:49:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH for 6.1 regression] mm, mremap: fix mremap() expanding for
 vma's with vm_ops->close()
Content-Language: en-US
To:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Fabian Vogt <fvogt@suse.com>,
        =?UTF-8?Q?Jakub_Mat=c4=9bna?= <matenajakub@gmail.com>,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
References: <20230117101939.9753-1-vbabka@suse.cz>
 <2f03bd25-bfa1-a8fe-558e-ae3ce22b97fa@leemhuis.info>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <2f03bd25-bfa1-a8fe-558e-ae3ce22b97fa@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/19/23 14:37, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
> On 17.01.23 11:19, Vlastimil Babka wrote:
>> Fabian has reported another regression in 6.1 due to ca3d76b0aa80 ("mm:
>> add merging after mremap resize"). The problem is that vma_merge() can
>> fail when vma has a vm_ops->close() method, causing is_mergeable_vma()
>> test to be negative. This was happening for vma mapping a file from
>> fuse-overlayfs, which does have the method. But when we are simply
>> expanding the vma, we never remove it due to the "merge" with the added
>> area, so the test should not prevent the expansion.
>> 
>> As a quick fix, check for such vmas and expand them using vma_adjust()
>> directly as was done before commit ca3d76b0aa80. For a more robust long
>> term solution we should try to limit the check for vma_ops->close only
>> to cases that actually result in vma removal, so that no merge would be
>> prevented unnecessarily.
>> 
>> Reported-by: Fabian Vogt <fvogt@suse.com>
>> Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359#c35
>> Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Jakub Matěna <matenajakub@gmail.com>
>> Cc: <stable@vger.kernel.org>
>> Tested-by: Fabian Vogt <fvogt@suse.com>
>> ---
> 
> Thx for highlighting it and CCing me.
> 
> Quick question: how fast do you think this should head towards mainline?
> 
> The patch landed in next today, so that step in the process is already
> covered. But is the issue serious enough to say "send this to Linus
> after it was a day or two in next, so it can be quickly backported to
> stable"?

I think it's not as serious as the previous one, the conditions should be
more rare. But you made me realize I should probably reply to the "stalls in
qemu" one in that sense. Thanks!

>> Thorsten: this should be added to the previous regression which wasn't
>> fully fixed by the previous patch:
>> https://linux-regtracking.leemhuis.info/regzbot/regression/20221216163227.24648-1-vbabka@suse.cz/
>>  mm/mremap.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>> [...]
> 
> In that case let me just briefly drop a link to the regression, as
> regzbot will notice that and file is as an activity.
> 
> https://lore.kernel.org/lkml/20221216163227.24648-1-vbabka@suse.cz/
> 
> And simply consider your patch submission as a new report I track
> separately:
> 
> #regzbot introduced ca3d76b0aa80 ^
> https://bugzilla.suse.com/show_bug.cgi?id=1206359#c35
> #regzbot title mm, mremap: another issue with mremap not fully fixed
> with the previous fix for the regression
> #regzbot fix: mm, mremap: fix mremap() expanding for vma's with
> vm_ops->close()
> #regzbot ignore-activity
> 
> Not ideal, but that will make sure it's on regzbot radar (where way too
> many dots appear currently, as I'm a bit behind with things... :-/ )
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> If I did something stupid, please tell me, as explained on that page.

