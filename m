Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7FF3AD2CE
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 21:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhFRTcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 15:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbhFRTcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 15:32:11 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C022C061574;
        Fri, 18 Jun 2021 12:30:01 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id E9D041F44CE8
Subject: Re: [PATCH] selftests/lkdtm: Use /bin/sh not $SHELL
To:     Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>
Cc:     stable@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210617231027.3908585-1-keescook@chromium.org>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <57775fe8-d9c2-4004-b8c5-0247faf33aa4@collabora.com>
Date:   Fri, 18 Jun 2021 20:29:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210617231027.3908585-1-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/06/2021 00:10, Kees Cook wrote:
> Some environments (e.g. kerneci.org) do not set $SHELL for their test
> environment. There's no need to use $SHELL here anyway, so just replace
> it with hard-coded /bin/sh instead. Without this, the LKDTM tests would
> never actually run on kerneci.org.

There's a bit more to it...  The lkdtm tests make use of the
process substitution feature with the <() syntax which is
specific to Bash.  The tests run by KernelCI use Debian, where
/bin/sh points to /bin/dash by default which doesn't support this
feature.  So one way to fix it would be:

  (/bin/bash -c 'cat <(echo '"$test"') >'"$TRIGGER")

However, this might break others' workflows.

In fact the LAVA jobs run by KernelCI do define the $SHELL
environment variable except it's defined to be /bin/sh - and that
means /bin/dash gets called and we're back to the issue explained
above.

I've manually run a modified test job which defines
SHELL=/bin/bash and that works:

  https://lava.collabora.co.uk/scheduler/job/4055547#L2835

So to avoid hitting the same issue in other places, as it seems
like there is an implicit dependency on Bash, we can just change
KernelCI kselftest jobs to always export SHELL=/bin/bash.

I suppose an even better fix would be to use standard shell
features that would work with any /bin/sh implementation, but
this is there to kill the sub-shell rather than the main script
process so I'm not entirely sure if we can easily do that
differently.  Maybe we can pipe the output to cat rather than the
substitution syntax, e.g.:

  (/bin/sh -c '(echo '"$test"') | cat >'"$TRIGGER") || true


So I think the "safest" solution is to not change the kselftest
script and export SHELL=/bin/bash in the KernelCI jobs.  If the
pipe approach is good enough at catching signals then it could be
done on top of this patch as it's standard and should work with
any /bin/sh implementation.  What do you think?

Thanks,
Guillaume


> Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  tools/testing/selftests/lkdtm/run.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/lkdtm/run.sh b/tools/testing/selftests/lkdtm/run.sh
> index bb7a1775307b..968ff3cf5667 100755
> --- a/tools/testing/selftests/lkdtm/run.sh
> +++ b/tools/testing/selftests/lkdtm/run.sh
> @@ -79,7 +79,7 @@ dmesg > "$DMESG"
>  # Most shells yell about signals and we're expecting the "cat" process
>  # to usually be killed by the kernel. So we have to run it in a sub-shell
>  # and silence errors.
> -($SHELL -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
> +(/bin/sh -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
>  
>  # Record and dump the results
>  dmesg | comm --nocheck-order -13 "$DMESG" - > "$LOG" || true
> 

