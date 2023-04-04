Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54C16D5A1E
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjDDH5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjDDH5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873E6198A
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 00:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680595023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3TkeClV4EMiV5agwGhkpRyE4q1gMA5VINpsaFciEjg=;
        b=EbExtiUA/1uVU8d85oupWAMHg+n3thyb7itn5gXyQzLUkjfXCbema7QCxfev57FcQKYJv5
        ehQi1dYlnSgv7ECTL8F2MocT4wxU+kOwQPwPsjhNcxN23A1K9MbO7pp32tu2jNcaJ6bSkU
        bUspIas1IowOwmBGgOlcZp5MCBXfRqw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-SK1Y5t8-PQS_sRfCCp7Syw-1; Tue, 04 Apr 2023 03:57:02 -0400
X-MC-Unique: SK1Y5t8-PQS_sRfCCp7Syw-1
Received: by mail-ed1-f71.google.com with SMTP id f15-20020a50a6cf000000b0050050d2326aso44454752edc.18
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 00:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680595021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E3TkeClV4EMiV5agwGhkpRyE4q1gMA5VINpsaFciEjg=;
        b=6nPdzRkewroLdYfhE+YpDkrnt+/StLVdrerl/WxKuyNDnN8sAhv29Zeka3nPApOh/L
         WjY4biPK3JKb5KVPGfIp6dhqEIhHL5qO8MVrlS7xgPzK79XsmrJWvH5axz3KqSOnS2eZ
         evHgCP5xswIAz/laRvTRHIhkt0ABfHikCl+zBC81+ys2LK46bYqn59SbfPBt5e3tYmuq
         Y4u58NpYL226io/xIDrYQIyZjUXYgH5VEpvYigWKjjQEP0gsLdYeilSPFqGht75oLAQz
         d0jXPAnYc77f7TfV4QC+A9jdet9UgyzhuDvesJIodgLEgk8oEx7qVoT9emPj7zTx1nrc
         c//Q==
X-Gm-Message-State: AAQBX9dUuI000V+jQDQBDLvHJmww27RmQEi874Nniq2BVuods+wFzV8B
        WjFTzkJKo70cxu+YWIlvWjAMyzaBEtRJAKCE2+H4iWOd8E6tH7C2nS/uVXWnCAnScxfTwBWHI6k
        DouH0ScEiEMkE7g3l
X-Received: by 2002:a05:6402:1809:b0:502:3ff4:4d76 with SMTP id g9-20020a056402180900b005023ff44d76mr1865673edy.27.1680595021372;
        Tue, 04 Apr 2023 00:57:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350YjfRzpnjPR/iLIdp3S5PgxAT4GGGc8/A08nFF7+jREhgxY0e2BavQgGAXFxXHTQ5adX1Or3g==
X-Received: by 2002:a05:6402:1809:b0:502:3ff4:4d76 with SMTP id g9-20020a056402180900b005023ff44d76mr1865659edy.27.1680595021091;
        Tue, 04 Apr 2023 00:57:01 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id a26-20020a50c31a000000b005027686918bsm5383762edb.11.2023.04.04.00.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:57:00 -0700 (PDT)
Message-ID: <7cd9a667-9ec8-b0a9-6f2c-de5f961d765b@redhat.com>
Date:   Tue, 4 Apr 2023 09:56:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] platform/x86: ideapad-laptop: Stop sending
 KEY_TOUCHPAD_TOGGLE
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     Mark Gross <markgross@kernel.org>,
        Andy Shevchenko <andy@kernel.org>,
        =?UTF-8?Q?Barnab=c3=a1s_P=c5=91cze?= <pobrn@protonmail.com>,
        Kai Heng Feng <kai.heng.feng@canonical.com>,
        GOESSEL Guillaume <g_goessel@outlook.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Manyi Li <limanyi@uniontech.com>,
        =?UTF-8?Q?Eray_Or=c3=a7unus?= <erayorcunus@gmail.com>,
        Philipp Jungkamp <p.jungkamp@gmx.net>,
        Arnav Rawat <arnavr3@illinois.edu>,
        Kelly Anderson <kelly@xilka.com>, Meng Dong <whenov@gmail.com>,
        Felix Eckhofer <felix@eckhofer.com>,
        Ike Panhc <ike.pan@canonical.com>,
        platform-driver-x86@vger.kernel.org, stable@vger.kernel.org
References: <20230330194644.64628-1-hdegoede@redhat.com>
 <ZCatIn7ok4jRrXS9@mail.gmail.com> <ZCs8SA47vGCjVl1l@mail.gmail.com>
Content-Language: en-US, nl
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <ZCs8SA47vGCjVl1l@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/3/23 22:51, Maxim Mikityanskiy wrote:
> On Fri, 31 Mar 2023 at 12:51:30 +0300, Maxim Mikityanskiy wrote:
>> On Thu, 30 Mar 2023 at 21:46:44 +0200, Hans de Goede wrote:
>>> Commit 5829f8a897e4 ("platform/x86: ideapad-laptop: Send
>>> KEY_TOUCHPAD_TOGGLE on some models") made ideapad-laptop send
>>> KEY_TOUCHPAD_TOGGLE when we receive an ACPI notify with VPC event bit 5 set
>>> and the touchpad-state has not been changed by the EC itself already.
>>>
>>> This was done under the assumption that this would be good to do to make
>>> the touchpad-toggle hotkey work on newer models where the EC does not
>>> toggle the touchpad on/off itself (because it is not routed through
>>> the PS/2 controller, but uses I2C).
>>>
>>> But it turns out that at least some models, e.g. the Yoga 7-15ITL5 the EC
>>> triggers an ACPI notify with VPC event bit 5 set on resume, which would
>>> now cause a spurious KEY_TOUCHPAD_TOGGLE on resume to which the desktop
>>> environment responds by disabling the touchpad in software, breaking
>>> the touchpad (until manually re-enabled) on resume.
>>
>> Oh gosh, the touchpad toggle on Ideapads is so much broken, I wonder how
>> the Windows driver deals with all this variety of different behaviors
>> (unless it's broken too :D).
>>
>> I'll test the patch on Z570, but as I see, it shouldn't change anything
>> for Z570.
> 
> Tested the kernel from your branch on Z570, the touchpad button still
> works fine.

Thank you for testing.

Regards,

Hans


