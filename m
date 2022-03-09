Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478134D3623
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbiCIQhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiCIQgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:36:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4E1910B6
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646843502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=19PBYcCeKB+hwuSIUaJilXLyNXqe53kOkbC+oSp2UR8=;
        b=Cfo9OKd7uVyvK8zLVWb40HANIFDbBVQ3u10B0eaCI4IjwicjbienJNbJj43b7Pm0no1JGl
        RUyEqYdHzx8mhq+zXFynBQ3qRWh5Qf3/0JaHMZRuubJCCcSPwT0hfDNU968pwE/mUlfs4r
        VXtAd+HR5RGWtYr9yhgYjXJkBBh5m3s=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-fMUDoigTMp-GtSOjCd4PwQ-1; Wed, 09 Mar 2022 11:31:41 -0500
X-MC-Unique: fMUDoigTMp-GtSOjCd4PwQ-1
Received: by mail-ed1-f72.google.com with SMTP id i5-20020a056402054500b00415ce7443f4so1568836edx.12
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 08:31:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=19PBYcCeKB+hwuSIUaJilXLyNXqe53kOkbC+oSp2UR8=;
        b=PktdTgs6P/yz7ngQIzbuYbAr5mfdJWbXxH/PDaJehTdQWjSkDLsNJCSshxMKJNhXvQ
         4XilGCbscLNV3ndMwkj2c7Fbq8BEMRHAcIgE808YVLi65Cnbg9t/FBEbFIGohh+knJI8
         GcCG42L10lHBEAyZ9Yceud3N5pZPIaJOoKaz+MPISoGYccfDryAvoDUd1gnxOZ/mLc2q
         v9Xt4f6DRPgFU5dTBqeMhfA7Up2uGvUksmP5H27j3/6SeGE/oq5PDXrTdZGMJQ9Nk2Yq
         e8GeJU5sXRso0KWZc2WvuXPU5kKP6nXkbQ9J5WLXybtSu2dq3T2I370a3v1FaVMbYqCJ
         FoZQ==
X-Gm-Message-State: AOAM533Cg5yWnOJj/ExU1/9nq3F99LwLZD14FIgmr3Dx8OoIYhIaBEXO
        0/ZXBMNI2gxuUEUde3W6vNHQuLPe7vytMQwm3PU0hVIkJL8nmbfPa5lTzXAd3tdSTGvyL+c+dOl
        vaxpKxiY3qo1FAOnZ
X-Received: by 2002:a17:907:7e9c:b0:6db:4788:66ab with SMTP id qb28-20020a1709077e9c00b006db478866abmr559586ejc.112.1646843500448;
        Wed, 09 Mar 2022 08:31:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJ1/tFiy2XrGUMMC8XJEstjoFFAPiNQlurnWEChLAbJlFSRbuN0IDy5oePAjn33pUEsAUweA==
X-Received: by 2002:a17:907:7e9c:b0:6db:4788:66ab with SMTP id qb28-20020a1709077e9c00b006db478866abmr559577ejc.112.1646843500225;
        Wed, 09 Mar 2022 08:31:40 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:cdb2:2781:c55:5db0? (2001-1c00-0c1e-bf00-cdb2-2781-0c55-5db0.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:cdb2:2781:c55:5db0])
        by smtp.gmail.com with ESMTPSA id v10-20020a170906380a00b006a68610908asm934875ejc.24.2022.03.09.08.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:31:39 -0800 (PST)
Message-ID: <ad3b77f8-7e75-1dfa-8ee4-1077336911aa@redhat.com>
Date:   Wed, 9 Mar 2022 17:31:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com>
 <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <CAJZ5v0hQifvD+U8q1O7p_5QeicG_On4=CrgNj0RsbPSbkY8Hww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/9/22 14:57, Rafael J. Wysocki wrote:
> On Wed, Mar 9, 2022 at 2:44 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi Rafael,
>>
>> We (Fedora) have been receiving a whole bunch of bug reports about
>> laptops getting hot/toasty while suspended with kernels >= 5.16.10
>> and this seems to still happen with 5.17-rc7 too.
>>
>> The following are all bugzilla.redhat.com bug numbers:
>>
>>    1750910 - Laptop failed to suspend and completely drained the battery
>>    2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
>>    2053957 - Package c-states never go below C2
>>    2056729 - No lid events when closing lid / laptop does not suspend
>>    2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
>>    2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
>>    2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
>>
>> And one of the bugs has also been mirrored at bugzilla.kernel.org by
>> the reporter:
>>
>>  bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
>>
>> The common denominator here (besides the kernel version) seems to
>> be that these are all Ice or Tiger Lake systems (I did not do
>> check this applies 100% to all bugs, but it does see, to be a pattern).
>>
>> A similar arch-linux report:
>>
>> https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
>>
>> Suggest that reverting
>> "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
>>
>> which was cherry-picked into 5.16.10 fixes things.
> 
> Thanks for letting me know!
> 
>> If you want I can create Fedora kernel test-rpms of a recent
>> 5.16.y with just that one commit reverted and ask users to
>> confirm if that helps. Please let me know if doing that woulkd
>> be useful ?
> 
> Yes, it would.
> 
> However, it follows from the arch-linux report linked above that
> 5.17-rc is fine, so it would be good to also check if reverting that
> commit from 5.17-rc helps.

Ok, I've done Fedora kernel builds of both 5.16.13 and 5.17-rc7 with
the patch reverted and asked the bug-reporters to test both.

Regards,

Hans

