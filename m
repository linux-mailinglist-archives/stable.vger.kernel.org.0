Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DCF21E04B
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 20:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgGMS7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 14:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgGMS7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 14:59:03 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96D492067D;
        Mon, 13 Jul 2020 18:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594666742;
        bh=vgTIYDVYS5jxJNVvYVjS8W29CjRb7evdjieLghrKvUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vJkGwft/OPtHl5k2q34hrVcc6ihePHkE86CZqR6CbgqO1ZHk9UOxL+xAnqJyXfukC
         WlIAkKYKoOsVdMlmeWa9e9sz8XXTCypRgU8hfB2OkJ5G4Gdrymp+IpuvxVzAXaT0cJ
         a4WhHqGKtKgRbMhEpqM5gkCi0oqZhh0E3rKWlEvE=
Date:   Mon, 13 Jul 2020 14:59:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     steven.price@arm.com, james.morse@arm.com, maz@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: arm64: Fix kvm_reset_vcpu() return
 code being incorrect" failed to apply to 5.4-stable tree
Message-ID: <20200713185901.GG2722994@sasha-vm>
References: <1594656059166107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1594656059166107@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 13, 2020 at 06:00:59PM +0200, gregkh@linuxfoundation.org wrote:
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
>From 66b7e05dc0239c5817859f261098ba9cc2efbd2b Mon Sep 17 00:00:00 2001
>From: Steven Price <steven.price@arm.com>
>Date: Wed, 17 Jun 2020 11:54:56 +0100
>Subject: [PATCH] KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect
> with SVE
>
>If SVE is enabled then 'ret' can be assigned the return value of
>kvm_vcpu_enable_sve() which may be 0 causing future "goto out" sites to
>erroneously return 0 on failure rather than -EINVAL as expected.
>
>Remove the initialisation of 'ret' and make setting the return value
>explicit to avoid this situation in the future.
>
>Fixes: 9a3cdf26e336 ("KVM: arm64/sve: Allow userspace to enable SVE for vcpus")
>Cc: stable@vger.kernel.org
>Reported-by: James Morse <james.morse@arm.com>
>Signed-off-by: Steven Price <steven.price@arm.com>
>Signed-off-by: Marc Zyngier <maz@kernel.org>
>Link: https://lore.kernel.org/r/20200617105456.28245-1-steven.price@arm.com

I've worked around not having 540f76d12c66 ("arm64: cpufeature: Add CPU
capability for AArch32 EL1 support") in 5.7 and 5.4 and queued this
patch.

-- 
Thanks,
Sasha
