Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE23FF2FC
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 20:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbhIBSIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 14:08:15 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49828 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhIBSIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 14:08:13 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:58308)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mLr7J-002ibM-9l; Thu, 02 Sep 2021 12:07:13 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:32950 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mLr7H-00GUKv-R8; Thu, 02 Sep 2021 12:07:12 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com,
        Alexey Gladkov <legion@kernel.org>
References: <20210901122300.503008474@linuxfoundation.org>
        <20210901122301.773759848@linuxfoundation.org>
        <87v93k4bl6.fsf@disp2133> <YS+s+XL0xXKGwh9a@kroah.com>
        <875yvk1a31.fsf@disp2133> <YTDLyU2mdeoe5cVt@sashalap>
Date:   Thu, 02 Sep 2021 13:06:34 -0500
In-Reply-To: <YTDLyU2mdeoe5cVt@sashalap> (Sasha Levin's message of "Thu, 2 Sep
        2021 09:04:09 -0400")
Message-ID: <875yvizwb9.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mLr7H-00GUKv-R8;;;mid=<875yvizwb9.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX197Mzq0y6e3Lff0lDxcRLSH17zrkIgajvc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong,XM_B_SpammyWords autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4755]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Sasha Levin <sashal@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 536 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.6 (0.9%), b_tie_ro: 3.2 (0.6%), parse: 1.11
        (0.2%), extract_message_metadata: 14 (2.5%), get_uri_detail_list: 3.7
        (0.7%), tests_pri_-1000: 11 (2.0%), tests_pri_-950: 1.06 (0.2%),
        tests_pri_-900: 0.82 (0.2%), tests_pri_-90: 103 (19.3%), check_bayes:
        102 (19.0%), b_tokenize: 7 (1.4%), b_tok_get_all: 7 (1.4%),
        b_comp_prob: 2.4 (0.4%), b_tok_touch_all: 81 (15.1%), b_finish: 0.80
        (0.1%), tests_pri_0: 389 (72.6%), check_dkim_signature: 0.44 (0.1%),
        check_dkim_adsp: 2.5 (0.5%), poll_dns_idle: 1.10 (0.2%), tests_pri_10:
        1.82 (0.3%), tests_pri_500: 6 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 5.10 036/103] ucounts: Increase ucounts reference counter before the security hook
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> On Wed, Sep 01, 2021 at 12:26:10PM -0500, Eric W. Biederman wrote:
>>Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>
>>> On Wed, Sep 01, 2021 at 09:25:25AM -0500, Eric W. Biederman wrote:
>>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>>>
>>>> > From: Alexey Gladkov <legion@kernel.org>
>>>> >
>>>> > [ Upstream commit bbb6d0f3e1feb43d663af089c7dedb23be6a04fb ]
>>>> >
>>>> > We need to increment the ucounts reference counter befor security_prepare_creds()
>>>> > because this function may fail and abort_creds() will try to decrement
>>>> > this reference.
>>>>
>>>> Has the conversion of the rlimits to ucounts been backported?
>>>>
>>>> Semantically the code is an improvement but I don't know of any cases
>>>> where it makes enough of a real-world difference to make it worth
>>>> backporting the code.
>>>>
>>>> Certainly the ucount/rlimit conversions do not meet the historical
>>>> criteria for backports.  AKA simple obviously correct patches.
>>>>
>>>> The fact we have been applying fixes for the entire v5.14 stabilization
>>>> period is a testament to the code not quite being obviously correct.
>>>>
>>>> Without backports the code only affects v5.14 so I have not been
>>>> including a Cc stable on any of the commits.
>>>>
>>>> So color me very puzzled about what is going on here.
>>>
>>> Sasha picked this for some reason, but if you think it should be
>>> dropped, we can easily do so.
>>
>>My question is what is the reason Sasha picked this up?
>>
>>If this patch even applies to v5.10 the earlier patches have been
>>backported.  So we can't just drop this patch.  Either the earlier
>>backports need to be reverted, or we need to make certain all of the
>>patches are backported.
>>
>>I really am trying to understand what is going on and why.
>
> I'll happily explain. The commit message is telling us that:
>
> 1. There is an issue uncovered by syzbot which this patch fixes:
>
> 	"Reported-by: syzbot"
>
> 2. The issue was introduced in 905ae01c4ae2 ("Add a reference to ucounts
> for each cred"):
>
> 	"Fixes: 905ae01c4ae2"
>
> Since 905ae01c4ae2 exist in 5.10, and this patch seemed to fix an issue,
> I've queued it up.

Which begs the question as Alex mentioned how did 905ae01c4ae2 get into
5.10, as it was merged to Linus's tree in the merge window for 5.14.

> In general, if we're missing backports, backported something only
> partially and should revert it, or anything else that might cause an
> issue, we'd be more than happy to work with you to fix it up.
>
> All the patches we queue up get multiple rounds of emails and reviews,
> if there is a better way to solicit reviews so that we won't up in a
> place where you haven't noticed something going in earlier we'd be more
> than happy to improve that process too.

I have the bad feeling that 905ae01c4ae2 was backported because it was a
prerequisite to something with a Fixes tag.

Fixes tags especially in this instance don't mean code needs to go to
stable Fixes tags mean that a bug was fixed.  Since I thought the code
only existed in Linus's tree, I haven't been adding Cc stable or even
thinking about earlier kernels with respect to this code.

I honestly can't keep up with the level of review needed for patches
targeting Linus's tree.  So I occasionally glance at patches destined
for the stable tree.

Most of the time it is something being backported without a stable tag,
but with a fixes tag, that is unnecessary but generally harmless so I
ignore it.

In this instance it looks like a whole new feature that has had a rocky
history and a lot of time to stablize is somehow backported to 5.10 and
5.13.  I think all of the known issues are addressed but I won't know
if all of the issues syzkaller can find are found for another couple of
weeks.

Because this code was not obviously correct, because this code did not
have a stable tag, because I am not even certain it is stable yet,
I am asking do you know how this code that feels to me like feature work
wound up being backported?  AKA why is 905ae01c4ae2 in 5.10 and 5.13.

Eric
