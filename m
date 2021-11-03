Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27FF4446DF
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhKCRU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:20:28 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:35400 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhKCRU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 13:20:28 -0400
Received: by mail-pj1-f46.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so1928044pje.0;
        Wed, 03 Nov 2021 10:17:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z5t0d+gRdOOdUtLccG4kB8aZNuMShtmwN1sAfSZJiMc=;
        b=uHTvxAsdrQpKaVM4lj99ry8b5cz5scLkpTUEkK2FrZa6gW3OEtryNoHnSwKgtELJnW
         glkD6V9v2iN8zH+jP3jZwCj0+VGKs3FHIqLFUooxEzHi2VlJnT+Aegw7o97+06T3MdUY
         4TPsshlqXw+w0ORXwhvkDOYr7Vc58CSpDbAZPLuHyuFT4xINAh8vNgMgFjip7RImaz1p
         tUfEgfj9ZBvIiCyM7ZqC1/YsjfC9IkoAuwMFm2YWpOJfts41ZrGwokrbDbUavejR31iW
         85SnTK/ldI78PtwI5el3/dQ5j8zNArzss7hXxPoejomPntSL7xwJRDGltNmZ3WY/IvSe
         myQw==
X-Gm-Message-State: AOAM532sL3iFGHHyy10H/Ebr1bQTgEdZQTiMxaBWB1fwMssWWRVftA2r
        oDknNgWIhajpQUCVCZ2oye0=
X-Google-Smtp-Source: ABdhPJzvIOyRUzMbFtvi+f9tE2NzknrnoaAEyOYdQgHRyzdntEMFGa22GC9rcp2U2PAe9+M0tT1TRQ==
X-Received: by 2002:a17:902:b696:b0:141:afeb:a40c with SMTP id c22-20020a170902b69600b00141afeba40cmr33144821pls.38.1635959871676;
        Wed, 03 Nov 2021 10:17:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9416:5327:a40e:e300])
        by smtp.gmail.com with ESMTPSA id z3sm3065481pfh.79.2021.11.03.10.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 10:17:51 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] scsi: core: remove command size deduction from
 scsi_setup_scsi_cmnd
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
References: <20211103170659.22151-1-tadeusz.struk@linaro.org>
 <20211103170659.22151-2-tadeusz.struk@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <35006864-549a-20bd-e03e-2ab449a1cc6e@acm.org>
Date:   Wed, 3 Nov 2021 10:17:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211103170659.22151-2-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/3/21 10:06 AM, Tadeusz Struk wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 572673873ddf..e026da7549be 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1174,8 +1174,6 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
>   	}
>   
>   	cmd->cmd_len = scsi_req(req)->cmd_len;
> -	if (cmd->cmd_len == 0)
> -		cmd->cmd_len = scsi_command_size(cmd->cmnd);
>   	cmd->cmnd = scsi_req(req)->cmd;
>   	cmd->transfersize = blk_rq_bytes(req);
>   	cmd->allowed = scsi_req(req)->retries;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


