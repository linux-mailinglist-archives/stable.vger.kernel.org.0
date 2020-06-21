Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1BC202DBA
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 01:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgFUXqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 19:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbgFUXqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jun 2020 19:46:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95660214D8;
        Sun, 21 Jun 2020 23:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592783182;
        bh=MVR0P4Maf2NQU4Sq1jPI51OShsob/nufybi+jUBB13w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ftI1MpqQhEDFp02DgvKdYPmHMwhIRztrO2wfWj6QU1c45qDYsCl3N0zBwd2rs5ovg
         +gw54xpoo52xBO5DVsDd6juHCqfCNjUbXjjokux9ULT/UMlgaltfHVhlC9rBrVTgb8
         0I4H0gliAo7f55jAhAMQCtBBFNM8rnYLQaycr4Qo=
Date:   Sun, 21 Jun 2020 19:46:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Oliver Neukum <oneukum@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 229/388] usb/ohci-platform: Fix a warning
 when hibernating
Message-ID: <20200621234621.GC1931@sasha-vm>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-229-sashal@kernel.org>
 <20200618095600.umb4gyegy2hszlep@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200618095600.umb4gyegy2hszlep@e107158-lin.cambridge.arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 10:56:01AM +0100, Qais Yousef wrote:
>Hi Sasha/Alan
>
>On 06/17/20 21:05, Sasha Levin wrote:
>
>[...]
>
>> diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
>> index 7addfc2cbadc..4a8456f12a73 100644
>> --- a/drivers/usb/host/ohci-platform.c
>> +++ b/drivers/usb/host/ohci-platform.c
>> @@ -299,6 +299,11 @@ static int ohci_platform_resume(struct device *dev)
>>  	}
>>
>>  	ohci_resume(hcd, false);
>> +
>> +	pm_runtime_disable(dev);
>> +	pm_runtime_set_active(dev);
>> +	pm_runtime_enable(dev);
>> +
>
>I am not sure what's the protocol here, but the series was fixing similar
>problems to this driver but I didn't myself directly observe a warning because
>of that.
>
>https://lore.kernel.org/lkml/20200518154931.6144-2-qais.yousef@arm.com/
>https://lore.kernel.org/lkml/20200518154931.6144-3-qais.yousef@arm.com/
>
>So just pointing it out in case they're worth backporting to stable too.

I'll grab them too, thanks!

-- 
Thanks,
Sasha
