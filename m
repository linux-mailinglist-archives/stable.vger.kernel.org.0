Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB7F7627
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfKKOOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:32814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbfKKOOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 09:14:46 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B62B21925;
        Mon, 11 Nov 2019 14:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573481685;
        bh=ZZWPDYpbjcB24wxjw0R/DjL+gTh8PeO37olaGfabnx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=piJhe3uZkk7+nBFKRiuo3umuyUZnV6R6ULbfqpR8zfT13J60wCjiz14DOQ2Zbl8O3
         pPDYZYpbUAOyKGJzOf8cgMGMJAI1Pe7rN3gy3ZFyxG4HRR4AmYZP/qtAzuMRJbAKs3
         1oiVurQ6z5RiVyJQvAIQq6vUHdTxEuBgOg4ViFIw=
Date:   Mon, 11 Nov 2019 09:14:44 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     jbeulich@suse.com, tglx@linutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/apic/32: Avoid bogus LDR warnings"
 failed to apply to 4.14-stable tree
Message-ID: <20191111141444.GD8496@sasha-vm>
References: <15734537989102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <15734537989102@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:29:58AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
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
>From fe6f85ca121e9c74e7490fe66b0c5aae38e332c3 Mon Sep 17 00:00:00 2001
>From: Jan Beulich <jbeulich@suse.com>
>Date: Tue, 29 Oct 2019 10:34:19 +0100
>Subject: [PATCH] x86/apic/32: Avoid bogus LDR warnings
>
>The removal of the LDR initialization in the bigsmp_32 APIC code unearthed
>a problem in setup_local_APIC().
>
>The code checks unconditionally for a mismatch of the logical APIC id by
>comparing the early APIC id which was initialized in get_smp_config() with
>the actual LDR value in the APIC.
>
>Due to the removal of the bogus LDR initialization the check now can
>trigger on bigsmp_32 APIC systems emitting a warning for every booting
>CPU. This is of course a false positive because the APIC is not using
>logical destination mode.
>
>Restrict the check and the possibly resulting fixup to systems which are
>actually using the APIC in logical destination mode.
>
>[ tglx: Massaged changelog and added Cc stable ]
>
>Fixes: bae3a8d3308 ("x86/apic: Do not initialize LDR and DFR for bigsmp")
>Signed-off-by: Jan Beulich <jbeulich@suse.com>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>Cc: stable@vger.kernel.org
>Link: https://lkml.kernel.org/r/666d8f91-b5a8-1afd-7add-821e72a35f03@suse.com

I've queued these additional patches as dependencies on 4.9 and 4.14:

9d4730880a6d3 ("x86/apic: Drop logical_smp_processor_id() inline")
30769b576ce79 ("x86/apic: Move pending interrupt check code into it's
own function")

-- 
Thanks,
Sasha
