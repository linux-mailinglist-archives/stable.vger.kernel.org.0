Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C23F591FA8
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 13:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiHNLpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 07:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHNLpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 07:45:05 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC973894
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 04:45:03 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id az6-20020a05600c600600b003a530cebbe3so2680848wmb.0
        for <stable@vger.kernel.org>; Sun, 14 Aug 2022 04:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=oJkvmKunXVSksj7R/HAFL2ci6t3b+CqKjsYz3hT1qLU=;
        b=qecOOtKMN0bBPUbZFWM+isNInYO/1oTGMLhsslWRP5eYC3HlZEhUoXRdcoLOY8MHTt
         ExGlvOD7S2lj+KjuckEuGjjLkQCvB2aagydnFIUCxFdNZGdpUzZf+Uh/MsBYGKRb9aLt
         LBmuIym2xL8MnHFfBVPBOYwoMZNbNgh61KkK5Qxc5fXlyvk3F1b7Az1I+/QK9hY+Z2LR
         j9lITi69IRNrOm7/uZGWXqSI5dWyKbx9AcITPXiT+uuCkQcPOpSqnC7jcp4HVSVdS2GE
         TQQjieqqAKn4wzm4O8KnFyzOGsCfIAtzXnDp7II9htNCkf+OlNfcKc27iKQw9+Qmx1Tm
         aPDw==
X-Gm-Message-State: ACgBeo1+4FjQQu5t9Wn8ADWpqYF/S1xhnQvglkLrj2Qo/UvdYKHHSnj4
        M/Eeq8RDqGcm0TGSJqnBSGs=
X-Google-Smtp-Source: AA6agR4ltvGkupz/rqsMcjKS9QULwEmIOcUbz7a2Fn3N13hKX94gQ6EKU6V45IHb5hVDxTdqUIAQ8Q==
X-Received: by 2002:a05:600c:35d5:b0:3a3:2490:c984 with SMTP id r21-20020a05600c35d500b003a32490c984mr14257898wmq.162.1660477501979;
        Sun, 14 Aug 2022 04:45:01 -0700 (PDT)
Received: from [10.100.102.14] (85.65.248.193.dynamic.barak-online.net. [85.65.248.193])
        by smtp.gmail.com with ESMTPSA id h3-20020a05600c2ca300b003a5ea1cc63csm2448159wmc.39.2022.08.14.04.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 04:45:01 -0700 (PDT)
Message-ID: <cd2189da-59b3-c01e-9bd3-5f838258c7bc@grimberg.me>
Date:   Sun, 14 Aug 2022 14:45:00 +0300
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
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220812210317.2252051-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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



On 8/13/22 00:03, Bart Van Assche wrote:
> Fix the following use-after-free complaint triggered by blktests nvme/004:
> 
> BUG: KASAN: user-memory-access in blk_mq_complete_request_remote+0xac/0x350
> Read of size 4 at addr 0000607bd1835943 by task kworker/13:1/460
> Workqueue: nvmet-wq nvme_loop_execute_work [nvme_loop]
> Call Trace:
>   show_stack+0x52/0x58
>   dump_stack_lvl+0x49/0x5e
>   print_report.cold+0x36/0x1e2
>   kasan_report+0xb9/0xf0
>   __asan_load4+0x6b/0x80
>   blk_mq_complete_request_remote+0xac/0x350
>   nvme_loop_queue_response+0x1df/0x275 [nvme_loop]
>   __nvmet_req_complete+0x132/0x4f0 [nvmet]
>   nvmet_req_complete+0x15/0x40 [nvmet]
>   nvmet_execute_io_connect+0x18a/0x1f0 [nvmet]
>   nvme_loop_execute_work+0x20/0x30 [nvme_loop]
>   process_one_work+0x56e/0xa70
>   worker_thread+0x2d1/0x640
>   kthread+0x183/0x1c0
>   ret_from_fork+0x1f/0x30
> 
> Cc: stable@vger.kernel.org
> Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/nvme/target/core.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
> index a1345790005f..7f4083cf953a 100644
> --- a/drivers/nvme/target/core.c
> +++ b/drivers/nvme/target/core.c
> @@ -735,6 +735,8 @@ static void nvmet_set_error(struct nvmet_req *req, u16 status)
>   
>   static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
>   {
> +	struct nvmet_ns *ns = req->ns;
> +
>   	if (!req->sq->sqhd_disabled)
>   		nvmet_update_sq_head(req);
>   	req->cqe->sq_id = cpu_to_le16(req->sq->qid);
> @@ -745,9 +747,9 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
>   
>   	trace_nvmet_req_complete(req);
>   
> -	if (req->ns)
> -		nvmet_put_namespace(req->ns);
>   	req->ops->queue_response(req);
> +	if (ns)
> +		nvmet_put_namespace(ns);

Why did the put change position?
I'm not exactly clear what was used-after-free here..

>   }
>   
>   void nvmet_req_complete(struct nvmet_req *req, u16 status)
