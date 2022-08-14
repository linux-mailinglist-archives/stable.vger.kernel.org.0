Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CCC592022
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 16:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiHNOY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 10:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiHNOY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 10:24:56 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6203F5BD
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 07:24:54 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id gj1so5008922pjb.0
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 07:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Nu1E7AmmDIl2LFiTiOoUmoMGabBpkxzR1LmY2ZhmWkw=;
        b=vG9q/YrUj91l+GGKWMq3E1BBF5tLYw2AQazeMZaYOdh5hD1y44oYRgJuPTtMR+giI7
         CbMUlmuuxiZGJdlvB9l5RdLQsAIkcOuo4Dq/0vg6oIInurxC40V2m63jyahNvUWmubb9
         u3Zk97MGNcxa0ErNCamoIPT5R3YnMGNeBoAaIVYpI1Vdx/MwfxSyjs+v1SDK/qM9APbw
         /ybQ3LoaXcRTD9nlT26uwzy4bXcpuwo0BwoJxovVnJ1VDRZgdUPyWdBJWusHfvNG0Ehn
         0nLJle8gAgWzbATOo8yTIQmpJoASH+dbIXwz+jPFLSQj/kACkThEf75G8Zcg030N9IkR
         s5yA==
X-Gm-Message-State: ACgBeo2s3CB8b+Yve6sIyPPVbi43b/P3q8l9I0+Aiy/4EG2DGUxu3MzC
        L4PuZOvCOxTNFiAqG2ZNV1+DnCVtq/U=
X-Google-Smtp-Source: AA6agR5HCgWAcQjNp29LelwPDbPAB0mm64U/w5KM+jlUo+hz5aRdPoEqZyCP7VVUl818K/V7bQ1yRA==
X-Received: by 2002:a17:902:6808:b0:170:9453:8203 with SMTP id h8-20020a170902680800b0017094538203mr12696076plk.24.1660487094199;
        Sun, 14 Aug 2022 07:24:54 -0700 (PDT)
Received: from [192.168.3.217] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f7-20020a623807000000b0052acb753b8bsm5156039pfa.158.2022.08.14.07.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 07:24:53 -0700 (PDT)
Message-ID: <9ec2e292-1e75-8ee2-a9fc-d5adfab92fbd@acm.org>
Date:   Sun, 14 Aug 2022 07:24:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] nvmet: Fix a use-after-free
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        stable@vger.kernel.org
References: <20220812210317.2252051-1-bvanassche@acm.org>
 <cd2189da-59b3-c01e-9bd3-5f838258c7bc@grimberg.me>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cd2189da-59b3-c01e-9bd3-5f838258c7bc@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/14/22 04:45, Sagi Grimberg wrote:
> On 8/13/22 00:03, Bart Van Assche wrote:
>> @@ -745,9 +747,9 @@ static void __nvmet_req_complete(struct nvmet_req 
>> *req, u16 status)
>>       trace_nvmet_req_complete(req);
>> -    if (req->ns)
>> -        nvmet_put_namespace(req->ns);
>>       req->ops->queue_response(req);
>> +    if (ns)
>> +        nvmet_put_namespace(ns);
> 
> Why did the put change position?
> I'm not exactly clear what was used-after-free here..

Hi Sagi,

Is my understanding correct that the NVMe target namespace owns the 
block device `req` is associated with and hence that the namespace 
reference count must only be dropped after dereferencing the `req` 
pointer has finished?

This is what I found in the NVMe target code:
* nvmet_put_namespace() decreases ns->ref.
* Dropping the last ns->ref causes nvmet_destroy_namespace() to be
   called. That function completes ns->disable_done.
* nvmet_ns_disable() waits on that completion and calls
   nvmet_ns_dev_disable().
* For a block device, nvmet_ns_dev_disable() calls blkdev_put().
* The last blkdev_put() call calls disk_release().
* disk_release() calls blk_put_queue().
* The last blk_put_queue() call calls blk_release_queue().
* blk_release_queue() frees struct request_queue.
* blk_mq_complete_request_remote() dereferences req->q.

Thanks,

Bart.
