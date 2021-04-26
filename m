Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9704536B3CB
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 15:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhDZNIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 09:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDZNIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 09:08:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B80A861353;
        Mon, 26 Apr 2021 13:07:51 +0000 (UTC)
Date:   Mon, 26 Apr 2021 09:07:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf.c: remove leftover 'f' and 'F' cases from
 bstr_printf()
Message-ID: <20210426090750.6be265d2@gandalf.local.home>
In-Reply-To: <20210423094529.1862521-1-linux@rasmusvillemoes.dk>
References: <20210423094529.1862521-1-linux@rasmusvillemoes.dk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 23 Apr 2021 11:45:29 +0200
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Commit 9af7706492f9 ("lib/vsprintf: Remove support for %pF and %pf in
> favour of %pS and %ps") removed support for %pF and %pf, and correctly
> removed the handling of those cases in vbin_printf(). However, the
> corresponding cases in bstr_printf() were left behind.
> 
> In the same series, %pf was re-purposed for dealing with
> fwnodes (3bd32d6a2ee6, "lib/vsprintf: Add %pfw conversion specifier
> for printing fwnode names").
> 
> So should anyone use %pf with the binary printf routines,
> vbin_printf() would (correctly, as it involves dereferencing the
> pointer) do the string formatting to the u32 array, but bstr_printf()
> would not copy the string from the u32 array, but instead interpret
> the first sizeof(void*) bytes of the formatted string as a pointer -
> which generally won't end well (also, all subsequent get_args would be
> out of sync).
> 
> Fixes: 9af7706492f9 ("lib/vsprintf: Remove support for %pF and %pf in favour of %pS and %ps")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Thanks!

-- Steve

>  lib/vsprintf.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 41ddc353ebb8..39ef2e314da5 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -3135,8 +3135,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
>  			switch (*fmt) {
>  			case 'S':
>  			case 's':
> -			case 'F':
> -			case 'f':
>  			case 'x':
>  			case 'K':
>  			case 'e':

