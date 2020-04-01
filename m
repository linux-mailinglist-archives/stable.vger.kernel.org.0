Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9130019B767
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 23:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732742AbgDAVGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 17:06:04 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38318 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732337AbgDAVGE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 17:06:04 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jJkYl-0004ja-6c; Wed, 01 Apr 2020 15:06:03 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jJkYk-0006fM-EY; Wed, 01 Apr 2020 15:06:03 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Adam Zabrocki <pi3@pi3.com.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
        <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
        <CAHk-=wihrtjjSsF6mGc7wjrtVQ-pha9ZAeo1rQAeuO1hr+i1qw@mail.gmail.com>
Date:   Wed, 01 Apr 2020 16:03:20 -0500
In-Reply-To: <CAHk-=wihrtjjSsF6mGc7wjrtVQ-pha9ZAeo1rQAeuO1hr+i1qw@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 1 Apr 2020 13:55:11 -0700")
Message-ID: <87sghmnckn.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jJkYk-0006fM-EY;;;mid=<87sghmnckn.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+c7hhxNri2jefkPydPIS+82k6pfB21yV8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 389 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (2.7%), b_tie_ro: 9 (2.4%), parse: 0.71 (0.2%),
         extract_message_metadata: 12 (3.2%), get_uri_detail_list: 0.65 (0.2%),
         tests_pri_-1000: 23 (5.8%), tests_pri_-950: 1.22 (0.3%),
        tests_pri_-900: 0.99 (0.3%), tests_pri_-90: 87 (22.4%), check_bayes:
        86 (22.0%), b_tokenize: 4.8 (1.2%), b_tok_get_all: 6 (1.5%),
        b_comp_prob: 1.63 (0.4%), b_tok_touch_all: 70 (18.0%), b_finish: 0.89
        (0.2%), tests_pri_0: 239 (61.5%), check_dkim_signature: 0.45 (0.1%),
        check_dkim_adsp: 2.3 (0.6%), poll_dns_idle: 0.75 (0.2%), tests_pri_10:
        3.1 (0.8%), tests_pri_500: 9 (2.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Apr 1, 2020 at 1:50 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> I have updated the update of exec_id on exec to use WRITE_ONCE
>> and the read of exec_id in do_notify_parent to use READ_ONCE
>> to make it clear that there is no locking between these two
>> locations.
>
> Ack, makes sense to me.
>
> Just put it in your branch, this doesn't look urgent, considering that
> it's something that has been around forever.

Done

Eric
