Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29CF30ED4C
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 08:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhBDH0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 02:26:54 -0500
Received: from mail-ed1-f52.google.com ([209.85.208.52]:33283 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhBDH0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 02:26:48 -0500
Received: by mail-ed1-f52.google.com with SMTP id c6so2921767ede.0;
        Wed, 03 Feb 2021 23:26:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5JXi3qUTShiqu7hOOg9BcbA80yUhHZFbxpF9TtPgue0=;
        b=MHNt1QlbxGX5V5DSrrQeohhQlHYQeo/33gw2qUbPxhZew+zhkRechLsR3H51QPuNUW
         kU0L0AxmcYUPXBmEWhZPK2EwGIcOIvEaGY/JC3+wu3h+wjsC33J+17BtbzBxQKk3z3YM
         yLIDdUosiabs5UVP68wE36BLKVu9D8abS9tiYiNZm5EnTTcT557TyZXlEkpuiCPbgl4d
         MAX1ZFOiB20DurflEjPRyac0xEm38Gh/MJnxLfSF9h3w/VvzohRIYxqGVg1w0L0a+ESo
         W5/r1Hlh3ooxYXtRhWSsEKPoyq9tipeK/pQ9iI/kmIgXKVl8Zhi6up/IOdmhilgxhoDC
         tcOw==
X-Gm-Message-State: AOAM532urPL0PcSHRl+BFthYGnr8LSbLZVqh0FS+TN6nNAAkeXY/ptPN
        8WaaJ/3vIcvg2Os5aov6Qrr4oGt2iNsa0g==
X-Google-Smtp-Source: ABdhPJxzdKi4EdOCPXd9PaII9gqrObwpwvSCLS46hFvk6RZAM3/yhKkAmBjgIvKpzORIriB1qSdlbQ==
X-Received: by 2002:a50:acc1:: with SMTP id x59mr6663900edc.43.1612423566484;
        Wed, 03 Feb 2021 23:26:06 -0800 (PST)
Received: from ?IPv6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id a25sm1975240eds.48.2021.02.03.23.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 23:26:05 -0800 (PST)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jari Ruusu <jariruusu@protonmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        masahiroy@kernel.org
References: <7pR0YCctzN9phpuEChlL7_SS6auHOM80bZBcGBTZPuMkc6XjKw7HUXf9vZUPi-IaV2gTtsRVXgywQbja8xpzjGRDGWJsVYSGQN5sNuX1yaQ=@protonmail.com>
 <YBuSJqIG+AeqDuMl@kroah.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Subject: Re: Kernel version numbers after 4.9.255 and 4.4.255
Message-ID: <78ada91b-21ee-563f-9f75-3cbaeffafad4@kernel.org>
Date:   Thu, 4 Feb 2021 08:26:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBuSJqIG+AeqDuMl@kroah.com>
Content-Type:   text/plain; charset=US-ASCII;
        format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04. 02. 21, 7:20, Greg Kroah-Hartman wrote:
> On Thu, Feb 04, 2021 at 05:59:42AM +0000, Jari Ruusu wrote:
>> Greg,
>> I hope that your linux kernel release scripts are
>> implemented in a way that understands that PATCHLEVEL= and
>> SUBLEVEL= numbers in top-level linux Makefile are encoded
>> as 8-bit numbers for LINUX_VERSION_CODE and
>> KERNEL_VERSION() macros, and must stay in range 0...255.
>> These 8-bit limits are hardcoded in both kernel source and
>> userspace ABI.
>>
>> After 4.9.255 and 4.4.255, your scripts should be
>> incrementing a number in EXTRAVERSION= in top-level
>> linux Makefile.
> 
> Should already be fixed in linux-next, right?

I assume you mean:
commit 537896fabed11f8d9788886d1aacdb977213c7b3
Author: Sasha Levin <sashal@kernel.org>
Date:   Mon Jan 18 14:54:53 2021 -0500

     kbuild: give the SUBLEVEL more room in KERNEL_VERSION

That would IMO break userspace as definition of kernel version has 
changed. And that one is UAPI/ABI (see 
include/generated/uapi/linux/version.h) as Jari writes. For example will 
glibc still work:
http://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/configure.ac;h=13abda0a51484c5951ffc6d718aa36b72f3a9429;hb=HEAD#l14

? Or gcc 10 (11 will have this differently):
https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/bpf/bpf.c;hb=ee5c3db6c5b2c3332912fb4c9cfa2864569ebd9a#l165

and

https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/bpf/bpf-helpers.h;hb=ee5c3db6c5b2c3332912fb4c9cfa2864569ebd9a#l53

It might work somewhere, but there are a lot of (X * 65536 + Y * 256 + 
Z) assumptions all around the world. So this doesn't look like a good idea.

thanks,
-- 
js
suse labs
