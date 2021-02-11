Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ADA318851
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBKKhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:37:21 -0500
Received: from mail.jv-coder.de ([5.9.79.73]:33570 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhBKKfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:02 -0500
Received: from [192.168.178.40] (unknown [188.192.1.224])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 05F05A14B9;
        Thu, 11 Feb 2021 10:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1613039645; bh=LcTRFOTkQnbeyfl+wKEoO2VXLucFdQjucP6C5s8Ghi4=;
        h=Subject:To:From:Message-ID:Date:MIME-Version;
        b=RRtRczBY7+J2dheRBG9l8IVaj/QeXTzt/uDQLjUe59cHorIo7eoK0BeHSSeJ5XOlR
         f6vaWGCAENKeABhqg6UuIT/92XQ/vQFAztWj3CaROjsOXRvXFqVmCp262TyHKFknUd
         cFI3722tozEazAXmFlR8ncRY9p4GoDIXpr2YPkpg=
Subject: Re: [4.14] Failing selftest timer/adjtick
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        linux-stable <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        lkft-triage@lists.linaro.org
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
 <YCPZA7nkGGDru3xw@kroah.com>
 <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
 <20210210131916.GC1903164@localhost>
 <CA+G9fYuQL9=gJJtWp7wHRzY1dc4q-Be4XjrZJUmYTJUbDEN=dA@mail.gmail.com>
From:   Joerg Vehlow <lkml@jv-coder.de>
Message-ID: <4fa3c57d-23ea-2f8c-72fe-d23f3146f571@jv-coder.de>
Date:   Thu, 11 Feb 2021 11:34:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYuQL9=gJJtWp7wHRzY1dc4q-Be4XjrZJUmYTJUbDEN=dA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.3 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.jv-coder.de
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/10/2021 7:59 PM, Naresh Kamboju wrote:
> I have tested adjtick on arm64 juno-r2 device and it got pass
> and here is the test output on Linux version 4.14.221-rc1.
Interesting. Is this vanilla 4.14.221 or are there some o-e patches applied?
I just tried again on qemu arm with 4.14.222 from kernel.org stable tree 
and still have failures like the one below every time I try. The failing 
test step differs, but it always fails.

Each iteration takes about 15 seconds
Estimating tick (act: 9000 usec, -100000 ppm): 9000 usec, -100000 ppm    
[OK]
Estimating tick (act: 9250 usec, -75000 ppm): 9250 usec, -75001 ppm    [OK]
Estimating tick (act: 9500 usec, -50000 ppm): 9501 usec, -49995 ppm    [OK]
Estimating tick (act: 9750 usec, -25000 ppm): 9750 usec, -25003 ppm    [OK]
Estimating tick (act: 10000 usec, 0 ppm): 9996 usec, -463 ppm [FAILED]
Bail out!
Pass 0 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
1..0


Joerg
