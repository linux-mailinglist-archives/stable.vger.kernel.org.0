Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D77770405
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 17:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfGVPk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 11:40:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43727 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfGVPk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 11:40:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so17558831pfg.10;
        Mon, 22 Jul 2019 08:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9VDIEaBQFbumPn4Bce8zgt7MQLL9xp5pDaU4ejJmVDg=;
        b=HbXbSf2siFI7RoYBcjwG5qMJdJ8iaUBVB23bvupFZQD/G4zq+YDi7IvYLEjXqTJzWA
         SqJDhlEyGEfri/a8yfalssNSK8+VHjQgXp3mgrM/sHd4P0PFfJz1mDgSTdp4mHWS1jyW
         JgZJm8n4FMol+6nIvasgb5WI+RgJs5cgs6nygik1s+zGAEZi3/ju8mew6R7WXMl275zW
         pP+b9VawFvXi9gQkWuE/PsGmjiTwRIutqm1a9QwpJ2OMT6ZuRR2QipLflTTf2gRSHZFb
         6Rshd+tYuexauHmtQ92bThJ7/PDEnr3Mmp8lctyNu2LiVdUSGqxlYAX2n1nb3g5nAhw1
         Ro7A==
X-Gm-Message-State: APjAAAVRNJV3+AFnCzkY84Jhko3E5vHKY1yjwdOCPSljBpCOrXVPw0Wq
        nNK6rD5Xr2iBHs1A1XXQUjM73GRG
X-Google-Smtp-Source: APXvYqzPGeYPDGcgeAkgH93yM2lKMQlRZowrweQeb+g1Y8vjkzbLJ9ZNl2ah7SODOkL9aCxA75AdGg==
X-Received: by 2002:a17:90a:b312:: with SMTP id d18mr75654365pjr.35.1563810025966;
        Mon, 22 Jul 2019 08:40:25 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 85sm41323334pfv.130.2019.07.22.08.40.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 08:40:24 -0700 (PDT)
Subject: Re: [PATCH V2 2/2] scsi: implement .cleanup_rq callback
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
 <20190720030637.14447-3-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <eed624d5-0585-699c-9084-9f5f0ea09e52@acm.org>
Date:   Mon, 22 Jul 2019 08:40:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190720030637.14447-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/19 8:06 PM, Ming Lei wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e1da8c70a266..52537c145762 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -154,12 +154,9 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
>   
>   static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
>   {
> -	if (cmd->request->rq_flags & RQF_DONTPREP) {
> -		cmd->request->rq_flags &= ~RQF_DONTPREP;
> -		scsi_mq_uninit_cmd(cmd);
> -	} else {
> -		WARN_ON_ONCE(true);
> -	}
> +	WARN_ON_ONCE(!(cmd->request->rq_flags & RQF_DONTPREP));
> +
> +	scsi_mq_uninit_cmd(cmd);
>   	blk_mq_requeue_request(cmd->request, true);
>   }

The above changes are independent of this patch series. Have you 
considered to move these into a separate patch?

> +/*
> + * Only called when the request isn't completed by SCSI, and not freed by
> + * SCSI
> + */
> +static void scsi_cleanup_rq(struct request *rq)
> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> +
> +	scsi_mq_uninit_cmd(cmd);
> +}

Is the comment above this function correct? The previous patch adds an 
unconditional call to mq_ops->cleanup_rq() in blk_mq_free_request().

Thanks,

Bart.
