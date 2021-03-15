Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B3833B220
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 13:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhCOMIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 08:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229748AbhCOMHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 08:07:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97E4764E27;
        Mon, 15 Mar 2021 12:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615810062;
        bh=vM8x/V/80btoDH0FlvPjCge1t8yEhaW77QScR8zl05Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bdbJOgCbj1xEP2D3DEilMOIjRGD4jB58O0KhLJFQsQgswxgh3sm1F59ffHk6H3ehP
         WMNmpbonXrH6IjjlVXJMTmDJGnH6uq1Q/YsVLzrAHg0WCPoQpR3rclukYgz0VZesyM
         Yj4O0evrVxDWCkcjWG0Zx1IzGgk7t/aUizT1IHtM=
Date:   Mon, 15 Mar 2021 13:07:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        Eric Auger <eric.auger@redhat.com>, stable@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH][stable-4.{4,9}] KVM: arm64: Fix exclusive limit for IPA
 size
Message-ID: <YE9OCxeXXilxCjhB@kroah.com>
References: <20210315114646.4137198-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315114646.4137198-1-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 11:46:46AM +0000, Marc Zyngier wrote:
> Commit 262b003d059c6671601a19057e9fe1a5e7f23722 upstream.
> 
> When registering a memslot, we check the size and location of that
> memslot against the IPA size to ensure that we can provide guest
> access to the whole of the memory.
> 
> Unfortunately, this check rejects memslot that end-up at the exact
> limit of the addressing capability for a given IPA size. For example,
> it refuses the creation of a 2GB memslot at 0x8000000 with a 32bit
> IPA space.
> 
> Fix it by relaxing the check to accept a memslot reaching the
> limit of the IPA space.
> 
> Fixes: c3058d5da222 ("arm/arm64: KVM: Ensure memslots are within KVM_PHYS_SIZE")
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org # 4.4, 4.9
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Link: https://lore.kernel.org/r/20210311100016.3830038-3-maz@kernel.org
> ---
>  arch/arm/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

That worked, now queued up, thanks!

greg k-h
