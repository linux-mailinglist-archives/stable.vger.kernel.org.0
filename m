Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA9B705B8
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbfGVQvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 12:51:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35452 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbfGVQvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 12:51:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id s1so11626050pgr.2;
        Mon, 22 Jul 2019 09:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sx4jGeZD1NAFZD3tRCTmaYml1fVFOhGJ/2sRj2Sic6g=;
        b=laMC66jr1i34BApU20ATF+b80NLJrA5zDeYpvIrHvBFtGcdgpPd0Qe5aJjJQHtK1BX
         IH48OJKSvKpRS4X1pABnMSdZMHQOaxCaIGeKrKgIjBnEmQLKZYB7YgtF/aNdnQpZn9+T
         irxA7qVgJw7SShS8FXcIWUJ7PJj+Ejr4q8aYLKn1NHxgsAQXaVSnwTZbLetMO0zPad55
         bcJL/s2nRjqabKNd2WWOp4ddpAZTXy6ASGCYzvSgOKA1BeByCIEE0Y84jaRRO5t4pPef
         wAvsA6bMtOTNjO/n89tLganov9F4m5E3q2tpD6LIIOcY45TTFDNYw1QirUk7TAFEjbxR
         dNRw==
X-Gm-Message-State: APjAAAV8O6j1bHUJeTXvAxIoSWt4JM3onAAyGIjqbREmq2SutfkgoWZQ
        lKLsagGnrVgmoc188q2v+eX2T83i
X-Google-Smtp-Source: APXvYqzgKB+ahambBQH5r+rB5Xfqr8ZuYUyKs+7UZ6PacGfkrBMgMtfp+VqBqVxhZA1PNYh9nmwRsw==
X-Received: by 2002:a17:90a:3247:: with SMTP id k65mr34724555pjb.49.1563814290331;
        Mon, 22 Jul 2019 09:51:30 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m4sm75534750pff.108.2019.07.22.09.51.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 09:51:29 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] blk-mq: add callback of .cleanup_rq
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
References: <20190720030637.14447-1-ming.lei@redhat.com>
 <20190720030637.14447-2-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4ffe9dd8-9e86-fd93-828e-78c1e5931c5f@acm.org>
Date:   Mon, 22 Jul 2019 09:51:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190720030637.14447-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/19 8:06 PM, Ming Lei wrote:
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b038ec680e84..fc38d95c557f 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -502,6 +502,9 @@ void blk_mq_free_request(struct request *rq)
>   	struct blk_mq_ctx *ctx = rq->mq_ctx;
>   	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
>   
> +	if (q->mq_ops->cleanup_rq)
> +		q->mq_ops->cleanup_rq(rq);
> +
>   	if (rq->rq_flags & RQF_ELVPRIV) {
>   		if (e && e->type->ops.finish_request)
>   			e->type->ops.finish_request(rq);

I'm concerned about the performance impact of this change. How about not 
introducing .cleanup_rq() and adding a call to
scsi_mq_uninit_cmd() in scsi_queue_rq() just before that function 
returns BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE?

Thanks,

Bart.
