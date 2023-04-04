Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6506D6806
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 17:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjDDP4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 11:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbjDDP4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 11:56:34 -0400
Received: from out-10.mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EEB5FF6
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 08:56:09 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680623724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rveLR/xMgdd42NYml6Br2i5T3+ij1eezzlv9OLDm9ps=;
        b=MCSttQfTASTgr2cFaO77Ktg62vc5o6WODh+5awdXCnscth56jqDXSc08J8dwhR1UQgSTPi
        L2MxRlmud8ytWzVboDIrY2FFWxDlX6ktnPwx1Zb9G5vejbIoCrriZkAdJJ6EZZP+ko4U84
        e3CZfRX51m0wd5hsXFbfvMVJse9KxAY=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, Reiji Watanabe <reijiw@google.com>,
        kvmarm@lists.linux.dev
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] KVM: arm64: PMU: Restore the guest's EL0 event counting after migration
Date:   Tue,  4 Apr 2023 15:55:01 +0000
Message-Id: <168062368624.2273324.12077737366076626485.b4-ty@linux.dev>
In-Reply-To: <20230329023944.2488484-1-reijiw@google.com>
References: <20230329023944.2488484-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Mar 2023 19:39:44 -0700, Reiji Watanabe wrote:
> Currently, with VHE, KVM enables the EL0 event counting for the
> guest on vcpu_load() or KVM enables it as a part of the PMU
> register emulation process, when needed.  However, in the migration
> case (with VHE), the same handling is lacking, as vPMU register
> values that were restored by userspace haven't been propagated yet
> (the PMU events haven't been created) at the vcpu load-time on the
> first KVM_RUN (kvm_vcpu_pmu_restore_guest() called from vcpu_load()
> on the first KVM_RUN won't do anything as events_{guest,host} of
> kvm_pmu_events are still zero).
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: PMU: Restore the guest's EL0 event counting after migration
      https://git.kernel.org/kvmarm/kvmarm/c/f9ea835e99bc

--
Best,
Oliver
