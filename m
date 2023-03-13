Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4186B8176
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 20:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCMTLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 15:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCMTLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 15:11:35 -0400
X-Greylist: delayed 505 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Mar 2023 12:11:34 PDT
Received: from out-13.mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9C374301
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 12:11:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678734185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nhDlaUueHGYKKeFLc5exd84+NUtoJ3lDFXMNBz3LSdg=;
        b=m4hyEG7bkNHPf9cfMhgvuTwGGTmLhvenUVmRkirOI58QCTUKVnLHsV8nm/v1Bd8A5k1suQ
        FBoH8PqPKc8XVp3gtQAZzRAuTqoI9L7CArtNJp63DafE2z+c5AQIm05Py4WUMKl31E/5Za
        DY84kXCtIGCAUXdFrL2jKUCx2pD6xaQ=
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
Subject: Re: [PATCH v2 1/2] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
Date:   Mon, 13 Mar 2023 19:02:54 +0000
Message-Id: <167873416494.193819.9004317354249564385.b4-ty@linux.dev>
In-Reply-To: <20230313033208.1475499-1-reijiw@google.com>
References: <20230313033208.1475499-1-reijiw@google.com>
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

On Sun, 12 Mar 2023 20:32:08 -0700, Reiji Watanabe wrote:
> Have KVM_GET_ONE_REG for vPMU counter (vPMC) registers (PMCCNTR_EL0
> and PMEVCNTR<n>_EL0) return the sum of the register value in the sysreg
> file and the current perf event counter value.
> 
> Values of vPMC registers are saved in sysreg files on certain occasions.
> These saved values don't represent the current values of the vPMC
> registers if the perf events for the vPMCs count events after the save.
> The current values of those registers are the sum of the sysreg file
> value and the current perf event counter value.  But, when userspace
> reads those registers (using KVM_GET_ONE_REG), KVM returns the sysreg
> file value to userspace (not the sum value).
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/2] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value
      https://git.kernel.org/kvmarm/kvmarm/c/9228b26194d1

--
Best,
Oliver
