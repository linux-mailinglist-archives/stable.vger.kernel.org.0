Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F33849E805
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 17:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243962AbiA0Qvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 11:51:47 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:44244 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbiA0Qvq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 11:51:46 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:34910)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nD7zs-00Db9R-SC; Thu, 27 Jan 2022 09:51:44 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:48590 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nD7zq-009OuW-Bx; Thu, 27 Jan 2022 09:51:44 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Ariadne Conill <ariadne@dereferenced.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <20220127000724.15106-1-ariadne@dereferenced.org>
        <202201262119.105FA8BCA9@keescook>
Date:   Thu, 27 Jan 2022 10:51:05 -0600
In-Reply-To: <202201262119.105FA8BCA9@keescook> (Kees Cook's message of "Wed,
        26 Jan 2022 21:29:02 -0800")
Message-ID: <87r18tt952.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nD7zq-009OuW-Bx;;;mid=<87r18tt952.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/mQqfE7iIYE+9AGFkmkLZr5ugXbyjF8J4=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: ***
X-Spam-Status: No, score=3.4 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,FVGT_m_MULTI_ODD,TR_Symld_Words,
        T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,T_TooManySym_02,T_TooManySym_03,
        T_XMDrugObfuBody_08,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.5 TR_Symld_Words too many words that have symbols inside
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
        *  1.0 T_XMDrugObfuBody_08 obfuscated drug references
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1731 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 12 (0.7%), b_tie_ro: 10 (0.6%), parse: 1.24
        (0.1%), extract_message_metadata: 60 (3.4%), get_uri_detail_list: 6
        (0.3%), tests_pri_-1000: 121 (7.0%), tests_pri_-950: 1.65 (0.1%),
        tests_pri_-900: 1.26 (0.1%), tests_pri_-90: 79 (4.6%), check_bayes: 77
        (4.5%), b_tokenize: 16 (0.9%), b_tok_get_all: 14 (0.8%), b_comp_prob:
        4.4 (0.3%), b_tok_touch_all: 36 (2.1%), b_finish: 1.61 (0.1%),
        tests_pri_0: 1426 (82.4%), check_dkim_signature: 1.09 (0.1%),
        check_dkim_adsp: 9 (0.5%), poll_dns_idle: 0.53 (0.0%), tests_pri_10:
        3.7 (0.2%), tests_pri_500: 22 (1.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v3] fs/exec: require argv[0] presence in
 do_execveat_common()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Thu, Jan 27, 2022 at 12:07:24AM +0000, Ariadne Conill wrote:
>> In several other operating systems, it is a hard requirement that the
>> second argument to execve(2) be the name of a program, thus prohibiting
>> a scenario where argc < 1.  POSIX 2017 also recommends this behaviour,
>> but it is not an explicit requirement[0]:
>> 
>>     The argument arg0 should point to a filename string that is
>>     associated with the process being started by one of the exec
>>     functions.
>> 
>> To ensure that execve(2) with argc < 1 is not a useful tool for
>> shellcode to use, we can validate this in do_execveat_common() and
>> fail for this scenario, effectively blocking successful exploitation
>> of CVE-2021-4034 and similar bugs which depend on execve(2) working
>> with argc < 1.
>> 
>> We use -EINVAL for this case, mirroring recent changes to FreeBSD and
>> OpenBSD.  -EINVAL is also used by QNX for this, while Solaris uses
>> -EFAULT.
>> 
>> In earlier versions of the patch, it was proposed that we create a
>> fake argv for applications to use when argc < 1, but it was concluded
>> that it would be better to just fail the execve(2) in these cases, as
>> launching a process with an empty or NULL argv[0] was likely to just
>> cause more problems.
>
> Let's do it and see what breaks. :)
>
> I do see at least tools/testing/selftests/exec/recursion-depth.c will
> need a fix. And maybe testcases/kernel/syscalls/execveat/execveat.h
> in LTP.
>
> Acked-by: Kees Cook <keescook@chromium.org>

Yes since this only appears to be tests that will break.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Especially since you are signing up to help fix the tests.


>> 
>> Interestingly, Michael Kerrisk opened an issue about this in 2008[1],
>> but there was no consensus to support fixing this issue then.
>> Hopefully now that CVE-2021-4034 shows practical exploitative use[2]
>> of this bug in a shellcode, we can reconsider.
>> 
>> This issue is being tracked in the KSPP issue tracker[3].
>> 
>> There are a few[4][5] minor edge cases (primarily in test suites) that
>> are caught by this, but we plan to work with the projects to fix those
>> edge cases.
>> 
>> [0]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
>> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=8408
>> [2]: https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
>> [3]: https://github.com/KSPP/linux/issues/176
>> [4]: https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
>> [5]: https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0
>> 
>> Changes from v2:
>> - Switch to using -EINVAL as the error code for this.
>> - Use pr_warn_once() to warn when an execve(2) is rejected due to NULL
>>   argv.
>> 
>> Changes from v1:
>> - Rework commit message significantly.
>> - Make the argv[0] check explicit rather than hijacking the error-check
>>   for count().
>> 
>> Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Cc: Rich Felker <dalias@libc.org>
>> Cc: Eric Biederman <ebiederm@xmission.com>
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ariadne Conill <ariadne@dereferenced.org>
>> ---
>>  fs/exec.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 79f2c9483302..982730cfe3b8 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1897,6 +1897,10 @@ static int do_execveat_common(int fd, struct filename *filename,
>>  	}
>>  
>>  	retval = count(argv, MAX_ARG_STRINGS);
>> +	if (retval == 0) {
>> +		pr_warn_once("Attempted to run process '%s' with NULL argv\n", bprm->filename);
>> +		retval = -EINVAL;
>> +	}
>>  	if (retval < 0)
>>  		goto out_free;
>>  	bprm->argc = retval;
>> -- 
>> 2.34.1
>> 
