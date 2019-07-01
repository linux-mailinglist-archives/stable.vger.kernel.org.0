Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2D45BDD8
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 16:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfGAOOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 10:14:12 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46359 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729459AbfGAOOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 10:14:12 -0400
Received: by mail-io1-f66.google.com with SMTP id i10so15336337iol.13
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 07:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sE1BaPOe4JxsMC6t4atlvq+xkIKYRLuwGnGyC71KtEM=;
        b=STYngXIOIWKNHJ2jMySf2qSCUM//ofiG/rsvVIsYU+D0KQJE55HII83CXBYLYqUFg1
         zl4DF/v3VEIJjXJ0asgD7zpxUU1+XlupBmVcqSc7u5nypPPrr/Su8qEGgmKfgx/iPdAd
         DRlT7ekn8rbGQ/Yj/Tr7kEe7lYFbe/B4yCmza58qJIEx22kz/fE49Zd4SFC3wj1o6SlQ
         TYp69EQt7IwnhzPwScg8PtI08F5t0D4/fM0MpzvvmwQ35LxGcdSGwwS2P9Lh5WOlw3Ej
         /IDghkTI1HNiK6VqMdisKjsmUgtBvBXLe2w2JmTiAYRvrFTYWMd37GoxyldaO6w1Vvyk
         vh7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sE1BaPOe4JxsMC6t4atlvq+xkIKYRLuwGnGyC71KtEM=;
        b=jXtu839cirAN+2os/njEeJJH7we55xMEWzmxf6N3e47tgyhARqOGNQ7ZsYyngwZFZt
         St9Fagq6tNTw8zc0zGDKW0xIwSYB1v2enrbwupuS4U5tUcCu3blsNYdRQa8LbRnxab2l
         VJlCYpWUcCkPGWix4H21x93HxQS4/42NAOwxLCsM5Ls85nRmfo0svZN8S8/jLcNfrZ2f
         0erinicj5kutn02RDaYwH1r8Nsp0dif+Z9Z76HxS7sQH+hJzsG5p2YoLmmkp7nq/8hGa
         0Z/KsNLCF1ay/cvGpvBL6cs+5twwDJ5PSg1DJsi0+xlpSo83QEKXYk8Tbm8hi5OOTp77
         ozOQ==
X-Gm-Message-State: APjAAAUHWUsM2aGMrbdXRU0y8boBMkZmK+djvcZoIgejCE2kEbZjiT4v
        G3e3HYlUbxtZm1YqwCoHJiAHJvikGztktqll
X-Google-Smtp-Source: APXvYqyiFniEOwLHu/uz2qamMaeQ68Nmd9RxmwgztEmEW9yzJG/mQ4oLQyuoUplS8jc71Mfce1pzxA==
X-Received: by 2002:a02:b016:: with SMTP id p22mr20064925jah.121.1561990450147;
        Mon, 01 Jul 2019 07:14:10 -0700 (PDT)
Received: from [192.168.1.158] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t5sm8756673iol.55.2019.07.01.07.14.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 07:14:09 -0700 (PDT)
Subject: Re: [PATCH V2] block: fix .bi_size overflow
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        kernel test robot <rong.a.chen@intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20190701071446.22028-1-ming.lei@redhat.com>
 <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
Message-ID: <bd45842a-e0fd-28a7-ac79-96f7cb9b66e4@kernel.dk>
Date:   Mon, 1 Jul 2019 08:14:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <8db73c5d-a0e2-00c9-59ab-64314097db26@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/1/19 8:05 AM, Jens Axboe wrote:
> On 7/1/19 1:14 AM, Ming Lei wrote:
>> 'bio->bi_iter.bi_size' is 'unsigned int', which at most hold 4G - 1
>> bytes.
>>
>> Before 07173c3ec276 ("block: enable multipage bvecs"), one bio can
>> include very limited pages, and usually at most 256, so the fs bio
>> size won't be bigger than 1M bytes most of times.
>>
>> Since we support multi-page bvec, in theory one fs bio really can
>> be added > 1M pages, especially in case of hugepage, or big writeback
>> with too many dirty pages. Then there is chance in which .bi_size
>> is overflowed.
>>
>> Fixes this issue by using bio_full() to check if the added segment may
>> overflow .bi_size.
> 
> Any objections to queuing this up for 5.3? It's not a new regression
> this series.

I took a closer look, and applied for 5.3 and removed the stable tag.
We'll need to apply your patch for stable, and I added an adapted
one for 5.3. I don't want a huge merge hassle because of this.

-- 
Jens Axboe

