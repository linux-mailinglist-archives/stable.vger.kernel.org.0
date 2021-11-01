Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D68442163
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 21:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhKAUJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 16:09:08 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:46595 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhKAUIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 16:08:52 -0400
Received: by mail-pg1-f178.google.com with SMTP id m21so18101659pgu.13;
        Mon, 01 Nov 2021 13:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rDPPEJZ4PfaljzqU6KzVa+Vi1ojm/Vf50IsAhnSSHec=;
        b=6AkwtufCG0tJWSCVMaLxMXIwQkyL+e14+K1rEDYxAfYg6W9QSPjn/LYUvr2zHdQUCA
         FAgWL02iQTindofUVZamGijIyFNQPpWcH+30qc4dqDc0615vclP/Mxww3RwpxiXBSMtl
         QFeDiNQAQjQebiTRecJv812HUBNKC5076b5nT1zQueLqiS1/11s8xz15GRz8dEH1lbAH
         CjgZgpuq+Yip4nYhQyfEHjUQbjGsutU0FE4BtwzO/eX98T3pp7LsXj35oz2n1AKW/VWZ
         5TJKlz4MUAsvvD5PELnYhNBUA/Ed9e6TBSgsWqRewhz0oCtngdMeP2PcCZ3yh54uNVP3
         zWIw==
X-Gm-Message-State: AOAM531UiUz3GEVWJwSZHrmDUNk1DGl2Qi90zmMppEzO/dCGbqo2UiWS
        hdshQtvp2RUUwEV2eZbhsJo=
X-Google-Smtp-Source: ABdhPJyD2Xgy2dv8OkS7CNR1d3KyglXggCufucfVZKnYVQYEB5rfGsTQTek+QYqTVvxxQtxIe3QLsQ==
X-Received: by 2002:a05:6a00:23d5:b0:47c:236d:65b4 with SMTP id g21-20020a056a0023d500b0047c236d65b4mr30828831pfc.52.1635797178045;
        Mon, 01 Nov 2021 13:06:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:45ec:8a15:a0bc:b1ed])
        by smtp.gmail.com with ESMTPSA id h11sm13469159pfc.131.2021.11.01.13.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 13:06:17 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: initialize cmd->cmnd before it is used
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
References: <20211101192417.324799-1-tadeusz.struk@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4cfa4049-aae5-51db-4ad2-b4c9db996525@acm.org>
Date:   Mon, 1 Nov 2021 13:06:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211101192417.324799-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 12:24 PM, Tadeusz Struk wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 572673873ddf..cd4b57747448 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1173,10 +1173,10 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
>   		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
>   	}
>   
> +	cmd->cmnd = scsi_req(req)->cmd;
>   	cmd->cmd_len = scsi_req(req)->cmd_len;
>   	if (cmd->cmd_len == 0)
>   		cmd->cmd_len = scsi_command_size(cmd->cmnd);
> -	cmd->cmnd = scsi_req(req)->cmd;
>   	cmd->transfersize = blk_rq_bytes(req);
>   	cmd->allowed = scsi_req(req)->retries;
>   	return BLK_STS_OK;

This patch is a duplicate and has been posted before.

Please take a look at https://lore.kernel.org/linux-scsi/20210904064534.1919476-1-qiulaibin@huawei.com/.
 From the replies to that email:
"> Thinking further about this: is there any code left that depends on
 > scsi_setup_scsi_cmnd() setting cmd->cmd_len? Can the cmd->cmd_len
 > assignment be removed from scsi_setup_scsi_cmnd()?

cmd_len should never be 0 now, so I think we can remove it."

Thanks,

Bart.

