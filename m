Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224034425E6
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 04:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhKBDJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 23:09:15 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:41858 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhKBDJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 23:09:15 -0400
Received: by mail-pl1-f177.google.com with SMTP id k4so3967939plx.8;
        Mon, 01 Nov 2021 20:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sRFLt+ScwC+b6JXHsh7TwBXtQ96PKTlE+P2DMsJLhhs=;
        b=FcCe4/f+3Xg8dmHE0Kj0NAPeHu/r1im4y5i+/AC4/t459C8MmtJtRO2jxqzp7rj2Zk
         eW/ydBUeoZWutoYBnBYBldo75gKO6j8Z3EOymANhWWMJNdMAZVPOj2NjPe9psX/neByk
         S+yORPF/WVmRjHqUBj6E0B8hRI/znhbEKziq9xwMq4XNb7YSfgDwNf1AGomDG1tV4Z2f
         eWKuQeJYkH3dw1tAyhqAKzUy7njWNUJW3JaBE75Uij8njgVCGF5qVC+I/YbmYL1fGg7v
         aWaapEIbjsXbYr7y96Y97fmBn4/b+z/GxYBusnlXzYo7ACLIRwIrf6VRhSDVoQ48bBTM
         SQpg==
X-Gm-Message-State: AOAM533iURa9eeEG72DFzqXq8IgHNS/QBraUtzm0ywadzoEEjHLaISDH
        TGFhuD2AMd381Wi3w/prWes=
X-Google-Smtp-Source: ABdhPJwkWYOi+Mc8Z28I2BpP/jo7JaPVHapN3DGw0ezCNQ5DEAQ0Kf5GXkVA0qAyVFdOfGX6qxRhtg==
X-Received: by 2002:a17:90b:1e0e:: with SMTP id pg14mr3354228pjb.143.1635822400637;
        Mon, 01 Nov 2021 20:06:40 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:70a9:502a:2a58:d9ba? ([2601:647:4000:d7:70a9:502a:2a58:d9ba])
        by smtp.gmail.com with ESMTPSA id w5sm14147382pgp.79.2021.11.01.20.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 20:06:39 -0700 (PDT)
Message-ID: <17a1b72e-2c2a-8492-cb92-4dec36a6531d@acm.org>
Date:   Mon, 1 Nov 2021 20:06:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] scsi: core: initialize cmd->cmnd before it is used
Content-Language: en-US
To:     dgilbert@interlog.com, Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com
References: <20211101192417.324799-1-tadeusz.struk@linaro.org>
 <4cfa4049-aae5-51db-4ad2-b4c9db996525@acm.org>
 <0024e0e1-589c-e2cd-2468-f4af8ec1cb95@linaro.org>
 <da8d3418-b95c-203d-16c3-8c4086ceaf73@acm.org>
 <8fbb619a-37b3-4890-37e0-b586bdee49d6@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8fbb619a-37b3-4890-37e0-b586bdee49d6@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 18:56, Douglas Gilbert wrote:
> On 2021-11-01 4:20 p.m., Bart Van Assche wrote:
>> One of the functions in the call stack in the first message of this email
>> thread is sg_io(). I am not aware of any documentation that specifies 
>> whether
>> it is valid to set cmd_len in the sg_io header to zero. My opinion is 
>> that
>> the SG_IO implementation should either reject cmd_len == 0 or set cmd_len
>> to a valid value if it is zero.
> 
> For the sg driver in production, the v3 interface users (including
> ioctl(<sg_fd>, SG_IO,) ) have this check:
> 
>         if ((!hp->cmdp) || (hp->cmd_len < 6) || (hp->cmd_len > sizeof 
> (cmnd))) {
>                  sg_remove_request(sfp, srp);
>                  return -EMSGSIZE;
>          }

Hi Doug,

Thanks for having taken a look. I found the above check in 
sg_new_write(). To me that function seems to come from a code path that 
is unrelated to sg_io(), the function shown in the call stack in the 
email at the start of this thread. Maybe I overlooked something but I 
haven't found a minimum size check for hdr->cmd_len in sg_io() before 
the blk_execute_rq() call. Should such a check perhaps be added?

Thanks,

Bart.
