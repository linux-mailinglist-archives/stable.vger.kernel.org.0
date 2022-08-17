Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35882596C99
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 12:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiHQKJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 06:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238846AbiHQKJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 06:09:41 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1DE52FE9
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 03:09:36 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id z16so15597529wrh.12
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 03:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=flCOnruedLv/caOc0xS1W4+CLvteqbYSWbjqjDLk1pw=;
        b=1KI6wA2PBEXD0FIjXirGfgQrX0qkIJwL98XF0//OpRIRtWoshjlFaj1VoJONFbQpvJ
         AfHKaC0bHbtDozG1SH9Y8BiXEfTKUaPe8UGLcdy9VwBBanyem2IMXiaUpMFcUfULHMRe
         gm6mwu/e+64tIw5s4VAn1JdN+2zTf+M4Ho6Iioa5rcvztQVXaijWKqL0SiQ7lv3h524c
         zAp/C0Htg0zR0RdqwzXy/AyaTrH7DrIsn3SECfImlzp2gx+oAmP2fD+yKB+Hwj3qwtef
         yE6u0Jaqbrb2Zts6yCG0elZzkubPdTHzqnEGvNxSSjPhxkUkxHsvuPQ7dcDJ6iFqgIMU
         ytcg==
X-Gm-Message-State: ACgBeo2194PYZi54EN46EKwSaa1MMDz1zCr6KOboDdpAmAWUSSBMMKCv
        z6Apski9LbuRocHAzVMrXvE=
X-Google-Smtp-Source: AA6agR5v7tQeU6EUN3CIVkxj/oIkGbYDtgmcYWMPYvXVZRSVD+BKHKjDLX4ksJ0jRB15bSLY34yrFg==
X-Received: by 2002:a5d:6501:0:b0:220:5f19:de73 with SMTP id x1-20020a5d6501000000b002205f19de73mr14033363wru.713.1660730975113;
        Wed, 17 Aug 2022 03:09:35 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id s3-20020a5d69c3000000b00225232154d7sm1766323wrw.110.2022.08.17.03.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 03:09:33 -0700 (PDT)
Message-ID: <3b12abd3-ba64-7811-8f1f-66dbb368cf66@grimberg.me>
Date:   Wed, 17 Aug 2022 13:09:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] nvmet: Fix a use-after-free
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        stable@vger.kernel.org
References: <20220812210317.2252051-1-bvanassche@acm.org>
 <cd2189da-59b3-c01e-9bd3-5f838258c7bc@grimberg.me>
 <9ec2e292-1e75-8ee2-a9fc-d5adfab92fbd@acm.org>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <9ec2e292-1e75-8ee2-a9fc-d5adfab92fbd@acm.org>
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


>>> @@ -745,9 +747,9 @@ static void __nvmet_req_complete(struct nvmet_req 
>>> *req, u16 status)
>>>       trace_nvmet_req_complete(req);
>>> -    if (req->ns)
>>> -        nvmet_put_namespace(req->ns);
>>>       req->ops->queue_response(req);
>>> +    if (ns)
>>> +        nvmet_put_namespace(ns);
>>
>> Why did the put change position?
>> I'm not exactly clear what was used-after-free here..
> 
> Hi Sagi,
> 
> Is my understanding correct that the NVMe target namespace owns the 
> block device `req` is associated with and hence that the namespace 
> reference count must only be dropped after dereferencing the `req` 
> pointer has finished?
> 
> This is what I found in the NVMe target code:
> * nvmet_put_namespace() decreases ns->ref.
> * Dropping the last ns->ref causes nvmet_destroy_namespace() to be
>    called. That function completes ns->disable_done.
> * nvmet_ns_disable() waits on that completion and calls
>    nvmet_ns_dev_disable().
> * For a block device, nvmet_ns_dev_disable() calls blkdev_put().
> * The last blkdev_put() call calls disk_release().
> * disk_release() calls blk_put_queue().
> * The last blk_put_queue() call calls blk_release_queue().
> * blk_release_queue() frees struct request_queue.
> * blk_mq_complete_request_remote() dereferences req->q.

The analysis is correct, specifically for loop transport, but it is not
the same request_queue...

blk_mq_complete_request_remote references the initiator block device
created from the namespace, but nvmet_ns_dev_disable puts the backend
blockdev, which is a separate blockdev...

Maybe I'm misunderstanding your point?
