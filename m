Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F9522419C
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 19:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGQRQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 13:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgGQRQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 13:16:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94967206BE;
        Fri, 17 Jul 2020 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595006179;
        bh=BMFDpLiXiIkNg05MYBPfN+bjURAfepPCUIPuHQlUSiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MAqrX9/PcmveaIgPJnYWRFY21xgtKg5EMWwxh3g7nMazwXEBJonijbZPHU1R1AQSa
         sag/nVtSM5RSL7FnVUtetWrUo05JniCdQjp8Hf6CEV9x3VnWZizsBv5sP2Ay/dRjQC
         vJr/42dT/FSeYxESIvBNs8Ae8GKXBGnAmzp/RL9Y=
Date:   Fri, 17 Jul 2020 13:16:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Oliver Neukum <oneukum@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 4.14 105/136] usb/ehci-platform: Set PM runtime as active
 on resume
Message-ID: <20200717171618.GQ2722994@sasha-vm>
References: <20200623195303.601828702@linuxfoundation.org>
 <20200623195308.955410923@linuxfoundation.org>
 <20200709070023.GA18414@lxhi-065.adit-jv.com>
 <20200717161639.37ptgbolborimcvs@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200717161639.37ptgbolborimcvs@e107158-lin.cambridge.arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 17, 2020 at 05:17:23PM +0100, Qais Yousef wrote:
>Hi Eugeniu
>
>On 07/09/20 09:00, Eugeniu Rosca wrote:
>> Hello everyone,
>>
>> Cc: linux-renesas-soc
>> Cc: linux-pm
>
>[...]
>
>> After integrating v4.14.186 commit 5410d158ca2a50 ("usb/ehci-platform:
>> Set PM runtime as active on resume") into downstream v4.14.x, we started
>> to consistently experience below panic [1] on every second s2ram of
>> R-Car H3 Salvator-X Renesas reference board.
>>
>> After some investigations, we concluded the following:
>>  - the issue does not exist in vanilla v5.8-rc4+
>>  - [bisecting shows that] the panic on v4.14.186 is caused by the lack
>>    of v5.6-rc1 commit 987351e1ea7772 ("phy: core: Add consumer device
>>    link support"). Getting evidence for that is easy. Reverting
>>    987351e1ea7772 in vanilla leads to a similar backtrace [2].
>>
>> Questions:
>>  - Backporting 987351e1ea7772 ("phy: core: Add consumer device
>>    link support") to v4.14.187 looks challenging enough, so probably not
>>    worth it. Anybody to contradict this?
>>  - Assuming no plans to backport the missing mainline commit to v4.14.x,
>>    should the following three v4.14.186 commits be reverted on v4.14.x?
>>    * baef809ea497a4 ("usb/ohci-platform: Fix a warning when hibernating")
>>    * 9f33eff4958885 ("usb/xhci-plat: Set PM runtime as active on resume")
>>    * 5410d158ca2a50 ("usb/ehci-platform: Set PM runtime as active on resume")
>
>Thanks for investigating this.
>
>Alan, Greg, do you have any ideas?

I've reverted these 3 commits from 5.4 and earlier, thank you for
investigating this issue.

-- 
Thanks,
Sasha
