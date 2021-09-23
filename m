Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDFE415990
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 09:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhIWHup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 03:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239768AbhIWHuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Sep 2021 03:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEE6B61038;
        Thu, 23 Sep 2021 07:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632383348;
        bh=vusf6qDWIT9w5MVhvAPN9FdsgE7iRc+kxkjVuubI6a0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=myc4dZMrnDAH63RkhdaKX84wRaAP+bmhetfc6GrRTI8r+jMQddrO0UMJL6BEZuUMa
         VNUD7wMltNUYFjVX02oGoFJhN6TdTG8vrIOER957wtYsmnWY3TWE7s45f5nYooDfh7
         cFlN5Vm1TK3hWnCT7KskIMDnubYR2a6G8Lqge1j4=
Date:   Thu, 23 Sep 2021 09:49:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH] [backport for 4.19/5.4 stable] KVM: remember position in
 kvm->vcpus array
Message-ID: <YUwxccuAgVki2wol@kroah.com>
References: <20210921134815.17615-1-borntraeger@de.ibm.com>
 <280d7fb4-a02a-f8db-8af0-b567699cea80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <280d7fb4-a02a-f8db-8af0-b567699cea80@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 04:31:03PM +0200, Paolo Bonzini wrote:
> On 21/09/21 15:48, Christian Borntraeger wrote:
> > From: Radim Krčmář <rkrcmar@redhat.com>
> > 
> > Fetching an index for any vcpu in kvm->vcpus array by traversing
> > the entire array everytime is costly.
> > This patch remembers the position of each vcpu in kvm->vcpus array
> > by storing it in vcpus_idx under kvm_vcpu structure.
> > 
> > Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > [borntraeger@de.ibm.com]: backport to 4.19 (also fits for 5.4)
> > Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > ---
> >   include/linux/kvm_host.h | 11 +++--------
> >   virt/kvm/kvm_main.c      |  5 +++--
> >   2 files changed, 6 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 8dd4ebb58e97..827f70ce0b49 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -248,7 +248,8 @@ struct kvm_vcpu {
> >   	struct preempt_notifier preempt_notifier;
> >   #endif
> >   	int cpu;
> > -	int vcpu_id;
> > +	int vcpu_id; /* id given by userspace at creation */
> > +	int vcpu_idx; /* index in kvm->vcpus array */
> >   	int srcu_idx;
> >   	int mode;
> >   	u64 requests;
> > @@ -551,13 +552,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
> >   static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
> >   {
> > -	struct kvm_vcpu *tmp;
> > -	int idx;
> > -
> > -	kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
> > -		if (tmp == vcpu)
> > -			return idx;
> > -	BUG();
> > +	return vcpu->vcpu_idx;
> >   }
> >   #define kvm_for_each_memslot(memslot, slots)	\
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a3d82113ae1c..86ef740763b5 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2751,7 +2751,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> >   		goto unlock_vcpu_destroy;
> >   	}
> > -	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
> > +	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
> > +	BUG_ON(kvm->vcpus[vcpu->vcpu_idx]);
> >   	/* Now it's all set up, let userspace reach it */
> >   	kvm_get_kvm(kvm);
> > @@ -2761,7 +2762,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> >   		goto unlock_vcpu_destroy;
> >   	}
> > -	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
> > +	kvm->vcpus[vcpu->vcpu_idx] = vcpu;
> >   	/*
> >   	 * Pairs with smp_rmb() in kvm_get_vcpu.  Write kvm->vcpus
> > 
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> The backport makes sense given the code in the stable branch now calls
> kvm_vcpu_get_idx more than it used to.

Now queued up, thanks.

greg k-h
