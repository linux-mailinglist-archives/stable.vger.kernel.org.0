Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809C5115512
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 17:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfLFQYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 11:24:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbfLFQYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 11:24:00 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 977C520659;
        Fri,  6 Dec 2019 16:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575649439;
        bh=F9OTDyXwrGShhha34PK6U8wuxLV81Kw3Kz0btZvBz6c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Jou6FGmHqPVqcqnO2VJmeqnwycT8hsakmYNCGMZfr2CqTCqAUEBNTxKw3VMk4k4ff
         qrcSONAFYYFOJ9VkhwlE9gl+0pEDfPIY/0bJhNkRaAv4VuUeyz2PhAzvXaKmz2Qlyc
         FKzv7KlmwZiouw7Jb2RjyV9ll/5zuO2ouf3F8wxs=
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20191204175321.609072813@linuxfoundation.org>
 <1dac10cd-7183-9dfd-204c-05fae75bcd74@kernel.org>
 <20191206152823.GA75339@kroah.com>
 <785c9534-1eb2-ea9b-8c9b-6713fdefdd01@kernel.org>
 <e04a233b-0854-2dd4-060e-47e1013879ee@roeck-us.net>
From:   shuah <shuah@kernel.org>
Message-ID: <f7e72654-42a6-864a-4b4c-41adcce74404@kernel.org>
Date:   Fri, 6 Dec 2019 09:23:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <e04a233b-0854-2dd4-060e-47e1013879ee@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/19 9:10 AM, Guenter Roeck wrote:
> On 12/6/19 7:35 AM, shuah wrote:
>> On 12/6/19 8:28 AM, Greg Kroah-Hartman wrote:
>>> On Fri, Dec 06, 2019 at 08:24:36AM -0700, shuah wrote:
>>>> On 12/4/19 10:53 AM, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 4.14.158 release.
>>>>> There are 209 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, 
>>>>> please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz 
>>>>>
>>>>> or in the git tree and branch at:
>>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>>>>> linux-4.14.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>
>>>> Starting with Linux 4.14.157, 4.9.204, and 4.4.204 stables stopped
>>>> booting on my system. It can't find the root disk. No config changes
>>>> in between.
>>>>
>>>> I have been bisecting 4.14 and 4.9 with no luck so far. I updated
>>>> to Ubuntu 19.10 in between.
>>>>
>>>> The only other thing I see is CONFIG_GCC_VERSION which is supported
>>>> starting 4.18. I don't this boot failing issue on 4.19 + up. I am
>>>> also chasing any links between this config and scripts and tools
>>>> that generate the initramfs.
>>>
>>> Did you also upgrade your version of gcc?  I know I build those older
>>> kernels with the latest version of gcc for build tests, but I do not
>>> boot them.  I think everyone who still uses them uses older versions of
>>> gcc.
>>
>> Yes. gcc version changed. That has been my strong suspect since I 
>> started poking around the CONFIG_GCC_VERSION.
>>
> 
> What version of gcc are you using ? I currently use gcc 8.3.0 for all
> qemu boot tests (except for 3.16 which doesn't support it, or at least
> it didn't when I last checked), and have not observed any problems.
> 

With the upgrade gcc version went from 8.3.0 to 9.2.1

Interestingly enough all the older 4.14, 4.9, and 4.4 kernel I have
on the system boot just fine. It fails when build newer rcs with new
gcc, boot fails.

I would really like to understand it just in case something in our
kbuild scrips is the issue.

thanks,
-- Shuah

