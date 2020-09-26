Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD265279C75
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 22:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgIZUvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 16:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgIZUvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 16:51:17 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6207207EA;
        Sat, 26 Sep 2020 20:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601153476;
        bh=RqI2XkUJnGfTSYFp3HDfs/QKnRhvBG5itC4b0KZfLFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yixz3jPary8hkalk5k87l/xp1SnOuwY3rJU/c7GSsSsNCt+Jp86+pVo0uKZsuQzRF
         AM9CMvDpow13UdBkne6TjU0AvZlCRiVBaE1XP+VLS8bXHm2rC7GfqODCsxoSe+gV9O
         +Z+1p73CjAKJ8z7QueCYIaMf0LZa6NWbA2urMtcM=
Date:   Sat, 26 Sep 2020 16:51:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        devicetree@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.8 20/20] riscv: Fix Kendryte K210 device tree
Message-ID: <20200926205114.GB2219727@sasha-vm>
References: <CY4PR04MB3751BE40C3EC0BD2F392E9EEE7380@CY4PR04MB3751.namprd04.prod.outlook.com>
 <mhng-ed52d354-09cf-4708-8b07-5e6559a7b5e8@palmerdabbelt-glaptop1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <mhng-ed52d354-09cf-4708-8b07-5e6559a7b5e8@palmerdabbelt-glaptop1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 26, 2020 at 12:42:42PM -0700, Palmer Dabbelt wrote:
>>On Tue, 22 Sep 2020 17:27:42 PDT (-0700), Damien Le Moal wrote:
>>>On 2020/09/21 23:41, Sasha Levin wrote:
>>>From: Damien Le Moal <damien.lemoal@wdc.com>
>>>
>>>[ Upstream commit f025d9d9934b84cd03b7796072d10686029c408e ]
>>>
>>>The Kendryte K210 SoC CLINT is compatible with Sifive clint v0
>>>(sifive,clint0). Fix the Kendryte K210 device tree clint entry to be
>>>inline with the sifive timer definition documented in
>>>Documentation/devicetree/bindings/timer/sifive,clint.yaml.
>>>The device tree clint entry is renamed similarly to u-boot device tree
>>>definition to improve compatibility with u-boot defined device tree.
>>>To ensure correct initialization, the interrup-cells attribute is added
>>>and the interrupt-extended attribute definition fixed.
>>>
>>>This fixes boot failures with Kendryte K210 SoC boards.
>>>
>>>Note that the clock referenced is kept as K210_CLK_ACLK, which does not
>>>necessarilly match the clint MTIME increment rate. This however does not
>>>seem to cause any problem for now.
>>>
>>>Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>>>Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
>>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>---
>>> arch/riscv/boot/dts/kendryte/k210.dtsi | 6 ++++--
>>> 1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>>diff --git a/arch/riscv/boot/dts/kendryte/k210.dtsi b/arch/riscv/boot/dts/kendryte/k210.dtsi
>>>index c1df56ccb8d55..d2d0ff6456325 100644
>>>--- a/arch/riscv/boot/dts/kendryte/k210.dtsi
>>>+++ b/arch/riscv/boot/dts/kendryte/k210.dtsi
>>>@@ -95,10 +95,12 @@ sysctl: sysctl@50440000 {
>>> 			#clock-cells = <1>;
>>> 		};
>>>-		clint0: interrupt-controller@2000000 {
>>>+		clint0: clint@2000000 {
>>>+			#interrupt-cells = <1>;
>>> 			compatible = "riscv,clint0";
>>> 			reg = <0x2000000 0xC000>;
>>>-			interrupts-extended = <&cpu0_intc 3>,  <&cpu1_intc 3>;
>>>+			interrupts-extended =  <&cpu0_intc 3 &cpu0_intc 7
>>>+						&cpu1_intc 3 &cpu1_intc 7>;
>>> 			clocks = <&sysctl K210_CLK_ACLK>;
>>> 		};
>>>
>>
>>Sasha,
>>
>>This is a fix for a problem in 5.9 tree. 5.8 kernel is fine without this patch.
>>And I think applying it to 5.8 might actually break things since the proper
>>clint driver was added to kernel 5.9 and does not exist in 5.8.
>
>IIUC this won't actually break anything on 5.8, as the reason nobody noticed
>that the old one was broken is because the old CLINT driver just didn't care
>about what's in the device tree.  These interrupt numbers are defined by the
>ISA manual so we jut had them encoded into the arch/riscv first-level interrupt
>controller driver.
>
>That said, it definately doesn't fix anything so it seems safer to just not
>backport it.

Sure, I'll drop it. Thanks!

-- 
Thanks,
Sasha
