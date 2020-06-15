Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33F61F9E31
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 19:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgFORNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 13:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbgFORNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 13:13:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA85A20656;
        Mon, 15 Jun 2020 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592241190;
        bh=/sJhRQXhZDp1B/EEpvnskvVH6jfudfhtWBuKnN3whqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mRGWtVvHvPXE7toOz/TQPS/RJ0xBnpl/z00wI8Cf8vKmH9WHIeNb+FTcGLPVvomT7
         83Ck4fsSb4j0w2RSooBNux+Si3XA51R5/W4+Pwa4B4MBt34JB9sp3D7Qe92gdXPETx
         /2E2V1f8YmvLh6zIMr2aVz0qGD8KTux+SJl1eqHw=
Date:   Mon, 15 Jun 2020 13:13:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86: only do L1TF workaround on
 affected processors" failed to apply to 4.19-stable tree
Message-ID: <20200615171308.GF5492@sasha-vm>
References: <159222779021249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <159222779021249@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 03:29:50PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From d43e2675e96fc6ae1a633b6a69d296394448cc32 Mon Sep 17 00:00:00 2001
>From: Paolo Bonzini <pbonzini@redhat.com>
>Date: Tue, 19 May 2020 05:34:41 -0400
>Subject: [PATCH] KVM: x86: only do L1TF workaround on affected processors
>
>KVM stores the gfn in MMIO SPTEs as a caching optimization.  These are split
>in two parts, as in "[high 11111 low]", to thwart any attempt to use these bits
>in an L1TF attack.  This works as long as there are 5 free bits between
>MAXPHYADDR and bit 50 (inclusive), leaving bit 51 free so that the MMIO
>access triggers a reserved-bit-set page fault.
>
>The bit positions however were computed wrongly for AMD processors that have
>encryption support.  In this case, x86_phys_bits is reduced (for example
>from 48 to 43, to account for the C bit at position 47 and four bits used
>internally to store the SEV ASID and other stuff) while x86_cache_bits in
>would remain set to 48, and _all_ bits between the reduced MAXPHYADDR
>and bit 51 are set.  Then low_phys_bits would also cover some of the
>bits that are set in the shadow_mmio_value, terribly confusing the gfn
>caching mechanism.
>
>To fix this, avoid splitting gfns as long as the processor does not have
>the L1TF bug (which includes all AMD processors).  When there is no
>splitting, low_phys_bits can be set to the reduced MAXPHYADDR removing
>the overlap.  This fixes "npt=0" operation on EPYC processors.
>
>Thanks to Maxim Levitsky for bisecting this bug.
>
>Cc: stable@vger.kernel.org
>Fixes: 52918ed5fcf0 ("KVM: SVM: Override default MMIO mask if memory encryption is enabled")
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I took these two additional patches for 4.14 and 4.19:

26c44a63a291 ("KVM: x86/mmu: Consolidate "is MMIO SPTE" code")
21dd7466353c ("kvm: x86: Fix L1TF mitigation for shadow MMU")

-- 
Thanks,
Sasha
