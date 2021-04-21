Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FE3366CD6
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241823AbhDUN3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235518AbhDUN3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:29:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6B5361449;
        Wed, 21 Apr 2021 13:29:20 +0000 (UTC)
Date:   Wed, 21 Apr 2021 09:29:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenwen Wang <wang6495@umn.edu>
Subject: Re: [PATCH 081/190] Revert "tracing: Fix a memory leak by early
 error exit in trace_pid_write()"
Message-ID: <20210421092919.2576ce8d@gandalf.local.home>
In-Reply-To: <20210421130105.1226686-82-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
        <20210421130105.1226686-82-gregkh@linuxfoundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Apr 2021 14:59:16 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This reverts commit 91862cc7867bba4ee5c8fcf0ca2f1d30427b6129.
> 
> Commits from @umn.edu addresses have been found to be submitted in "bad
> faith" to try to test the kernel community's ability to review "known
> malicious" changes.  The result of these submissions can be found in a
> paper published at the 42nd IEEE Symposium on Security and Privacy
> entitled, "Open Source Insecurity: Stealthily Introducing
> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> of Minnesota) and Kangjie Lu (University of Minnesota).
> 
> Because of this, all submissions from this group must be reverted from
> the kernel tree and will need to be re-reviewed again to determine if
> they actually are a valid fix.  Until that work is complete, remove this
> change to ensure that no problems are being introduced into the
> codebase.
> 

I have reviewed this change, and this is a valid fix and does not need to
be reverted.

The code before the change is:

	if (trace_parser_get_init(&parser, PID_BUF_SIZE + 1))
		return -ENOMEM;

Where that does:

int trace_parser_get_init(struct trace_parser *parser, int size)
{
	memset(parser, 0, sizeof(*parser));

	parser->buffer = kmalloc(size, GFP_KERNEL);
	if (!parser->buffer)
		return 1;

	parser->size = size;
	return 0;
}

And the trace_parser_put() does:

void trace_parser_put(struct trace_parser *parser)
{
	kfree(parser->buffer);
	parser->buffer = NULL;
}

Hence, exiting the function without calling trace_parser_put() will indeed
leak memory.

Please do not revert this patch.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


> Cc: http
> Cc: stable@vger.kernel.org
> Cc: Wenwen Wang <wang6495@umn.edu>
> Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/trace/trace.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5c777627212f..faed4f44d224 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -691,10 +691,8 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
>  	 * not modified.
>  	 */
>  	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
> -	if (!pid_list) {
> -		trace_parser_put(&parser);
> +	if (!pid_list)
>  		return -ENOMEM;
> -	}
>  
>  	pid_list->pid_max = READ_ONCE(pid_max);
>  
> @@ -704,7 +702,6 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
>  
>  	pid_list->pids = vzalloc((pid_list->pid_max + 7) >> 3);
>  	if (!pid_list->pids) {
> -		trace_parser_put(&parser);
>  		kfree(pid_list);
>  		return -ENOMEM;
>  	}

