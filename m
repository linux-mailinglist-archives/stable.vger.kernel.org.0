Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3789130DEF9
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 17:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhBCP5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 10:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234699AbhBCP5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 10:57:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2ABE64D90;
        Wed,  3 Feb 2021 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612367782;
        bh=iqZEmEMfQVbGhNOvrmiywegPN/XO5IkB/s/O37rDgDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oQETclcCklKxjatzOTdvcf3oRfofVwOL5h4ZheCcP+bELF9XrnlVJ++fAqoPOVEuO
         +2xhvJca3GOKM6xsNhgd02eWrhOP1Aj22g0QNFMEk1mzzWzvZd40THn9me/dnvivr+
         pe+pbO3dEst/Tt/twV4HR0NjE19LX4WwCiPPcXaU/3Gclz7KC0YFeZuOG656WzWIpF
         LG40diET7n3y1TnWXqOzdvTQWP83x92ZqKnaFDw66H9wBvNYQO8zYAmQgoiQ7aFzv+
         ILP/1EpGhRi+9HbsHGEv49NjTalEofGHLoO2Q2zd25qlnekUPxoLOOkb8CHKMsjzS+
         2LCb84mj9D8fg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1l7KWB-000363-CJ; Wed, 03 Feb 2021 16:56:36 +0100
Date:   Wed, 3 Feb 2021 16:56:35 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/apic/of: Fix CPU devicetree-node lookups
Message-ID: <YBrHs7UJNkkLpagx@hovoldconsulting.com>
References: <20201210133910.4229-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210133910.4229-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 02:39:10PM +0100, Johan Hovold wrote:
> Architectures that describe the CPU topology in devicetree and that do
> not have an identity mapping between physical and logical CPU ids need
> to override the default implementation of arch_match_cpu_phys_id().
> 
> Failing to do so breaks CPU devicetree-node lookups using
> of_get_cpu_node() and of_cpu_device_node_get() which several drivers
> rely on. It also causes the CPU struct devices exported through sysfs to
> point to the wrong devicetree nodes.
> 
> On x86, CPUs are described in devicetree using their APIC ids and those
> do not generally coincide with the logical ids, even if CPU0 typically
> uses APIC id 0. Add the missing implementation of
> arch_match_cpu_phys_id() so that CPU-node lookups work also with SMP.
> 
> Apart from fixing the broken sysfs devicetree-node links this likely do
> not affect users of mainline kernels as the above mentioned drivers are
> currently not used on x86 as far as I know.
> 
> Fixes: 4e07db9c8db8 ("x86/devicetree: Use CPU description from Device Tree")
> Cc: stable <stable@vger.kernel.org>     # 4.17
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> Thomas,
> 
> Hope this looks better to you.
> 
> My use case for this is still out-of-tree, but since CPU-node lookup is
> generic functionality and with observable impact also for mainline users
> (sysfs) I added a stable tag.

Did you have a chance to look at this one yet?

Johan

> Changes in v2
>  - rewrite commit message
>  - add Fixes tag
>  - add stable tag for the benefit of out-of-tree users
> 
> 
>  arch/x86/kernel/apic/apic.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index b3eef1d5c903..19c0119892dd 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -2311,6 +2311,11 @@ static int cpuid_to_apicid[] = {
>  	[0 ... NR_CPUS - 1] = -1,
>  };
>  
> +bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
> +{
> +	return phys_id == cpuid_to_apicid[cpu];
> +}
> +
>  #ifdef CONFIG_SMP
>  /**
>   * apic_id_is_primary_thread - Check whether APIC ID belongs to a primary thread
