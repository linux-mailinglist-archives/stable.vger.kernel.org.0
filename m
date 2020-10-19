Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A16029288F
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 15:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgJSNtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 09:49:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:47262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgJSNtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Oct 2020 09:49:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603115385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0WuEu1sVQYwypPrmeh7IRBZ4h6wCe1meEeUaExOedg4=;
        b=bjmLHlUzq4NO0ZPLwtRJ1+FOVEceZm8hIxvyXlWUP+fNXiERSRk+mo3ZpqKLhnA38DTkaf
        jzRUjxUVeC1zNT8Bdi75/VmjbctFveWyPyVU3v6SU7XUT/sbGP2Rg94/dMs6p+2Q1iPc8f
        WVuA6U70zeoMKukXSNeQYDZh+ifpn9I=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DDD1AB22E;
        Mon, 19 Oct 2020 13:49:44 +0000 (UTC)
Date:   Mon, 19 Oct 2020 15:49:44 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] reboot: fix parsing of reboot cpu number
Message-ID: <20201019134944.GC26718@alley>
References: <20201016180907.171957-1-mcroce@linux.microsoft.com>
 <20201016180907.171957-3-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016180907.171957-3-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 2020-10-16 20:09:07, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> The kernel cmdline reboot= argument allows to specify the CPU used
> for rebooting, with the syntax `s####` among the other flags, e.g.
> 
>   reboot=soft,s4
>   reboot=warm,s31,force
> 
> In the early days the parsing was done with simple_strtoul(), later
> deprecated in favor of the safer kstrtoint() which handles overflow.
> 
> But kstrtoint() returns -EINVAL if there are non-digit characters
> in a string, so if this flag is not the last given, it's silently
> ignored as well as the subsequent ones.
> 
> To fix it, revert the usage of simple_strtoul(), which is no longer
> deprecated, and restore the old behaviour.
> 
> While at it, merge two identical code blocks into one.
> 
> Fixes: 616feab75397 ("kernel/reboot.c: convert simple_strtoul to kstrtoint")
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
> diff --git a/kernel/reboot.c b/kernel/reboot.c
> index c4e7965c39b9..475f790bbd75 100644
> --- a/kernel/reboot.c
> +++ b/kernel/reboot.c
> @@ -552,25 +552,19 @@ static int __init reboot_setup(char *str)
>  
>  		case 's':
>  		{
> -			int rc;
> -
> -			if (isdigit(*(str+1))) {
> -				rc = kstrtoint(str+1, 0, &reboot_cpu);
> -				if (rc)
> -					return rc;
> -				if (reboot_cpu >= num_possible_cpus()) {
> -					reboot_cpu = 0;
> -					return -ERANGE;
> -				}
> -			} else if (str[1] == 'm' && str[2] == 'p' &&
> -				   isdigit(*(str+3))) {
> -				rc = kstrtoint(str+3, 0, &reboot_cpu);
> -				if (rc)
> -					return rc;
> -				if (reboot_cpu >= num_possible_cpus()) {
> -					reboot_cpu = 0;
> +			int cpu;
> +
> +			/*
> +			 * reboot_cpu is s[mp]#### with #### being the processor
> +			 * to be used for rebooting. Skip 's' or 'smp' prefix.
> +			 */
> +			str += str[1] == 'm' && str[2] == 'p' ? 3 : 1;
> +
> +			if (isdigit(str[0])) {
> +				cpu = simple_strtoul(str, NULL, 10);

The original code did not force the base 10. And even the code before the
commit 616feab75397 ("kernel/reboot.c: convert simple_strtoul to
kstrtoint") did not force the base 10.

I am not sure if people use it. But sometimes it might be easier
to define the CPU number in hexa format.

With using simple_strtoul(str, NULL, 0):

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
