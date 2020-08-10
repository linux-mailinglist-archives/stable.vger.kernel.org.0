Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA6C2410C1
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgHJTc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgHJTJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 15:09:49 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91152C061756
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 12:09:48 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id u24so9898194oiv.7
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 12:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vRzdrafv/FNOSfYeomOTItS2BwVVTrTYSwyncaMq87A=;
        b=Fu5OgTjWhcoGoXlt2yWElgYtA1Ji8hUuug6RaeiIMnyrazW6Bl/v5mj7k9MePXssxY
         w2gYGPeYFDTWZZlHVeyoi9x9LgdGLA+pdlga36Le3rscb4aA35KJizchz3a0nTd46+LP
         RUR4N3qh41M6U66vEga4nfPqvO4hV1z0ZV+OU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vRzdrafv/FNOSfYeomOTItS2BwVVTrTYSwyncaMq87A=;
        b=Z57tKTO3b4H8vOkJgPWWYa4BKrsNGcSt81QQElUyjZuyWSJwDuWDw3AVvPgVUFmD/Y
         wjlJXwTsdpCl1z9KdIdX4kOaelhocEVpvRuV/oivVJUfyeRvN6aLcxFO/EY5l8gM7yQE
         hozFz4aUdZkAynGd9cc2q7ovDxEDxmoL8DMGLgx9Oq+482LtGWE0OhsMRE3N9IlevSzm
         aamaMqu31mstnyCu0o879rcYFpZ2N6HX4bmWgNpxwt4md/b98eCXlX6kXQfxwb6NXkNH
         Lz2t1KMIkPQrbsweLGboPkHVMI1vRQFx8uh/rrsYxUAt3xpoWM6L525Cxr7G6RasWNqy
         mLcg==
X-Gm-Message-State: AOAM532ljFBQuqtEfjDn+YSpXh2EtS2GcqERc/zNRKpd2Z9TMh6C6gqE
        v7eDB00Mxu7rjxw5n/F2BTqccg==
X-Google-Smtp-Source: ABdhPJxknNG5tuqNi56LuzgZJEuj/QlI273m9hV+b5kpEgHMrrXN2rV/QXGecqi01dkP0VcdFN3bNA==
X-Received: by 2002:aca:130f:: with SMTP id e15mr564195oii.173.1597086587361;
        Mon, 10 Aug 2020 12:09:47 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x5sm3763811oop.4.2020.08.10.12.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 12:09:46 -0700 (PDT)
Subject: Re: [PATCH] usbip: Implement a match function to fix usbip
To:     Bastien Nocera <hadess@hadess.net>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200810160017.46002-1-m.v.b@runbox.com>
 <6e450e16117afb9e1dd1e4270ef5c2e0d5885348.camel@hadess.net>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a7351706-9933-a3e1-4e7d-b7ab6f289938@linuxfoundation.org>
Date:   Mon, 10 Aug 2020 13:09:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6e450e16117afb9e1dd1e4270ef5c2e0d5885348.camel@hadess.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 11:31 AM, Bastien Nocera wrote:
> On Mon, 2020-08-10 at 19:00 +0300, M. Vefa Bicakci wrote:
>> Commit 88b7381a939d ("USB: Select better matching USB drivers when
>> available") introduced the use of a "match" function to select a
>> non-generic/better driver for a particular USB device. This
>> unfortunately breaks the operation of usbip in general, as reported
>> in
>> the kernel bugzilla with bug 208267 (linked below).
>>
>> Upon inspecting the aforementioned commit, one can observe that the
>> original code in the usb_device_match function used to return 1
>> unconditionally, but the aforementioned commit makes the
>> usb_device_match
>> function use identifier tables and "match" virtual functions, if
>> either of
>> them are available.
>>
>> Hence, this commit implements a match function for usbip that
>> unconditionally returns true to ensure that usbip is functional
>> again.
>>
>> This change has been verified to restore usbip functionality, with a
>> v5.7.y kernel on an up-to-date version of Qubes OS 4.0, which uses
>> usbip to redirect USB devices between VMs.
>>
>> Thanks to Jonathan Dieter for the effort in bisecting this issue down
>> to the aforementioned commit.
> 
> Looks correct. Thanks for root causing the problem.
> 
> Reviewed-by: Bastien Nocera <hadess@hadess.net>
> 

Thank you for finding and fixing the problem.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
