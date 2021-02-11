Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23BD318847
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhBKKf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:35:26 -0500
Received: from mail.jv-coder.de ([5.9.79.73]:33542 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229943AbhBKKc4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 05:32:56 -0500
Received: from [192.168.178.40] (unknown [188.192.1.224])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 24EEA9F75B;
        Thu, 11 Feb 2021 10:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1613039532; bh=fnKdAqH3gT0iLhIIIVZK4pOspTc+ZPy27Kj+tL1bZjE=;
        h=Subject:To:From:Message-ID:Date:MIME-Version;
        b=sBpVzL2AIbSUXjzH6U2hmZQ4/iJuNs5eDIFua6UNGnSmT/TF8ehGv+a3nxNSqKjc0
         0mNK5xZ/vdLlgXY2pQ0LuXKLkYLe/riyFLyj9ZQRaxjw1kd2IPfS4S3HW6NDCCjXCj
         4mF0lZz6P7cI3u4w8P5yVZzUFG08qhEtaqIDwPVA=
Subject: Re: [4.14] Failing selftest timer/adjtick
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
 <YCPZA7nkGGDru3xw@kroah.com>
 <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
 <20210210131916.GC1903164@localhost>
From:   Joerg Vehlow <lkml@jv-coder.de>
Message-ID: <897e03f9-4062-d34f-0445-ff4f047ccd13@jv-coder.de>
Date:   Thu, 11 Feb 2021 11:33:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210131916.GC1903164@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.3 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.jv-coder.de
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Miroslav,

On 2/10/2021 2:19 PM, Miroslav Lichvar wrote:
> That patch cannot be applied alone. It would break the timekeeping in
> not so obvious ways as there will be unexpected sources of the NTP
> tracking error. IIRC, at least the following changes would need to be
> included with it. There may be others.
>
> c2cda2a5bda9 ("timekeeping/ntp: Don't align NTP frequency adjustments to ticks")
> aea3706cfc4d ("timekeeping: Remove CONFIG_GENERIC_TIME_VSYSCALL_OLD")
> d4d1fc61eb38 ("ia64: Update fsyscall gettime to use modern vsyscall_update")
>
> My suggestion for a fix would be to increase the limit in the failing
> test.
Thanks, that's what I expected. But I still wonder why the test is 
failing almost 100% of time for me on qemu-arm64 (running on x86). Is 
this a regression in 4.14, that was working at some point or was it 
never tested on arm?

Joerg
