Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CA0380BB5
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 16:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhENOXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 10:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230460AbhENOXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 10:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43CC361107;
        Fri, 14 May 2021 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621002141;
        bh=kxiUgLhuFt62++4dkESESOH7B1uO/TQ4XYIjDLmcx8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J5msPRD+nsha1gDYNCYns4k/Zzq4pFTWMN7qu340XSG0ESpN5ZX6QJBt6qCZBgc18
         D257cRR8GmlisJE0ou4s1dNiwjGtKTTb/8mwjCshCv+Aw7LUbSp3ZK2e//hlRThcLS
         XHNFmtSXPVKfjK9efYyVvgMyaHz0Gcqt9+bg7/o0=
Date:   Fri, 14 May 2021 16:21:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove the defunct update_pte() paging hook
Message-ID: <YJ6HZfCvpt3ucpOO@kroah.com>
References: <20210514113853.37957-1-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514113853.37957-1-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 01:38:53PM +0200, Jack Wang wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> commit c5e2184d1544f9e56140791eff1a351bea2e63b9 upstream
> 
> Remove the update_pte() shadow paging logic, which was obsoleted by
> commit 4731d4c7a077 ("KVM: MMU: out of sync shadow core"), but never
> removed.  As pointed out by Yu, KVM never write protects leaf page
> tables for the purposes of shadow paging, and instead marks their
> associated shadow page as unsync so that the guest can write PTEs at
> will.
> 
> The update_pte() path, which predates the unsync logic, optimizes COW
> scenarios by refreshing leaf SPTEs when they are written, as opposed to
> zapping the SPTE, restarting the guest, and installing the new SPTE on
> the subsequent fault.  Since KVM no longer write-protects leaf page
> tables, update_pte() is unreachable and can be dropped.
> 
> Reported-by: Yu Zhang <yu.c.zhang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20210115004051.4099250-1-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> (jwang: backport to 5.4 to fix a warning on AMD nested Virtualization)
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
> We hit a warning in  WARNING: CPU: 62 PID: 29302 at arch/x86/kvm/mmu.c:2250 nonpaging_update_pte+0x5/0x10 [kvm]
> on AMD Opteron(tm) Processor 6386 SE with kernel 5.4.113, it seems nested L2 is running, I notice a similar bug
> report on https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1884058.
> 
> I did test with kvm-unit-tests on both Intel Broadwell/Skylake, AMD Opteron, no
> regression, basic VM tests work fine too on 5.4 kernel.
> the commit c5e2184d1544f9e56140791eff1a351bea2e63b9 can be cherry-picked cleanly
> to kernel 5.10+.

Now queued up, thanks.

greg k-h
