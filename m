Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1D06BACC9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjCOJ5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjCOJ5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:57:07 -0400
Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E4629432;
        Wed, 15 Mar 2023 02:55:39 -0700 (PDT)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Wed, 15 Mar
 2023 12:55:27 +0300
Received: from [10.0.253.157] (10.0.253.157) by Ex16-01.fintech.ru
 (10.0.10.18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Wed, 15 Mar
 2023 12:55:27 +0300
Message-ID: <e837a9a1-d5ed-ae97-3a55-7e4525a315ae@fintech.ru>
Date:   Wed, 15 Mar 2023 02:55:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4/5.10 1/1] RDMA/i40iw: Fix potential
 NULL-ptr-dereference
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Leon Romanovsky" <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
References: <20230314134456.3557-1-n.zhandarovich@fintech.ru>
 <20230314134456.3557-2-n.zhandarovich@fintech.ru>
 <ZBF7A87Ph+O2y7KY@kroah.com>
Content-Language: en-US
From:   Nikita Zhandarovich <n.zhandarovich@fintech.ru>
In-Reply-To: <ZBF7A87Ph+O2y7KY@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.253.157]
X-ClientProxiedBy: Ex16-02.fintech.ru (10.0.10.19) To Ex16-01.fintech.ru
 (10.0.10.18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/15/23 01:00, Greg Kroah-Hartman wrote:
> On Tue, Mar 14, 2023 at 06:44:56AM -0700, Nikita Zhandarovich wrote:
>> From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>>
>> commit 5d9745cead1f121974322b94ceadfb4d1e67960e upstream.
>>
>> in_dev_get() can return NULL which will cause a failure once idev is
>> dereferenced in in_dev_for_each_ifa_rtnl(). This patch adds a
>> check for NULL value in idev beforehand.
>>
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> Changes made to the original patch during backporting:
>> Apply patch to drivers/infiniband/hw/i40iw/i40iw_cm.c instead of
>> drivers/infiniband/hw/irdma/cm.c due to the fact that kernel versions
>> 5.10 and below use i40iw driver, not irdma.
>>
>> Fixes: f27b4746f378 ("i40iw: add connection management code")
>> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>> Link: https://lore.kernel.org/r/20230126185230.62464-1-n.zhandarovich@fintech.ru
>> ---
>>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
>> index 3053c345a5a3..e1236ac502f2 100644
>> --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
>> +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
>> @@ -1776,6 +1776,8 @@ static enum i40iw_status_code i40iw_add_mqh_4(
>>  			const struct in_ifaddr *ifa;
>>  
>>  			idev = in_dev_get(dev);
>> +			if (!idev)
>> +				continue;
>>  
>>  			in_dev_for_each_ifa_rtnl(ifa, idev) {
>>  				i40iw_debug(&iwdev->sc_dev,
> 
> As this isn't anything that can be triggered by a normal system
> operation, I'm going to drop it from the review queue.  Unless you have
> a reproducer that can cause this to happen from userspace?
> 
> thanks,
> 
> greg k-h

Currently working on seeing whether a reproducer is feasible. It makes
sense to not include the patch until then.

thanks for your time,

Nikita
