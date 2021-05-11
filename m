Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6266F379DFA
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 05:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEKD47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 23:56:59 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2297 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEKD46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 23:56:58 -0400
Received: from dggeml716-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FfP9j3K2pz19NW8;
        Tue, 11 May 2021 11:51:37 +0800 (CST)
Received: from dggpemm500009.china.huawei.com (7.185.36.225) by
 dggeml716-chm.china.huawei.com (10.3.17.127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 11 May 2021 11:55:50 +0800
Received: from [10.174.179.24] (10.174.179.24) by
 dggpemm500009.china.huawei.com (7.185.36.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 11 May 2021 11:55:50 +0800
Subject: Re: [PATCH 5.10 105/299] crypto: stm32/cryp - Fix PM reference leak
 on stm32-cryp.c
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102008.407819731@linuxfoundation.org>
 <20210510120742.GC3547@duo.ucw.cz>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
From:   Liu Shixin <liushixin2@huawei.com>
Message-ID: <d01d5e9e-45c7-52e7-ef56-0350ff7a618e@huawei.com>
Date:   Tue, 11 May 2021 11:55:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210510120742.GC3547@duo.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500009.china.huawei.com (7.185.36.225)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/5/10 20:07, Pavel Machek wrote:
> On Mon 2021-05-10 12:18:22, Greg Kroah-Hartman wrote:
>> From: Shixin Liu <liushixin2@huawei.com>
>>
>> [ Upstream commit 747bf30fd944f02f341b5f3bc7d97a13f2ae2fbe ]
>>
>> pm_runtime_get_sync will increment pm usage counter even it failed.
>> Forgetting to putting operation will result in reference leak here.
>> Fix it by replacing it with pm_runtime_resume_and_get to keep usage
>> counter balanced.
> Yes, but that only works when code checks the return value.
Thank you for the correction. Yes, You are right that if we carry out runtime resume
failed on the path where the return value is not checked, the pm usage counter will
be put in later path.

But I have another question. Why don't we check the return values in these path?
Does that mean these resumes will never fail?
>> +++ b/drivers/crypto/stm32/stm32-cryp.c
>> @@ -542,7 +542,7 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
>>  	int ret;
>>  	u32 cfg, hw_mode;
>>  
>> -	pm_runtime_get_sync(cryp->dev);
>> +	pm_runtime_resume_and_get(cryp->dev);
>>  
>>  	/* Disable interrupt */
>>  	stm32_cryp_write(cryp, CRYP_IMSCR, 0);
> Again, this is wrong.
>
>> @@ -2043,7 +2043,7 @@ static int stm32_cryp_remove(struct platform_device *pdev)
>>  	if (!cryp)
>>  		return -ENODEV;
>>  
>> -	ret = pm_runtime_get_sync(cryp->dev);
>> +	ret = pm_runtime_resume_and_get(cryp->dev);
>>  	if (ret < 0)
>>  		return ret;
>>  
> But this may be right.
>
> Best regards,
> 								Pavel

