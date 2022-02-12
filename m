Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718BB4B386E
	for <lists+stable@lfdr.de>; Sat, 12 Feb 2022 23:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiBLWol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Feb 2022 17:44:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiBLWol (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Feb 2022 17:44:41 -0500
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Feb 2022 14:44:36 PST
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 976DD23BD5
        for <stable@vger.kernel.org>; Sat, 12 Feb 2022 14:44:36 -0800 (PST)
Received: (qmail 22387 invoked from network); 12 Feb 2022 22:37:54 -0000
Received: from localhost (HELO pvt.openwall.com) (127.0.0.1)
  by localhost with SMTP; 12 Feb 2022 22:37:54 -0000
Received: by pvt.openwall.com (Postfix, from userid 503)
        id 2BA26AB88C; Sat, 12 Feb 2022 23:36:39 +0100 (CET)
Date:   Sat, 12 Feb 2022 23:36:39 +0100
From:   Solar Designer <solar@openwall.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        Michal Koutn?? <mkoutny@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 5/8] ucounts: Handle wrapping in is_ucounts_overlimit
Message-ID: <20220212223638.GB29214@openwall.com>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org> <20220211021324.4116773-5-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211021324.4116773-5-ebiederm@xmission.com>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 10, 2022 at 08:13:21PM -0600, Eric W. Biederman wrote:
> While examining is_ucounts_overlimit and reading the various messages
> I realized that is_ucounts_overlimit fails to deal with counts that
> may have wrapped.
> 
> Being wrapped should be a transitory state for counts and they should
> never be wrapped for long, but it can happen so handle it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/ucount.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 65b597431c86..06ea04d44685 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -350,7 +350,8 @@ bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsign
>  	if (rlimit > LONG_MAX)
>  		max = LONG_MAX;
>  	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
> -		if (get_ucounts_value(iter, type) > max)
> +		long val = get_ucounts_value(iter, type);
> +		if (val < 0 || val > max)
>  			return true;
>  		max = READ_ONCE(iter->ns->ucount_max[type]);
>  	}

You probably deliberately assume "gcc -fwrapv", but otherwise:

As you're probably aware, a signed integer wrapping is undefined
behavior in C.  In the function above, "val" having wrapped to negative
assumes we had occurred UB elsewhere.  Further, there's an instance of
UB in the function itself:

bool is_ucounts_overlimit(struct ucounts *ucounts, enum ucount_type type, unsigned long rlimit)
{
	struct ucounts *iter;
	long max = rlimit;
	if (rlimit > LONG_MAX)
		max = LONG_MAX;

The assignment on "long max = rlimit;" would have already been UB if
"rlimit > LONG_MAX", which is only checked afterwards.  I think the
above would be better written as:

	if (rlimit > LONG_MAX)
		rlimit = LONG_MAX;
	long max = rlimit;

considering that "rlimit" is never used further in that function.

And to more likely avoid wraparound of "val", perhaps have the limit at
a value significantly lower than LONG_MAX, like half that?  So:

	if (rlimit > LONG_MAX / 2)
		rlimit = LONG_MAX / 2;
	long max = rlimit;

And sure, also keep the "val < 0" check as defensive programming, or you
can do:

	if (rlimit > LONG_MAX / 2)
		rlimit = LONG_MAX / 2;
[...]
		if ((unsigned long)get_ucounts_value(iter, type) > rlimit)
			return true;

and drop both "val" and "max".  However, this also assumes the return
type of get_ucounts_value() doesn't become larger than "unsigned long".

I assume that once is_ucounts_overlimit() returned true, it is expected
the value would almost not grow further (except a little due to races).

I also assume there's some reason a signed type is used there.

Alexander
