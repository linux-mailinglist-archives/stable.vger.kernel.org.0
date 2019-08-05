Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327AF81583
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 11:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfHEJdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 05:33:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37563 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfHEJdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 05:33:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so58595121wrr.4
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 02:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e6mpzWuHkNsT3rptUQH52jVRQqHIX7D9o531pV6bORY=;
        b=hRIlQEDNX2xX5rCHoSv+sGZD59H38Ow/EYR0T1ajP5OaF8L2KA9hQBFUoMpXh0HE0D
         HWTHxMzmEfrB4IqyQa3yGqNfq4mXnhyIMusHeOGkp4+HUBtc8iTNqXU9vDkI9BIZ95kw
         V5Vfh+j570DChZJqUnBHLzIpqgGHLJm+0JL1BWcSvVJzyYuiMvzEYRrpgZ78fURUHl3N
         ovjUGELg40J2Gm0d8pMCnljPsXVktlFARe436/iKTp8psqDnHGt3p3ILoUeA8pd6dAO9
         ovpfVwtj4qN7LkFnoKf71I32m17M4sE0fJM7zWE/+42S4VhFJq2Of1UsBjFi2ClfbWeY
         1HfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e6mpzWuHkNsT3rptUQH52jVRQqHIX7D9o531pV6bORY=;
        b=LS0BhN2M+A0I29hFSyK8s1Q2LmaVN4pZoivgvn5JI5GE5ovNRqp/g/ieE6NqQce16a
         ExJ7du8gPomX9I+7Q+Oma469govOP2MTcHqPfgi+Ca1NoeyreUHLwdwFU+RhHCGEZHzU
         HOC7Mz/FlGNhbIRbtoQewOIFePJYnEe5D6/Tzq/itIxC2gzMg8agN2dfSOTOnoLlyEX9
         gCWgmjDiAfUzhVFuG13pDoaO6p6lHVCSSHQyoHtDK5mTFM3f0VON5DNpUX9lq/NhtthS
         Xz8ssE5s3LlczRHKgxsMM9xHyKg6q0yYdjtej4sq/3yUTZ7SaLajFYFbonYhl0jJ9mFZ
         Cprw==
X-Gm-Message-State: APjAAAXByNcDkzsqed4APVsNr25LOCs6gopFj27F1oepUYL0caiM2t1T
        Ojs7mPVkRo2Y+l97DIkZ8ENl07pMh3omew==
X-Google-Smtp-Source: APXvYqz6T7cZ7wa/+gLiHZdm5Uiv/PuUcbTNxoUWmZaDsCa8yclPwjoVxW6PV7E51zV0/r2XvX7/NA==
X-Received: by 2002:adf:f04d:: with SMTP id t13mr45767334wro.133.1564997593542;
        Mon, 05 Aug 2019 02:33:13 -0700 (PDT)
Received: from ?IPv6:2001:858:107:1:28f7:ac40:788a:ffa1? ([2001:858:107:1:28f7:ac40:788a:ffa1])
        by smtp.gmail.com with ESMTPSA id a84sm108098037wmf.29.2019.08.05.02.33.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 02:33:13 -0700 (PDT)
Subject: Re: [PATCH] drbd: do not ignore signals in threads
To:     David Laight <David.Laight@ACULAB.COM>,
        Jens Axboe <axboe@kernel.dk>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
 <6259de605e9246b095233e3984262b93@AcuMS.aculab.com>
From:   =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
Message-ID: <ad16d006-4382-3f77-8968-6f840e58b8df@linbit.com>
Date:   Mon, 5 Aug 2019 11:33:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6259de605e9246b095233e3984262b93@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.07.19 10:50, David Laight wrote:
> Doesn't unmasking the signals and using send_sig() instead  of force_sig()
> have the (probably unwanted) side effect of allowing userspace to send
> the signal?

I have ran some tests, and it does look like it is now possible to send
signals to the DRBD kthread from userspace. However, ...

> I've certainly got some driver code that uses force_sig() on a kthread
> that it doesn't (ever) want userspace to signal.

... we don't feel that it is absolutely necessary for userspace to be
unable to send a signal to our kthreads. This is because the DRBD thread
independently checks its own state, and (for example) only exits as a
result of a signal if its thread state was already "EXITING" to begin
with.

As such, our priority here is to get the main issue -- DRBD hanging upon
exit -- resolved. I agree that it is not exactly desirable to have userspace
send random signals to kthreads; not for DRBD and certainly not in general.
However, we feel like it is more important to have DRBD actually work again
in 5.3.

That said, there should probably still be a way to be able to send a signal
to a kthread from the kernel, but not from userspace. I think the author of
the original patch (Eric) might have some ideas here.

Jens, could you take a look and decide whether or not it's appropriate for you
to funnel this through the linux-block tree to Linus for rc4?

> The origina1 commit says:
>> Further force_sig is for delivering synchronous signals (aka exceptions).
>> The locking in force_sig is not prepared to deal with running processes, as
>> tsk->sighand may change during exec for a running process.
> 
> I think a lot of code has assumed that the only real difference between
> send_sig() and force_sig() is that the latter ignores the signal mask.
> 
> If you need to unblock a kernel thread (eg one blocked in kernel_accept())
> in order to unload a driver, then you really don't want it to be possible
> for anything else to signal the kthread.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
--
Christoph Böhmwalder
LINBIT | Keeping the Digital World Running
DRBD HA —  Disaster Recovery — Software defined Storage
