Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69874396DAB
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 09:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFAHEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 03:04:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60236 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhFAHEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 03:04:20 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lnyQA-0001E6-A8
        for stable@vger.kernel.org; Tue, 01 Jun 2021 07:02:38 +0000
Received: by mail-wr1-f69.google.com with SMTP id z13-20020adfec8d0000b0290114cc6b21c4so4068062wrn.22
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 00:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+q0fy62bCiYCRQlgvzF96zfrYq5CGXYdLhzOWbFqVNY=;
        b=EloFravF+6tsqNlcurWuxX2Hj0+f0lvxej1J1as5+USvEM4J+vZmDBP2j23+uz1UeJ
         yYCVM0sJi73f3o1j3m9Cr0B28dHMFPFPFSgQYf4vkb3/EhGj8mCXaM+advip5FAr8AzV
         jx0Kg5D7XR/iqUeZpqgOrxScpd7ihCWO5pHMqjOBQ3WVdsSyRnf3EYhqWggUh+nkE+mS
         gcSC8uBonEmbAnuGVsZdgUHEqU7hSZQQt1KifrVOLgGL2zDIXCVjmyoY1YtkZtjPXKE2
         w1s/pqn3woYsiHsBkcXnvjRMCer+B8NMe3Bmx8om7Da9CngyJ2JBVyrvoFEnGFou6qT3
         OZhA==
X-Gm-Message-State: AOAM532iKxuPwXj2H+oZgLf8vVCJuXVGcR6T0zND8RimX1Vo48ksQ0At
        DrGzUgrfSWJpmYPw0/+kSN3xsGO+38PmDfk6BAydLA6Y4q2HwvTbsInraH9/S6R2IMm/R7O2F8f
        szqkUPjS18pYDlzc7exurBSC+9Abq0inriw==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr25441886wmh.130.1622530958003;
        Tue, 01 Jun 2021 00:02:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmcY8piuui2VEiNfEy/XL18hSp+/BRJa4F9fhlhp6UszoKa2ivePjd6BCx+K2mbKPlklGXsQ==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr25441872wmh.130.1622530957834;
        Tue, 01 Jun 2021 00:02:37 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id v8sm2269728wrc.29.2021.06.01.00.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 00:02:37 -0700 (PDT)
Subject: Re: [PATCH v3 | stable v5.10 0/3] x86/kvm: fixes for hibernation
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210531140526.42932-1-krzysztof.kozlowski@canonical.com>
 <YLXWWWG7Ut7p3SPE@kroah.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <beba6f04-490d-30e4-4fb5-984d6441c249@canonical.com>
Date:   Tue, 1 Jun 2021 09:02:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YLXWWWG7Ut7p3SPE@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/06/2021 08:40, Greg KH wrote:
> On Mon, May 31, 2021 at 04:05:23PM +0200, Krzysztof Kozlowski wrote:
>> Hi,
>>
>> This is version 2 of a backport for v5.10.
>>
>> Changes since v2:
>> 1. Rebased v3 of v5.4 version, I kept numbering to be consistent.
>> 2. The context in patch 1/3 had to be adjusted.
> 
> I also need a 5.12.y version of this series before I can apply these to
> older kernel releases.

The cherry-pick from v5.10 would work although apply might fail due to
context difference. I'll sent shortly a v5.12 port.


Best regards,
Krzysztof
