Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD111FA009
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 21:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbgFOTOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 15:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731179AbgFOTOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 15:14:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40B9920739;
        Mon, 15 Jun 2020 19:14:44 +0000 (UTC)
Date:   Mon, 15 Jun 2020 15:14:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tools/bootconfig: Fix to return 0 if succeeded to
 show the bootconfig
Message-ID: <20200615151442.028c2876@oasis.local.home>
In-Reply-To: <159197541534.80267.9851345208191438725.stgit@devnote2>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
        <159197541534.80267.9851345208191438725.stgit@devnote2>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 13 Jun 2020 00:23:35 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Fix bootconfig to return 0 if succeeded to show the bootconfig
> in initrd. Without this fix, "bootconfig INITRD" command
> returns !0 even if the command succeeded to show the bootconfig.
> 
> Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
> Cc: stable@vger.kernel.org
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  tools/bootconfig/main.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
> index 21896a6675fd..ff2cc9520e10 100644
> --- a/tools/bootconfig/main.c
> +++ b/tools/bootconfig/main.c
> @@ -209,8 +209,10 @@ int show_xbc(const char *path)
>  	ret = load_xbc_from_initrd(fd, &buf);
>  	if (ret < 0)
>  		pr_err("Failed to load a boot config from initrd: %d\n", ret);
> -	else
> +	else {
>  		xbc_show_compact_tree();
> +		ret = 0;
> +	}

Usually for the above, I think goto is cleaner. As it is strange to
have a successful case as the "else" condition. Not to mention, if you
add brackets for one side of the else, it is usually recommended to add
them for the other side.

But in this case I think it would read better to have:


	if (ret < 0) {
		pr_err(...);
		goto out;
	}
	xbc_show_compact_tree();
	ret = 0;
out:
	
>  
>  	close(fd);
>  	free(buf);

-- Steve
