Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0C8162D46
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 18:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBRRox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 12:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgBRRox (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 12:44:53 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27F4424654;
        Tue, 18 Feb 2020 17:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582047892;
        bh=bXAM0wGGNI5ywPV+tCjoGi1vjqgF/CH9EIETimdkIzs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=owpUN6HXPhUr3nxpwhPBjirAybKQCtqYRWnlG8VmHZYvG9WM/zivS8AEJNMc6yMpW
         jVpD5ftpmSolx5p5vRJFSMRZaKCxn8Y0SFoYAi1NlvU8uknotXOLcw0KzmM2TZhLTB
         D8CMIW3bZNOfKG77Ef3opVhD3sVczX61jXm8OSRw=
Date:   Tue, 18 Feb 2020 12:44:51 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Fix struct guest_walker
 arrays for 5-level" failed to apply to 5.4-stable tree
Message-ID: <20200218174451.GT1734@sasha-vm>
References: <1581966871164161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1581966871164161@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 08:14:31PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From f6ab0107a4942dbf9a5cf0cca3f37e184870a360 Mon Sep 17 00:00:00 2001
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>Date: Fri, 7 Feb 2020 09:37:42 -0800
>Subject: [PATCH] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level
> paging
>
>Define PT_MAX_FULL_LEVELS as PT64_ROOT_MAX_LEVEL, i.e. 5, to fix shadow
>paging for 5-level guest page tables.  PT_MAX_FULL_LEVELS is used to
>size the arrays that track guest pages table information, i.e. using a
>"max levels" of 4 causes KVM to access garbage beyond the end of an
>array when querying state for level 5 entries.  E.g. FNAME(gpte_changed)
>will read garbage and most likely return %true for a level 5 entry,
>soft-hanging the guest because FNAME(fetch) will restart the guest
>instead of creating SPTEs because it thinks the guest PTE has changed.
>
>Note, KVM doesn't yet support 5-level nested EPT, so PT_MAX_FULL_LEVELS
>gets to stay "4" for the PTTYPE_EPT case.
>
>Fixes: 855feb673640 ("KVM: MMU: Add 5 level EPT & Shadow page table support.")
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

File name is different in 5.4 and 4.19. Fixed and queued up for both.

-- 
Thanks,
Sasha
