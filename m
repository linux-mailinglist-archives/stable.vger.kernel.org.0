Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6E22904F6
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 14:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407342AbgJPMUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 08:20:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:57708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407332AbgJPMUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 08:20:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602850840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AN4PMuJ4sFqz6aPhmMGQdbQDoEmXBQZinO+4lRCKVrQ=;
        b=qfDeFe6++JLpWavIdnxE9JzwWJR8a5yeK19508uva0y474H5bqDzaVWpbvhkcSo55GeRFy
        7ocyrbpm5yMRe2RV4EWmiPs5w4qBZZog7JW9ixfnyho7GjMyDzgYbYJjnuXeU8AJsrq/tJ
        x8ss9xcQ9VSNqWRlbryHLLYt5+sQjDM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 664EDACA0;
        Fri, 16 Oct 2020 12:20:40 +0000 (UTC)
Date:   Fri, 16 Oct 2020 14:20:39 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: Re: [PATCH] reboot: fix parsing of reboot cpu number
Message-ID: <20201016122039.GH8871@alley>
References: <20201014212746.161363-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014212746.161363-1-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 2020-10-14 23:27:46, Matteo Croce wrote:
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
> To fix it, use _parse_integer() which still handles overflow, but
> restores the old behaviour of parsing until a non-digit character
> is found.

Hmm, _parse_integer() is an internal function. And even the comment
says "Don't you dare use this function."

I guess the it is because the base must be hardcoded. And
KSTRTOX_OVERFLOW bit must be handled.

I suggest to go back to simple_strtoul(). It is not longer obsolete.
It still exists because it is needed for exactly this purpose,
see the comment in include/linux/kernel.h

The potentional overflow is not a big deal. The result will be
that the system will reboot on another rCPU than expected. But
it might happen also with any typo.

> While at it, limit the CPU number to num_possible_cpus(),
> because setting it to a value lower than INT_MAX but higher
> than NR_CPUS produces the following error on reboot and shutdown:

Great catch! Please, fix this in a separate patch.

Best Regards,
Petr
