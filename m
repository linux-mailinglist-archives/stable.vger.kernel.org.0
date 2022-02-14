Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3D04B5442
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 16:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243277AbiBNPLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 10:11:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352976AbiBNPLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 10:11:34 -0500
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D36C40;
        Mon, 14 Feb 2022 07:11:22 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:40898)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nJd0Z-00301D-RO; Mon, 14 Feb 2022 08:11:19 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:60176 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nJd0Y-00AMYl-HJ; Mon, 14 Feb 2022 08:11:19 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Solar Designer <solar@openwall.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        Michal Koutn?? <mkoutny@suse.com>, stable@vger.kernel.org
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
        <20220211021324.4116773-3-ebiederm@xmission.com>
        <20220212231701.GA29483@openwall.com>
Date:   Mon, 14 Feb 2022 09:10:49 -0600
In-Reply-To: <20220212231701.GA29483@openwall.com> (Solar Designer's message
        of "Sun, 13 Feb 2022 00:17:01 +0100")
Message-ID: <87ee45wkjq.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nJd0Y-00AMYl-HJ;;;mid=<87ee45wkjq.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ckuSLbOWMncQUqnAK4hiHBj/D3E9gRuw=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Solar Designer <solar@openwall.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 709 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.5%), b_tie_ro: 9 (1.3%), parse: 1.62 (0.2%),
         extract_message_metadata: 21 (2.9%), get_uri_detail_list: 3.3 (0.5%),
        tests_pri_-1000: 24 (3.4%), tests_pri_-950: 1.27 (0.2%),
        tests_pri_-900: 1.02 (0.1%), tests_pri_-90: 135 (19.0%), check_bayes:
        122 (17.3%), b_tokenize: 11 (1.5%), b_tok_get_all: 11 (1.6%),
        b_comp_prob: 4.0 (0.6%), b_tok_touch_all: 91 (12.8%), b_finish: 1.06
        (0.1%), tests_pri_0: 501 (70.6%), check_dkim_signature: 0.61 (0.1%),
        check_dkim_adsp: 2.7 (0.4%), poll_dns_idle: 0.52 (0.1%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 8 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 3/8] ucounts: Fix and simplify RLIMIT_NPROC handling
 during setuid()+execve
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Solar Designer <solar@openwall.com> writes:

> On Thu, Feb 10, 2022 at 08:13:19PM -0600, Eric W. Biederman wrote:
>> As of commit 2863643fb8b9 ("set_user: add capability check when
>> rlimit(RLIMIT_NPROC) exceeds") setting the flag to see if execve
>> should check RLIMIT_NPROC is buggy, as it tests the capabilites from
>> before the credential change and not aftwards.
>> 
>> As of commit 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of
>> ucounts") examining the rlimit is buggy as cred->ucounts has not yet
>> been properly set in the new credential.
>> 
>> Make the code correct and more robust moving the test to see if
>> execve() needs to test RLIMIT_NPROC into commit_creds, and defer all
>> of the rest of the logic into execve() itself.
>> 
>> As the flag only indicateds that RLIMIT_NPROC should be checked
>> in execve rename it from PF_NPROC_EXCEEDED to PF_NPROC_CHECK.
>> 
>> Cc: stable@vger.kernel.org
>> Link: https://lkml.kernel.org/r/20220207121800.5079-2-mkoutny@suse.com
>> Link: https://lkml.kernel.org/r/20220207121800.5079-3-mkoutny@suse.com
>> Reported-by: Michal Koutn?? <mkoutny@suse.com>
>> Fixes: 2863643fb8b9 ("set_user: add capability check when rlimit(RLIMIT_NPROC) exceeds")
>> Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> On one hand, this looks good.
>
> On the other, you asked about the Apache httpd suexec scenario in the
> other thread, and here's what this means for it (per my code review):
>
> In that scenario, we have two execve(): first from httpd to suexec, then
> from suexec to the CGI script.  Previously, the limit check only
> occurred on the setuid() call by suexec, and its effect was deferred
> until execve() of the script.  Now wouldn't it occur on both execve()
> calls, because commit_creds() is also called on execve() (such as in
> case the program is SUID, which suexec actually is)?

Yes.  Moving the check into commit_creds means that the exec after a
suid exec will perform an RLIMIT_NPROC check and could possibly fail.  I
would call that a bug.  Anything happening in execve should be checked
and handled in execve as execve can fail.

It also points out that our permission checks for increasing
RLIMIT_NPROC are highly inconsistent.

One set of permissions in fork().
Another set of permissions in set*id() and delayed until execve.
No permission checks for the uid change in execve.

Every time I look into the previous behavior of RLIMIT_NPROC I seem
to find issues.  Currently I am planning a posting to linux-api
so sorting out what when RLIMIT_NPROC should be enforced and how
RLIMIT_NPROC gets accounted receives review.  I am also planning a
feature branch to deal with the historical goofiness.

I really like how cleanly this patch seems to be.  Unfortunately it is
wrong.

> Since the check is
> kind of against real uid (not the euid=0 that suexec gains), it'd apply
> the limit against httpd pseudo-user's process count.  While it could be
> a reasonable kernel policy to impose this limit in more places, this is
> a change of behavior for Apache httpd, and is not the intended behavior
> there.  However, I think the answer to my question earlier in this
> paragraph is actually a "no", the check wouldn't occur on the execve()
> of suexec, because "new->user != old->user" would be false.  Right?
>
> As an alternative, you could keep setting the (renamed and reused) flag
> in set_user().  That would avoid the (non-)issue I described above - but
> again, your patch is probably fine as-is.
>
> I do see it's logical to have these two lines next to each other:
>
>>  		inc_rlimit_ucounts(new->ucounts, UCOUNT_RLIMIT_NPROC, 1);
>> +		task->flags |= PF_NPROC_CHECK;
>
> Of course, someone would need to actually test this.

That too.

I am increasingly of the opinion that the process accounting should not
be in cred.c at all.  That we just remember the who was charged with the
process when we created it, and then at exec time we can update that
charge, and verify that the new user is solid.  At exit time we can look
up who was charged with the process and decrement the count.

Of course at this point my opinion may change after I implement that.

Eric

