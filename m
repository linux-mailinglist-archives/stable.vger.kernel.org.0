Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E3C3BBD0F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 14:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhGEMto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 08:49:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhGEMto (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 08:49:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 989506135F;
        Mon,  5 Jul 2021 12:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625489227;
        bh=0roFNllKY9iPA4LuoFrjB0k+/abhW27hg6meO0rDgoI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rHIXXEb+8d97+7DYmzogbcGyGq2sAMtMIusGr7SioLLAydeXkfNOyHjB8riXH9foS
         ToW/u1opdH7ZCwwzEe/DDGWXSEPVRfl5iddZNnLiNky6uiUR1ZphCUyvPQDTFYZTW9
         p6eSkdN95UaHTiV1yKh9u1ZFOJUYB92K+ulyC9/w=
Date:   Mon, 5 Jul 2021 14:47:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alper Gun <alpergun@google.com>, stable@vger.kernel.org,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>
Subject: Re: [PATCH 5.4] KVM: SVM: Call SEV Guest Decommission if ASID
 binding fails
Message-ID: <YOL/Rpsw9JkEE8dR@kroah.com>
References: <20210628211054.61528-1-alpergun@google.com>
 <YOKxf/8AT5LA5wfu@kroah.com>
 <d857d3b7-edef-d9ea-98ac-70c4c5783c88@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d857d3b7-edef-d9ea-98ac-70c4c5783c88@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 01:40:39PM +0200, Paolo Bonzini wrote:
> On 05/07/21 09:15, Greg KH wrote:
> > On Mon, Jun 28, 2021 at 09:10:54PM +0000, Alper Gun wrote:
> > > commit 934002cd660b035b926438244b4294e647507e13 upstream.
> > > 
> > > Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
> > > fails. If a failure happens after  a successful LAUNCH_START command,
> > > a decommission command should be executed. Otherwise, guest context
> > > will be unfreed inside the AMD SP. After the firmware will not have
> > > memory to allocate more SEV guest context, LAUNCH_START command will
> > > begin to fail with SEV_RET_RESOURCE_LIMIT error.
> > > 
> > > The existing code calls decommission inside sev_unbind_asid, but it is
> > > not called if a failure happens before guest activation succeeds. If
> > > sev_bind_asid fails, decommission is never called. PSP firmware has a
> > > limit for the number of guests. If sev_asid_binding fails many times,
> > > PSP firmware will not have resources to create another guest context.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
> > > Reported-by: Peter Gonda <pgonda@google.com>
> > > Signed-off-by: Alper Gun <alpergun@google.com>
> > > Reviewed-by: Marc Orr <marcorr@google.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Message-Id: <20210610174604.2554090-1-alpergun@google.com>
> > 
> > Message-id?  Odd...
> 
> Not that much, see "git log -- drivers | grep Message-Id".  A link to
> lore.kernel.org is getting more popular these days, but Message-Id is what
> "git am" knows about.
> 
> > > ---
> > >   arch/x86/kvm/svm.c | 32 +++++++++++++++++++++-----------
> > >   1 file changed, 21 insertions(+), 11 deletions(-)
> > 
> > <snip>
> > 
> > Can you also provide working backports for the newer kernel trees as
> > well?  We would need this in 5.10 and 5.12, right?
> 
> Already queued:
> 
> https://lore.kernel.org/stable/20210628141828.31757-102-sashal@kernel.org/
> for 5.12
> https://lore.kernel.org/stable/20210628142607.32218-94-sashal@kernel.org/
> for 5.10

Ah, you are right, I forgot to update my local tree, my fault.

greg k-h
