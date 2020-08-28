Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEB425534A
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 05:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgH1D1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 23:27:53 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39642 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgH1D1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 23:27:53 -0400
Received: by mail-pj1-f68.google.com with SMTP id s2so3047031pjr.4;
        Thu, 27 Aug 2020 20:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZNfdUVEKwoE3V2VlwICXVLqoeLGJj5IiBXaUyBDGtyM=;
        b=QmDPv0aXpcqwghy/xmncoqEbREjNKe1BV3JXPo58sCOQ+SIIeSp+7SBuZtTRUT/mmR
         ZlD4mXX/XukP7EbQRqUElg1T24ketOIQaHNSjwxsO7d9AySfePGj94/g50FA43w61EtU
         oWMmu6eTxWqmOy5oe+grxDuFsDlyrzmiFwcG6K64IdgnKDwTmMKxe1nFbsyXAlsIuSUw
         acM8SRbISLvL0EJCu/jw5WR74la7o05kNKwChaYCP6zst76p1VEnRcImqAT9ko6roZ+U
         RPx1HXJagKZctYhDD44/nK6d5MscnG2fQMZ5g+GBTQ17nS0UO3FVwrdQoP9UTOXSF4gS
         8/fQ==
X-Gm-Message-State: AOAM532KCo1YkPIAU7Hy5EftwIV6BI5giab8hfMe3aeDUzXoEyhl28eo
        k+UmVwyYydIqUhbyLbYuV0S0BhIcx2M=
X-Google-Smtp-Source: ABdhPJwQcAdgU/gF60fp0y/dwv4ha89SyKaP823HuRtEjDju89cVtMsLjgVwAqUPK2t11hedEj7Whg==
X-Received: by 2002:a17:90a:fe83:: with SMTP id co3mr670556pjb.157.1598585272180;
        Thu, 27 Aug 2020 20:27:52 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w3sm4570478pff.56.2020.08.27.20.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 20:27:51 -0700 (PDT)
Subject: Re: [PATCH] block: Fix a race in the runtime power management code
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20200824030607.19357-1-bvanassche@acm.org>
 <1598346681.10649.8.camel@mtkswgap22>
 <20200825182423.GB375466@rowland.harvard.edu>
 <1f798c21-241f-59f8-5298-a32fffe2ff01@acm.org>
 <20200826015159.GA387575@rowland.harvard.edu>
 <af1b1f57-59ff-0133-8108-0f3d1e1254e1@acm.org>
 <20200827203321.GB449067@rowland.harvard.edu>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <5da883fe-b5ec-b98d-ae0c-bc053b6e22cb@acm.org>
Date:   Thu, 27 Aug 2020 20:27:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827203321.GB449067@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-27 13:33, Alan Stern wrote:
> It may not need to be that complicated.  what about something like this?
> 
> Index: usb-devel/block/blk-core.c
> ===================================================================
> --- usb-devel.orig/block/blk-core.c
> +++ usb-devel/block/blk-core.c
> @@ -420,11 +420,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
>  /**
>   * blk_queue_enter() - try to increase q->q_usage_counter
>   * @q: request queue pointer
> - * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
> + * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PM
>   */
>  int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>  {
> -	const bool pm = flags & BLK_MQ_REQ_PREEMPT;
> +	const bool pm = flags & BLK_MQ_REQ_PM;
>  
>  	while (true) {
>  		bool success = false;
> @@ -626,7 +626,8 @@ struct request *blk_get_request(struct r
>  	struct request *req;
>  
>  	WARN_ON_ONCE(op & REQ_NOWAIT);
> -	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
> +	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT |
> +			BLK_MQ_REQ_PM));
>  
>  	req = blk_mq_alloc_request(q, op, flags);
>  	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
> Index: usb-devel/drivers/scsi/scsi_lib.c
> ===================================================================
> --- usb-devel.orig/drivers/scsi/scsi_lib.c
> +++ usb-devel/drivers/scsi/scsi_lib.c
> @@ -245,11 +245,15 @@ int __scsi_execute(struct scsi_device *s
>  {
>  	struct request *req;
>  	struct scsi_request *rq;
> +	blk_mq_req_flags_t mq_req_flags;
>  	int ret = DRIVER_ERROR << 24;
>  
> +	mq_req_flags = BLK_MQ_REQ_PREEMPT;
> +	if (rq_flags & RQF_PM)
> +		mq_req_flags |= BLK_MQ_REQ_PM;
>  	req = blk_get_request(sdev->request_queue,
>  			data_direction == DMA_TO_DEVICE ?
> -			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
> +			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, mq_req_flags);
>  	if (IS_ERR(req))
>  		return ret;
>  	rq = scsi_req(req);
> Index: usb-devel/include/linux/blk-mq.h
> ===================================================================
> --- usb-devel.orig/include/linux/blk-mq.h
> +++ usb-devel/include/linux/blk-mq.h
> @@ -435,6 +435,8 @@ enum {
>  	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
>  	/* set RQF_PREEMPT */
>  	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
> +	/* used for power management */
> +	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 4),
>  };
>  
>  struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,

I think this patch will break SCSI domain validation. The SCSI domain
validation code calls scsi_device_quiesce() and that function in turn calls
blk_set_pm_only(). The SCSI domain validation code submits SCSI commands with
the BLK_MQ_REQ_PREEMPT flag. Since the above code postpones such requests
while blk_set_pm_only() is in effect, I think the above patch will cause the
SCSI domain validation code to deadlock.

Bart.


