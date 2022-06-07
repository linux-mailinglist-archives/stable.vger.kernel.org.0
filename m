Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837E053FF78
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 14:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbiFGMzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 08:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244270AbiFGMzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 08:55:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8D4C7892E
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 05:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654606501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PikFI8IuFGilq0ztM72f7JxwavOO8rV8L+cu0/Iu4x8=;
        b=EtyB1LWhWNfL63MlIGdNjX7xkKZh6WdCCsqcT1FhR6nbBrzqwI7jA/wQ061S55QEmUqJlM
        ME6XiAPavt1U6eQjEnVpklA1DWoy/tSmKkiFA89EsdtrPhPvhpcE4GaFt1QynKfhlENZA/
        /vLDx8E8zee/wo7xHV8+De7ZrsLyAsU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-2kApkOQWNHG5_X_vJrpCrQ-1; Tue, 07 Jun 2022 08:54:21 -0400
X-MC-Unique: 2kApkOQWNHG5_X_vJrpCrQ-1
Received: by mail-wr1-f71.google.com with SMTP id i10-20020a5d55ca000000b002103d76ffcaso3897419wrw.17
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 05:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PikFI8IuFGilq0ztM72f7JxwavOO8rV8L+cu0/Iu4x8=;
        b=3Chmi0r7ZxwjgC8bc8qQ3bBgWO22yVo3SiRv13z2elSY1BOZVEDuYkdLYLfYDXpBj6
         MnuLgMwJd2rssVaxl+MQo2+HIZ3zYGq9rBYehRoopjcjoELzT8oTiZXC3/icPjvHCbsX
         0bOUlPwgYGAaIrvvW4bJuS42wtrQ4Ea7OiSRnlwiUlqrj5R8YcZIh01rOuuJ6yeBdANz
         PdL1Hp/5Rtrau8c0jKhkzAKNdZqqyOr65/Ds2THq+e/L3e/MkT/dRtHdJsiDxFVhG6Yl
         kfQHqtNuEsh1YuHQPYYZxPl7557tXNQc7zeiwqekEI+YfyC69aWrSyITKrtU2TCxu05T
         XiAg==
X-Gm-Message-State: AOAM530es9zQn1W6iXbrOgbD0mHo7S2fufh8uzpkIFjpzJnVIM5iFXIq
        lzlMdeLdM7bJYZT5AQ4dc2eTRdWeY1w8fPgj0nmLlXeDE+7dLqXUgYIpaOSKgNznnmRvi2C7jcH
        paBBgxtxn3docspqX
X-Received: by 2002:a7b:c401:0:b0:397:26fb:ebf7 with SMTP id k1-20020a7bc401000000b0039726fbebf7mr29011210wmi.90.1654606459916;
        Tue, 07 Jun 2022 05:54:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJa9Ztgs/feNXwUUZcblGX2ZWB3NuTx5Hif1QltOBA4EuHQl1hdGlGjZxUtoDL/Nv8LMki0A==
X-Received: by 2002:a7b:c401:0:b0:397:26fb:ebf7 with SMTP id k1-20020a7bc401000000b0039726fbebf7mr29011177wmi.90.1654606459567;
        Tue, 07 Jun 2022 05:54:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id g6-20020a056000118600b002183fabc53csm5233442wrx.17.2022.06.07.05.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 05:54:18 -0700 (PDT)
Message-ID: <9d336622-6964-454a-605f-1ca90b902836@redhat.com>
Date:   Tue, 7 Jun 2022 14:54:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        chang.seok.bae@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
 <YppVupW+IWsm7Osr@xz-m1.local>
 <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
 <Yp5xSi6P3q187+A+@xz-m1.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yp5xSi6P3q187+A+@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/6/22 23:27, Peter Xu wrote:
> On Mon, Jun 06, 2022 at 06:18:12PM +0200, Paolo Bonzini wrote:
>>> However there seems to be something missing at least to me, on why it'll
>>> fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
>>> In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
>>> patch, but 0x0 if with it.
>>
>> What CPU model are you using for the VM?
> 
> I didn't specify it, assuming it's qemu64 with no extra parameters.

Ok, so indeed it lacks AVX and this patch can have an effect.

>> For example, if the source lacks this patch but the destination has it,
>> the source will transmit YMM registers, but the destination will fail to
>> set them if they are not available for the selected CPU model.
>>
>> See the commit message: "As a bonus, it will also fail if userspace tries to
>> set fpu features (with the KVM_SET_XSAVE ioctl) that are not compatible to
>> the guest configuration.  Such features will never be returned by
>> KVM_GET_XSAVE or KVM_GET_XSAVE2."
> 
> IIUC you meant we should have failed KVM_SET_XSAVE when they're not aligned
> (probably by failing validate_user_xstate_header when checking against the
> user_xfeatures on dest host). But that's probably not my case, because here
> KVM_SET_XSAVE succeeded, it's just that the guest gets a double fault after
> the precopy migration completes (or for postcopy when the switchover is
> done).

Difficult to say what's happening without seeing at least the guest code 
around the double fault (above you said "fail a migration" and I thought 
that was a different scenario than the double fault), and possibly which 
was the first exception that contributed to the double fault.

Paolo

