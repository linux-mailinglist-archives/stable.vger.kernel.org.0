Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F8E6B9DEE
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 19:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCNSKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 14:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCNSKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 14:10:39 -0400
Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD25D21955
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 11:10:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678817432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/e8hGKQr30b5ZvdSDvuiuWs97jzQhjwuRhF+vuhvk8=;
        b=To69XkfxqTbOxl5n49kjumMJ7t3j0izNLm88VXspv8c8B1+4S6tHPjESl9RFvOvz5Jh7DF
        lkTAuaGZs3L9wVaF4ymnTYNduKWZbOGf4ywCvG2CXyclM04KVH2tsFAlgx56LqPoYUMb4+
        OJMdIAmSGztCai6SQVzNcJxb7j0U+ik=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        stable@vger.kernel.org,
        Christoffer Dall <c.dall@virtualopensystems.com>,
        kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Retry fault if vma_lookup() results become invalid
Date:   Tue, 14 Mar 2023 18:10:18 +0000
Message-Id: <167881740956.623301.15796552782250010868.b4-ty@linux.dev>
In-Reply-To: <20230313235454.2964067-1-dmatlack@google.com>
References: <20230313235454.2964067-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Mar 2023 16:54:54 -0700, David Matlack wrote:
> Read mmu_invalidate_seq before dropping the mmap_lock so that KVM can
> detect if the results of vma_lookup() (e.g. vma_shift) become stale
> before it acquires kvm->mmu_lock. This fixes a theoretical bug where a
> VMA could be changed by userspace after vma_lookup() and before KVM
> reads the mmu_invalidate_seq, causing KVM to install page table entries
> based on a (possibly) no-longer-valid vma_shift.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Retry fault if vma_lookup() results become invalid
      https://git.kernel.org/kvmarm/kvmarm/c/13ec9308a857

--
Best,
Oliver
