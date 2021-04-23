Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2543B3695B6
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbhDWPLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:11:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:46356 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231269AbhDWPLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:11:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619190623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JmQ7Myjvr5caQMjQGq7P6Xo7dPghr5/mLb4Tc4GGKVI=;
        b=jAcLp3uMRrKzjzYIHYR7wqmVgxFtX2FugozA/di22uZcqg3392F94tU8SyIWf+w6d7blQn
        hBqerGWQc5EB083PFAOguOAljW6pxiQrKDB35kQEee4V6P1d95IAtktfpeBMYBkT4gRLrv
        +LcGucv86HrMKtGzPqt9la5KUpq5Tto=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 42B57AFD0;
        Fri, 23 Apr 2021 15:10:23 +0000 (UTC)
Date:   Fri, 23 Apr 2021 17:10:22 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf.c: remove leftover 'f' and 'F' cases from
 bstr_printf()
Message-ID: <YILjXk4lXavneW7H@alley>
References: <20210423094529.1862521-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423094529.1862521-1-linux@rasmusvillemoes.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 2021-04-23 11:45:29, Rasmus Villemoes wrote:
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

Great catch!

The patch is pushed in printk/linux.git, branch for-5.13 now.

I did it quickly because the merge window will likely be opened
next week and this should get in.

Best Regards,
Petr
