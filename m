Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D7F61FE39
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 20:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiKGTJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 14:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiKGTJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 14:09:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCFE29C98
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 11:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667848098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UgPw3Uycjo+aR/bhw4+iz5M1GwR3kladuKSag7k8jc4=;
        b=QBcMsXU5MQDSMBgbvsRTRUIa0wnKT0AXv5QPwoacpoPnfp7IifN5TSjFcXz7AJECrIsGKt
        kHmGEiNIM3ALkyPW015Gz6/lR/88eom/J8QXeCWcSerNGrvL+M8c0DD0YLNa4A2NF+XIG7
        2uuI2E+cqnz7BViNHSaWtinq4zwbKu0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-DKQ4B1MUM0O2qWDrYFd0OA-1; Mon, 07 Nov 2022 14:08:16 -0500
X-MC-Unique: DKQ4B1MUM0O2qWDrYFd0OA-1
Received: by mail-wr1-f70.google.com with SMTP id j20-20020adfb314000000b002366d9f67aaso3117827wrd.3
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 11:08:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UgPw3Uycjo+aR/bhw4+iz5M1GwR3kladuKSag7k8jc4=;
        b=MEUs7JGFQwYhNFiB5pF0ledrfVQ1DMi8jplt/keZjaEFxdEuH/Nv22MWH/tkf0GXHE
         GyKfIUsVFZHJowODdE0s+B0hhZI/lNExwI1o4Ak/BU7sWM9bdVVJAX0ze/jJDSGvnbRa
         FBh2+3o9PpG6p7piMgse0lmrgdlknt3+kXkuf/WqCdflbreMsdo/y8FTk1nS26kry+e8
         szd4A79LjXp/MCIIeEeKXg1HVq9T6vtMH9kIM9K9R+c7zBhH+2q+osnoKKjvv3DzfNxp
         yTzyCQTdrdjqJKl7gL/Tm4VVspRgN1DhhxDtq0AGP1fTujjLXVgjyNxAgJQFYWo80Ayu
         mJVg==
X-Gm-Message-State: ACrzQf1NbXLr2iJXz9eYvj/83hL9CSJE7Nfla+LR0jKB/B/t7W2TbjZm
        8xYjBlY3Glu+nvw++1F0EAsLcZOClt2fhSBB0cgos3pp5dGScjLfncrmp1bQLBn39FGVTM4D5x4
        rU7SbauTllkQYh+JC
X-Received: by 2002:a5d:6b8d:0:b0:236:6d5d:bcbc with SMTP id n13-20020a5d6b8d000000b002366d5dbcbcmr31895733wrx.628.1667848095601;
        Mon, 07 Nov 2022 11:08:15 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5uEy+QQUdEh5hqBzMvOocPm/27ctdAUc5YhvMrZPC9O/MgcORlg4SudmqMjNpy/SqW6eDWoQ==
X-Received: by 2002:a5d:6b8d:0:b0:236:6d5d:bcbc with SMTP id n13-20020a5d6b8d000000b002366d5dbcbcmr31895715wrx.628.1667848095364;
        Mon, 07 Nov 2022 11:08:15 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h7-20020a05600c314700b003a1980d55c4sm13023276wmo.47.2022.11.07.11.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 11:08:14 -0800 (PST)
Message-ID: <81f7dc5c-c45d-76fc-d9e8-4f3f65c29c12@redhat.com>
Date:   Mon, 7 Nov 2022 20:08:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org, seanjc@google.com,
        stable@vger.kernel.org
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-8-pbonzini@redhat.com>
 <CALMp9eRDehmWC1gZmSjxjwCvm4VXf_FnR-MiFkHxkTn4_DJ4aA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 7/8] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to
 assembly
In-Reply-To: <CALMp9eRDehmWC1gZmSjxjwCvm4VXf_FnR-MiFkHxkTn4_DJ4aA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 11/7/22 19:45, Jim Mattson wrote:
>> +.macro RESTORE_GUEST_SPEC_CTRL
>> +       /* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
>> +       ALTERNATIVE_2 "jmp 999f", \
>> +               "", X86_FEATURE_MSR_SPEC_CTRL, \
>> +               "jmp 999f", X86_FEATURE_V_SPEC_CTRL
>> +
>> +       /*
>> +        * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
>> +        * host's, write the MSR.
>> +        *
>> +        * IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
>> +        * there must not be any returns or indirect branches between this code
>> +        * and vmentry.
>> +        */
>> +       movl SVM_spec_ctrl(%_ASM_DI), %eax
>> +       cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
>> +       je 999f
>> +       mov $MSR_IA32_SPEC_CTRL, %ecx
>> +       xor %edx, %edx
>> +       wrmsr
>> +999:
>> +
>> +.endm
>> +
>> +.macro RESTORE_HOST_SPEC_CTRL
>> +       /* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
>> +       ALTERNATIVE_2 "jmp 999f", \
>> +               "", X86_FEATURE_MSR_SPEC_CTRL, \
>> +               "jmp 999f", X86_FEATURE_V_SPEC_CTRL
>> +
>> +       mov $MSR_IA32_SPEC_CTRL, %ecx
>> +
>> +       /*
>> +        * Load the value that the guest had written into MSR_IA32_SPEC_CTRL,
>> +        * if it was not intercepted during guest execution.
>> +        */
>> +       cmpb $0, (%_ASM_SP)
>> +       jnz 998f
>> +       rdmsr
>> +       movl %eax, SVM_spec_ctrl(%_ASM_DI)
>> +998:
>> +
>> +       /* Now restore the host value of the MSR if different from the guest's.  */
>> +       movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
>> +       cmp SVM_spec_ctrl(%_ASM_DI), %eax
>> +       je 999f
>> +       xor %edx, %edx
>> +       wrmsr
>> +999:
>> +
>> +.endm
>> +
>> +
> 
> It seems unfortunate to have the unconditional branches in the more
> common cases.

One way to do it could be something like

.macro RESTORE_HOST_SPEC_CTRL
        ALTERNATIVE_2 "", \
                "jmp 900f", X86_FEATURE_MSR_SPEC_CTRL, \
                "", X86_FEATURE_V_SPEC_CTRL \
901:
.endm

.macro RESTORE_SPEC_CTRL_BODY \
800:
	/* restore guest spec ctrl ... */
	jmp 801b

900:
	/* save guest spec ctrl + restore host ... */
	jmp 901b
.endm

The cmp/je pair can also jump back to 801b/901b.

What do you think?  I'll check if objtool is happy and if so include it 
in v2.

Paolo

