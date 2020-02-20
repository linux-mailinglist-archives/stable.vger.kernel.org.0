Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28551166438
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 18:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgBTRUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 12:20:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbgBTRUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 12:20:11 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A15C9208E4;
        Thu, 20 Feb 2020 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582219210;
        bh=nISuG6svIwzof7JHQmMj7ZgoZJYtf5uXKsOvPPgXBsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HzXgcVxojD9fCltFKaqoYXkNdpoi4yaKM5Zv2RduL6TzvqtjeQf/FBNHxB/Aq1DBf
         EV4WYvPyU7kHGli3k+0OKCwM1mWsB6ifYjh+es2/KnSm7R6+3Ep4W8BnQo5nydkjwC
         MJzv1KyUBmeotowmCURgfjmzmk+9OV3eDp/zZACw=
Date:   Thu, 20 Feb 2020 12:20:09 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 383/542] gpio: Fix the no return statement
 warning
Message-ID: <20200220172009.GG1734@sasha-vm>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-383-sashal@kernel.org>
 <20200215004455.GA499724@pek-khao-d2.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200215004455.GA499724@pek-khao-d2.corp.ad.wrs.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 15, 2020 at 08:44:55AM +0800, Kevin Hao wrote:
>On Fri, Feb 14, 2020 at 10:46:15AM -0500, Sasha Levin wrote:
>> From: Kevin Hao <haokexin@gmail.com>
>>
>> [ Upstream commit 9c6722d85e92233082da2b3623685bba54d6093e ]
>>
>> In commit 242587616710 ("gpiolib: Add support for the irqdomain which
>> doesn't use irq_fwspec as arg") we have changed the return type of
>> gpiochip_populate_parent_fwspec_twocell/fourcell() from void to void *,
>> but forgot to add a return statement for these two dummy functions.
>> Add "return NULL" to fix the build warnings.
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Signed-off-by: Kevin Hao <haokexin@gmail.com>
>> Link: https://lore.kernel.org/r/20200116095003.30324-1-haokexin@gmail.com
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  include/linux/gpio/driver.h | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
>> index e2480ef94c559..5dce9c67a961e 100644
>> --- a/include/linux/gpio/driver.h
>> +++ b/include/linux/gpio/driver.h
>> @@ -553,6 +553,7 @@ static inline void gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chi
>>  						    unsigned int parent_hwirq,
>>  						    unsigned int parent_type)
>>  {
>> +	return NULL;
>
>Hi Sasha,
>
>This commit shouldn't go to the v5.5.x kernel. This is a fix for the
>commit 242587616710, but that commit doesn't exist in the v5.5.x kernel,
>then it will trigger a build warning due to the wrong returning type.

Now dropped, thank you.

-- 
Thanks,
Sasha
