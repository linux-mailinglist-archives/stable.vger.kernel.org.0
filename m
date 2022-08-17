Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC972596CB0
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 12:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiHQKRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 06:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiHQKRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 06:17:14 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287D758DCE
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 03:17:13 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id s11-20020a1cf20b000000b003a52a0945e8so723028wmc.1
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 03:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=GS3uETP2QCuIf1x+SmwTzncgxqElF+XQyJdEpNKzueU=;
        b=rAmC0o8TTYmvHbpkcfk9+gVA/8DSJj/qmkzWFKuve5fVdZ8SHUQHuN6Lfs9o5e1Xli
         Js8ojEYp4jAZEpRCzDCqiAoEbGCIErmctlC9h7bl32qGmnIHoK51iLbwoQXBOFNko3w0
         OSlYY8kTYlN1NPkq+1tT5KCUXYVKfsacdlMz3wJJTq7ljpk5RLIi/5yN+3r5jKIWFZx3
         TCTYHPdmGqyvxG4ZlA86sqS7CEaizMAQS2/w884BJuR0sAddNw6+avXD63tYv98P6QTn
         wlDXY2hYBNZWST7MIlQjZJuSNHRbYTEb/EbcEBVogAIqzD8iquIESrx2GKlDtUeEcy1L
         1Lrg==
X-Gm-Message-State: ACgBeo2NdX1mkkz3FVw9fsdx62WibiRDQYAA0xLJdpJUmsz68zxESJZh
        DdC0yUP8uvzuRS6wHxlDeiI=
X-Google-Smtp-Source: AA6agR4r/8L7E5SJBKbsOGDmzoR51jCKFtjjiCg+olxay5OS41P9zHGxy7p4gj0Lbqg+GMNEEbw7Rw==
X-Received: by 2002:a05:600c:4e94:b0:3a5:b7e5:9e64 with SMTP id f20-20020a05600c4e9400b003a5b7e59e64mr1668507wmq.26.1660731431711;
        Wed, 17 Aug 2022 03:17:11 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id t185-20020a1c46c2000000b003a5f812635asm1623636wma.39.2022.08.17.03.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 03:17:09 -0700 (PDT)
Message-ID: <97436a8d-e7ce-0118-1b88-739539adf302@grimberg.me>
Date:   Wed, 17 Aug 2022 13:17:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] nvmet: Fix a use-after-free
Content-Language: en-US
From:   Sagi Grimberg <sagi@grimberg.me>
To:     Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        stable@vger.kernel.org
References: <20220812210317.2252051-1-bvanassche@acm.org>
 <cd2189da-59b3-c01e-9bd3-5f838258c7bc@grimberg.me>
 <9ec2e292-1e75-8ee2-a9fc-d5adfab92fbd@acm.org>
 <3b12abd3-ba64-7811-8f1f-66dbb368cf66@grimberg.me>
In-Reply-To: <3b12abd3-ba64-7811-8f1f-66dbb368cf66@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>>> nvmet_req *req, u16 status)
>>>>       trace_nvmet_req_complete(req);
>>>> -    if (req->ns)
>>>> -        nvmet_put_namespace(req->ns);
>>>>       req->ops->queue_response(req);
>>>> +    if (ns)
>>>> +        nvmet_put_namespace(ns);
>>>
>>> Why did the put change position?
>>> I'm not exactly clear what was used-after-free here..
>>
>> Hi Sagi,
>>
>> Is my understanding correct that the NVMe target namespace owns the 
>> block device `req` is associated with and hence that the namespace 
>> reference count must only be dropped after dereferencing the `req` 
>> pointer has finished?
>>
>> This is what I found in the NVMe target code:
>> * nvmet_put_namespace() decreases ns->ref.
>> * Dropping the last ns->ref causes nvmet_destroy_namespace() to be
>>    called. That function completes ns->disable_done.
>> * nvmet_ns_disable() waits on that completion and calls
>>    nvmet_ns_dev_disable().
>> * For a block device, nvmet_ns_dev_disable() calls blkdev_put().
>> * The last blkdev_put() call calls disk_release().
>> * disk_release() calls blk_put_queue().
>> * The last blk_put_queue() call calls blk_release_queue().
>> * blk_release_queue() frees struct request_queue.
>> * blk_mq_complete_request_remote() dereferences req->q.
> 
> The analysis is correct, specifically for loop transport, but it is not
> the same request_queue...
> 
> blk_mq_complete_request_remote references the initiator block device
> created from the namespace, but nvmet_ns_dev_disable puts the backend
> blockdev, which is a separate blockdev...
> 
> Maybe I'm misunderstanding your point?

And specifically your stack trace references nvmet_execute_io_connect
which is not addressed to a namespace... This I think that the
request_queue is actually the ctrl->connect_q, which is used for
io_connect commands.

It is unclear to me how this one ended up with a use-after-free...
Maybe we have a stray io_connect command lingering after we teardown
the controller?
