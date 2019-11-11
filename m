Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6B5F743C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 13:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfKKMnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 07:43:52 -0500
Received: from 14.mo7.mail-out.ovh.net ([178.33.251.19]:49309 "EHLO
        14.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKMnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 07:43:52 -0500
X-Greylist: delayed 4629 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Nov 2019 07:43:50 EST
Received: from player788.ha.ovh.net (unknown [10.109.146.82])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id AF11713D240
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 12:26:39 +0100 (CET)
Received: from kaod.org (lfbn-1-2229-223.w90-76.abo.wanadoo.fr [90.76.50.223])
        (Authenticated sender: clg@kaod.org)
        by player788.ha.ovh.net (Postfix) with ESMTPSA id 9FB97BEE6275;
        Mon, 11 Nov 2019 11:26:26 +0000 (UTC)
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: Free previous EQ page when
 setting up a new one
To:     Greg Kurz <groug@kaod.org>, Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Lijun Pan <ljp@linux.ibm.com>,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <157346576671.818016.10401178701091199969.stgit@bahia.lan>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <3373a85a-09bb-3345-ef27-68177c360786@kaod.org>
Date:   Mon, 11 Nov 2019 12:26:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <157346576671.818016.10401178701091199969.stgit@bahia.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5003217712743287575
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedruddvjedgvdelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdqfffguegfifdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpledtrdejiedrhedtrddvvdefnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejkeekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/2019 10:49, Greg Kurz wrote:
> The EQ page is allocated by the guest and then passed to the hypervisor
> with the H_INT_SET_QUEUE_CONFIG hcall. A reference is taken on the page
> before handing it over to the HW. This reference is dropped either when
> the guest issues the H_INT_RESET hcall or when the KVM device is released.
> But, the guest can legitimately call H_INT_SET_QUEUE_CONFIG several times
> to reset the EQ (vCPU hot unplug) or set a new EQ (guest reboot). In both
> cases the EQ page reference is leaked. This is especially visible when
> the guest memory is backed with huge pages: start a VM up to the guest
> userspace, either reboot it or unplug a vCPU, quit QEMU. The leak is
> observed by comparing the value of HugePages_Free in /proc/meminfo before
> and after the VM is run.
> 
> Note that the EQ reset path seems to be calling put_page() but this is
> done after xive_native_configure_queue() which clears the qpage field
> in the XIVE queue structure, ie. the put_page() block is a nop and the
> previous page pointer was just overwritten anyway. In the other case of
> configuring a new EQ page, nothing seems to be done to release the old
> one.

Yes. Nice catch. I think we should try to fix the problem differently. 

The routine xive_native_configure_queue() is only suited for XIVE 
drivers doing their own EQ page allocation: Linux PowerNV and the 
KVM XICS-over-XIVE device. The KVM XIVE device acts as a proxy for 
the guest OS doing the allocation and it has different needs.

Having a specific xive_native_configure_queue() for the KVM XIVE 
device seems overkill. May be, we could introduce a helper routine 
in KVM XIVE device calling xive_native_configure_queue() and handling 
the page reference how it should be ? That is to drop the previous
page reference in case of a change on q->qpage.


Also, we should try to preserve the previous setting until the whole 
configuration is in place. That seems possible up to the call to 
xive_native_configure_queue(). If kvmppc_xive_attach_escalation()
fails I think it is too late, as the HW has been configured by 
xive_native_configure_queue(), and we should just cleanup everything. 

Thanks,

C. 


> Fix both cases by always calling put_page() on the existing EQ page in
> kvmppc_xive_native_set_queue_config(). This is a seemless change for the
> EQ reset case. However this causes xive_native_configure_queue() to be
> called twice for the new EQ page case: one time to reset the EQ and another
> time to configure the new page. This is needed because we cannot release
> the EQ page before calling xive_native_configure_queue() since it may still
> be used by the HW. We cannot modify xive_native_configure_queue() to drop
> the reference either because this function is also used by the XICS-on-XIVE
> device which requires free_pages() instead of put_page(). This isn't a big
> deal anyway since H_INT_SET_QUEUE_CONFIG isn't a hot path.
> 
> Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org # v5.2
> Fixes: 13ce3297c576 ("KVM: PPC: Book3S HV: XIVE: Add controls for the EQ configuration")
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  arch/powerpc/kvm/book3s_xive_native.c |   21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index 34bd123fa024..8ab908d23dc2 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -570,10 +570,12 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
>  		 __func__, server, priority, kvm_eq.flags,
>  		 kvm_eq.qshift, kvm_eq.qaddr, kvm_eq.qtoggle, kvm_eq.qindex);
>  
> -	/* reset queue and disable queueing */
> -	if (!kvm_eq.qshift) {
> -		q->guest_qaddr  = 0;
> -		q->guest_qshift = 0;
> +	/*
> +	 * Reset queue and disable queueing. It will be re-enabled
> +	 * later on if the guest is configuring a new EQ page.
> +	 */
> +	if (q->guest_qshift) {
> +		page = virt_to_page(q->qpage);
>  
>  		rc = xive_native_configure_queue(xc->vp_id, q, priority,
>  						 NULL, 0, true);
> @@ -583,12 +585,13 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
>  			return rc;
>  		}
>  
> -		if (q->qpage) {
> -			put_page(virt_to_page(q->qpage));
> -			q->qpage = NULL;
> -		}
> +		put_page(page);
>  
> -		return 0;
> +		if (!kvm_eq.qshift) {
> +			q->guest_qaddr  = 0;
> +			q->guest_qshift = 0;
> +			return 0;
> +		}
>  	}
>  
>  	/*
> 

