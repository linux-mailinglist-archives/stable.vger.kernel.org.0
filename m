Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5333B12E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 12:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCOLay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 07:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhCOLaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 07:30:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 836AB64E20;
        Mon, 15 Mar 2021 11:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615807834;
        bh=+Vh47VzzAQ8Y4lYeLFe/YRi9yK/q8CBm43+kjOVO1oQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O+XAjXZbwbH1sy7ZxvsEZXXP3r8S7RXFTo90Xin/1o2pE1np7AY1LOUyAbwIX52bt
         04hRCTwzTond2tfpAOO9XE0PPUJAbEBCa7nAyqwUkER3LaLeqMowG88HfjvdEqa8ZG
         Ht0Cu9kkCEpV/XgSTaWtptx/bwjGiELAUHhlT4E0=
Date:   Mon, 15 Mar 2021 12:30:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kernel-team@android.com,
        Eric Auger <eric.auger@redhat.com>, stable@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH][stable-4.{4,9,14,19}] KVM: arm64: Fix exclusive limit
 for IPA size
Message-ID: <YE9FVw1PE9kClrdi@kroah.com>
References: <20210315110833.4135927-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315110833.4135927-1-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 11:08:33AM +0000, Marc Zyngier wrote:
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
> Cc: stable@vger.kernel.org # 4.4, 4.9, 4.14, 4.19
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Link: https://lore.kernel.org/r/20210311100016.3830038-3-maz@kernel.org
> ---
>  virt/kvm/arm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This file does not exist in 4.4.y or 4.9.y, so I can't apply it there :(

Queued up everywhere else, and also the other backports you sent,
thanks.

gre gk-h
