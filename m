Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D781305D0F
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 14:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhA0N03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 08:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S313560AbhAZWgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 17:36:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FBC22065E;
        Tue, 26 Jan 2021 22:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611700547;
        bh=Q1GyRhpkZiVQToN/jT2ZPcVt3BW6HFaKBIAmsCu2bCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnxfXEhAt5e/63DrE8s+rWzNBER52n3jEXPQlNMC/nc6Ti+X+VSP/YbFKL+KxtwNb
         kEryFl/EK49PYII5Z7np11Tl8nITq2dxISWzqHKW/Y58aC4cMHZ6heu3zPUcLzwrqv
         Itz9HtP20hbwkvF5GkW295UitLIWTnWo6iTIZc6iphBD5ZnylWnn5m+3QIUHfqLgbo
         BC+1sIgIzhqa/rmSbB8IWTdOMjvjtSxVkNhaixwuNEbg5FsIeXoEikEwfHgIBMB9C1
         qS5uCgh4d0PJscnJS6d+lfkAmOg7ZzUZ0x5GeqzvM7nzUadOmqZ+wpnJvkYm3EoVeY
         t+Phu04NZhDFw==
From:   Will Deacon <will@kernel.org>
To:     robin.murphy@arm.com, bjorn.andersson@linaro.org,
        "Isaac J. Manjarres" <isaacm@codeaurora.org>, joro@8bytes.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] iommu/arm-smmu-qcom: Fix mask extraction for bootloader programmed SMRs
Date:   Tue, 26 Jan 2021 22:35:41 +0000
Message-Id: <161167109569.3787430.13165422969483638185.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1611611545-19055-1-git-send-email-isaacm@codeaurora.org>
References: <1611611545-19055-1-git-send-email-isaacm@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Jan 2021 13:52:25 -0800, Isaac J. Manjarres wrote:
> When extracting the mask for a SMR that was programmed by the
> bootloader, the SMR's valid bit is also extracted and is treated
> as part of the mask, which is not correct. Consider the scenario
> where an SMMU master whose context is determined by a bootloader
> programmed SMR is removed (omitting parts of device/driver core):
> 
> ->iommu_release_device()
>  -> arm_smmu_release_device()
>   -> arm_smmu_master_free_smes()
>    -> arm_smmu_free_sme() /* Assume that the SME is now free */
>    -> arm_smmu_write_sme()
>     -> arm_smmu_write_smr() /* Construct SMR value using mask and SID */
> 
> [...]

Applied to will (for-joerg/arm-smmu/updates), thanks!

[1/1] iommu/arm-smmu-qcom: Fix mask extraction for bootloader programmed SMRs
      https://git.kernel.org/will/c/dead723e6f04

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
