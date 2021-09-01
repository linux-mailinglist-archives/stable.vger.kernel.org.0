Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63213FE11D
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 19:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344594AbhIAR1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 13:27:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48834 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344419AbhIAR1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 13:27:17 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:36124)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mLU0C-00BPFm-40; Wed, 01 Sep 2021 11:26:20 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:50202 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mLU0A-00E0Lo-Ry; Wed, 01 Sep 2021 11:26:19 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+01985d7909f9468f013c@syzkaller.appspotmail.com,
        Alexey Gladkov <legion@kernel.org>,
        Sasha Levin <sashal@kernel.org>
In-Reply-To: <YS+s+XL0xXKGwh9a@kroah.com> (Greg Kroah-Hartman's message of
        "Wed, 1 Sep 2021 18:40:25 +0200")
References: <20210901122300.503008474@linuxfoundation.org>
        <20210901122301.773759848@linuxfoundation.org>
        <87v93k4bl6.fsf@disp2133> <YS+s+XL0xXKGwh9a@kroah.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Wed, 01 Sep 2021 12:26:10 -0500
Message-ID: <875yvk1a31.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mLU0A-00E0Lo-Ry;;;mid=<875yvk1a31.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19f0m9OYwI8n0/+ppm82Kvgc8OcOnANoWU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=8.0 tests=ALL_TRUSTED,BAYES_40,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3799]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 416 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 11 (2.5%), b_tie_ro: 9 (2.2%), parse: 0.90 (0.2%),
         extract_message_metadata: 10 (2.5%), get_uri_detail_list: 1.61 (0.4%),
         tests_pri_-1000: 12 (2.9%), tests_pri_-950: 1.12 (0.3%),
        tests_pri_-900: 0.87 (0.2%), tests_pri_-90: 79 (19.0%), check_bayes:
        78 (18.7%), b_tokenize: 6 (1.4%), b_tok_get_all: 8 (1.8%),
        b_comp_prob: 2.4 (0.6%), b_tok_touch_all: 59 (14.3%), b_finish: 0.76
        (0.2%), tests_pri_0: 287 (69.1%), check_dkim_signature: 0.56 (0.1%),
        check_dkim_adsp: 2.5 (0.6%), poll_dns_idle: 0.82 (0.2%), tests_pri_10:
        2.1 (0.5%), tests_pri_500: 8 (1.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 5.10 036/103] ucounts: Increase ucounts reference counter before the security hook
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Sep 01, 2021 at 09:25:25AM -0500, Eric W. Biederman wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> 
>> > From: Alexey Gladkov <legion@kernel.org>
>> >
>> > [ Upstream commit bbb6d0f3e1feb43d663af089c7dedb23be6a04fb ]
>> >
>> > We need to increment the ucounts reference counter befor security_prepare_creds()
>> > because this function may fail and abort_creds() will try to decrement
>> > this reference.
>> 
>> Has the conversion of the rlimits to ucounts been backported?
>> 
>> Semantically the code is an improvement but I don't know of any cases
>> where it makes enough of a real-world difference to make it worth
>> backporting the code.
>> 
>> Certainly the ucount/rlimit conversions do not meet the historical
>> criteria for backports.  AKA simple obviously correct patches.
>> 
>> The fact we have been applying fixes for the entire v5.14 stabilization
>> period is a testament to the code not quite being obviously correct.
>> 
>> Without backports the code only affects v5.14 so I have not been
>> including a Cc stable on any of the commits.
>> 
>> So color me very puzzled about what is going on here.
>
> Sasha picked this for some reason, but if you think it should be
> dropped, we can easily do so.

My question is what is the reason Sasha picked this up?

If this patch even applies to v5.10 the earlier patches have been
backported.  So we can't just drop this patch.  Either the earlier
backports need to be reverted, or we need to make certain all of the
patches are backported.

I really am trying to understand what is going on and why.

I work on a lot of stuff that has been imperfect for years.  Generally I
clean up the code and the semantics so the old imperfect code does not
impede new development (user or kernel).  Updating a couple of rlimits
to the ucount infrastructure was one of those improvements to imperfect
code.

As I expect this situation to come up again and again, I am asking what
is going on?  What are the rules under which code is backported?

I am hoping to get a clear answer on why what looks to me like feature
development has been backported into v5.10, and v5.13.


If the answer is going to be random commits are going to be backported
whenever the stable reviewers think it is a good idea, with no
explanation of why they think so, can I please not be Cc'd during stable
review as I have no basis on which to perform a review.

Eric
