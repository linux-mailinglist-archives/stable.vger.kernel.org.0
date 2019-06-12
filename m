Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE642C7A
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 18:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440323AbfFLQhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 12:37:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52859 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438342AbfFLQhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 12:37:31 -0400
Received: from mail-qk1-f198.google.com ([209.85.222.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hb6Fd-0005oL-F5
        for stable@vger.kernel.org; Wed, 12 Jun 2019 16:37:29 +0000
Received: by mail-qk1-f198.google.com with SMTP id n190so14191175qkd.5
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 09:37:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eWIbSdtbL3heMXckk0UQZQqRJzG0E85cU2o+f0djUPw=;
        b=QQsXT9fnvhIwXXHte/LZ8LNiAlGPq8vUs/neBSQYOJmDGLnnxzo8tjhBNPBQZip5TQ
         eKKN2ZP7amQVJ+xwMhj6iY5oj1Et549De3JeqJE1Wq28dLWiXS8qVOq/jfSwEEHx1DGF
         Xf4X6S1NYWPDIfJh8G7msoFxC6N8uGrL0He+WB1XOr0pfPAKneXjdz7OQPqpe9BMRdBe
         VZRblxVNocmKTlARipHQe/hS0Ur/dgdZp02KkoJ5guUY8eOdbl2v1OHcYjhou9VEzgZT
         Mnu1GPrlQsV3ze2BWkA+Mp6FSmnzwUbACeMlDUYDjqNyOWLap/lMiWuSkMuzf7MBBHo+
         c4Lw==
X-Gm-Message-State: APjAAAXOj5iGxQ47CkRvI1RVfUBVdVAIcocmzfqeSi48o2fjmKwH1n+Z
        a9QiKCX3hFCAE/rcgvdttt44nE2YdJ0dvRK+XaMaWXDkuf9RpCfEUOXPSP1lN6Chh4ifTyIdCvD
        xVxLuaR5D72M8p1n+0ZP67QJn6E1XRhkc0A==
X-Received: by 2002:ac8:219d:: with SMTP id 29mr9141895qty.37.1560357448653;
        Wed, 12 Jun 2019 09:37:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzDouJmh4G3rIDzRCGlvwCsdTCzK8s4rO5zIDUSDpHwi+KFM/clzPjWEEUJ8qgLnNgpZ3KI3Q==
X-Received: by 2002:ac8:219d:: with SMTP id 29mr9141880qty.37.1560357448449;
        Wed, 12 Jun 2019 09:37:28 -0700 (PDT)
Received: from [192.168.1.75] ([177.68.236.180])
        by smtp.gmail.com with ESMTPSA id z50sm219287qtz.36.2019.06.12.09.37.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:37:27 -0700 (PDT)
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     stable@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org,
        axboe@kernel.dk, Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        gregkh@linuxfoundation.org, sashal@kernel.org
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com>
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
Message-ID: <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
Date:   Wed, 12 Jun 2019 13:37:24 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190523172345.1861077-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Greg, Sasha


On 23/05/2019 14:23, Song Liu wrote:
> From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
> 
> Commit cd4a4ae4683d ("block: don't use blocking queue entered for
> recursive bio submits") introduced the flag BIO_QUEUE_ENTERED in order
> split bios bypass the blocking queue entering routine and use the live
> non-blocking version. It was a result of an extensive discussion in
> a linux-block thread[0], and the purpose of this change was to prevent
> a hung task waiting on a reference to drop.
> 
> Happens that md raid0 split bios all the time, and more important,
> it changes their underlying device to the raid member. After the change
> introduced by this flag's usage, we experience various crashes if a raid0
> member is removed during a large write. This happens because the bio
> reaches the live queue entering function when the queue of the raid0
> member is dying.
> 
> A simple reproducer of this behavior is presented below:
> a) Build kernel v5.2-rc1 with CONFIG_BLK_DEV_THROTTLING=y.
> 
> b) Create a raid0 md array with 2 NVMe devices as members, and mount it
> with an ext4 filesystem.
> 
> c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
> (dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
> echo 1 > /sys/block/nvme0n1/device/device/remove
> (whereas nvme0n1 is the 2nd array member)
> 
> This will trigger the following warning/oops:
> 
> ------------[ cut here ]------------
> no blkg associated for bio on block-device: nvme0n1
> WARNING: CPU: 9 PID: 184 at ./include/linux/blk-cgroup.h:785
> generic_make_request_checks+0x4dd/0x690
> [...]
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000155
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> RIP: 0010:blk_throtl_bio+0x45/0x970
> [...]
> Call Trace:
>  generic_make_request_checks+0x1bf/0x690
>  generic_make_request+0x64/0x3f0
>  raid0_make_request+0x184/0x620 [raid0]
>  ? raid0_make_request+0x184/0x620 [raid0]
>  ? blk_queue_split+0x384/0x6d0
>  md_handle_request+0x126/0x1a0
>  md_make_request+0x7b/0x180
>  generic_make_request+0x19e/0x3f0
>  submit_bio+0x73/0x140
> [...]
> 
> This patch changes raid0 driver to fallback to the "old" blocking queue
> entering procedure, by clearing the BIO_QUEUE_ENTERED from raid0 bios.
> This prevents the crashes and restores the regular behavior of raid0
> arrays when a member is removed during a large write.
> 
> [0] https://marc.info/?l=linux-block&m=152638475806811
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Song Liu <liu.song.a23@gmail.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: stable@vger.kernel.org # v4.18
> Fixes: cd4a4ae4683d ("block: don't use blocking queue entered for recursive bio submits")
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid0.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index f3fb5bb8c82a..d5bdc79e0835 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -547,6 +547,7 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>  			trace_block_bio_remap(bdev_get_queue(rdev->bdev),
>  				discard_bio, disk_devt(mddev->gendisk),
>  				bio->bi_iter.bi_sector);
> +		bio_clear_flag(bio, BIO_QUEUE_ENTERED);
>  		generic_make_request(discard_bio);
>  	}
>  	bio_endio(bio);
> @@ -602,6 +603,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>  				disk_devt(mddev->gendisk), bio_sector);
>  	mddev_check_writesame(mddev, bio);
>  	mddev_check_write_zeroes(mddev, bio);
> +	bio_clear_flag(bio, BIO_QUEUE_ENTERED);
>  	generic_make_request(bio);
>  	return true;
>  }
> 
