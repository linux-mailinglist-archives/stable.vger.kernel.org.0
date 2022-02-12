Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522F04B388C
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 00:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiBLXRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 18:17:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiBLXRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 18:17:13 -0500
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 306755F8D4
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 15:17:07 -0800 (PST)
Received: (qmail 6042 invoked from network); 12 Feb 2022 23:17:06 -0000
Received: from localhost (HELO pvt.openwall.com) (127.0.0.1)
  by localhost with SMTP; 12 Feb 2022 23:17:06 -0000
Received: by pvt.openwall.com (Postfix, from userid 503)
        id D1CBDAB88C; Sun, 13 Feb 2022 00:17:01 +0100 (CET)
Date:   Sun, 13 Feb 2022 00:17:01 +0100
From:   Solar Designer <solar@openwall.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        Michal Koutn?? <mkoutny@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/8] ucounts: Fix and simplify RLIMIT_NPROC handling during setuid()+execve
Message-ID: <20220212231701.GA29483@openwall.com>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org> <20220211021324.4116773-3-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211021324.4116773-3-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 08:13:19PM -0600, Eric W. Biederman wrote:
> As of commit 2863643fb8b9 ("set_user: add capability check when
> rlimit(RLIMIT_NPROC) exceeds") setting the flag to see if execve
> should check RLIMIT_NPROC is buggy, as it tests the capabilites from
> before the credential change and not aftwards.
> 
> As of commit 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of
> ucounts") examining the rlimit is buggy as cred->ucounts has not yet
> been properly set in the new credential.
> 
> Make the code correct and more robust moving the test to see if
> execve() needs to test RLIMIT_NPROC into commit_creds, and defer all
> of the rest of the logic into execve() itself.
> 
> As the flag only indicateds that RLIMIT_NPROC should be checked
> in execve rename it from PF_NPROC_EXCEEDED to PF_NPROC_CHECK.
> 
> Cc: stable@vger.kernel.org
> Link: https://lkml.kernel.org/r/20220207121800.5079-2-mkoutny@suse.com
> Link: https://lkml.kernel.org/r/20220207121800.5079-3-mkoutny@suse.com
> Reported-by: Michal Koutn?? <mkoutny@suse.com>
> Fixes: 2863643fb8b9 ("set_user: add capability check when rlimit(RLIMIT_NPROC) exceeds")
> Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

On one hand, this looks good.

On the other, you asked about the Apache httpd suexec scenario in the
other thread, and here's what this means for it (per my code review):

In that scenario, we have two execve(): first from httpd to suexec, then
from suexec to the CGI script.  Previously, the limit check only
occurred on the setuid() call by suexec, and its effect was deferred
until execve() of the script.  Now wouldn't it occur on both execve()
calls, because commit_creds() is also called on execve() (such as in
case the program is SUID, which suexec actually is)?  Since the check is
kind of against real uid (not the euid=0 that suexec gains), it'd apply
the limit against httpd pseudo-user's process count.  While it could be
a reasonable kernel policy to impose this limit in more places, this is
a change of behavior for Apache httpd, and is not the intended behavior
there.  However, I think the answer to my question earlier in this
paragraph is actually a "no", the check wouldn't occur on the execve()
of suexec, because "new->user != old->user" would be false.  Right?

As an alternative, you could keep setting the (renamed and reused) flag
in set_user().  That would avoid the (non-)issue I described above - but
again, your patch is probably fine as-is.

I do see it's logical to have these two lines next to each other:

>  		inc_rlimit_ucounts(new->ucounts, UCOUNT_RLIMIT_NPROC, 1);
> +		task->flags |= PF_NPROC_CHECK;

Of course, someone would need to actually test this.

Alexander
