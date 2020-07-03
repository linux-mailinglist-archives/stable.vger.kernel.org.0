Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EAA2133D6
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 08:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgGCGEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 02:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgGCGEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 02:04:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE71A2075D;
        Fri,  3 Jul 2020 06:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593756282;
        bh=ktuG9czb+58BbK8kRYL68lYjCdzJrusDhSKUz53p4A4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LxEKRXVkGE4cuKlchDNeSGwI6mfVsfD9qgCi86Lx9akoCLQz3XnI5iiGFE0Oj5tEH
         +6rlrYnnuxWIPLcGqfEwvzlZeGxpIrczXs84fzQ588H5x3rqo4IwEX3Sr6x1Yhi8Ol
         T7BWukASauTr0EjDo+bxgvLKQ59994XBMbeXjfpo=
Date:   Fri, 3 Jul 2020 08:04:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4.19 119/131] tracing: Fix event trigger to accept
 redundant spaces
Message-ID: <20200703060439.GB6344@kroah.com>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-120-sashal@kernel.org>
 <20200702211728.GD5787@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702211728.GD5787@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 11:17:28PM +0200, Pavel Machek wrote:
> Hi!
> 
> > commit 6784beada631800f2c5afd567e5628c843362cee upstream.
> > 
> > Fix the event trigger to accept redundant spaces in
> > the trigger input.
> > 
> > For example, these return -EINVAL
> > 
> > echo " traceon" > events/ftrace/print/trigger
> > echo "traceon  if common_pid == 0" > events/ftrace/print/trigger
> > echo "disable_event:kmem:kmalloc " > events/ftrace/print/trigger
> > 
> > But these are hard to find what is wrong.
> > 
> > To fix this issue, use skip_spaces() to remove spaces
> > in front of actual tokens, and set NULL if there is no
> > token.
> 
> For the record, I'm not fan of this one. It is ABI change, not a
> bugfix.
> 
> Yes, it makes kernel interface "easier to use". It also changes
> interface in the middle of stable series, and if people start relying
> on new interface and start putting extra spaces, they'll get nasty
> surprise when they move code to the older kernel.

If an interface changes anywhere that breaks userspace, it needs to be
not done, stable kernels are not an issue here or not.

Does this do that?  It looks to me that this actually fixes things
instead.

thanks,

greg k-h
