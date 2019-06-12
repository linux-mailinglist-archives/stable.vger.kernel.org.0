Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCB042C7E
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 18:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438357AbfFLQiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 12:38:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52885 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389150AbfFLQiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 12:38:09 -0400
Received: from mail-qk1-f200.google.com ([209.85.222.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hb6GE-0005qc-Nr
        for stable@vger.kernel.org; Wed, 12 Jun 2019 16:38:06 +0000
Received: by mail-qk1-f200.google.com with SMTP id u128so14196115qka.2
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 09:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pDYsGxTnngNXWC22/wI3SxZkoSz3E0BCw1TgcXeKdGU=;
        b=g92ArSSpOez7IR/n4G0UbzE8/Fa1lQXSryU9IuSV+QI80rE9X10MVuW1vMMiShmqoU
         eHmGv508iIxrIg+3RDNcZUm5EjE03N/mcVl7PEo5ej4MiJLVcAgMwa4pT+SBCxc2cVcK
         KSuebShU69HWUFOuLE3A5Q4yQhkf6SUBCs1dYGoQETPTI8fyPoMggzfshAxkMLzl3gIu
         VVyHTlH8v+myauHAqgPp/NFXnDE78dYlpv0YtI3ELtkzH61+BL0htzUdsMi56CzWUCDf
         H7Kz6XjxPA0UvTx75So4sotQg38EXNyjI03tgmrhyYcMCTP8Y1BrfMZvtS8GKqlZaAL+
         zfIA==
X-Gm-Message-State: APjAAAVuAYDKZ8fOdu6+O+T+4JkDOTTj5Pw2/hjYvJ/aiwEsd02uQZJe
        wDSuV79rC3Q51f9X56l/ZczdZG0eYxhBFMfExKv6k4A81/6KteG0IA8RX6kWRbkSuil+5SxQBbF
        xPVJZ/HuwpRKIWMrCRkYQjrbboKBBAsb+yA==
X-Received: by 2002:ae9:e217:: with SMTP id c23mr20142164qkc.227.1560357485936;
        Wed, 12 Jun 2019 09:38:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw43HEmG6LXdKhoodnRF+E23lwcnxyiAUk8jNFsvqZE1DYQ9H4lDGKDS3Q8+Wj3mMcqwDs4jg==
X-Received: by 2002:ae9:e217:: with SMTP id c23mr20142143qkc.227.1560357485741;
        Wed, 12 Jun 2019 09:38:05 -0700 (PDT)
Received: from [192.168.1.75] ([177.68.236.180])
        by smtp.gmail.com with ESMTPSA id c4sm84725qkd.24.2019.06.12.09.38.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:38:05 -0700 (PDT)
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com>
 <CAHD1Q_wraiFkLP72pFfGhON+KZe7yo3ktXvsAA40QVcXvzviSA@mail.gmail.com>
 <20190612124834.GA27918@kroah.com>
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Openpgp: preference=signencrypt
Autocrypt: addr=gpiccoli@canonical.com; prefer-encrypt=mutual; keydata=
 mQENBFpVBxcBCADPNKmu2iNKLepiv8+Ssx7+fVR8lrL7cvakMNFPXsXk+f0Bgq9NazNKWJIn
 Qxpa1iEWTZcLS8ikjatHMECJJqWlt2YcjU5MGbH1mZh+bT3RxrJRhxONz5e5YILyNp7jX+Vh
 30rhj3J0vdrlIhPS8/bAt5tvTb3ceWEic9mWZMsosPavsKVcLIO6iZFlzXVu2WJ9cov8eQM/
 irIgzvmFEcRyiQ4K+XUhuA0ccGwgvoJv4/GWVPJFHfMX9+dat0Ev8HQEbN/mko/bUS4Wprdv
 7HR5tP9efSLucnsVzay0O6niZ61e5c97oUa9bdqHyApkCnGgKCpg7OZqLMM9Y3EcdMIJABEB
 AAG0LUd1aWxoZXJtZSBHLiBQaWNjb2xpIDxncGljY29saUBjYW5vbmljYWwuY29tPokBNwQT
 AQgAIQUCWmClvQIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRDOR5EF9K/7Gza3B/9d
 5yczvEwvlh6ksYq+juyuElLvNwMFuyMPsvMfP38UslU8S3lf+ETukN1S8XVdeq9yscwtsRW/
 4YoUwHinJGRovqy8gFlm3SAtjfdqysgJqUJwBmOtcsHkmvFXJmPPGVoH9rMCUr9s6VDPox8f
 q2W5M7XE9YpsfchS/0fMn+DenhQpV3W6pbLtuDvH/81GKrhxO8whSEkByZbbc+mqRhUSTdN3
 iMpRL0sULKPVYbVMbQEAnfJJ1LDkPqlTikAgt3peP7AaSpGs1e3pFzSEEW1VD2jIUmmDku0D
 LmTHRl4t9KpbU/H2/OPZkrm7809QovJGRAxjLLPcYOAP7DUeltveuQENBFpVBxcBCADbxD6J
 aNw/KgiSsbx5Sv8nNqO1ObTjhDR1wJw+02Bar9DGuFvx5/qs3ArSZkl8qX0X9Vhptk8rYnkn
 pfcrtPBYLoux8zmrGPA5vRgK2ItvSc0WN31YR/6nqnMfeC4CumFa/yLl26uzHJa5RYYQ47jg
 kZPehpc7IqEQ5IKy6cCKjgAkuvM1rDP1kWQ9noVhTUFr2SYVTT/WBHqUWorjhu57/OREo+Tl
 nxI1KrnmW0DbF52tYoHLt85dK10HQrV35OEFXuz0QPSNrYJT0CZHpUprkUxrupDgkM+2F5LI
 bIcaIQ4uDMWRyHpDbczQtmTke0x41AeIND3GUc+PQ4hWGp9XABEBAAGJAR8EGAEIAAkFAlpV
 BxcCGwwACgkQzkeRBfSv+xv1wwgAj39/45O3eHN5pK0XMyiRF4ihH9p1+8JVfBoSQw7AJ6oU
 1Hoa+sZnlag/l2GTjC8dfEGNoZd3aRxqfkTrpu2TcfT6jIAsxGjnu+fUCoRNZzmjvRziw3T8
 egSPz+GbNXrTXB8g/nc9mqHPPprOiVHDSK8aGoBqkQAPZDjUtRwVx112wtaQwArT2+bDbb/Y
 Yh6gTrYoRYHo6FuQl5YsHop/fmTahpTx11IMjuh6IJQ+lvdpdfYJ6hmAZ9kiVszDF6pGFVkY
 kHWtnE2Aa5qkxnA2HoFpqFifNWn5TyvJFpyqwVhVI8XYtXyVHub/WbXLWQwSJA4OHmqU8gDl
 X18zwLgdiQ==
Message-ID: <845eef8b-d64f-5213-b863-081a72fd5598@canonical.com>
Date:   Wed, 12 Jun 2019 13:38:01 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612124834.GA27918@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/06/2019 09:48, Greg KH wrote:
> On Wed, Jun 12, 2019 at 09:40:17AM -0300, Guilherme Piccoli wrote:
>> Hi Greg and Sasha, is there any news about these patches?
> 
> What patches?
> 
>> Just checked the stable branches 5.1.y and 5.0.y, they seem not merged.
> 
> Are they merged in Linus's tree?  What are the git commit ids?
> 

Hi Greg, thanks for your prompt response! The story behind these patches
is a bit confusing; I'll summarize below.

I've submitted 2 patches with fixes to linux-raid in April; if you wanna
take a look, they are:

https://marc.info/?l=linux-raid&m=155839017427565
https://marc.info/?l=linux-raid&m=155839017827569

After some discussion, it was determined a patchset from Ming Lei fixed
the same issues I've reported/fixed, but it was a rework (and depends on
the removal of legacy IO path).
That said, Song Liu submitted both of my fixes as stable-only patches.
I couldn't find a stable archive (and I don't subscribe to that), so I
cannot point links here.

I just resubmitted both patches, this time CCing you and Sasha. Let me
know if there's anything needed - I'd prefer to have them upstream too,
but the discussion with Christoph/Ming/Song reached a consensus that it
wouldn't make sense to add them and soon after add Ming's patchset,
which removes that code.
But backporting Ming's series is not really simple/feasible.

Thanks,


Guilherme


> I have no record of these patches in my queue at the moment, sorry.  If
> these were a backport, please resend them in the proper format.
> 
> thanks,
> 
> greg k-h
> 
