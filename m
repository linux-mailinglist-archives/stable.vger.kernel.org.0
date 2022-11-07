Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE74C61F7DE
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiKGPl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiKGPl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:41:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076B11F63A
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667835628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0RG2qjH57v6es353SUCFI/Tv9kwI5E+OcxJV2Spp6Rc=;
        b=bv1m3mHfe7KYKlT2PLyX4Wn5WadEVll/s3G6Y/0R15VcgUN4K8l7tYATdXoefYKCvR93JX
        9Ooi89gVdqXnsVFnCgTDbhnoOLOrNvDEXMo2QJp1vl83MtBU0lb3CieAuL9dPLuJqDxnxA
        KXNr9a1eezNIl7efUSq7RD1v4WJAfpk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-116-s1eZiK5YOxGuOVm2gzoVAA-1; Mon, 07 Nov 2022 10:40:26 -0500
X-MC-Unique: s1eZiK5YOxGuOVm2gzoVAA-1
Received: by mail-wm1-f71.google.com with SMTP id az40-20020a05600c602800b003cfa26c40easo2284193wmb.1
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 07:40:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0RG2qjH57v6es353SUCFI/Tv9kwI5E+OcxJV2Spp6Rc=;
        b=olcOCOAUIcWj2o8EmWsxN73A7ie3Mc45INPIO0afZxLDf6MUIFgLUhDW9fmX603UoW
         +54DnR2o0vZbLMg4tNIfftdLc4SvxrX5eba23I4KAregzSZd3vXN4W0Be3aZz5OdHuw4
         ToN5pvbLn5Fzq0uUKM3ULy0vDu8WULUzjP/u+LulxeQGiQCMPuIxGIPqlTHdy3JNAiPR
         1BxzAZBH5VB4eBwwTCWf18SKQPSSMShkkGQo/CUlCK+hLatuiXuD3/q/yIzbZyG57jgy
         FqrrGs/FfjXG4aDP3OVDGhMEjWxIpcx6dBCiOZ+ldRMR7tYTxU5XGHhw8OsIMd+y4qDs
         +zoA==
X-Gm-Message-State: ACrzQf0UO2yP9oMAkkhGKHN9JnLGo/gidRyqIZZT4pOKJLML5eo+XvxZ
        nM6KcOX4SCLPFB/Kq+k6+T9ae/WRar5MvUZFYOPYo52ckIC9i249faSlMoOTH68JrwCtTQ6Oy+x
        jRhgcydO1K6g4a8p3
X-Received: by 2002:a05:6000:1a41:b0:22e:3667:d306 with SMTP id t1-20020a0560001a4100b0022e3667d306mr31781645wry.21.1667835625846;
        Mon, 07 Nov 2022 07:40:25 -0800 (PST)
X-Google-Smtp-Source: AMsMyM43CzSLo45txkBr/LR1HD0u4aQzeSZDSSshQoLseGKtmzaSgzMFWVPFWTNHLrm4+Jz2aV2pkw==
X-Received: by 2002:a05:6000:1a41:b0:22e:3667:d306 with SMTP id t1-20020a0560001a4100b0022e3667d306mr31781627wry.21.1667835625649;
        Mon, 07 Nov 2022 07:40:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t20-20020a05600c199400b003cf9bf5208esm10359646wmq.19.2022.11.07.07.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 07:40:24 -0800 (PST)
Message-ID: <4427cc5b-82fd-5656-da68-186b87dbe666@redhat.com>
Date:   Mon, 7 Nov 2022 16:40:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 4/8] KVM: SVM: move guest vmsave/vmload to assembly
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, jmattson@google.com, seanjc@google.com,
        stable@vger.kernel.org
References: <20221107145436.276079-1-pbonzini@redhat.com>
 <20221107145436.276079-5-pbonzini@redhat.com>
 <Y2ki4Iz8AZzTODKS@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y2ki4Iz8AZzTODKS@hirez.programming.kicks-ass.net>
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

On 11/7/22 16:23, Peter Zijlstra wrote:
>>   
>> +3:	vmrun %_ASM_AX
>> +4:
>> +	cli
>>   
>> +	/* Pop @svm to RAX while it's the only available register. */
>>   	pop %_ASM_AX
>>   
>>   	/* Save all guest registers.  */
> So Andrew noted that once the vmload has executed any exception taken
> (say at 3) will crash and burn because %gs is scribbled.
> 
> Might be good to make a record of this in the code so it can be cleaned
> up some day.
> 

Yeah, it won't happen because clgi/stgi blocks setting kvm_rebooting so 
I thought of killing the three exception fixups after the first.  In the 
end I kept them for simplicity and to keep the normal/SEV-ES versions as 
similar as possible.

Paolo

