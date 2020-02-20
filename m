Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F14166370
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 17:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgBTQtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 11:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgBTQtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 11:49:45 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24399207FD;
        Thu, 20 Feb 2020 16:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582217384;
        bh=7rYxqANQCf7hTl3tzhws3Y+kLKCxf80ReHi8QZQDs10=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TDwNjp21PuyTCYCua7hWSYoYD18e5SPNajumHDnNM286oKqCbkom/Z1svBBC8JJWQ
         vCSSOxBgnAxu3PeSsQz00Rzbtfqtdf6CKAkgey1Oskxextr9dGhUn/SIEP4jrQQCUC
         evHDOpyHD53SRuXW+m02mRFK8jGya4c4YPmySofA=
Date:   Thu, 20 Feb 2020 11:49:43 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Suman Anna <s-anna@ti.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.5 219/542] ARM: OMAP2+: use separate IOMMU
 pdata to fix DRA7 IPU1 boot
Message-ID: <20200220164943.GF1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-219-sashal@kernel.org>
 <a7666322-f931-63f1-a4c5-d44c2ba4ed0c@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a7666322-f931-63f1-a4c5-d44c2ba4ed0c@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 12:34:58PM -0600, Suman Anna wrote:
>Hi Sasha,
>
>On 2/14/20 9:43 AM, Sasha Levin wrote:
>> From: Suman Anna <s-anna@ti.com>
>>
>> [ Upstream commit 4601832f40501efc3c2fd264a5a69bd1ac17d520 ]
>>
>> The IPU1 MMU has been using common IOMMU pdata quirks defined and
>> used by all IPU IOMMU devices on OMAP4 and beyond. Separate out the
>> pdata for IPU1 MMU with the additional .set_pwrdm_constraint ops
>> plugged in, so that the IPU1 power domain can be restricted to ON
>> state during the boot and active period of the IPU1 remote processor.
>> This eliminates the pre-conditions for the IPU1 boot issue as
>> described in commit afe518400bdb ("iommu/omap: fix boot issue on
>> remoteprocs with AMMU/Unicache").
>>
>> NOTE:
>> 1. RET is not a valid target power domain state on DRA7 platforms,
>>    and IPU power domain is normally programmed for OFF. The IPU1
>>    still fails to boot though, and an unclearable l3_noc error is
>>    thrown currently on 4.14 kernel without this fix. This behavior
>>    is slightly different from previous 4.9 LTS kernel.
>> 2. The fix is currently applied only to IPU1 on DRA7xx SoC, as the
>>    other affected processors on OMAP4/OMAP5/DRA7 are in domains
>>    that are not entering RET. IPU2 on DRA7 is in CORE power domain
>>    which is only programmed for ON power state. The fix can be easily
>>    scaled if these domains do hit RET in the future.
>> 3. The issue was not seen on current DRA7 platforms if any of the
>>    DSP remote processors were booted and using one of the GPTimers
>>    5, 6, 7 or 8 on previous 4.9 LTS kernel. This was due to the
>>    errata fix for i874 implemented in commit 1cbabcb9807e ("ARM:
>>    DRA7: clockdomain: Implement timer workaround for errata i874")
>>    which keeps the IPU1 power domain from entering RET when the
>>    timers are active. But the timer workaround did not make any
>>    difference on 4.14 kernel, and an l3_noc error was seen still
>>    without this fix.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> Signed-off-by: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>And drop this one as well, since mainline doesn't yet boot
>the processors, so this is not needed for stable queue.

Now dropped, thank you.

-- 
Thanks,
Sasha
