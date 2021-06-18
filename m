Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA833AC6AE
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 10:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFRJCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 05:02:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48106 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhFRJCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 05:02:01 -0400
Received: from mail-ed1-f71.google.com ([209.85.208.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1luALv-0001FL-PS
        for stable@vger.kernel.org; Fri, 18 Jun 2021 08:59:51 +0000
Received: by mail-ed1-f71.google.com with SMTP id f12-20020a056402150cb029038fdcfb6ea2so1363586edw.14
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 01:59:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PEcc2XLwF7gLUJu71YgacFESmL81dpTQvc0XnJ0Z794=;
        b=OEhhrcfy4QHlfe7Q+BNAXszOha2YXR203vXneUM5oieu04KgrQVbiBTKHqx2ry1wO9
         +WbtU/yoCIUz0loyZkNOzuBG6tMaCXUEfE1NekUmvrKLk7J38aAfuopRcS6wCedpU5gm
         s1oJ8T29yJD939CmZB205X7+qKdKIz0tQVu5BhCTKsUxHxVK8riBHIPifzeEmU3rgtrh
         lRaMLsZ++p3ehxWRSgutOdD5dFwcEsBw1JswHg+B2UBzZUy4WD1WREW45gkmZjGfKMo5
         U5Os1nZDW/z7YAyqZH5xpp+duvFO6iVCtUiHzS81A7o3luLERIBYS+cCN0irt+yrBVEt
         Yw/w==
X-Gm-Message-State: AOAM5314bf7+GOKVO79472fTXQZGxVZmZXNso5gD++u/t3uv59oOktrR
        bt/4Nt0BcpI8VpERG1vIHa4/tIToMi9/XWLvc/nO7mVrYsZCVeV8xSUpTn4RGVua8Z4zRFpYpSj
        5MqCI9yRF6Ynp1tca/3zmOZ+QEMl7DtcksA==
X-Received: by 2002:a05:6402:18f6:: with SMTP id x54mr3654891edy.53.1624006791575;
        Fri, 18 Jun 2021 01:59:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMQ0H4LDz9fog0E8p/D6NA/qzZNLkPqQI/pYPUCukC7/7rPKA6YEBSYoQrWiaPFZY5N9RtTQ==
X-Received: by 2002:a05:6402:18f6:: with SMTP id x54mr3654881edy.53.1624006791433;
        Fri, 18 Jun 2021 01:59:51 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id y20sm5737732edq.69.2021.06.18.01.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 01:59:50 -0700 (PDT)
Subject: Re: [PATCH 5.4 031/184] modules: inherit TAINT_PROPRIETARY_MODULE
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, Jessica Yu <jeyu@kernel.org>
References: <20210510101950.200777181@linuxfoundation.org>
 <20210510101951.249384110@linuxfoundation.org>
 <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
Message-ID: <08a2e600-74cf-dbf8-1ecc-777ff65e06b0@canonical.com>
Date:   Fri, 18 Jun 2021 10:59:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8edc6f45-6c42-19c7-6f40-6f1a49cc685b@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/06/2021 10:57, Krzysztof Kozlowski wrote:
> On 10/05/2021 12:18, Greg Kroah-Hartman wrote:
>> From: Christoph Hellwig <hch@lst.de>
>>
>> commit 262e6ae7081df304fc625cf368d5c2cbba2bb991 upstream.
>>
>> If a TAINT_PROPRIETARY_MODULE exports symbol, inherit the taint flag
>> for all modules importing these symbols, and don't allow loading
>> symbols from TAINT_PROPRIETARY_MODULE modules if the module previously
>> imported gplonly symbols.  Add a anti-circumvention devices so people
>> don't accidentally get themselves into trouble this way.
>>
>> Comment from Greg:
>>   "Ah, the proven-to-be-illegal "GPL Condom" defense :)"
> 
> Patch got in to stable, so my comments are quite late, but can someone
> explain me - how this is a stable material? What specific, real bug that
> bothers people, is being fixed here? Or maybe it fixes serious issue
> reported by a user of distribution kernel? IOW, how does this match
> stable kernel rules at all?
> 
> For sure it breaks some out-of-tree modules already present and used by
> customers of downstream stable kernels. Therefore I wonder what is the
> bug fixed here, so the breakage and annoyance of stable users is justified.

And for the record I am not talking about this patch only. I am asking
also what serious or real bug is being fixed by:
"modules: mark find_symbol static
find_symbol is only used in module.c."

I would be really happy to extend my knowledge about real bugs faced by
people, where the fix is to un-export unused symbol. It must have been
very interesting, real bug bothering people. :)


Best regards,
Krzysztof
