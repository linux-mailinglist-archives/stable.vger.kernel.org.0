Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA8F15F741
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388011AbgBNUB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:01:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387401AbgBNUB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 15:01:56 -0500
Received: from localhost (unknown [12.246.51.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAAA0206D7;
        Fri, 14 Feb 2020 20:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581710515;
        bh=EP6Yz8QatpWGnQGb0Qfq43e9/UcTZyGHaZs8ysch+5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJ1qe3G//QuGyzDQdewbPTz46rASSMoC+F70SU6TiGXnd4/02ul+n8yWKklMfUcNq
         YpmReVQXcgD4VCjhHWdNSfvHjy+3lWcwnrt23q+EQcGp8rXHVuip8ptUoc6pi0IQxt
         xkr+i12D5gsI9V810x3i4Z1tbpwOeT48X/iAQkao=
Date:   Fri, 14 Feb 2020 07:17:27 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     stable@vger.kernel.org, X86 ML <x86@kernel.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mce/amd: Fix kobject lifetime
Message-ID: <20200214151727.GA3959278@kroah.com>
References: <20200214082801.13836-1-bp@alien8.de>
 <20200214083230.GA13395@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214083230.GA13395@zn.tnic>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 09:32:30AM +0100, Borislav Petkov wrote:
> On Fri, Feb 14, 2020 at 09:28:01AM +0100, Borislav Petkov wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Accessing the MCA thresholding controls in sysfs concurrently with CPU
> > hotplug can lead to a couple of KASAN-reported issues:
> > 
> >   BUG: KASAN: use-after-free in sysfs_file_ops+0x155/0x180
> >   Read of size 8 at addr ffff888367578940 by task grep/4019
> > 
> > and
> > 
> >   BUG: KASAN: use-after-free in show_error_count+0x15c/0x180
> >   Read of size 2 at addr ffff888368a05514 by task grep/4454
> > 
> > for example. Both result from the fact that the threshold block
> > creation/teardown code frees the descriptor memory itself instead of
> > defining proper ->release function and leaving it to the driver core to
> > take care of that, after all sysfs accesses have completed.
> > 
> > Do that and get rid of the custom freeing code, fixing the above UAFs in
> > the process.
> > 
> >   [ bp: write commit message. ]
> > 
> > Fixes: 95268664390b ("[PATCH] x86_64: mce_amd support for family 0x10 processors")
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Cc: <stable@vger.kernel.org>
> 
> Damn git-send-email: it read out Cc: stable and added it to the Cc list.
> I've added
> 
> suppresscc = bodycc
> 
> to my .gitconfig.
> 
> Sorry stable guys.

Does not bother me at all, it's fine to see stuff come by that will end
up in future trees, it's not noise at all.  So no need to suppress
stable@vger if you don't want to.

thanks,

greg k-h
