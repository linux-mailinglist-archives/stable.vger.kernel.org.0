Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0A61FAA79
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 09:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgFPHxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 03:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbgFPHxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 03:53:41 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5B6F2074D;
        Tue, 16 Jun 2020 07:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592294021;
        bh=R6gjrNu6udhcMvwI8G7NyjY7QsOLzDo0ytkfJbT0sQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oFYI8c63G/btvujMLJczMKbzpu/RCp3di3UlsywdDZoxjO+rrmrrYsWAp31Ld5or4
         oc/RCW8ZgTpaE5WlXM1CAXV4ls71l1AiXzMKyCxb6QbEQmSfbcs1eGKdoDTC5eArTU
         ibGvrYcQWoP9JUafy7u7RG04K665i+nq/hxfe/7s=
Date:   Tue, 16 Jun 2020 16:53:37 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] tools/bootconfig: Fix to return 0 if succeeded to
 show the bootconfig
Message-Id: <20200616165337.f73e9b787098cc681b21c4b4@kernel.org>
In-Reply-To: <20200615151442.028c2876@oasis.local.home>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
        <159197541534.80267.9851345208191438725.stgit@devnote2>
        <20200615151442.028c2876@oasis.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 15:14:42 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 13 Jun 2020 00:23:35 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > Fix bootconfig to return 0 if succeeded to show the bootconfig
> > in initrd. Without this fix, "bootconfig INITRD" command
> > returns !0 even if the command succeeded to show the bootconfig.
> > 
> > Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > ---
> >  tools/bootconfig/main.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
> > index 21896a6675fd..ff2cc9520e10 100644
> > --- a/tools/bootconfig/main.c
> > +++ b/tools/bootconfig/main.c
> > @@ -209,8 +209,10 @@ int show_xbc(const char *path)
> >  	ret = load_xbc_from_initrd(fd, &buf);
> >  	if (ret < 0)
> >  		pr_err("Failed to load a boot config from initrd: %d\n", ret);
> > -	else
> > +	else {
> >  		xbc_show_compact_tree();
> > +		ret = 0;
> > +	}
> 
> Usually for the above, I think goto is cleaner. As it is strange to
> have a successful case as the "else" condition. Not to mention, if you
> add brackets for one side of the else, it is usually recommended to add
> them for the other side.
> 
> But in this case I think it would read better to have:
> 
> 
> 	if (ret < 0) {
> 		pr_err(...);
> 		goto out;
> 	}
> 	xbc_show_compact_tree();
> 	ret = 0;
> out:

Agreed. OK, I'll update it.

Thank you!

> 	
> >  
> >  	close(fd);
> >  	free(buf);
> 
> -- Steve


-- 
Masami Hiramatsu <mhiramat@kernel.org>
