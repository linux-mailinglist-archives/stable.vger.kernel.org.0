Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2A716635E
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 17:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgBTQqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 11:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgBTQqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 11:46:31 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F08520801;
        Thu, 20 Feb 2020 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582217190;
        bh=6KCr8/c31+4Zjv2FH9fu1ipa+HTFqM2T3bz66PmzOTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p8EY09tKFL3VUgGkWXd8/ebo9udOVi2YkgfOFmh6dOOng/lP+pdix1x8aoPoy6Urr
         sxmsyjOhrBZsvmTh0FGHwxJNI/yHFPA2IorIv1gtJlw7IDsd154sfOGrWwfpKTqKwa
         hSdmHhrfaPhR+U0UfUm0RenX/Y7ENgCExOAYOzDU=
Date:   Thu, 20 Feb 2020 11:46:28 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Suman Anna <s-anna@ti.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.5 218/542] ARM: OMAP2+: Add workaround for DRA7
 DSP MStandby errata i879
Message-ID: <20200220164628.GE1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-218-sashal@kernel.org>
 <1ea1b9d3-ce1e-83ca-e2a4-dfb67b12754d@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1ea1b9d3-ce1e-83ca-e2a4-dfb67b12754d@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 12:34:19PM -0600, Suman Anna wrote:
>Hi Sasha,
>
>On 2/14/20 9:43 AM, Sasha Levin wrote:
>> From: Suman Anna <s-anna@ti.com>
>>
>> [ Upstream commit 2f14101a1d760db72393910d481fbf7768c44530 ]
>>
>> Errata Title:
>> i879: DSP MStandby requires CD_EMU in SW_WKUP
>>
>> Description:
>> The DSP requires the internal emulation clock to be actively toggling
>> in order to successfully enter a low power mode via execution of the
>> IDLE instruction and PRCM MStandby/Idle handshake. This assumes that
>> other prerequisites and software sequence are followed.
>>
>> Workaround:
>> The emulation clock to the DSP is free-running anytime CCS is connected
>> via JTAG debugger to the DSP subsystem or when the CD_EMU clock domain
>> is set in SW_WKUP mode. The CD_EMU domain can be set in SW_WKUP mode
>> via the CM_EMU_CLKSTCTRL [1:0]CLKTRCTRL field.
>>
>> Implementation:
>> This patch implements this workaround by denying the HW_AUTO mode
>> for the EMU clockdomain during the power-up of any DSP processor
>> and re-enabling the HW_AUTO mode during the shutdown of the last
>> DSP processor (actually done during the enabling and disabling of
>> the respective DSP MDMA MMUs). Reference counting has to be used to
>> manage the independent sequencing between the multiple DSP processors.
>>
>> This switching is done at runtime rather than a static clockdomain
>> flags value to meet the target power domain state for the EMU power
>> domain during suspend.
>>
>> Note that the DSP MStandby behavior is not consistent across all
>> boards prior to this fix. Please see commit 45f871eec6c0 ("ARM:
>> OMAP2+: Extend DRA7 IPU1 MMU pdata quirks to DSP MDMA MMUs") for
>> details.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> Signed-off-by: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>You can drop this from the 5.5-stable queue. Mainline doesn't yet boot
>the processors, so this is not needed for stable queue.

Now dropped, thank you.

-- 
Thanks,
Sasha
