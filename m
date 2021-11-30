Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FB3462E88
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbhK3Ie1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbhK3Ie1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 03:34:27 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959B5C061574;
        Tue, 30 Nov 2021 00:31:08 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x6so83070611edr.5;
        Tue, 30 Nov 2021 00:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wxEHzupmidTEPgkCq0lyqX6XmQoNOKfn2zdyBePEV3w=;
        b=nVNP/d+VJy9HkHn4ALSxPEY6Jt24QCJDF9cRZMgtUShFjdELQPnHHGSOy1Op4XfmVO
         yRsOV3kuYdZxIW/wkb9TB5L/TuEsWOTw34XD95PBGzzuPzg88ure/ZGYdKB0gb2vF/HU
         6aKkBvYa6J+9FTXlnUUzYmU0zYXCxiUD++5bdiyHYeF7S9cJXzp5ALYBSbUp6KtNlyby
         QWpcfX/kj6RSGmGwa1ZrEN43tyVFsyKbLiHFtX1cMcHl3n4k8Ttf2wsyX9yRjClBRIyB
         sv4lgpKukNTnf2UAKdD+NT6oyGdHDxmYH1PP1U+cH7RhrINT28/CtWAEopGp6iMwOyNg
         jUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wxEHzupmidTEPgkCq0lyqX6XmQoNOKfn2zdyBePEV3w=;
        b=s48mEwruAL3CDNwxPx2pP3WV/SzkYBfJr/VYAN7G6dxZ92MMIb3iekSlmHKQjxqAxW
         PbcKNBhGd0pekoFlPi7LGGq6Qq8di+z8MJkm9BkQDdy81mgRwG0ikHuNP5GoJgRa+6bB
         acEQNmW1evmSUKKcSoYl3cd8ggiASTxtRcF2eeBOyiIkmUFWLLkwJMsfqfn/OiDnyW0M
         26GUgTfbT1XkzylbKNPPJjvI4hCq5UvUi35OQYH+v4uY7TYAo4vkJ5T4VdawhL0XDwGl
         xJt/CmUBU5WhknfZC+Xq09WOLa+gKeRo8BREwdXSAF9QcwNdQsXR9Dgaujqk6yUVbU3A
         1gZA==
X-Gm-Message-State: AOAM53136RPfrLPkJ1m5qvRL2tLLD24Pw8QI8iUARxs+ALcJZo8E2Ir/
        3dP5oNMbP4DBqHlFPRsRx6E=
X-Google-Smtp-Source: ABdhPJxDiKVFmsDhFkc6OefndA3xVl2/OwtTOSFwjgQ7oEy0ZOFPKWGGpEtVCOqcBzQD73I4jZCfFw==
X-Received: by 2002:a17:907:9723:: with SMTP id jg35mr69475749ejc.329.1638261067118;
        Tue, 30 Nov 2021 00:31:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id de37sm8500815ejc.60.2021.11.30.00.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 00:31:06 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <64c3e26a-1f58-c121-3a42-38e70fb6f77e@redhat.com>
Date:   Tue, 30 Nov 2021 09:31:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/4] KVM: VMX: prepare sync_pir_to_irr for running with
 APICv disabled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20211123004311.2954158-1-pbonzini@redhat.com>
 <20211123004311.2954158-3-pbonzini@redhat.com> <YaVQxZ42Ve6JNIzt@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YaVQxZ42Ve6JNIzt@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/21 23:14, Sean Christopherson wrote:
> Heh, maybe s/max_irr_updated/new_pir_found or so?  This is a bit weird:
> 
>    1. Update max_irr
>    2. max_irr_updated = false

Sounds good (I went for got_posted_interrupt).

>>   	}
>> -	vmx_hwapic_irr_update(vcpu, max_irr);
>> +
>> +	/*
>> +	 * If virtual interrupt delivery is not in use, the interrupt
>> +	 * will be processed via KVM_REQ_EVENT, not RVI.  This can happen
> 
> I'd strongly prefer to phrase this as a command, e.g. "process the interrupt via
> KVM_REQ_EVENT".  "will be processed" makes it sound like some other flow is
> handling the event, which confused me.

What I wanted to convey is that the interrupt is not processed yet, and 
the vmentry might have to be canceled.  I changed it to

          * Newly recognized interrupts are injected via either virtual 
interrupt
          * delivery (RVI) or KVM_REQ_EVENT.  Virtual interrupt delivery is
          * disabled in two cases:

> 	 * 1) If L2 is running and the vCPU has a new pending interrupt.  If L1
> 	 * wants to exit on interrupts, KVM_REQ_EVENT is needed to synthesize a
> 	 * VM-Exit to L1.  If L1 doesn't want to exit, the interrupt is injected
> 	 * into L2, but KVM doesn't use virtual interrupt delivery to inject
> 	 * interrupts into L2, and so KVM_REQ_EVENT is again needed.
> 	 *
> 	 * 2) If APICv is disabled for this vCPU, assigned devices may still
> 	 * attempt to post interrupts.  The posted interrupt vector will cause
> 	 * a VM-Exit and the subsequent entry will call sync_pir_to_irr.
> 	 */

Applied these.

Paolo
