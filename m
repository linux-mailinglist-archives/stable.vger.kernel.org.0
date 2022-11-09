Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DD2622702
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 10:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiKIJbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 04:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiKIJbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 04:31:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54EA14D05
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 01:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667986203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q81R0xjwZq+Uqwnnq1xIVaWYwdB8y5Gee+dkpFHuQEI=;
        b=gsDfjVF4RmUQEb45hXAxQcPXmJ/7EMld1sBgGeX+8YpBlTJX1ae50Nk8U3BpK3q0tMyH/5
        4FhpeLEvlu/SCulXEa2Shi32OqgoaHQj0na1VN/PlEGUn8VI0e2PWzA9kDBz+U08cHBa8K
        3qTWOuzyaYYFwCDw5G37shb3SIlsMeU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-450-5z0YHHc-O7yDnKKbWtW6Kw-1; Wed, 09 Nov 2022 04:30:01 -0500
X-MC-Unique: 5z0YHHc-O7yDnKKbWtW6Kw-1
Received: by mail-wm1-f69.google.com with SMTP id j2-20020a05600c1c0200b003cf7397fc9bso7853503wms.5
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 01:30:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q81R0xjwZq+Uqwnnq1xIVaWYwdB8y5Gee+dkpFHuQEI=;
        b=2r5Uv8Tvvnri2Vhyb6Sj+gTwHj24tMTfSQV+vGNPBOVJQLg58DG8+X6x84QxxYL5vf
         kZvwGSsWblLP4slxCjNLyjH1kG0hIYr2ANYdOaguQl7q3tNvReBKfhB3YwI8cGiWLxh8
         H1YZ987HGiHvIRJDxu7K0c2eF/ebvvt3+VNfny8mCR/JY68Etk/+k0Ul+RNrkt7sZmtq
         Xkk4KXh2LyJEfznpS9q1DZNaQ8Y45iQks58mVCxbn/TF5m2n7hTCXkMTlsLzJwzHXpiI
         uU7YNlfykc9onltijbt7Kyr4HxohS38AhTNqEmCb1BxiMYCGfmW/0McmcDuzP+bip9xY
         HgXg==
X-Gm-Message-State: ACrzQf3/1j8Leua1NBbCceNL0Y0H1RgQxDtdLIemteONBD+3hIEOMxQk
        gtbwvb08OQdj0JgzFQG0lMV72qlqBCwV8noczX0VLoewvy+C/rnsc0sXpAh0GjMYPrmBKSd6c0b
        gWles1kqX+7ZBLYMl
X-Received: by 2002:a05:600c:48a7:b0:3cf:8025:c899 with SMTP id j39-20020a05600c48a700b003cf8025c899mr29896506wmp.26.1667986200745;
        Wed, 09 Nov 2022 01:30:00 -0800 (PST)
X-Google-Smtp-Source: AMsMyM65t7+LWnDL71R+3AhoHt5oj9qYOtk7HdQRv2DlwJcYLMkAaWkALyOAg1gZGKJPkzQQ4ug7qg==
X-Received: by 2002:a05:600c:48a7:b0:3cf:8025:c899 with SMTP id j39-20020a05600c48a700b003cf8025c899mr29896496wmp.26.1667986200542;
        Wed, 09 Nov 2022 01:30:00 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q189-20020a1c43c6000000b003cf483ee8e0sm975366wma.24.2022.11.09.01.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 01:30:00 -0800 (PST)
Message-ID: <85d7b64a-cdb0-d63b-ec4a-8d6920071fef@redhat.com>
Date:   Wed, 9 Nov 2022 10:29:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 7/8] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to
 assembly
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20221108151532.1377783-1-pbonzini@redhat.com>
 <20221108151532.1377783-8-pbonzini@redhat.com> <Y2r+/UYNeZ7ljYXC@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2r+/UYNeZ7ljYXC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/9/22 02:14, Sean Christopherson wrote:
>>
>> +.macro RESTORE_SPEC_CTRL_BODY
> 
> Can we split these into separate macros?  It's a bit more typing, but it's not
> immediately obvious that these are two independent chunks (I was expecting a JMP
> from the 800 section into the 900 section).
> 
> E.g. RESTORE_GUEST_SPEC_CTRL_BODY and RESTORE_HOST_SPEC_CTRL_BODY

Sure, I had it like that in an earlier version.  I didn't see much 
benefit but it is indeed a bit more readable if you order the macros like

.macro RESTORE_GUEST_SPEC_CTRL
.macro RESTORE_GUEST_SPEC_CTRL_BODY
.macro RESTORE_HOST_SPEC_CTRL
.macro RESTORE_HOST_SPEC_CTRL_BODY

>> +800:
>
> Ugh, the multiple users makes it somewhat ugly, but rather than arbitrary numbers,
> what about using named labels to make it easier to understand the branches?

I think it's okay if we separate the macros.

Paolo

