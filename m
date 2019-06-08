Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CA13A22C
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 23:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfFHVbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 17:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbfFHVbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 17:31:16 -0400
Received: from oasis.local.home (unknown [12.156.218.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D22A208E3;
        Sat,  8 Jun 2019 21:31:15 +0000 (UTC)
Date:   Sat, 8 Jun 2019 17:31:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andreas Ziegler <andreas.ziegler@fau.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH AUTOSEL 5.1 058/186] tracing: probeevent: Fix to make
 the type of $comm string
Message-ID: <20190608173113.5fc866bf@oasis.local.home>
In-Reply-To: <20190601131653.24205-58-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
        <20190601131653.24205-58-sashal@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat,  1 Jun 2019 09:14:34 -0400
Sasha Levin <sashal@kernel.org> wrote:

> From: Masami Hiramatsu <mhiramat@kernel.org>
> 
> [ Upstream commit 3dd1f7f24f8ceec00bbbc364c2ac3c893f0fdc4c ]
> 
> Fix to make the type of $comm "string".  If we set the other type to $comm
> argument, it shows meaningless value or wrong data. Currently probe events
> allow us to set string array type (e.g. ":string[2]"), or other digit types
> like x8 on $comm. But since clearly $comm is just a string data, it should
> not be fetched by other types including array.
> 
> Link: http://lkml.kernel.org/r/155723736241.9149.14582064184468574539.stgit@devnote2
> 
> Cc: Andreas Ziegler <andreas.ziegler@fau.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")

I thought the "AUTOSEL" patches are to find patches that are not marked
for stable and pull them in. It would be good to differentiate those in
the subject. As I'm more inclined to audit automatically pulled in ones,
because those are more likely to be incorrectly backported.

-- Steve


> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/trace/trace_probe.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 8f8411e7835fd..e41d389b7f491 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -420,13 +420,14 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
>  				return -E2BIG;
>  		}
>  	}
> -	/*
> -	 * The default type of $comm should be "string", and it can't be
> -	 * dereferenced.
> -	 */
> -	if (!t && strcmp(arg, "$comm") == 0)
> +
> +	/* Since $comm can not be dereferred, we can find $comm by strcmp */
> +	if (strcmp(arg, "$comm") == 0) {
> +		/* The type of $comm must be "string", and not an array. */
> +		if (parg->count || (t && strcmp(t, "string")))
> +			return -EINVAL;
>  		parg->type = find_fetch_type("string");
> -	else
> +	} else
>  		parg->type = find_fetch_type(t);
>  	if (!parg->type) {
>  		pr_info("Unsupported type: %s\n", t);

