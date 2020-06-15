Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD1D1F9FFE
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 21:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731179AbgFOTLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 15:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbgFOTLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 15:11:41 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F246C20739;
        Mon, 15 Jun 2020 19:11:40 +0000 (UTC)
Date:   Mon, 15 Jun 2020 15:11:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] proc/bootconfig: Fix to use correct quotes for
 value
Message-ID: <20200615151139.5cc223fc@oasis.local.home>
In-Reply-To: <159197539793.80267.10836787284189465765.stgit@devnote2>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
        <159197539793.80267.10836787284189465765.stgit@devnote2>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 13 Jun 2020 00:23:18 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Fix /proc/bootconfig to show the correctly choose the
> double or single quotes according to the value.
> 
> If a bootconfig value includes a double quote character,
> we must use single-quotes to quote that value.
> 
> Fixes: c1a3c36017d4 ("proc: bootconfig: Add /proc/bootconfig to show boot config list")
> Cc: stable@vger.kernel.org
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  fs/proc/bootconfig.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/bootconfig.c b/fs/proc/bootconfig.c
> index 9955d75c0585..930d1dae33eb 100644
> --- a/fs/proc/bootconfig.c
> +++ b/fs/proc/bootconfig.c
> @@ -27,6 +27,7 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
>  {
>  	struct xbc_node *leaf, *vnode;
>  	const char *val;
> +	char q;
>  	char *key, *end = dst + size;
>  	int ret = 0;

Hmm, shouldn't the above have the upside-down xmas tree format?

	struct xbc_node *leaf, *vnode;
	char *key, *end = dst + size;
	const char *val;
	char q;
	int ret = 0;


Looks a little better that way. But anyway, more meat below.

>  
> @@ -41,16 +42,20 @@ static int __init copy_xbc_key_value_list(char *dst, size_t size)
>  			break;
>  		dst += ret;
>  		vnode = xbc_node_get_child(leaf);
> -		if (vnode && xbc_node_is_array(vnode)) {
> +		if (vnode) {
>  			xbc_array_for_each_value(vnode, val) {
> -				ret = snprintf(dst, rest(dst, end), "\"%s\"%s",
> -					val, vnode->next ? ", " : "\n");

The above is a functional change that is not described in the change
log.

You use to have:

	if (vnode && xbc_node_is_array(vnode)) {
		xbc_array_for_each_value() {
			[..]
		}
	} else {
		[..]
	}

And now have:

	if (vnode) {
		xbc_array_for_each_value() {
			[..]
		}
	} else {
		[..]
	}

Is "vnode" equivalent to "vnode && xbc_node_is_array(vnode)" ?

Why was this change made? It seems out of scope with the change log?

-- Steve


> +				if (strchr(val, '"'))
> +					q = '\'';
> +				else
> +					q = '"';
> +				ret = snprintf(dst, rest(dst, end), "%c%s%c%s",
> +					q, val, q, vnode->next ? ", " : "\n");
>  				if (ret < 0)
>  					goto out;
>  				dst += ret;
>  			}
>  		} else {
> -			ret = snprintf(dst, rest(dst, end), "\"%s\"\n", val);
> +			ret = snprintf(dst, rest(dst, end), "\"\"\n");
>  			if (ret < 0)
>  				break;
>  			dst += ret;

