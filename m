Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD6119C1E0
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 15:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388510AbgDBNO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 09:14:28 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49380 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388504AbgDBNO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 09:14:28 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jJzfp-00075I-T0; Thu, 02 Apr 2020 07:14:21 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jJzfj-00021V-6R; Thu, 02 Apr 2020 07:14:21 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jann Horn <jannh@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Adam Zabrocki <pi3@pi3.com.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
        <87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
        <CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
        <CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
        <CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
        <CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
        <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
Date:   Thu, 02 Apr 2020 08:11:31 -0500
In-Reply-To: <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 1 Apr 2020 19:05:59 -0700")
Message-ID: <877dyym3r0.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jJzfj-00021V-6R;;;mid=<877dyym3r0.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/aAgD/0VF7hya1cN9dZdOTpz/w8uomdK0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,NO_DNS_FOR_FROM,T_TM2_M_HEADER_IN_MSG
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4987]
        *  0.0 NO_DNS_FOR_FROM DNS: Envelope sender has no MX or A DNS records
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 6259 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 4.6 (0.1%), b_tie_ro: 3.2 (0.1%), parse: 1.03
        (0.0%), extract_message_metadata: 11 (0.2%), get_uri_detail_list: 0.70
        (0.0%), tests_pri_-1000: 4.0 (0.1%), tests_pri_-950: 1.01 (0.0%),
        tests_pri_-900: 0.88 (0.0%), tests_pri_-90: 83 (1.3%), check_bayes: 82
        (1.3%), b_tokenize: 5 (0.1%), b_tok_get_all: 6 (0.1%), b_comp_prob:
        1.59 (0.0%), b_tok_touch_all: 66 (1.0%), b_finish: 0.79 (0.0%),
        tests_pri_0: 6143 (98.1%), check_dkim_signature: 0.51 (0.0%),
        check_dkim_adsp: 5997 (95.8%), poll_dns_idle: 5993 (95.7%),
        tests_pri_10: 1.70 (0.0%), tests_pri_500: 6 (0.1%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> tasklist_lock is aboue the hottest lock there is in all of the kernel.

Do you know code paths you see tasklist_lock being hot?

I am looking at some of the exec/signal/ptrace code paths because they
get subtle corner case wrong like a threaded exec deadlocking when
straced.

If the performance problems are in the same neighbourhood I might be
able to fix those problems while I am in the code.

Eric



