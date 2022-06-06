Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5148453E93C
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241486AbiFFQSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 12:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241527AbiFFQSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 12:18:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2743D1B9A62
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 09:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654532297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J0ZUO9BPOkOuAPGkk2Pz+5mNS4xSTxe1mTSmQ0cCQME=;
        b=UKJ2Hra25ZF7JaO5jL8S5adyYY/m9GDeZoQjQgNCD0w2HweancjPwNaOAhrOhx3Mo3m4rB
        Q2FOi6v+9syVmYOVlVOwj8LFgIum4LQadBrqhLYD/AqnPar1/9ROB7q4AojTVYMyfjHNyE
        c21iHjOMIYp1ZdADLUxTYpvTj68TRAk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-WE3Lnv1WMweCHJN0XRTjQQ-1; Mon, 06 Jun 2022 12:18:16 -0400
X-MC-Unique: WE3Lnv1WMweCHJN0XRTjQQ-1
Received: by mail-wm1-f72.google.com with SMTP id m19-20020a05600c4f5300b003974eba88c0so7890138wmq.9
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 09:18:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J0ZUO9BPOkOuAPGkk2Pz+5mNS4xSTxe1mTSmQ0cCQME=;
        b=rcdQmHCdIYA4JbnyToRmFaE7aVWoO0WrAcdb6bGjVLnfDusBV4zW3BGmVGtTEq7E3T
         aRNyW7nSjbM67su/A8PfZsLWeL9MB2LCypITxZ/P1k0U8gfqx/jxNBZx3vTLnR6zNhIE
         IUI8KAEIFmQn3hmMUHmLXYoXGONp7czQtBBiMz9FxtGYCdzfhSb2/J19kLmhgEQ56HZB
         coGREGbMtnbqGfJ+9ll9uJULqltJesYm+MRC/0CnRXRugGTjf+Nyp1hwotJjAsxqwHec
         WpS65m44PvM7Uh/epZfGFyWrbcJg5LdMpQWDmSwKvNnFPpnZlAW90J6HZ4HFm9/fGlJi
         iCyQ==
X-Gm-Message-State: AOAM531Qc8YSTNKYWeTlpZBa4QKIn6uh6MbO1Bhq2r7FYZh45fWjJPCt
        ob/b93jv5PYIAy/sS/Z0mAWZOPuSiTdPg5FGmnDy8at5jw9SoJcBObpkDTX3oqG/hfTxitLV2jx
        4EE8FdULX8BBjUwAs
X-Received: by 2002:a7b:c012:0:b0:39c:529a:7590 with SMTP id c18-20020a7bc012000000b0039c529a7590mr4431369wmb.6.1654532295408;
        Mon, 06 Jun 2022 09:18:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytGjRc+3NcIpfrqSv+o2Yaf/0WsZqKDYGxK8IxZRkKuhEAHyljhV2LtSwvga+jXqWkWBYJuw==
X-Received: by 2002:a7b:c012:0:b0:39c:529a:7590 with SMTP id c18-20020a7bc012000000b0039c529a7590mr4431330wmb.6.1654532295117;
        Mon, 06 Jun 2022 09:18:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id u12-20020a05600c210c00b003942a244f39sm15167933wml.18.2022.06.06.09.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 09:18:14 -0700 (PDT)
Message-ID: <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
Date:   Mon, 6 Jun 2022 18:18:12 +0200
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YppVupW+IWsm7Osr@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/3/22 20:40, Peter Xu wrote:
> I'm not really sure whether this is a bug or by design - do we require this
> patch to be applied to all stable branches to make the guest not crash
> after migration, or it is unexpected?

Yes, we do, though the only reported bug was for PKRU.

> However there seems to be something missing at least to me, on why it'll
> fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
> In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
> patch, but 0x0 if with it.

What CPU model are you using for the VM?  For example, if the source 
lacks this patch but the destination has it, the source will transmit 
YMM registers, but the destination will fail to set them if they are not 
available for the selected CPU model.

See the commit message: "As a bonus, it will also fail if userspace 
tries to set fpu features (with the KVM_SET_XSAVE ioctl) that are not 
compatible to the guest configuration.  Such features will never be 
returned by KVM_GET_XSAVE or KVM_GET_XSAVE2."

Paolo

