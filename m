Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1A6B5AB9
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 12:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCKLEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 06:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCKLEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 06:04:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCFA69CE6
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 03:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678532629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R5J6AMnrRcXzt+I/O0ChiKQKBLR4EtyPdwMr9Jqq3Qs=;
        b=jJoxFPiwHvxygVO4WCLjQdiLN5RyaX8VQX1qJTcrJ7hFlIIpEf53CxC8ryzXS73/8kUm04
        EZ9UO63nl+50HPUof0SkRzfD6/2m/4lmhC+y7acxzGs4mfAopMN9om3LfJbR+MXz5+Jooa
        4SFF0mpEZdDf1I2dHu4mb1TZfxDNWOk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-DumZJiV5PQGiXdp_bZd9Vw-1; Sat, 11 Mar 2023 06:03:47 -0500
X-MC-Unique: DumZJiV5PQGiXdp_bZd9Vw-1
Received: by mail-ed1-f70.google.com with SMTP id v11-20020a056402348b00b004ce34232666so10896776edc.3
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 03:03:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678532626;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R5J6AMnrRcXzt+I/O0ChiKQKBLR4EtyPdwMr9Jqq3Qs=;
        b=3XdD+owuAqwYvUl+O+CUIyKaGjvCaHnh9UOd324o3CwAtu8T2nVi/0Wo0/jyUyOEL6
         CHO1lBFvmDs7sFzBrfqTuvvFZsZyf67FAwsYJdxt+6RPwlNwkIr9BGXLxUi7nUcAh8z7
         jDQtCKZ88K3gxZGZFcKsru/SwTHeD/VCrM67A2LT+TwfZphs/bcqEFgaefP3+4lN8oND
         X6Mb5XQATpv5trToqONrZgK1UfLjHBLhGRr2L6IhihmUwlwl2gEw3FglfKkNmYhI3Sid
         +yWARs0zUmzdQFwJI49vSbn4EurczXw10RPGEPyFJwefE2r60R+SDg3hHWWakEnZhFxa
         XMLw==
X-Gm-Message-State: AO0yUKWAaXrhXSjRSbQ51kAbWDHGab6eYrBxpI6CS4YCfVrZ55StZVHm
        /KCYvnTZHU/sKXfBmJq8kPVIoPl+fUXRW08pP8wWbNsgv3pgtLRY78A8HdaSTNLYggytegJo2w+
        iarKXJ2B1DZeFgwkM
X-Received: by 2002:aa7:d714:0:b0:4a2:5f73:d3d2 with SMTP id t20-20020aa7d714000000b004a25f73d3d2mr22955524edq.41.1678532626384;
        Sat, 11 Mar 2023 03:03:46 -0800 (PST)
X-Google-Smtp-Source: AK7set+z3RdYzPB7NNH4vz6C3euW7LL8q3Xo56HBL74ZzcsDrSAmzJYqxuYwdhdRqfkvj5wUVIbkUQ==
X-Received: by 2002:aa7:d714:0:b0:4a2:5f73:d3d2 with SMTP id t20-20020aa7d714000000b004a25f73d3d2mr22955513edq.41.1678532626120;
        Sat, 11 Mar 2023 03:03:46 -0800 (PST)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id v21-20020a50d595000000b004f9ca99cf5csm909711edi.92.2023.03.11.03.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 03:03:45 -0800 (PST)
Message-ID: <02ba45eb-1970-791a-d922-7b325ea51146@redhat.com>
Date:   Sat, 11 Mar 2023 12:03:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [REGRESSION] Patch broke WPA auth: Re: [PATCH v2] wifi: cfg80211:
 Fix use after free for wext
Content-Language: en-US, nl
To:     Hector Martin <marcan@marcan.st>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org,
        Asahi Linux <asahi@lists.linux.dev>, Ilya <me@0upti.me>,
        Janne Grunau <j@jannau.net>,
        LKML <linux-kernel@vger.kernel.org>, regressions@lists.linux.dev
References: <20230124141856.356646-1-alexander@wetzel-home.de>
 <d6851c2b-7966-6cb4-a51c-7268c60e0a86@marcan.st>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <d6851c2b-7966-6cb4-a51c-7268c60e0a86@marcan.st>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hector,

On 3/11/23 10:55, Hector Martin wrote:
> Hi,
> 
> This broke WPA auth entirely on brcmfmac (in offload mode) and probably
> others, including on stable 6.2.3 and 6.3-rc1 (tested with iwd). Please
> revert or fix. Notes below.
> 
> Reported-by: Ilya <me@0upti.me>
> Reported-by: Janne Grunau <j@jannau.net>
> 
> #regzbot introduced: 015b8cc5e7c4d7
> #regzbot monitor:
> https://lore.kernel.org/linux-wireless/20230124141856.356646-1-alexander@wetzel-home.de/

I can confirm this bug, I was seeing broken wifi on brcmfmac with 6.3-rc1
and I was about to start a git bisect for this this morning when I saw
this email.

Reverting 015b8cc5e7c4d7 fixes the broken wifi. Hector, thank you, you
just saved me from a bisect on somewhat slow hardware :)

Regards,

Hans






> 
> On 24/01/2023 23.18, Alexander Wetzel wrote:
>> Key information in wext.connect is not reset on (re)connect and can hold
>> data from a previous connection.
>>
>> Reset key data to avoid that drivers or mac80211 incorrectly detect a
>> WEP connection request and access the freed or already reused memory.
>>
>> Additionally optimize cfg80211_sme_connect() and avoid an useless
>> schedule of conn_work.
>>
>> Fixes: fffd0934b939 ("cfg80211: rework key operation")
>> Cc: stable@vger.kernel.org
>> Link: https://lore.kernel.org/r/c80f04d2-8159-a02a-9287-26e5ec838826@wetzel-home.de
>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>>
>> ---
>> V2 changes:
>> - updated comment
>> - reset more key data
>>
>> ---
>>  net/wireless/sme.c | 31 ++++++++++++++++++++++++++-----
>>  1 file changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
>> index 123248b2c0be..0cc841c0c59b 100644
>> --- a/net/wireless/sme.c
>> +++ b/net/wireless/sme.c
> [snip]
>> @@ -1464,6 +1476,15 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
> 
> This if branch only fires if the connection is WEP.
> 
>>  	} else {
>>  		if (WARN_ON(connkeys))
>>  			return -EINVAL;
>> +
>> +		/* connect can point to wdev->wext.connect which
>> +		 * can hold key data from a previous connection
>> +		 */
>> +		connect->key = NULL;
>> +		connect->key_len = 0;
>> +		connect->key_idx = 0;
> 
> And these are indeed only used by WEP.
> 
>> +		connect->crypto.cipher_group = 0;
>> +		connect->crypto.n_ciphers_pairwise = 0;
> 
> But here you're killing the info that is used for *other* auth modes too
> if !WEP, breaking WPA and everything else.
> 
>>  	}
>>  
>>  	wdev->connect_keys = connkeys;
> 
> - Hector
> 

