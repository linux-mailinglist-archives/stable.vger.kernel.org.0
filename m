Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF9B42C70
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 18:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438320AbfFLQgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 12:36:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52845 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438250AbfFLQgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 12:36:46 -0400
Received: from mail-qk1-f198.google.com ([209.85.222.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hb6Et-0005jz-LR
        for stable@vger.kernel.org; Wed, 12 Jun 2019 16:36:43 +0000
Received: by mail-qk1-f198.google.com with SMTP id u128so14193422qka.2
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 09:36:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2sXKb3S0hkAldGBNHNsOXbFztlm2M018ZcmWxgm1nzo=;
        b=TU6bUb/LtoEtvCFZOZ0nOMGUzqtJ8cNss5638H7/9Zd7fIF7Nd86blFyO2Q/6mBH90
         Z+kFCvlCW/GpcdQRoYidoOu7Do/M/z3+XPoJWYWUutpPqf8sizUSZO03jrhXi3PswtDG
         e1LEp8fohDxtbb26qMoOdzrWUmTYpsiiNtjOvZ/G7hYPJ3QNtvyL7MxH33+0SwywVPfy
         XCRxx5fEbjzmMLb2AypdtqtAczkppNtMUv+wq3+780s6B/p2yptWp0rDlMYoYyBqnfk7
         Njg+bvMnQKr4K3l7amlhAPkU8G7TqAHoaKWN5rRQziWehcNVKvZ24UO2/9A4SXd9TUPW
         g+Kg==
X-Gm-Message-State: APjAAAVt+jNF7AvRGMYaM7sYaVsruwPOWBUynCUP0XLc+LaTR0/0lPxP
        SSePO+yEnttcBBFACzSzFPp0Y1M4arB63xQo09hGN6W8L4/hgqqoceWIxWljFemtkLtnCxu24ei
        8+cX52M9STaiqzrxpKJfQKIv2HK4gcyhGew==
X-Received: by 2002:a05:620a:15c9:: with SMTP id o9mr26129958qkm.195.1560357402865;
        Wed, 12 Jun 2019 09:36:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx51qlZHklizAJjgSBCGJptpeCG/TUfkqn13Mp812mX+Z2l53c7iku7+XcCKhn0nlv9LRYr6w==
X-Received: by 2002:a05:620a:15c9:: with SMTP id o9mr26129938qkm.195.1560357402648;
        Wed, 12 Jun 2019 09:36:42 -0700 (PDT)
Received: from [192.168.1.75] ([177.68.236.180])
        by smtp.gmail.com with ESMTPSA id q29sm74552qkq.77.2019.06.12.09.36.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:36:41 -0700 (PDT)
Subject: Re: [PATCH 1/2] block: Fix a NULL pointer dereference in
 generic_make_request()
To:     stable@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org,
        axboe@kernel.dk, gregkh@linuxfoundation.org, sashal@kernel.org
References: <20190523172345.1861077-1-songliubraving@fb.com>
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
Message-ID: <d1448b8d-1534-3b7a-d8e1-4c4bf467cf54@canonical.com>
Date:   Wed, 12 Jun 2019 13:36:37 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190523172345.1861077-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ Greg, Sasha


On 23/05/2019 14:23, Song Liu wrote:
> From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
> 
> Commit 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently
> with device removal triggers a crash") introduced a NULL pointer
> dereference in generic_make_request(). The patch sets q to NULL and
> enter_succeeded to false; right after, there's an 'if (enter_succeeded)'
> which is not taken, and then the 'else' will dereference q in
> blk_queue_dying(q).
> 
> This patch just moves the 'q = NULL' to a point in which it won't trigger
> the oops, although the semantics of this NULLification remains untouched.
> 
> A simple test case/reproducer is as follows:
> a) Build kernel v5.2-rc1 with CONFIG_BLK_CGROUP=n.
> 
> b) Create a raid0 md array with 2 NVMe devices as members, and mount it
> with an ext4 filesystem.
> 
> c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
> (dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
> echo 1 > /sys/block/nvme0n1/device/device/remove
> (whereas nvme0n1 is the 2nd array member)
> 
> This will trigger the following oops:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP PTI
> RIP: 0010:generic_make_request+0x32b/0x400
> Call Trace:
>  submit_bio+0x73/0x140
>  ext4_io_submit+0x4d/0x60
>  ext4_writepages+0x626/0xe90
>  do_writepages+0x4b/0xe0
> [...]
> 
> This patch has no functional changes and preserves the md/raid0 behavior
> when a member is removed before kernel v4.17.
> 
> Cc: stable@vger.kernel.org # v4.17
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Eric Ren <renzhengeek@gmail.com>
> Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  block/blk-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a55389ba8779..d24a29244cb8 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1074,10 +1074,8 @@ blk_qc_t generic_make_request(struct bio *bio)
>  			flags = 0;
>  			if (bio->bi_opf & REQ_NOWAIT)
>  				flags = BLK_MQ_REQ_NOWAIT;
> -			if (blk_queue_enter(q, flags) < 0) {
> +			if (blk_queue_enter(q, flags) < 0)
>  				enter_succeeded = false;
> -				q = NULL;
> -			}
>  		}
>  
>  		if (enter_succeeded) {
> @@ -1108,6 +1106,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>  				bio_wouldblock_error(bio);
>  			else
>  				bio_io_error(bio);
> +			q = NULL;
>  		}
>  		bio = bio_list_pop(&bio_list_on_stack[0]);
>  	} while (bio);
> 
