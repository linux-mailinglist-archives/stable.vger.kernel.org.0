Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF214B54B4
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 16:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240557AbiBNPX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 10:23:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355757AbiBNPX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 10:23:57 -0500
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0EE60077;
        Mon, 14 Feb 2022 07:23:49 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:41396)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nJdCe-00DL3l-Ob; Mon, 14 Feb 2022 08:23:48 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:60382 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nJdCd-001VLN-It; Mon, 14 Feb 2022 08:23:48 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Solar Designer <solar@openwall.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        Michal Koutn?? <mkoutny@suse.com>, stable@vger.kernel.org
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
        <20220211021324.4116773-5-ebiederm@xmission.com>
        <20220212223638.GB29214@openwall.com>
        <87k0dxv5eq.fsf@email.froward.int.ebiederm.org>
Date:   Mon, 14 Feb 2022 09:23:40 -0600
In-Reply-To: <87k0dxv5eq.fsf@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Mon, 14 Feb 2022 09:23:09 -0600")
Message-ID: <87ee45v5dv.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nJdCd-001VLN-It;;;mid=<87ee45v5dv.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18M8BoP96TO2JUrHTpU4dmd2gizafaDJjg=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Solar Designer <solar@openwall.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 556 ms - load_scoreonly_sql: 0.12 (0.0%),
        signal_user_changed: 12 (2.1%), b_tie_ro: 10 (1.8%), parse: 1.10
        (0.2%), extract_message_metadata: 20 (3.6%), get_uri_detail_list: 2.5
        (0.5%), tests_pri_-1000: 22 (3.9%), tests_pri_-950: 1.38 (0.2%),
        tests_pri_-900: 1.14 (0.2%), tests_pri_-90: 120 (21.5%), check_bayes:
        118 (21.2%), b_tokenize: 9 (1.7%), b_tok_get_all: 15 (2.7%),
        b_comp_prob: 2.9 (0.5%), b_tok_touch_all: 87 (15.7%), b_finish: 0.86
        (0.2%), tests_pri_0: 359 (64.5%), check_dkim_signature: 0.59 (0.1%),
        check_dkim_adsp: 3.2 (0.6%), poll_dns_idle: 1.11 (0.2%), tests_pri_10:
        2.3 (0.4%), tests_pri_500: 15 (2.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 5/8] ucounts: Handle wrapping in is_ucounts_overlimit
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

"Eric W. Biederman" <ebiederm@xmission.com> writes:

> Solar Designer <solar@openwall.com> writes:
>
>> On Thu, Feb 10, 2022 at 08:13:21PM -0600, Eric W. Biederman wrote:
>>> While examining is_ucounts_overlimit and reading the various messages
>>> I realized that is_ucounts_overlimit fails to deal with counts that
>>> may have wrapped.
>>> 
>>> Being wrapped should be a transitory state for counts and they should
>>> never be wrapped for long, but it can happen so handle it.
>>> 
>>> Cc: stable@vger.kernel.org
>>> Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>> ---
>>>  kernel/ucount.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>> 
>>> diff --git a/kernel/ucount.c b/kernel/ucount.c
>>> index 65b597431c86..06ea04d44685 100644
>>> --- a/kernel/ucount.c
>>> +++ b/kernel/ucount.c
>>> @@ -350,7 +350,8 @@ bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsign
>>>  	if (rlimit > LONG_MAX)
>>>  		max = LONG_MAX;
>>>  	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
>>> -		if (get_ucounts_value(iter, type) > max)
>>> +		long val = get_ucounts_value(iter, type);
>>> +		if (val < 0 || val > max)
>>>  			return true;
>>>  		max = READ_ONCE(iter->ns->ucount_max[type]);
>>>  	}
>>
>> You probably deliberately assume "gcc -fwrapv", but otherwise:
>>
>> As you're probably aware, a signed integer wrapping is undefined
>> behavior in C.  In the function above, "val" having wrapped to negative
>> assumes we had occurred UB elsewhere.  Further, there's an instance of
>> UB in the function itself:
>
> While in cases like this we pass the value in a long, the operations on
> the value occur in an atomic_long_t.  As atomic_long_t is implemented in
> assembly we do escape the problems of undefined behavior.
>
>
>> bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsigned long rlimit)
>> {
>> 	struct ucounts *iter;
>> 	long max = rlimit;
>> 	if (rlimit > LONG_MAX)
>> 		max = LONG_MAX;
>>
>> The assignment on "long max = rlimit;" would have already been UB if
>> "rlimit > LONG_MAX", which is only checked afterwards.  I think the
>> above would be better written as:
>>
>> 	if (rlimit > LONG_MAX)
>> 		rlimit = LONG_MAX;
>> 	long max = rlimit;
>>
>> considering that "rlimit" is never used further in that function.
>
> Thank you for spotting that.  That looks like a good idea.  Even if it
> works in this case it is better to establish patterns that are not
> problematic if copy and pasted elsewhere.
>
>> And to more likely avoid wraparound of "val", perhaps have the limit at
>> a value significantly lower than LONG_MAX, like half that?  So:
>
> For the case of RLIMIT_NPROC the real world limit is PID_MAX_LIMIT
> which is 2^22.
>
> Beyond that the code deliberately uses all values with the high bit/sign
> bit set to flag that things went too high.  So the code already reserves
> half of the values.
>
>> I assume that once is_ucounts_overlimit() returned true, it is expected
>> the value would almost not grow further (except a little due to races).
>
> Pretty much. The function essentially only exists so that we can
> handle the weirdness of RLIMIT_NPROC.  Now that I have discovered the
> weirdness of RLIMIT_NPROC is old historical sloppiness I expect the
> proper solution is to rework how RLIMIT_NPROC operates and to remove
> is_ucounts_overlimit all together.   I have to figure out what a proper
> RLIMIT_NPROC check looks like in proc.
                                   ^^^^ execve

Eric

