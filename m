Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C5E2A07E1
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 15:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgJ3Oaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 10:30:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:47700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgJ3Oaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 10:30:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604068250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dzYRrHej5hwjdfH+v+jsCGMI1ohR5+BirpcUtCHUXxQ=;
        b=CPD8K/ywq8vKYtZW5A2+PtWBC4VF2z7PYJKPwv2MMTuvQ66KNaZzlhmyOFkQpOOWU0nGlU
        hZBN5dX22vj+/LXY62V7n/T1Hs7LKOqWQoBsHBQS99fPgM4Cr6VGBTUFGR4vyih15fy0jp
        B/p/LKjHKTqkd+hvpDp2gc0ENNGOCaA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0117BAE0F;
        Fri, 30 Oct 2020 14:30:50 +0000 (UTC)
Date:   Fri, 30 Oct 2020 15:30:49 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] reboot: fix parsing of reboot cpu number
Message-ID: <20201030143049.GE1602@alley>
References: <20201027133545.58625-1-mcroce@linux.microsoft.com>
 <20201027133545.58625-3-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027133545.58625-3-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 2020-10-27 14:35:45, Matteo Croce wrote:
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

                                                     ^^^^^^

> +			int cpu;
> +
> +			/*
> +			 * reboot_cpu is s[mp]#### with #### being the processor
> +			 * to be used for rebooting. Skip 's' or 'smp' prefix.
> +			 */
> +			str += str[1] == 'm' && str[2] == 'p' ? 3 : 1;
> +
> +			if (isdigit(str[0])) {
> +				cpu = simple_strtoul(str, NULL, 0);
> +				if (cpu >= num_possible_cpus())
>  					return -ERANGE;
> -				}
> +				reboot_cpu = cpu;

The original value stays when the new one is out of range. It is
small functional change that should get mentioned in the commit
message or better fixed separately.

Hmm, I suggest to split this into 3 patches and switch the order:

  + 1st patch should simply revert the commit 616feab75397
   ("kernel/reboot.c: convert simple_strtoul to kstrtoint").

  + 2nd patch should merge the two branches without any
    functional change.

  + 3rd patch should add the check for num_possible_cpus()
    and update the value only when it is valid.

I am sorry that I did not suggested this when reviewed v1.
I have missed this functional change at that time.

Best Regards,
Petr
