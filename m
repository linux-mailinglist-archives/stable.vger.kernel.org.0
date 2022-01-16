Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A7748FA23
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 02:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiAPBXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 20:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiAPBXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 20:23:00 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E4AC061574;
        Sat, 15 Jan 2022 17:23:00 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n11so14618978plf.4;
        Sat, 15 Jan 2022 17:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ncy8jeX0mJQyLf9jFUXaIhuo8aI5C6k7Kmj45FMlceA=;
        b=I9izczAcgmK8ke/z8RzxQ4elEJgRAOSZwOwJoBkzW8WY6NjqCMmgrN0bQ5Z/53qh0N
         PdTsaMa/vcLdBZxuGo92UkLJnYACMe3WEWI/CP9Emql24SFLQO1qZRXYJ4k5nk+EKqzw
         OaaaM9m5ixcCHwGs5DqvDqgqbZFHk84c7gbYWIJVffI4JudrxX9WNRjInYinfn5Dn1nQ
         Vhm4Fer7YJlxMjT9bALjCbKBg7iX0ynC5RQ47tWHTdxQlusEnME0gum5/I1/ZSLyp+Yv
         wdeQZauWK0aRNQ9ut1aXG9sVoEaSFkawOYkvR/Ca2B4eBKBpD6LlDXURg+GArYkbtlHF
         o+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ncy8jeX0mJQyLf9jFUXaIhuo8aI5C6k7Kmj45FMlceA=;
        b=pU3PpfKCRCdRt2r7h/hUxk69TYYXQ8ea0PNS9d0Ip42yCOf3o3GITPCAtnaB2sVbx/
         xM6Ijoi8fJeSG6Mwz85ImG6eBwD7mBzVQnR4t2H+qwaoHE5Vx46eRyUWkuHKr/bLvhaM
         zaslOvW3YyOPj701HUG2g9lEQOhV1PXmoZG44Ffzzz82Pu8Nce1l0pvHYvRkgbkORJf+
         3gTdwAtLxhSxEwG9o5R9Apiz/kT1UvIXOG7DTecT5N6jGE2tYa+M/PO5ZZEHUSkL8H/C
         SMJnUwAC35Z1etdNgRTk2xpNJcNw8LJ/FmDjCGRA6vzz9qEgYlYD0sJVToAVUda1H3a2
         cpgQ==
X-Gm-Message-State: AOAM533tBfCnhI7XTEACNdDEND4cv/mS7EoXvK6N7AcZUgPa2HTpFs4D
        hltqjHt0pOxk/j/Z+2NM5Io=
X-Google-Smtp-Source: ABdhPJz0JzAXI4UU2jF6zqa8MdDXReRvFSUj0Vwn9s02eCX59KGEa0is9kYANeoohHdQIc6j3TeRQQ==
X-Received: by 2002:a17:902:c283:b0:14a:1cfe:fc46 with SMTP id i3-20020a170902c28300b0014a1cfefc46mr16113995pld.99.1642296179891;
        Sat, 15 Jan 2022 17:22:59 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id j18sm7861116pgi.78.2022.01.15.17.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Jan 2022 17:22:59 -0800 (PST)
Message-ID: <7a94d9a3-729a-817a-d2bc-143c25a2a5d4@gmail.com>
Date:   Sat, 15 Jan 2022 17:22:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 1/2] tpm: Fix error handling in async work
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        stefanb@linux.ibm.com
References: <20220111055228.1830-1-tstruk@gmail.com> <Yd8fY/wixkXhXEFH@iki.fi>
 <3c2eeee7-0d3e-8000-67ad-3054f229cbe0@linaro.org> <YeHmB0BWgfVGPL55@iki.fi>
 <YeHnTlK+QCZiUyOL@iki.fi>
From:   Tadeusz Struk <tstruk@gmail.com>
In-Reply-To: <YeHnTlK+QCZiUyOL@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/22 13:12, Jarkko Sakkinen wrote:
>> Please send new versions, there's also this:
>>
>> def test_flush_invlid_context()
>>
>> I'd figure "invlid" should be  "invalid"
>>
>> You can add, as these changes do not change the semantics of the
>> patches:
>>
>> Tested-by: Jarkko Sakkinen<jarkko@kernel.org>
>>
>> It's always best if you author the final version, as then a clear
>> reference on what was accepted exist at lore.kernel.org.
> Maybe it is good to mention that the test environment was libvirt hosted
> QEMU using swtpm, which I tried for the first time, instead of real hadware
> (libvirt has a nice property that it handles the startup/shutdown of
> swtpm). I managed to run all tests so I guess swtpm is working properly.

Yes, I have been using it all the time for testing since the support was
added to qemu. New versions on their way.

Thanks,
Tadeusz
