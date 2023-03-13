Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1746B8177
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 20:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCMTLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 15:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCMTLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 15:11:36 -0400
Received: from out-49.mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9762474306
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 12:11:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678734191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eg1s/UHvVY8oZjii/NK613/5yHGvioFeV1O2ojnw3dk=;
        b=vBovC7IYoSHIuliWIuzkN54ze/EW7lQHB5AtvhpvJnNv/0ZSBJbgejLT32QT0zJb+EFUKa
        +OWMuuX44El47AEt85XpRXkmfCL3KgZ/eYxK4A6wyHv+8HOduAKgjeoB7IluwA2YNMZjtd
        uj4mEZYSziB52+jshZvkpQW3QH9iAf8=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Ricardo Koller <ricarkol@google.com>, stable@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
Date:   Mon, 13 Mar 2023 19:02:55 +0000
Message-Id: <167873416495.193819.13647538612732773300.b4-ty@linux.dev>
In-Reply-To: <20230313033234.1475987-1-reijiw@google.com>
References: <20230313033234.1475987-1-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 12 Mar 2023 20:32:34 -0700, Reiji Watanabe wrote:
> Presently, when a guest writes 1 to PMCR_EL0.{C,P}, which is WO/RAZ,
> KVM saves the register value, including these bits.
> When userspace reads the register using KVM_GET_ONE_REG, KVM returns
> the saved register value as it is (the saved value might have these
> bits set).  This could result in userspace setting these bits on the
> destination during migration.  Consequently, KVM may end up resetting
> the vPMU counter registers (PMCCNTR_EL0 and/or PMEVCNTR<n>_EL0) to
> zero on the first KVM_RUN after migration.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
      https://git.kernel.org/kvmarm/kvmarm/c/f6da81f650fa

--
Best,
Oliver
