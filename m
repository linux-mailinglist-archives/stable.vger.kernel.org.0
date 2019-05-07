Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7E116D4F
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 23:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfEGVvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 17:51:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53197 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbfEGVvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 17:51:48 -0400
Received: from mail-qk1-f198.google.com ([209.85.222.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hO801-0007Qr-QW
        for stable@vger.kernel.org; Tue, 07 May 2019 21:51:45 +0000
Received: by mail-qk1-f198.google.com with SMTP id t67so19709625qkd.15
        for <stable@vger.kernel.org>; Tue, 07 May 2019 14:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ABxz2zyv5bmpxAzqyzrtcoqu224yUlyjNfm0bz0RUYo=;
        b=lJ7/cCkTLSIZKzZ+Tqitxzw21TIC0v+/mLRYpFiA7zfPkQciAuGZYvqi4YF3Fxy91L
         1d+UJ9nTZIPA9ysvIhASvxKKCqxzlg5pc/rSXqmft2y/cMgPQJtVEA6oC1aD5O01WBfs
         qGZWO2ngnfpFpqDRDwSisJKzEVTWSVtN18qgKAGIwV7DCCZU/cRlEORwCX0lBWs60rCw
         Zdo2++WMHk3M5ILtWfI5PqVMnEQuuGygLxXSRVSsT6wfYQUeqHN5uKfMdfzdPVVHO1mH
         P8ZRt73fnGrg4PXAIOGwSttLGuLi7hC2tQ8U/lVFUG49b6UC+xjX6RWbMHxelZ/sKBVr
         H6oQ==
X-Gm-Message-State: APjAAAUzvlzDNxXUEJ9N/PGHVddxaEGCRlWnIja9dt5CWpZr0aVjgfFJ
        /yZK5VrqkjU1Qzq5rdVlB4kDLBfi4VfnWJqm1+WRCiJbdaJvLO9IHIywokfyeV/xDJekAyEuO5T
        rpHqB2lkaHp2IxQ4KPN6NCbd4Bd7yTDNuDg==
X-Received: by 2002:ac8:8c4:: with SMTP id y4mr568114qth.334.1557265904500;
        Tue, 07 May 2019 14:51:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxqmyA8mbiqIMGA6UVYNcKNbJyCt+/9kos8Zg0GnTOlwY7lwTrsVbbrcPB3iSk/BlNaK4k9rQ==
X-Received: by 2002:ac8:8c4:: with SMTP id y4mr568099qth.334.1557265904325;
        Tue, 07 May 2019 14:51:44 -0700 (PDT)
Received: from [192.168.1.205] (201-92-248-20.dsl.telesp.net.br. [201.92.248.20])
        by smtp.gmail.com with ESMTPSA id d41sm2961824qta.22.2019.05.07.14.51.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 14:51:43 -0700 (PDT)
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>, kernel@gpiccoli.net,
        Ming Lei <ming.lei@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
References: <20190430223722.20845-1-gpiccoli@canonical.com>
 <20190430223722.20845-2-gpiccoli@canonical.com>
 <CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
 <c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
 <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
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
Message-ID: <21d2ab66-4295-6b69-ef85-d798f3406fbd@canonical.com>
Date:   Tue, 7 May 2019 18:51:36 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/05/2019 18:07, Song Liu wrote:
>> [...]
>> I understand this could in theory affects all the RAID levels, but in
>> practice I don't think it'll happen. RAID0 is the only "blind" mode of
>> RAID, in the sense it's the only one that doesn't care at all with
>> failures. In fact, this was the origin of my other thread [0], regarding
>> the change of raid0's behavior in error cases..because it currently does
>> not care with members being removed and rely only in filesystem failures
>> (after submitting many BIOs to the removed device).
>>
>> That said, in this change I've only took care of raid0, since in my
>> understanding the other levels won't submit BIOs to dead devices; we can
>> experiment that to see if it's true.
> 
> Could you please run a quick test with raid5? I am wondering whether
> some race condition could get us into similar crash. If we cannot easily
> trigger the bug, we can process with this version.
> 
> Thanks,
> Song

Hi Song, I've tested both RAID5 (with 3 disks, removing one at a time),
and also RAID 1 (2 disks, also removing one at a time); no issues
observed in kernel 5.1. We can see one interesting message in kernel
log: "super_written gets error=10", which corresponds to md detecting
the error (bi_status == BLK_STS_IOERROR) and instantly failing the
write, making FS read-only.

So, I think really the issue happens only in RAID0, which writes
"blindly" to its components.
Let me know your thoughts - thanks again for your input!

Cheers,


Guilherme
