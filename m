Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567AD30A411
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 10:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhBAJKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 04:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbhBAJKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 04:10:06 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D68C061573;
        Mon,  1 Feb 2021 01:08:25 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id e15so12462373wme.0;
        Mon, 01 Feb 2021 01:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o5JnS33laQU6G5fECPGW2s6WllKBqXM6zsLrlBz79zQ=;
        b=gP2BmoVu0zeE4TgEq7ynuU4qsij3UO1rKLSY/4sPfg4SaNdsZWRRFEQf/ecgTbq7vE
         vd5+yCKwvg+n/vP/5G7MmroT+0c6BBOhWchc77GUeP5JZ0Bkc8uaRp109NArtlpMCCFu
         Zo1uqks0EXzBwKDdC++LyNsyLuxhaNxC/lznk5/LZmrmXfBaAZWuaeObVG97oB/EHOid
         mvxJWpsKg7gdNYf+GA5KK6bUQN4v4o2UXXpUqBPjpcUjBQ6017kNwop6w11kEC4NJcBe
         ++pmYz5IwHtF4QZyXR/i9OIO9mX//hDtXJdZw1sgcqeCbrrorQnJuAibDeaoi6yHMBhM
         dPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5JnS33laQU6G5fECPGW2s6WllKBqXM6zsLrlBz79zQ=;
        b=lxnNKLQLJ+qETA6acns/ThElOMBu5CH887E8GhzrIXCXsq6hH0fOR/TwMA2UFbyvzX
         7NZGWgo4wmjYXR4jONlwV0L3B7+iP+YVtHg16PGcUCjlFEtXvLPWYFv3Co5n0WRKBoYi
         L1voJMjnoH9UHqGJRhXxuNGsa6glAy6anV0JCkQktxaRNbZsV3sk+LMhdO5LBZj6iz+h
         xUN0KbqnW2Iy5sPiw1EHG8+XSyGYqEoZ+NBznvjDnhl27Uvxp7s58hzIEpY6IlMIXn07
         EgAwvbWV+WTJ9GOnGzfUhmZWXlCeWtfUFViIDkg79pACw/W5eQvnvFbYEJ82UQoGqPMe
         BLPg==
X-Gm-Message-State: AOAM5300GmFDRXSdSgev1SrNiNecQO8aEuNYD4iFkbbdaAf8BHP19Rla
        OEj2yYB7rKTnATGkqq7nW7AtjDTmfMaK4Q==
X-Google-Smtp-Source: ABdhPJy6/cmSRLPwon2z/9R2p2zZzCuxZPmybKgd4sNw0z52O7qFXNgW0Uzy9QX4MfBGuQ0FhPAM+A==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr4126589wmh.51.1612170503875;
        Mon, 01 Feb 2021 01:08:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id q24sm772398wmq.24.2021.02.01.01.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 01:08:23 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even
 if tsx=off
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
References: <20210129101912.1857809-1-pbonzini@redhat.com>
 <YBQ+peAEdX2h3tro@google.com>
 <37be5fb8-056f-8fba-3016-464634e069af@redhat.com>
Message-ID: <618c5513-5092-f7cd-b47b-933936001180@redhat.com>
Date:   Mon, 1 Feb 2021 10:08:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <37be5fb8-056f-8fba-3016-464634e069af@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/02/21 09:46, Paolo Bonzini wrote:
>>
>> This comment be updated to call out the new TSX_CTRL behavior.
>>
>>     /*
>>      * On TAA affected systems:
>>      *      - nothing to do if TSX is disabled on the host.
>>      *      - we emulate TSX_CTRL if present on the host.
>>      *      This lets the guest use VERW to clear CPU buffers.
>>      */
> 
> Ok.

Hmm, but the comment is even more accurate now than before, isn't it? 
It said nothing about hiding TSX_CTRL, so now it matches the code below.

Paolo
