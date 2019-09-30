Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E62C20DC
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 14:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfI3MtI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Sep 2019 08:49:08 -0400
Received: from 6.mo178.mail-out.ovh.net ([46.105.53.132]:50184 "EHLO
        6.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730693AbfI3MtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 08:49:08 -0400
X-Greylist: delayed 1171 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2019 08:49:07 EDT
Received: from player794.ha.ovh.net (unknown [10.109.160.232])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id 640E078A99
        for <stable@vger.kernel.org>; Mon, 30 Sep 2019 14:29:35 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player794.ha.ovh.net (Postfix) with ESMTPSA id 67737A5A57C6;
        Mon, 30 Sep 2019 12:29:22 +0000 (UTC)
Date:   Mon, 30 Sep 2019 14:29:21 +0200
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/6] KVM: PPC: Book3S HV: XIVE: Compute the VP id in
 a common helper
Message-ID: <20190930142921.380e4e1b@bahia.w3ibm.bluemix.net>
In-Reply-To: <fb6accd0-f3fa-d441-5892-516ed4118d3b@kaod.org>
References: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
        <156958523534.1503771.7854438316257986828.stgit@bahia.lan>
        <fb6accd0-f3fa-d441-5892-516ed4118d3b@kaod.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 17667339865624058251
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrgedvgdegkecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 30 Sep 2019 14:01:56 +0200
Cédric Le Goater <clg@kaod.org> wrote:

> On 27/09/2019 13:53, Greg Kurz wrote:
> > Reduce code duplication by consolidating the checking of vCPU ids and VP
> > ids to a common helper used by both legacy and native XIVE KVM devices.
> > And explain the magic with a comment.
> > 
> > Signed-off-by: Greg Kurz <groug@kaod.org>
> 
> Looks fine. One question below,
> 
> > ---
> >  arch/powerpc/kvm/book3s_xive.c        |   42 ++++++++++++++++++++++++++-------
> >  arch/powerpc/kvm/book3s_xive.h        |    1 +
> >  arch/powerpc/kvm/book3s_xive_native.c |   11 ++-------
> >  3 files changed, 36 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> > index 0b7859e40f66..d84da9f6ee88 100644
> > --- a/arch/powerpc/kvm/book3s_xive.c
> > +++ b/arch/powerpc/kvm/book3s_xive.c
> > @@ -1211,6 +1211,37 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.xive_vcpu = NULL;
> >  }
> >  
> > +static bool kvmppc_xive_vcpu_id_valid(struct kvmppc_xive *xive, u32 cpu)
> > +{
> > +	/* We have a block of KVM_MAX_VCPUS VPs. We just need to check
> > +	 * raw vCPU ids are below the expected limit for this guest's
> > +	 * core stride ; kvmppc_pack_vcpu_id() will pack them down to an
> > +	 * index that can be safely used to compute a VP id that belongs
> > +	 * to the VP block.
> > +	 */
> > +	return cpu < KVM_MAX_VCPUS * xive->kvm->arch.emul_smt_mode;
> > +}
> > +
> > +int kvmppc_xive_compute_vp_id(struct kvmppc_xive *xive, u32 cpu, u32 *vp)
> > +{
> > +	u32 vp_id;
> > +
> > +	if (!kvmppc_xive_vcpu_id_valid(xive, cpu)) {
> > +		pr_devel("Out of bounds !\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	vp_id = kvmppc_xive_vp(xive, cpu);
> > +	if (kvmppc_xive_vp_in_use(xive->kvm, vp_id)) {
> > +		pr_devel("Duplicate !\n");
> > +		return -EEXIST;
> > +	}
> > +
> > +	*vp = vp_id;
> > +
> > +	return 0;
> 
> why not return vp_id ? and test for a negative value in callers.
> 

Simpler code in the callers IMHO.

> 
> C.
> 
> > +}
> > +
> >  int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
> >  			     struct kvm_vcpu *vcpu, u32 cpu)
> >  {
> > @@ -1229,20 +1260,13 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
> >  		return -EPERM;
> >  	if (vcpu->arch.irq_type != KVMPPC_IRQ_DEFAULT)
> >  		return -EBUSY;
> > -	if (cpu >= (KVM_MAX_VCPUS * vcpu->kvm->arch.emul_smt_mode)) {
> > -		pr_devel("Out of bounds !\n");
> > -		return -EINVAL;
> > -	}
> >  
> >  	/* We need to synchronize with queue provisioning */
> >  	mutex_lock(&xive->lock);
> >  
> > -	vp_id = kvmppc_xive_vp(xive, cpu);
> > -	if (kvmppc_xive_vp_in_use(xive->kvm, vp_id)) {
> > -		pr_devel("Duplicate !\n");
> > -		r = -EEXIST;
> > +	r = kvmppc_xive_compute_vp_id(xive, cpu, &vp_id);
> > +	if (r)
> >  		goto bail;
> > -	}
> >  
> >  	xc = kzalloc(sizeof(*xc), GFP_KERNEL);
> >  	if (!xc) {
> > diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
> > index fe3ed50e0818..90cf6ec35a68 100644
> > --- a/arch/powerpc/kvm/book3s_xive.h
> > +++ b/arch/powerpc/kvm/book3s_xive.h
> > @@ -296,6 +296,7 @@ int kvmppc_xive_attach_escalation(struct kvm_vcpu *vcpu, u8 prio,
> >  struct kvmppc_xive *kvmppc_xive_get_device(struct kvm *kvm, u32 type);
> >  void xive_cleanup_single_escalation(struct kvm_vcpu *vcpu,
> >  				    struct kvmppc_xive_vcpu *xc, int irq);
> > +int kvmppc_xive_compute_vp_id(struct kvmppc_xive *xive, u32 cpu, u32 *vp);
> >  
> >  #endif /* CONFIG_KVM_XICS */
> >  #endif /* _KVM_PPC_BOOK3S_XICS_H */
> > diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> > index 43a86858390a..5bb480b2aafd 100644
> > --- a/arch/powerpc/kvm/book3s_xive_native.c
> > +++ b/arch/powerpc/kvm/book3s_xive_native.c
> > @@ -118,19 +118,12 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
> >  		return -EPERM;
> >  	if (vcpu->arch.irq_type != KVMPPC_IRQ_DEFAULT)
> >  		return -EBUSY;
> > -	if (server_num >= (KVM_MAX_VCPUS * vcpu->kvm->arch.emul_smt_mode)) {
> > -		pr_devel("Out of bounds !\n");
> > -		return -EINVAL;
> > -	}
> >  
> >  	mutex_lock(&xive->lock);
> >  
> > -	vp_id = kvmppc_xive_vp(xive, server_num);
> > -	if (kvmppc_xive_vp_in_use(xive->kvm, vp_id)) {
> > -		pr_devel("Duplicate !\n");
> > -		rc = -EEXIST;
> > +	rc = kvmppc_xive_compute_vp_id(xive, server_num, &vp_id);
> > +	if (rc)
> >  		goto bail;
> > -	}
> >  
> >  	xc = kzalloc(sizeof(*xc), GFP_KERNEL);
> >  	if (!xc) {
> > 
> 

