Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A177339F5A
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 18:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhCMRJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 12:09:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43336 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbhCMRJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 12:09:15 -0500
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lL7lK-0000m6-1q
        for stable@vger.kernel.org; Sat, 13 Mar 2021 17:09:14 +0000
Received: by mail-wm1-f71.google.com with SMTP id n2so6671734wmi.2
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 09:09:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3qTfJlodacsURNs3YKBF5eAxs7WNf+IklwzHAjJUXEM=;
        b=gPIJ3+LpBv3IguqOwP3d895oDb3D7ytuCqAynQ/GKvSkJWq7zqm2bCtW/0jIG4sav3
         NvIlBxPvMAEO0+gt/UCMo1AiljFlsZGeufpIi6M4o9yCJnL1HbQo9uxaIGNFfsotFYkX
         +O3fA+mWIskvh72evjQVj7HKmIRhFmTw/f4kqCCSmGt+ICHsW7G+OmuVOyrrGwqO8FLm
         FQVdxpkEZCnhmNZGQqnR/DLSUlkP7QqwlALyQshRRuP/LAwgQBV+G5csUONef+e289MR
         Ef05qTNNI1t2xBhDKGOlF7PjcA6j/96zf/P77+fYXa+Qsi1ZyuK2OyonCWCyFQTJsZjO
         PjZg==
X-Gm-Message-State: AOAM532kqtQiaYpb1CkiDS0qwvnsz3M+/2A7D58wREgr+cWr8Fg/v1en
        MvBB7OiZwdu8X1ivfPp4T40Ar7Q0TFw7EJ6H+0Un3GaP36EEWkTTUJrQ8+7fhBUDuQRSEIJgw53
        hXtMAhbEHs3/wqHw0it40ATCF2AqYmxQBYg==
X-Received: by 2002:a7b:c04c:: with SMTP id u12mr18760896wmc.9.1615655353410;
        Sat, 13 Mar 2021 09:09:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkL0mf4bQ7o8l+wPpM8fKVuEK41BuL8u2WBZiiBvOrYkT9cipYzRB/2QFUy8/fIJMU5InHLw==
X-Received: by 2002:a7b:c04c:: with SMTP id u12mr18760887wmc.9.1615655353291;
        Sat, 13 Mar 2021 09:09:13 -0800 (PST)
Received: from [192.168.1.116] (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id r11sm12623828wrx.37.2021.03.13.09.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 09:09:12 -0800 (PST)
Subject: Re: [PATCH stable v4.4] iio: imu: adis16400: fix memory leak
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
References: <20210312170311.17464-1-krzysztof.kozlowski@canonical.com>
 <YEy//r+IqxvR/tbu@kroah.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <ba7c64bc-9aae-5de5-6666-786553201d37@canonical.com>
Date:   Sat, 13 Mar 2021 18:09:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YEy//r+IqxvR/tbu@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/03/2021 14:37, Greg KH wrote:
> On Fri, Mar 12, 2021 at 06:03:11PM +0100, Krzysztof Kozlowski wrote:
>> From: Navid Emamdoost <navid.emamdoost@gmail.com>
>>
>> commit 9c0530e898f384c5d279bfcebd8bb17af1105873 upstream.
>>
>> In adis_update_scan_mode_burst, if adis->buffer allocation fails release
>> the adis->xfer.
>>
>> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
>> Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
>> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> (cherry picked from commit 9c0530e898f384c5d279bfcebd8bb17af1105873)
>> [krzk: backport applied to adis16400_buffer.c instead of adis_buffer.c]
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>>  drivers/iio/imu/adis16400_buffer.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> What about 4.9.y?  Will this backport also work there too?

Yes, v4.4 and v4.9. However I noticed that second patch similar patch
was not backported, so let me send v2 of this backport.

Best regards,
Krzysztof
