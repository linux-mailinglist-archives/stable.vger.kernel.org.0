Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669941FAAAF
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 10:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgFPIFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 04:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFPIFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 04:05:19 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 276DE2074D;
        Tue, 16 Jun 2020 08:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592294719;
        bh=xS1bz/I8TuJWQXl/b8r7l6ZWj5h9r7ECmLDtJ9PzSgk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yeo3WK8ZeBdlZV9PyIT6cPW7zKJnQqiFsHfXXJpyg6SBIy5CQRba96zgytf1wqKtx
         /xNL0V4FTR+y5pUniIQJBR9d3mH+vK1NvVY0sYgJVyrV/5M+pA6zQSE6OCt5MJpP9T
         eR5PS3LXBKW9KQaENu4vnHy0n3wyLJYHJdt64VBE=
Date:   Tue, 16 Jun 2020 17:05:16 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] proc/bootconfig: Fix to use correct quotes for
 value
Message-Id: <20200616170516.927d75bd98237466339fca33@kernel.org>
In-Reply-To: <20200615151139.5cc223fc@oasis.local.home>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
        <159197539793.80267.10836787284189465765.stgit@devnote2>
        <20200615151139.5cc223fc@oasis.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 15:11:39 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 13 Jun 2020 00:23:18 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > Fix /proc/bootconfig to show the correctly choose the
> > double or single quotes according to the value.
> > 
> > If a bootconfig value includes a double quote character,
> > we must use single-quotes to quote that value.
> > 
> > Fixes: c1a3c36017d4 ("proc: bootconfig: Add /proc/bootconfig to show boot config list")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > ---
> >  fs/proc/bootconfig.c |   13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/proc/bootconfig.c b/fs/proc/bootconfig.c
> > index 9955d75c0585..930d1dae33eb 100644
> > --- a/fs/proc/bootconfig.c
> > +++ b/fs/proc/bootconfig.c
> > @@ -27,6 +27,7 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
> >  {
> >  	struct xbc_node *leaf, *vnode;
> >  	const char *val;
> > +	char q;
> >  	char *key, *end = dst + size;
> >  	int ret = 0;
> 
> Hmm, shouldn't the above have the upside-down xmas tree format?
> 
> 	struct xbc_node *leaf, *vnode;
> 	char *key, *end = dst + size;
> 	const char *val;
> 	char q;
> 	int ret = 0;
> 
> 
> Looks a little better that way. But anyway, more meat below.

OK.

> 
> >  
> > @@ -41,16 +42,20 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
> >  			break;
> >  		dst += ret;
> >  		vnode = xbc_node_get_child(leaf);
> > -		if (vnode && xbc_node_is_array(vnode)) {
> > +		if (vnode) {
> >  			xbc_array_for_each_value(vnode, val) {
> > -				ret = snprintf(dst, rest(dst, end), "\"%s\"%s",
> > -					val, vnode->next ? ", " : "\n");
> 
> The above is a functional change that is not described in the change
> log.
> 
> You use to have:
> 
> 	if (vnode && xbc_node_is_array(vnode)) {
> 		xbc_array_for_each_value() {
> 			[..]
> 		}
> 	} else {
> 		[..]
> 	}
> 
> And now have:
> 
> 	if (vnode) {
> 		xbc_array_for_each_value() {
> 			[..]
> 		}
> 	} else {
> 		[..]
> 	}
> 
> Is "vnode" equivalent to "vnode && xbc_node_is_array(vnode)" ?

No, it's not. But actually, the above change is equivalent, because
xbc_array_for_each_value() can handle the vnode has no "next" member.
(the array means just "a list of value node")

Thus,

if (vnode && xbc_node_is_array(vnode)) {
	xbc_array_for_each_value(vnode)	/* vnode->next != NULL */
		...
} else {
	snprintf(val); /* val is an empty string if !vnode */
}

is equivalent to 

if (vnode) {
	xbc_array_for_each_value(vnode)	/* vnode->next can be NULL */
		...
} else {
	snprintf("");
}

> 
> Why was this change made? It seems out of scope with the change log?

Because I want to avoid checking double-quote in each value in 2 places.
If we don't change the if() code, we need 

	if (strchr(val, '"'))
		q = '\'';
	else
		q = '"';

this in 2 places.

Anyway, I'll add it in the patch comment.

Thank you,

> 
> -- Steve
> 
> 
> > +				if (strchr(val, '"'))
> > +					q = '\'';
> > +				else
> > +					q = '"';
> > +				ret = snprintf(dst, rest(dst, end), "%c%s%c%s",
> > +					q, val, q, vnode->next ? ", " : "\n");
> >  				if (ret < 0)
> >  					goto out;
> >  				dst += ret;
> >  			}
> >  		} else {
> > -			ret = snprintf(dst, rest(dst, end), "\"%s\"\n", val);
> > +			ret = snprintf(dst, rest(dst, end), "\"\"\n");
> >  			if (ret < 0)
> >  				break;
> >  			dst += ret;
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
