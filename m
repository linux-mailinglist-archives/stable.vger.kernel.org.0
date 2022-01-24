Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4B8498276
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 15:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiAXOcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 09:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiAXOcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 09:32:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D91C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 06:32:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA6F661357
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 14:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C22C340E1;
        Mon, 24 Jan 2022 14:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643034739;
        bh=4mGGFtBi8/9kEw7YvDwd6fmmblkHiorNTsZPijNnnJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c3VCzkbBEbXmT6PdXMtFccQs+E8gVvBvFsk2Kd7ytEjBdaiVZfsA6jmz63EYmJkT6
         frYMrQlSfedxgZqRVNKfPhOP3x1SfMWTBoqhU4xhbNMuoZyk/64x4uLduBjMaNckVu
         V3yWP2lXDVSXcxPebks99uwHVAlIFbC4vgGvakLo=
Date:   Mon, 24 Jan 2022 15:32:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, stable@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH stable 5.16 v1 0/4] KVM: x86: Partially allow
 KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug
Message-ID: <Ye64cENZbXBLtouG@kroah.com>
References: <20220124130534.2645955-1-vkuznets@redhat.com>
 <3a46a1b5-88ec-83c1-53ac-a08e5900062f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a46a1b5-88ec-83c1-53ac-a08e5900062f@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 02:17:52PM +0100, Paolo Bonzini wrote:
> On 1/24/22 14:05, Vitaly Kuznetsov wrote:
> > This is a backport of the recently merged "[PATCH v3 0/4] KVM: x86:
> > Partially allow KVM_SET_CPUID{,2} after KVM_RUN for CPU hotplug"
> > (https://lore.kernel.org/kvm/20220118141801.2219924-1-vkuznets@redhat.com/)
> > 
> > Original description:
> > 
> > Recently, KVM made it illegal to change CPUID after KVM_RUN but
> > unfortunately this change is not fully compatible with existing VMMs.
> > In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
> > calls KVM_SET_CPUID2. Relax the requirement by implementing an allowing
> > KVM_SET_CPUID{,2} with the exact same data.
> > 
> > Vitaly Kuznetsov (4):
> >    KVM: x86: Do runtime CPUID update before updating
> >      vcpu->arch.cpuid_entries
> >    KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
> >    KVM: selftests: Rename 'get_cpuid_test' to 'cpuid_test'
> >    KVM: selftests: Test KVM_SET_CPUID2 after KVM_RUN
> > 
> >   arch/x86/kvm/cpuid.c                          | 90 ++++++++++++++-----
> >   arch/x86/kvm/x86.c                            | 19 ----
> >   tools/testing/selftests/kvm/.gitignore        |  2 +-
> >   tools/testing/selftests/kvm/Makefile          |  4 +-
> >   .../selftests/kvm/include/x86_64/processor.h  |  7 ++
> >   .../selftests/kvm/lib/x86_64/processor.c      | 33 ++++++-
> >   .../x86_64/{get_cpuid_test.c => cpuid_test.c} | 30 +++++++
> >   7 files changed, 139 insertions(+), 46 deletions(-)
> >   rename tools/testing/selftests/kvm/x86_64/{get_cpuid_test.c => cpuid_test.c} (83%)
> > 
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 

Thanks, all now queued up.

greg k-h
