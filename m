Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F1D411407
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 14:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbhITMOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 08:14:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237519AbhITMN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 08:13:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B58D61040;
        Mon, 20 Sep 2021 12:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632139952;
        bh=92Zco9rXt6W+e6PF3VjFECoFUbUIIIKca4hGES5Ml+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kSOSfcoJpTxGrpygYlvVlVB4djdfH7aRb6HHRyy9jIQaRSBF0C17nydFMyr0CbbKE
         vxcMLftmwR93lOfPaGj/V6LDMZZ6ow4WLsxyLmN3RJvgXcOKUpK25sqR0alChon3PO
         92ZU9DVll/y0bZeBy9mLeYOFYmEuFAx+ti/w2veFBrp4YX3P8r9EvJSfrG+iD6L01r
         Ty/+gnc5ge1dhzCAKJXzgoe0WGJqcwK7IVW48LDE1EvOR9uc+C77W8mQfIjJr2mRsF
         r50x5Mwzid6J8CUWPWba8amSTEtbHpVAAj4L5PaIGS08r/xFEfAvO0+91AdI9PG2q8
         LsNCv1EWgEvEQ==
Date:   Mon, 20 Sep 2021 08:12:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marek Vasut <marek.vasut@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa@the-dreams.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-renesas-soc@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 12/32] PCI: rcar: Add L1 link state fix into
 data abort hook
Message-ID: <YUh6r6SOu7AH6P3f@sashalap>
References: <20210911131149.284397-1-sashal@kernel.org>
 <20210911131149.284397-12-sashal@kernel.org>
 <6cbfadee-0d74-fa4c-9ef3-a1bce55632bb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6cbfadee-0d74-fa4c-9ef3-a1bce55632bb@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 11, 2021 at 06:05:37PM +0200, Marek Vasut wrote:
>On 9/11/21 3:11 PM, Sasha Levin wrote:
>>From: Marek Vasut <marek.vasut+renesas@gmail.com>
>>
>>[ Upstream commit a115b1bd3af0c2963e72f6e47143724c59251be6 ]
>>
>>When the link is in L1, hardware should return it to L0
>>automatically whenever a transaction targets a component on the
>>other end of the link (PCIe r5.0, sec 5.2).
>>
>>The R-Car PCIe controller doesn't handle this transition correctly.
>>If the link is not in L0, an MMIO transaction targeting a downstream
>>device fails, and the controller reports an ARM imprecise external
>>abort.
>>
>>Work around this by hooking the abort handler so the driver can
>>detect this situation and help the hardware complete the link state
>>transition.
>>
>>When the R-Car controller receives a PM_ENTER_L1 DLLP from the
>>downstream component, it sets PMEL1RX bit in PMSR register, but then
>>the controller enters some sort of in-between state.  A subsequent
>>MMIO transaction will fail, resulting in the external abort.  The
>>abort handler detects this condition and completes the link state
>>transition by setting the L1IATN bit in PMCTLR and waiting for the
>>link state transition to complete.
>
>You will also need the following patch, otherwise the build will fail 
>on configurations without COMMON_CLK (none where this driver is used, 
>but happened on one of the build bots). I'm waiting for PCIe 
>maintainers to pick it up:
>https://patchwork.kernel.org/project/linux-pci/patch/20210907144512.5238-1-marek.vasut@gmail.com/

I see that it's not upstream yet, so I'll drop this patch for now.

-- 
Thanks,
Sasha
