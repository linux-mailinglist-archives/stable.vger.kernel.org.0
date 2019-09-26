Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6A6BEF34
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 12:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfIZKFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 06:05:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55807 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfIZKFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Sep 2019 06:05:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id a6so1992533wma.5
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 03:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6t/395YJPTpkIopiqPd9n80eFNg313G8rGGfISQ+VfY=;
        b=aCR/PPqJD5az8PqU6htoYprQuoxi7bbJbDzAMw7SCjFliKTyHNHDsrMU/Es0kD0IKJ
         8dTMn1rgrNN0M5spolH8refi7QIWe1fuAbfCwqmcjWdjWF2ZOLao78thpPiAvaVMdcNj
         kjXpF20o+b4LkR+VRCkrOGiTYK3TOZKM0grW4bqCLWgMEIO7PM42kAEhEmHIux8b3W4h
         28NcouGFosy0r2iQshHzaMVIo9f0F/Zi47Lc+QFY/4RjjIxLPmP1sPnIQfKCB0sluBML
         kTed6SxjK1lbgClKZf4d4xY32MgOk/ipxSKqqexzVPS8ZSt00VVgOrrLwy3W99s+UYhz
         yYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6t/395YJPTpkIopiqPd9n80eFNg313G8rGGfISQ+VfY=;
        b=KSYnCfnZstwC00/uyOeN140WgkdEA1/AhudpUmlj8+dsM19urVt2vHdRkQiI7LQQTM
         VlrzmAZpHojOUK3Izfvv2M7jvJ39hotUUgyyENgqKKnMa1toeZ9jQyPxuPiRhNi7C4He
         Xz//txdv36w5BTAlpqabm7obftx3eYeeaTHk5oqupKcfPmYygna+pjOPDsho/YrrtX6S
         pYPPu+YI5XFGc8BgCw/vh0STWKcaL6b4Fr5DqNzNfCKhOEqc3X1wEUPjUJDeK8/KMxF/
         O2oUlmWza5dgZwA3KxLBePWKorDci/53gddOahfnHz0E+jZwK2g276Uk3cWX9xx8qagk
         qVDQ==
X-Gm-Message-State: APjAAAX5J43XhCL24chCTmJ8pYiPgFEZS7fGPXfeYzRtGSrjd89Dv8v4
        f9FshEg00A9TjaYhVVMMz+W4ivUvA3mi1taG
X-Google-Smtp-Source: APXvYqzfVmZJDDfYzTQKfhcEoESp05tB95zXfX5FO7FI6eI2UAgyETMyDPEv/j13dLRIJU0H+rcbqw==
X-Received: by 2002:a1c:b745:: with SMTP id h66mr2199329wmf.70.1569492297740;
        Thu, 26 Sep 2019 03:04:57 -0700 (PDT)
Received: from [192.168.1.145] ([65.39.69.237])
        by smtp.gmail.com with ESMTPSA id s1sm3815000wrg.80.2019.09.26.03.04.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 03:04:57 -0700 (PDT)
Subject: Re: [PATCH v4] block: fix null pointer dereference in
 blk_mq_rq_timed_out()
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <keith.busch@intel.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
References: <20190925122025.31246-1-yuyufen@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9fda0509-0ee5-9f9d-8a37-2d33a097d1bd@kernel.dk>
Date:   Thu, 26 Sep 2019 12:04:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190925122025.31246-1-yuyufen@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/25/19 2:20 PM, Yufen Yu wrote:
> diff --git a/block/blk.h b/block/blk.h
> index ed347f7a97b1..de258e7b9db8 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -30,6 +30,7 @@ struct blk_flush_queue {
>   	 */
>   	struct request		*orig_rq;
>   	spinlock_t		mq_flush_lock;
> +	blk_status_t 		rq_status;
>   };

Patch looks fine to me, but you should move rq_status to after the
flush_running_idx member of struct blk_flush_queue, since then it'll
fill a padding hole instead of adding new ones.

-- 
Jens Axboe

