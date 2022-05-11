Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C3A523BC3
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 19:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345728AbiEKRl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 13:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245572AbiEKRlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 13:41:55 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2087521A953;
        Wed, 11 May 2022 10:41:53 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:39398)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1noqLQ-00FuHr-O2; Wed, 11 May 2022 11:41:52 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37824 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1noqLO-001d7U-Ly; Wed, 11 May 2022 11:41:52 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-arch@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?utf-8?B?0JzQsNC60YHQuNC8INCa0YPRgtGP0LLQuNC9?= 
        <maximkabox13@gmail.com>
References: <87mtfu4up3.fsf@email.froward.int.ebiederm.org>
        <20220506141512.516114-1-ebiederm@xmission.com> <87fslhpi58.ffs@tglx>
        <87v8udwhc6.fsf@email.froward.int.ebiederm.org>
Date:   Wed, 11 May 2022 12:41:44 -0500
In-Reply-To: <87v8udwhc6.fsf@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Tue, 10 May 2022 10:14:01 -0500")
Message-ID: <87ilqcuftz.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1noqLO-001d7U-Ly;;;mid=<87ilqcuftz.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/WkcezZ++DvlUbGu03UhymtxgbMnY4ZO0=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1440 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 4.3 (0.3%), b_tie_ro: 3.1 (0.2%), parse: 0.69
        (0.0%), extract_message_metadata: 10 (0.7%), get_uri_detail_list: 0.66
        (0.0%), tests_pri_-1000: 13 (0.9%), tests_pri_-950: 1.06 (0.1%),
        tests_pri_-900: 0.78 (0.1%), tests_pri_-90: 238 (16.5%), check_bayes:
        232 (16.1%), b_tokenize: 4.1 (0.3%), b_tok_get_all: 6 (0.4%),
        b_comp_prob: 1.31 (0.1%), b_tok_touch_all: 218 (15.2%), b_finish: 0.77
        (0.1%), tests_pri_0: 1158 (80.4%), check_dkim_signature: 0.36 (0.0%),
        check_dkim_adsp: 2.0 (0.1%), poll_dns_idle: 0.17 (0.0%), tests_pri_10:
        2.9 (0.2%), tests_pri_500: 9 (0.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/7] kthread: Don't allocate kthread_struct for init and
 umh
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Eric W. Biederman" <ebiederm@xmission.com> writes:

> Thomas Gleixner <tglx@linutronix.de> writes:
>
>> I'm worried that there are more of these issues lurking. Haven't looked
>> yet.
>
> I looked earlier and I missed this one.  I am going to look again today,
> along with applying the obvious fix to task_tick_numa.

So I have just looked again and I don't see anything.  There are a
couple of subtle issues on x86.  Especially with saving floating
point but as I read the code copy_thread initializes things
properly so that code that doesn't touch floating point registers
doesn't need to do anything.

The important thing for lurking issues is that even if I missed
something practically all of the uses of PF_KTHREAD are on x86
or generic code so they should be flushed out quickly.

Eric

