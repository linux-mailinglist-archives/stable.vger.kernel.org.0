Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAFB118AEE
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 15:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLJOcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 09:32:45 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18586 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbfLJOcp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 09:32:45 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5defac770000>; Tue, 10 Dec 2019 06:32:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Dec 2019 06:32:43 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Dec 2019 06:32:43 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Dec
 2019 14:32:43 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Dec
 2019 14:32:42 +0000
Subject: Re: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
References: <20191210103708.7023-1-jonathanh@nvidia.com>
 <20191210120909.GA2703785@ulmo>
 <8bf12fcd-02c7-4dc0-90e6-30009ab9f8e7@nvidia.com>
Message-ID: <cd2aaa4a-c0de-a6e7-ca93-06901f5bb142@nvidia.com>
Date:   Tue, 10 Dec 2019 14:32:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <8bf12fcd-02c7-4dc0-90e6-30009ab9f8e7@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575988343; bh=ZztB0uubCfN04mux0kLM32BK0EExqmJdekMbzYpGL5k=;
        h=X-PGP-Universal:Subject:From:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=f9z8iPkOuQGIaU36MLSWe9RWM89Az+FxjeKt6bQE/cYWtlEcwAiLZpFRXKVf1pCax
         3MtLfTmFIb85auowc5ldNI8DRxthz4aGeGWmeuQDcVbPCQIPgoqjiXoHuAZXCm9qtr
         HA3yzhqoU38BSO++X3M0WuJszlrR3+jQLNqLLwAuoKDJcLhgHC43BqiXHbOfq1kHO5
         PdW2ts87OFs+shtB17tpJsJxF5yhT557OEV3nMNHMR3ccyOVTiPy7/2chzKwVoA0HF
         J8BOcadPqclAH7VmMOD3IQaZqxOjez32/KTwFnU1ycQ05SMtdT+zAWJAisXYv25x5I
         /k6e7vWRI76qQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/12/2019 14:29, Jon Hunter wrote:
> 
> On 10/12/2019 12:09, Thierry Reding wrote:
>> On Tue, Dec 10, 2019 at 10:37:08AM +0000, Jon Hunter wrote:
>>> The suspend entry and exit code for 32-bit Tegra devices assumes that
>>> the PLLM (which is used to provide the clock for external memory)
>>> is always enabled on entry to suspend. Hence, the current code always
>>> disables the PLLM on entry to suspend and re-enables the PLLM on exit
>>> from suspend.
>>>
>>> Since the introduction of the Tegra124 EMC driver by commit 73a7f0a90641
>>> ("memory: tegra: Add EMC (external memory controller) driver"), which is
>>> used to scale the EMC frequency, PLLM may not be the current clock
>>> source for the EMC on entry to suspend and hence may not be enabled.
>>> Always enabling the PLLM on exit from suspend can cause the actual
>>> status on the PLL to be different from that reported by the common clock
>>> framework.
>>>
>>> On kernels prior to v4.5, the code to set the rate of the PLLM had a
>>> test to verify if the PLL was enabled and if the PLL was enabled,
>>> setting the rate would fail. Since commit 267b62a96951
>>> ("clk: tegra: pll: Update PLLM handling") the test to see if PLLM is
>>> enabled was removed.
>>>
>>> With these earlier kernels, if the PLLM is disabled on entering suspend
>>> and the EMC driver attempts to set the parent of the EMC clock to the
>>> PLLM on exiting suspend, then the set rate for the PLLM will fail and in
>>> turn cause the resume to fail.
>>>
>>> We should not be re-enabling the PLLM on resume from suspend unless it
>>> was enabled on entry to suspend. Therefore, fix this by saving the state
>>> of PLLM on entry to suspend and only re-enable it, if it was already
>>> enabled.
>>>
>>> Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
>>> Cc: stable@vger.kernel.org
>>>
>>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>>> ---
>>>  arch/arm/mach-tegra/sleep-tegra30.S | 33 +++++++++++++++++++++++------
>>>  1 file changed, 27 insertions(+), 6 deletions(-)
>>
>> Looks good to me. If I understand correctly we really only need this on
>> v4.4 and earlier because the issue doesn't happen on later kernels
>> because of that PLLM handling update change that you mentioned, right?
> 
> Yes.

However, although we don't see any failures so far on mainline, it is
possible for the CCF status for PLLM to be incorrect following suspend.

Jon

-- 
nvpublic
