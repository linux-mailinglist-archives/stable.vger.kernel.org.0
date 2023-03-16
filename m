Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8576BDD19
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 00:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCPXnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 19:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjCPXnM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 19:43:12 -0400
Received: from out-60.mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4041836478
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 16:42:46 -0700 (PDT)
Date:   Thu, 16 Mar 2023 23:42:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679010137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z9wFXHFTqY0qDRcH43pszZPbHt+9ze46oN5dD5scERM=;
        b=LtNgIIiFchLoDQZMYIjfVErlc53+gEFMCv31zVbKG+w/WX/9cNgUJtNhJsaE+oGs4zhs9Y
        Xmejd3PTagnQcaBzhRVlOhhT9fNC5mNMCSe6dDDiK5yOIT3LggZ4EJY7B3QDQzi5qpwu0c
        oTpCCSGaN7OezLzUDYGEL35c1tuTeAs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Disable interrupts while walking
 userspace PTs
Message-ID: <ZBOpVLEPEJazjyGD@linux.dev>
References: <20230316174546.3777507-1-maz@kernel.org>
 <20230316174546.3777507-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316174546.3777507-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Marc,

On Thu, Mar 16, 2023 at 05:45:45PM +0000, Marc Zyngier wrote:
> We walk the userspace PTs to discover what mapping size was
> used there. However, this can race against the userspace tables
> being freed, and we end-up in the weeds.
> 
> Thankfully, the mm code is being generous and will IPI us when
> doing so. So let's implement our part of the bargain and disable
> interrupts around the walk. This ensures that nothing terrible
> happens during that time.
> 
> We still need to handle the removal of the page tables before
> the walk. For that, allow get_user_mapping_size() to return an
> error, and make sure this error can be propagated all the way
> to the the exit handler.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Looks good. I've squashed in this meaningless diff to make use of an existing
helper.


diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e95593736ae3..3b9d4d24c361 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -691,7 +691,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 		return -EFAULT;
 
 	/* Oops, the userspace PTs are gone... Replay the fault */
-	if (!(pte & PTE_VALID))
+	if (!kvm_pte_valid(pte))
 		return -EAGAIN;
 
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));

-- 
Thanks,
Oliver
