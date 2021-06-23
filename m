Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7569E3B1A59
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 14:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhFWMmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 08:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhFWMmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 08:42:20 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96294C061574;
        Wed, 23 Jun 2021 05:40:02 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id 555951F436DA
Subject: Re: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
To:     Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>
Cc:     stable@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210619025834.2505201-1-keescook@chromium.org>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <e958209b-8621-57ca-01d6-2e76b05dab4c@collabora.com>
Date:   Wed, 23 Jun 2021 13:39:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210619025834.2505201-1-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19/06/2021 03:58, Kees Cook wrote:
> Some environments do not set $SHELL when running tests. There's no need
> to use $SHELL here anyway, so just replace it with hard-coded path
> instead. Additionally avoid using bash-isms in the command, so that
> regular /bin/sh can be used.
> 
> Suggested-by: Guillaume Tucker <guillaume.tucker@collabora.com>
> Fixes: 46d1a0f03d66 ("selftests/lkdtm: Add tests for LKDTM targets")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>


Tested-by: "kernelci.org bot" <bot@kernelci.org> 


Sample staging results with this patch applied on top of
next-20210622:

https://staging.kernelci.org/test/plan/id/60d2dbdc3cfb88da0924bf41/

Full log:

https://storage.staging.kernelci.org/kernelci/staging-next/staging-next-20210623.0/x86_64/x86_64_defconfig+x86-chromebook+kselftest/clang-13/lab-collabora/kselftest-lkdtm-asus-C523NA-A20057-coral.html


This was tested using Debian Buster with the default shell
being "dash", which doesn't support Bash-specific features.


Thanks,
Guillaume

> ---
>  tools/testing/selftests/lkdtm/run.sh | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/lkdtm/run.sh b/tools/testing/selftests/lkdtm/run.sh
> index bb7a1775307b..0f9f22ac004b 100755
> --- a/tools/testing/selftests/lkdtm/run.sh
> +++ b/tools/testing/selftests/lkdtm/run.sh
> @@ -78,8 +78,9 @@ dmesg > "$DMESG"
>  
>  # Most shells yell about signals and we're expecting the "cat" process
>  # to usually be killed by the kernel. So we have to run it in a sub-shell
> -# and silence errors.
> -($SHELL -c 'cat <(echo '"$test"') >'"$TRIGGER" 2>/dev/null) || true
> +# to avoid terminating this script. Leave stderr alone, just in case
> +# something _else_ happens.
> +(/bin/sh -c '(echo '"$test"') | cat >'"$TRIGGER") || true
>  
>  # Record and dump the results
>  dmesg | comm --nocheck-order -13 "$DMESG" - > "$LOG" || true
> 

