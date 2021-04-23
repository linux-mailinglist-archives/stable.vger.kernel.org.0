Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCC7368FF8
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 12:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhDWKCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 06:02:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:54056 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230036AbhDWKCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 06:02:31 -0400
IronPort-SDR: 9G4E3Ov8ssAf/hNOCMSTzMAy6OjXeohq6tQpfVoV4YnjIIGX8+FthmQPMri9FytpZUfpzcIE0O
 YkNH1tqouVHA==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195601753"
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="195601753"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 03:01:52 -0700
IronPort-SDR: rAkZ9qqNlkzR9RQiI6kXoqh1DuQ9T70NQSncXM/J+MS347z6VVq5gTON5YXp36GbgmH22P8Rbr
 L0e+gVRln1XA==
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="603499222"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 03:01:49 -0700
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id 66F5820207;
        Fri, 23 Apr 2021 13:01:46 +0300 (EEST)
Date:   Fri, 23 Apr 2021 13:01:46 +0300
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf.c: remove leftover 'f' and 'F' cases from
 bstr_printf()
Message-ID: <20210423100146.GQ3@paasikivi.fi.intel.com>
References: <20210423094529.1862521-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423094529.1862521-1-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rasmus,

On Fri, Apr 23, 2021 at 11:45:29AM +0200, Rasmus Villemoes wrote:
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

Thanks!

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> ---
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
> -- 
> 2.29.2
> 

-- 
Sakari Ailus
