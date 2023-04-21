Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BBA6EA719
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 11:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDUJgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 05:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjDUJfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 05:35:55 -0400
Received: from out-11.mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAED093F7
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 02:35:43 -0700 (PDT)
Date:   Fri, 21 Apr 2023 09:35:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682069741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i5U1AZ+eWrIoVxlayHzG/8S4OiVZIZwprEyJL67qDII=;
        b=Y8aSjqHdDhVJGlM+pB5Iv7LhI4t9dg+OTrLjTErBsxnctlO+dAJBA3CXb50tPdtSdhcspj
        kn4FLwIYaw8HkGS1uXWz0TfFoTZUv/sJigaW+RWGMitJWvpiUKMD9OpVBgzSsuz/A0aVt8
        iMXMRQTtbjtEdhRYNAe/i8tmcV0hZ6U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        David Matlack <dmatlack@google.com>,
        Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Infer the PA offset from IPA in stage-2
 map walker
Message-ID: <ZEJY6Smz3A2uZ4Ne@linux.dev>
References: <20230421071606.1603916-1-oliver.upton@linux.dev>
 <20230421071606.1603916-2-oliver.upton@linux.dev>
 <86r0sdk2hx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r0sdk2hx.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 21, 2023 at 10:28:58AM +0100, Marc Zyngier wrote:

[...]

> So my conclusion is that after these two patches, data->phys should
> never be updated, right?

Yep, that's the intention.

> Then I'd suggest an additional patch to constify a couple of things
> and make sure we don't accidentally update them. Something like the
> patch below (compile-tested only).

I'm always a fan of more idiot proofing, especially when I am said idiot
:)

> From a2eb08ce793c1cf01c79df13a619815e9d7c1d41 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Fri, 21 Apr 2023 10:18:34 +0100
> Subject: [PATCH] KVM: arm64: Constify start/end/phys fields of the pgtable
>  walker data
> 
> As we are revamping the way the pgtable walker evaluates some of the
> data, make it clear that we rely on somew of the fields to be constant
> across the lifetime of a walk.
> 
> For this, flag the start, end and pjys fields of the walk data as

typo: phys

> 'const', which will generate an error if we were to accidentally
> update these fields again.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Looks good.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Let's see if I've confused b4 into thinking I'm reviewing my own patches
:-P

> ---
>  arch/arm64/kvm/hyp/pgtable.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 356a3fd5220c..5282cb9ca4cf 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -58,9 +58,9 @@
>  struct kvm_pgtable_walk_data {
>  	struct kvm_pgtable_walker	*walker;
>  
> -	u64				start;
> +	const u64			start;
>  	u64				addr;
> -	u64				end;
> +	const u64			end;
>  };
>  
>  static bool kvm_phys_is_valid(u64 phys)
> @@ -352,7 +352,7 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
>  }
>  
>  struct hyp_map_data {
> -	u64				phys;
> +	const u64			phys;
>  	kvm_pte_t			attr;
>  };
>  
> @@ -578,7 +578,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
>  }
>  
>  struct stage2_map_data {
> -	u64				phys;
> +	const u64			phys;
>  	kvm_pte_t			attr;
>  	u8				owner_id;
>  
> -- 
> 2.34.1
> 
> -- 
> Without deviation from the norm, progress is not possible.

-- 
Thanks,
Oliver
