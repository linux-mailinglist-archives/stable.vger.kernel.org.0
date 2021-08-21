Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941A23F37F5
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 03:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhHUBnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 21:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhHUBnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 21:43:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FEAE60F45;
        Sat, 21 Aug 2021 01:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629510188;
        bh=rfxBSjkKjzvMie/PhnLgofpGTbMzR8ve9hvClVth3qE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezuzZ50PUWPh9w9Fj4JOKvRidGd8R9ASXTwh4zO9Rw2VMVpC0OcBwd++rmsad6aKq
         05HCw7QNtCJRK663go/K1eIh6BsbM5OoIo9Aa5FauShpfyC5GOtCxWc2X9kGL9DRWl
         o7EoPlfTYEUj1Q5pMo2xE78wEJQA3bRylcZ9P+SSHnOPUdhxjjLu1biZ4jQpdbI+v2
         wXfKAY8htO3U9939u0sF9GnOJMSeycM1KCAml2f01u6zPO8Ziva0iaKTTYumf2CzPd
         U+o8ojoePe3U8uBPJFUX/equ5ML5voaZZBvxw6r6GfI0Fk4thsjVpA0i2fWm7mAIyx
         aAOrg3OHf1nJw==
Date:   Sat, 21 Aug 2021 10:43:05 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v9 3/6] selftests/ftrace: Fix requirement check of
 README file
Message-Id: <20210821104305.5c87c77e482261131a4ac3b8@kernel.org>
In-Reply-To: <20210820204742.087177341@goodmis.org>
References: <20210820204644.546662591@goodmis.org>
        <20210820204742.087177341@goodmis.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Aug 2021 16:46:47 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> The selftest for ftrace checks some features by checking if the README has
> text that states the feature is supported by that kernel. Unfortunately,
> this check gives false positives because it many not be checked if there's
> spaces in the string to check. This is due to the compare between the
> required variable with the ":README" string stripped, because neither has
> quotes around them.

Oops, good catch!

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!

> 
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: linux-kselftest@vger.kernel.org
> Cc: stable@vger.kernel.org
> Fixes: 1b8eec510ba64 ("selftests/ftrace: Support ":README" suffix for requires")
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tools/testing/selftests/ftrace/test.d/functions | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
> index f68d336b961b..000fd05e84b1 100644
> --- a/tools/testing/selftests/ftrace/test.d/functions
> +++ b/tools/testing/selftests/ftrace/test.d/functions
> @@ -137,7 +137,7 @@ check_requires() { # Check required files and tracers
>                  echo "Required tracer $t is not configured."
>                  exit_unsupported
>              fi
> -        elif [ $r != $i ]; then
> +        elif [ "$r" != "$i" ]; then
>              if ! grep -Fq "$r" README ; then
>                  echo "Required feature pattern \"$r\" is not in README."
>                  exit_unsupported
> -- 
> 2.30.2


-- 
Masami Hiramatsu <mhiramat@kernel.org>
