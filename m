Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B474118AD5
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 15:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLJO3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 09:29:24 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18493 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbfLJO3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 09:29:23 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5defabae0000>; Tue, 10 Dec 2019 06:29:02 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Dec 2019 06:29:23 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Dec 2019 06:29:23 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Dec
 2019 14:29:22 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Dec
 2019 14:29:21 +0000
Subject: Re: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
References: <20191210103708.7023-1-jonathanh@nvidia.com>
 <20191210120909.GA2703785@ulmo>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8bf12fcd-02c7-4dc0-90e6-30009ab9f8e7@nvidia.com>
Date:   Tue, 10 Dec 2019 14:29:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191210120909.GA2703785@ulmo>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575988142; bh=IRe6MY+3DRGHo5Au+IrCebqeGNCPq72U22T59CMWvmg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Nl8S70F0mXaZ/CbV+Ygw2fr71GH0T0vxiO8SmFa2ke0bEnQ6bXvXRxVTo41WRnATI
         rPorag22QIrrmoqdSGKYWgQXlxfxtPAwlUZwxVqr0UFdDCmRb1SJvJiC6cEktUXQ7w
         AqAdYL8faUWE2w3eheHYtIWuXl9NjHdDtiLd6/uhSgh1Oy9zTp5qMru7EqCNH1I3du
         lEE63+PY3zOtzTySEARFWzxZEK9o85+S5CHxn7kRZ8anlcSsx6+FWRClUUVynojuEd
         +XZqNY9j4zi+znojryHdOF5LbxD34DMSIl41NrUWLUfqKfesSrHe3vTjXNy9pgH6st
         kRFBg8385xzWw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/12/2019 12:09, Thierry Reding wrote:
> On Tue, Dec 10, 2019 at 10:37:08AM +0000, Jon Hunter wrote:
>> The suspend entry and exit code for 32-bit Tegra devices assumes that
>> the PLLM (which is used to provide the clock for external memory)
>> is always enabled on entry to suspend. Hence, the current code always
>> disables the PLLM on entry to suspend and re-enables the PLLM on exit
>> from suspend.
>>
>> Since the introduction of the Tegra124 EMC driver by commit 73a7f0a90641
>> ("memory: tegra: Add EMC (external memory controller) driver"), which is
>> used to scale the EMC frequency, PLLM may not be the current clock
>> source for the EMC on entry to suspend and hence may not be enabled.
>> Always enabling the PLLM on exit from suspend can cause the actual
>> status on the PLL to be different from that reported by the common clock
>> framework.
>>
>> On kernels prior to v4.5, the code to set the rate of the PLLM had a
>> test to verify if the PLL was enabled and if the PLL was enabled,
>> setting the rate would fail. Since commit 267b62a96951
>> ("clk: tegra: pll: Update PLLM handling") the test to see if PLLM is
>> enabled was removed.
>>
>> With these earlier kernels, if the PLLM is disabled on entering suspend
>> and the EMC driver attempts to set the parent of the EMC clock to the
>> PLLM on exiting suspend, then the set rate for the PLLM will fail and in
>> turn cause the resume to fail.
>>
>> We should not be re-enabling the PLLM on resume from suspend unless it
>> was enabled on entry to suspend. Therefore, fix this by saving the state
>> of PLLM on entry to suspend and only re-enable it, if it was already
>> enabled.
>>
>> Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
>> Cc: stable@vger.kernel.org
>>
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>> ---
>>  arch/arm/mach-tegra/sleep-tegra30.S | 33 +++++++++++++++++++++++------
>>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> Looks good to me. If I understand correctly we really only need this on
> v4.4 and earlier because the issue doesn't happen on later kernels
> because of that PLLM handling update change that you mentioned, right?

Yes.

> At the same time, this is the correct thing to do even on more recent
> kernels because we currently rely on the PLLM status check being absent
> for this to work.

Yes exactly.

> So it seems like the safest option going forward is to apply this patch
> to all versions, so that we don't rely on any assumptions.
> 
> Do you agree?

Yes, my feeling is that we should apply to mainline and then it should
be picked-up for stable.

Cheers
Jon

-- 
nvpublic
