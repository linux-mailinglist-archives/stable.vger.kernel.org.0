Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C75029AD9A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752421AbgJ0NmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409344AbgJ0NmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:42:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B64221707;
        Tue, 27 Oct 2020 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603806123;
        bh=rPZ1e/apu/84Ff1QPQDnMRCJ/51pT/Q3Isr+hNwHq6Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c12dLILyQZuTBNo8D1k8FZjOVq+3z/v8Qu23932n5kBMI4MsxM7WSJbX+91AHRjvC
         RA1KiR0UNpH3rhuR8w1f2mHxe8zp/R4B5uexzGggIhZYwVbXIeBAp7B28KGlbwg7ke
         jX8Ve8o25rXGkx6ENpDKFjTObnRxohOxZVbOuQJc=
Date:   Tue, 27 Oct 2020 14:42:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Petr Mladek <pmladek@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] reboot: fix parsing of reboot cpu number
Message-ID: <20201027134233.GB991306@kroah.com>
References: <20201027133545.58625-1-mcroce@linux.microsoft.com>
 <20201027133545.58625-3-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027133545.58625-3-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 02:35:45PM +0100, Matteo Croce wrote:
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
>  kernel/reboot.c | 30 ++++++++++++------------------
>  1 file changed, 12 insertions(+), 18 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
