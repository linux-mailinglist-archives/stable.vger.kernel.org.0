Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4674FF9BB
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 17:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiDMPJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 11:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiDMPJW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 11:09:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDDB12DD59;
        Wed, 13 Apr 2022 08:07:00 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9432A139F;
        Wed, 13 Apr 2022 08:07:00 -0700 (PDT)
Received: from [10.57.8.248] (unknown [10.57.8.248])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE8B23F5A1;
        Wed, 13 Apr 2022 08:06:58 -0700 (PDT)
Message-ID: <af2c9715-b085-ac84-22fe-c3f082f889a0@arm.com>
Date:   Wed, 13 Apr 2022 16:06:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] thermal: devfreq_cooling: use local ops instead of
 global ops
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Amit Kucheria <amitk@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        allwinner-opensource-support@allwinnertech.com,
        Stable <stable@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Kant Fan <kant@allwinnertech.com>
References: <20220325073030.91919-1-kant@allwinnertech.com>
 <c881de5f-5a1e-19ff-0ae6-f68032c79f03@arm.com>
 <CAJZ5v0j9O4mnUtNNtaQ7SZ1_N8GUOJ0CeSzZOwcJ18BKU9yKqQ@mail.gmail.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
In-Reply-To: <CAJZ5v0j9O4mnUtNNtaQ7SZ1_N8GUOJ0CeSzZOwcJ18BKU9yKqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/13/22 15:58, Rafael J. Wysocki wrote:
> On Fri, Mar 25, 2022 at 10:02 AM Lukasz Luba <lukasz.luba@arm.com> wrote:
>>
>> Hi Kant,
>>
>> On 3/25/22 07:30, Kant Fan wrote:
>>> Fix access illegal address problem in following condition:
>>> There are muti devfreq cooling devices in system, some of them has
>>> em model but other does not, energy model ops such as state2power will
>>> append to global devfreq_cooling_ops when the cooling device with
>>> em model register. It makes the cooling device without em model
>>> also use devfreq_cooling_ops after appending when register later by
>>> of_devfreq_cooling_register_power() or of_devfreq_cooling_register().
>>>
>>> IPA governor regards the cooling devices without em model as a power actor
>>> because they also have energy model ops, and will access illegal address
>>> at dfc->em_pd when execute cdev->ops->get_requested_power,
>>> cdev->ops->state2power or cdev->ops->power2state.
>>>
>>> Fixes: 615510fe13bd2 ("thermal: devfreq_cooling: remove old power model and use EM")
>>> Cc: stable@vger.kernel.org # 5.13+
>>> Signed-off-by: Kant Fan <kant@allwinnertech.com>
>>> ---
>>>    drivers/thermal/devfreq_cooling.c | 25 ++++++++++++++++++-------
>>>    1 file changed, 18 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/thermal/devfreq_cooling.c b/drivers/thermal/devfreq_cooling.c
>>> index 4310cb342a9f..d38a80adec73 100644
>>> --- a/drivers/thermal/devfreq_cooling.c
>>> +++ b/drivers/thermal/devfreq_cooling.c
>>> @@ -358,21 +358,28 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
>>>        struct thermal_cooling_device *cdev;
>>>        struct device *dev = df->dev.parent;
>>>        struct devfreq_cooling_device *dfc;
>>> +     struct thermal_cooling_device_ops *ops;
>>>        char *name;
>>>        int err, num_opps;
>>>
>>> -     dfc = kzalloc(sizeof(*dfc), GFP_KERNEL);
>>> -     if (!dfc)
>>> +     ops = kmemdup(&devfreq_cooling_ops, sizeof(*ops), GFP_KERNEL);
>>> +     if (!ops)
>>>                return ERR_PTR(-ENOMEM);
>>>
>>> +     dfc = kzalloc(sizeof(*dfc), GFP_KERNEL);
>>> +     if (!dfc) {
>>> +             err = -ENOMEM;
>>> +             goto free_ops;
>>> +     }
>>> +
>>>        dfc->devfreq = df;
>>>
>>>        dfc->em_pd = em_pd_get(dev);
>>>        if (dfc->em_pd) {
>>> -             devfreq_cooling_ops.get_requested_power =
>>> +             ops->get_requested_power =
>>>                        devfreq_cooling_get_requested_power;
>>> -             devfreq_cooling_ops.state2power = devfreq_cooling_state2power;
>>> -             devfreq_cooling_ops.power2state = devfreq_cooling_power2state;
>>> +             ops->state2power = devfreq_cooling_state2power;
>>> +             ops->power2state = devfreq_cooling_power2state;
>>>
>>>                dfc->power_ops = dfc_power;
>>>
>>> @@ -407,8 +414,7 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
>>>        if (!name)
>>>                goto remove_qos_req;
>>>
>>> -     cdev = thermal_of_cooling_device_register(np, name, dfc,
>>> -                                               &devfreq_cooling_ops);
>>> +     cdev = thermal_of_cooling_device_register(np, name, dfc, ops);
>>>        kfree(name);
>>>
>>>        if (IS_ERR(cdev)) {
>>> @@ -429,6 +435,8 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
>>>        kfree(dfc->freq_table);
>>>    free_dfc:
>>>        kfree(dfc);
>>> +free_ops:
>>> +     kfree(ops);
>>>
>>>        return ERR_PTR(err);
>>>    }
>>> @@ -510,11 +518,13 @@ EXPORT_SYMBOL_GPL(devfreq_cooling_em_register);
>>>    void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
>>>    {
>>>        struct devfreq_cooling_device *dfc;
>>> +     const struct thermal_cooling_device_ops *ops;
>>>        struct device *dev;
>>>
>>>        if (IS_ERR_OR_NULL(cdev))
>>>                return;
>>>
>>> +     ops = cdev->ops;
>>>        dfc = cdev->devdata;
>>>        dev = dfc->devfreq->dev.parent;
>>>
>>> @@ -525,5 +535,6 @@ void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
>>>
>>>        kfree(dfc->freq_table);
>>>        kfree(dfc);
>>> +     kfree(ops);
>>>    }
>>>    EXPORT_SYMBOL_GPL(devfreq_cooling_unregister);
>>
>>
>> Thank you for updating it, LGTM
>>
>> Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
> 
> Applied as 5.19 material.
> 
> Lukasz, this had a conflict with your EM series, please double check
> if my resolution in the bleeding-edge branch is correct.

OK, I'll let you know after I fetch and build that branch.

> 
> Thanks!
