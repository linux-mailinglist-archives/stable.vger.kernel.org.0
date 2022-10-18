Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487FC602EFD
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 16:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiJRO5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 10:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJRO5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 10:57:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780D9DAC49
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 07:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666105028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N18X2J/ONbO6fBplsdixEtdnDqytNGDyOXwWdNHlzog=;
        b=NV6HbTP3kNsfUGAC9xKqGASiPZcJQqRTPIDN4kogV+enhw8M6n2sR5kPpPkMJSWeZsBPqd
        43+WCf/1WBES+XMA+TXZmqnVRoNnujtCkzQkQlnIDgK4w6/fjKCplOZ8jDQld2jofRmKRt
        crkdoxpf0y6MCWELV/DhIoZLxv4RVoM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-131-uDDWnL1KMEGEklUAWPI66w-1; Tue, 18 Oct 2022 10:57:07 -0400
X-MC-Unique: uDDWnL1KMEGEklUAWPI66w-1
Received: by mail-wm1-f71.google.com with SMTP id 125-20020a1c0283000000b003c6d73209b0so2846216wmc.1
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 07:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N18X2J/ONbO6fBplsdixEtdnDqytNGDyOXwWdNHlzog=;
        b=r8jR+alVAtYZ6ere7FoH164p/ZMkiEMWOux/xbkyzucNYSfVWO1KTnV2fbZb2ptnll
         oJ5LYS6+9BEXUly4cHu1vER1vVIulN5XQMD+yT01IhVSIxTunZ/dF23MjucbH9qxciX8
         wRxvPEYvFsmZS7jOhn8HVKlU8qqy6ukazL8zooW71o8hK7x1BmUYyqcT3ESjvK90JpmM
         jdSi0EtIVcJQcMgsV/w1TXUXmWreD8qgBHyA65URGes778IH30wQhr8cQnmg8xPtXm5v
         Z8w3L3dMqjnihnmFk4epAs++rU3eYYx+4+Z7Sk1K1H1Lse3F08lFioJryZ2cjIdtatYq
         bbsA==
X-Gm-Message-State: ACrzQf1LdFGYBvYgjPC3ybKQM3D18eO6siBcoXU8Yb449SpMWS0sPiEM
        qJpk6xM6JBk07fGuHauJLEgj3n0GMPfelYEUG//jsYLfOyHm9exBaxF2qZrsQ+n/MKvJqvJpoPr
        hGIZJq57q0CWvM/lq
X-Received: by 2002:a05:600c:214f:b0:3c6:ce02:8a68 with SMTP id v15-20020a05600c214f00b003c6ce028a68mr23598179wml.187.1666105025930;
        Tue, 18 Oct 2022 07:57:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6054Cazg2z9TC7UqsrNGdhopIpZm1elhvnKApojdAs5XcIRVqvOggdge+pR3acpIcpGS8i5g==
X-Received: by 2002:a05:600c:214f:b0:3c6:ce02:8a68 with SMTP id v15-20020a05600c214f00b003c6ce028a68mr23598167wml.187.1666105025727;
        Tue, 18 Oct 2022 07:57:05 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:38da:a7d9:7cc9:db3e? ([2a01:e0a:c:37e0:38da:a7d9:7cc9:db3e])
        by smtp.gmail.com with ESMTPSA id a1-20020a05600c348100b003a5f4fccd4asm20221640wmq.35.2022.10.18.07.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 07:57:05 -0700 (PDT)
Message-ID: <b9f25473-d598-7566-96cf-4f8b10453722@redhat.com>
Date:   Tue, 18 Oct 2022 16:57:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Cc:     michel@daenzer.net, stable@vger.kernel.org
References: <20221013132810.521945-1-jfalempe@redhat.com>
 <03ca96bc-358f-3f02-c53e-5ff3a0d935dc@suse.de>
Content-Language: en-US
From:   Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <03ca96bc-358f-3f02-c53e-5ff3a0d935dc@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I just pushed it to drm-misc-next.

I also fixed the commit message a bit, the commit moving this line of 
code is in fact:

commit 877507bb954e ("drm/mgag200: Provide per-device callbacks for 
PIXPLLC")

Best Regards

-- 

Jocelyn

On 13/10/2022 15:55, Thomas Zimmermann wrote:
> 
> 
> Am 13.10.22 um 15:28 schrieb Jocelyn Falempe:
>> For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
>> or "signal out of range" on VGA display.
>> previous code had "m |= 0x80" which was changed to
>> m |= ((pixpllcn & BIT(8)) >> 1);
>>
>> Tested on G200_SE_A rev 42
>>
>> This line of code was moved to another file with
>> commit 85397f6bc4ff ("drm/mgag200: Initialize each model in separate
>> function") but can be easily backported before this commit.
>>
>> v2: * put BIT(7) First to respect MSB-to-LSB (Thomas)
>>      * Add a comment to explain that this bit must be set (Thomas)
>>
>> Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct 
>> mgag200_pll_values")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
> 
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> 
>> ---
>>   drivers/gpu/drm/mgag200/mgag200_g200se.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/mgag200/mgag200_g200se.c 
>> b/drivers/gpu/drm/mgag200/mgag200_g200se.c
>> index be389ed91cbd..bd6e573c9a1a 100644
>> --- a/drivers/gpu/drm/mgag200/mgag200_g200se.c
>> +++ b/drivers/gpu/drm/mgag200/mgag200_g200se.c
>> @@ -284,7 +284,8 @@ static void 
>> mgag200_g200se_04_pixpllc_atomic_update(struct drm_crtc *crtc,
>>       pixpllcp = pixpllc->p - 1;
>>       pixpllcs = pixpllc->s;
>> -    xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
>> +    // For G200SE A, BIT(7) should be set unconditionally.
>> +    xpixpllcm = BIT(7) | pixpllcm;
>>       xpixpllcn = pixpllcn;
>>       xpixpllcp = (pixpllcs << 3) | pixpllcp;
> 

