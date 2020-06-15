Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D441FA15F
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbgFOUV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731467AbgFOUV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 16:21:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19DC32074D;
        Mon, 15 Jun 2020 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592252518;
        bh=HI2BAY0H+qIOEZCzlTFo/ESz0Cmw03+IY6nmq2ZwN4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DrYkvP4zVUo1z45W0u+1HZR1Aewv3M7zepx/+DhV1TwcqwmmYnY9uGUTt4KOUAhqM
         rFg0iMiselOd7LCSWpbcvWqNm14GncyQWR6fNaTHUrjqAwSJPCJgS+wjFhnWpvdGIs
         5tHIvJPYbMwF/4fN7yC6i+0JNH2ZrbTwePEQ8yeA=
Date:   Mon, 15 Jun 2020 16:21:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     tony.luck@intel.com, bp@suse.de, juew@google.com,
        stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: FAILED: patch "[PATCH] x86/{mce,mm}: Unmap the entire page if
 the whole page is" failed to apply to 5.7-stable tree
Message-ID: <20200615202157.GB1931@sasha-vm>
References: <1592233210137106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1592233210137106@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:00:10PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.7-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 17fae1294ad9d711b2c3dd0edef479d40c76a5e8 Mon Sep 17 00:00:00 2001
>From: Tony Luck <tony.luck@intel.com>
>Date: Wed, 20 May 2020 09:35:46 -0700
>Subject: [PATCH] x86/{mce,mm}: Unmap the entire page if the whole page is
> affected and poisoned
>
>An interesting thing happened when a guest Linux instance took a machine
>check. The VMM unmapped the bad page from guest physical space and
>passed the machine check to the guest.
>
>Linux took all the normal actions to offline the page from the process
>that was using it. But then guest Linux crashed because it said there
>was a second machine check inside the kernel with this stack trace:
>
>do_memory_failure
>    set_mce_nospec
>         set_memory_uc
>              _set_memory_uc
>                   change_page_attr_set_clr
>                        cpa_flush
>                             clflush_cache_range_opt
>
>This was odd, because a CLFLUSH instruction shouldn't raise a machine
>check (it isn't consuming the data). Further investigation showed that
>the VMM had passed in another machine check because is appeared that the
>guest was accessing the bad page.
>
>Fix is to check the scope of the poison by checking the MCi_MISC register.
>If the entire page is affected, then unmap the page. If only part of the
>page is affected, then mark the page as uncacheable.
>
>This assumes that VMMs will do the logical thing and pass in the "whole
>page scope" via the MCi_MISC register (since they unmapped the entire
>page).
>
>  [ bp: Adjust to x86/entry changes. ]

We need to "unadjust" it for the stable branches, and I dare not do it
myself :)

Would picking up the original version from the mailing list work here as
a backport?

-- 
Thanks,
Sasha
