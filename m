Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 334ADC1FEC
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 13:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfI3LZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 07:25:01 -0400
Received: from 8.mo179.mail-out.ovh.net ([46.105.75.26]:38189 "EHLO
        8.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbfI3LZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 07:25:01 -0400
X-Greylist: delayed 4609 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2019 07:25:00 EDT
Received: from player692.ha.ovh.net (unknown [10.108.54.97])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 25F80143F30
        for <stable@vger.kernel.org>; Mon, 30 Sep 2019 12:08:10 +0200 (CEST)
Received: from kaod.org (lfbn-1-2229-223.w90-76.abo.wanadoo.fr [90.76.50.223])
        (Authenticated sender: clg@kaod.org)
        by player692.ha.ovh.net (Postfix) with ESMTPSA id 3BA53A40CB9B;
        Mon, 30 Sep 2019 10:07:55 +0000 (UTC)
Subject: Re: [PATCH v2 3/6] KVM: PPC: Book3S HV: XIVE: Show VP id in debugfs
To:     Greg Kurz <groug@kaod.org>, Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <156958521220.1503771.2119482814236775333.stgit@bahia.lan>
 <156958522955.1503771.11724507735868652914.stgit@bahia.lan>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <a164000d-284a-3ca7-a6b2-a5977a4b169f@kaod.org>
Date:   Mon, 30 Sep 2019 12:07:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <156958522955.1503771.11724507735868652914.stgit@bahia.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15278743213254937460
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrgedvgddvudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/09/2019 13:53, Greg Kurz wrote:
> Print out the VP id of each connected vCPU, this allow to see:
> - the VP block base in which OPAL encodes information that may be
>   useful when debugging
> - the packed vCPU id which may differ from the raw vCPU id if the
>   latter is >= KVM_MAX_VCPUS (2048)
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>


Reviewed-by: Cédric Le Goater <clg@kaod.org>
> ---
>  arch/powerpc/kvm/book3s_xive.c        |    4 ++--
>  arch/powerpc/kvm/book3s_xive_native.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index baa740815b3c..0b7859e40f66 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -2107,9 +2107,9 @@ static int xive_debug_show(struct seq_file *m, void *private)
>  		if (!xc)
>  			continue;
>  
> -		seq_printf(m, "cpu server %#x CPPR:%#x HWCPPR:%#x"
> +		seq_printf(m, "cpu server %#x VP:%#x CPPR:%#x HWCPPR:%#x"
>  			   " MFRR:%#x PEND:%#x h_xirr: R=%lld V=%lld\n",
> -			   xc->server_num, xc->cppr, xc->hw_cppr,
> +			   xc->server_num, xc->vp_id, xc->cppr, xc->hw_cppr,
>  			   xc->mfrr, xc->pending,
>  			   xc->stat_rm_h_xirr, xc->stat_vm_h_xirr);
>  
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index ebb4215baf45..43a86858390a 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -1204,8 +1204,8 @@ static int xive_native_debug_show(struct seq_file *m, void *private)
>  		if (!xc)
>  			continue;
>  
> -		seq_printf(m, "cpu server %#x NSR=%02x CPPR=%02x IBP=%02x PIPR=%02x w01=%016llx w2=%08x\n",
> -			   xc->server_num,
> +		seq_printf(m, "cpu server %#x VP=%#x NSR=%02x CPPR=%02x IBP=%02x PIPR=%02x w01=%016llx w2=%08x\n",
> +			   xc->server_num, xc->vp_id,
>  			   vcpu->arch.xive_saved_state.nsr,
>  			   vcpu->arch.xive_saved_state.cppr,
>  			   vcpu->arch.xive_saved_state.ipb,
> 

