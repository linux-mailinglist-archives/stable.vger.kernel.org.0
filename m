Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39012467DE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgHQN67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgHQN64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:58:56 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1F7C061342
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:58:56 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g33so8164536pgb.4
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LkOmn31+YLHcI3qHC2T5Tg8Vl2aeMTikX/AW3L7JIio=;
        b=tReyIAqP8L9XFCUhOcvqmTuyDNCmXePdaY+d0CAgzqmJApCAp9KoyBiY0BybWY9skU
         vpOkvrq1GxnBfN37bsAe8RWg7U9TSQ9Zl70TYtIeLgglR7CYsOnwsNZ2APP1XQ3/rCrN
         WXSRlf65I5DIWY/z1pVGqYFcWAG6lp96jQI+v59qaVFSpPgkxpVaGfl29ek508rH3rTY
         f0cNHJbpsZSf52jAzstTLonCY5XU87qQJliDwjSKQ7WwhwQ8pdEH+Hggt++qg0cLjLbT
         5UUw1sv5WW7aRAYHAeavS6Rw2MabClmvDKwcg9D6kPV2Q/bZVHgkPNiaPZqMjVt7IHho
         HKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LkOmn31+YLHcI3qHC2T5Tg8Vl2aeMTikX/AW3L7JIio=;
        b=lGqWhYPmkbTEFnw27pRboPFtZD9ssXnOE9k0jGmOFDFZ6B0FJsZ4IIqX5mxQboruP7
         sCZ3QzYyA3Zk7EWDS7sJCPIqYYUy4j7Uhi/1jsOsKEN+a72jse5WsWwXQG+y99+KIzxS
         g3+z3kg+xVjTWyrQwHd8kAVQO+pFESBf22ZL5XuG3jPOMf9FoAivNfiNZFWTioMpCmW7
         FwM8WKDDfIrYeDdlPiGd9VnQ2ttWiYJ7HzDWrAD+/FE4jf4Y+z/BDo+pJXW3CWFHCRSG
         EGrpjZGIB2/fx5UEHOzI74/Z/+RtbM/Mgf1nnPpQTlQctad/8L+X6+v6smwdGUVbTgED
         jMKw==
X-Gm-Message-State: AOAM533RVZ8lY56ojf9cKA4nUAPZRp71IDgFIoT3dpkNmC72AFhmaJIx
        9FMkDfnOQzr0V2fZEOWalZUOMAFQ8B2f3g==
X-Google-Smtp-Source: ABdhPJwqinMo1rn1icRqQHvKrQuSzlzejc5Fe4XsWZR8TioFBUs77e12ftwi1ObZablAE0+UvLW+DQ==
X-Received: by 2002:a63:4c57:: with SMTP id m23mr9691036pgl.77.1597672735861;
        Mon, 17 Aug 2020 06:58:55 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id h65sm19881667pfb.210.2020.08.17.06.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:58:55 -0700 (PDT)
Subject: Re: [PATCH RESEND] block: loop: set discard granularity and alignment
 for block device backed loop
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.com>, Xiao Ni <xni@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20200817100130.2496059-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bea9ed29-066e-a334-337e-76972ea6b7df@kernel.dk>
Date:   Mon, 17 Aug 2020 06:58:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817100130.2496059-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 3:01 AM, Ming Lei wrote:
> In case of block device backend, if the backend supports write zeros, the
> loop device will set queue flag of QUEUE_FLAG_DISCARD. However,
> limits.discard_granularity isn't setup, and this way is wrong,
> see the following description in Documentation/ABI/testing/sysfs-block:
> 
> 	A discard_granularity of 0 means that the device does not support
> 	discard functionality.
> 
> Especially 9b15d109a6b2 ("block: improve discard bio alignment in
> __blkdev_issue_discard()") starts to take q->limits.discard_granularity
> for computing max discard sectors. And zero discard granularity may cause
> kernel oops, or fail discard request even though the loop queue claims
> discard support via QUEUE_FLAG_DISCARD.
> 
> Fix the issue by setup discard granularity and alignment.

Applied, thanks.

-- 
Jens Axboe

