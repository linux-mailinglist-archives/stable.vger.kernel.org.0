Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD62442197
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 21:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhKAUWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 16:22:55 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:44677 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhKAUWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 16:22:55 -0400
Received: by mail-pl1-f179.google.com with SMTP id t11so12453552plq.11;
        Mon, 01 Nov 2021 13:20:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j1U5qGsWwCMuBW5qFzTSEwVzbsSHV/ZSRfO6rUZPjqU=;
        b=NyTzmNh5F0C6gF6SRn8FDLZuBzi2WL5ZG+A2DG75+BhMVvmOoKFqgcea0GgJalvyTd
         JjRBNuHNtncR347FkkWMObzKUNBeuN1DMNtRMtC9e4rr7veKOF+QrdPOZ2pDYC5h3sfB
         NuUn1ckqcgjL/U83v46oKbSurHuKKyZWPNrLyu+s8zMt0OWjPpNmB5EXIdF8YfpwH7Zy
         007uOWbqHUHL/uyOvsTZwPjAxD7y0bdWGdxsI5gcd2giKgDQO/IYMLHvk4VoBMRCeUv/
         agggT7bydafZwmSGZZivl8N+HMr46QOnJQN0fwTeXxd64zyjE5Bmt1eBpF1rrxMbFjCU
         R9fA==
X-Gm-Message-State: AOAM533U/87/QmObRUCW9rALWBOzB6ULZB0YRsJwQGgOUcagNbfOverc
        14rS3JcmNRkvQwkkV41xG8Qcp0gzMSsnSQ==
X-Google-Smtp-Source: ABdhPJywCa6uSFJnDDsbcvia0CHaouYjt9eQNYm2xU3c/adP4Mauo2dX+VEjABRokXvNGNBDNk7ZLA==
X-Received: by 2002:a17:90a:d0f:: with SMTP id t15mr1264025pja.7.1635798021083;
        Mon, 01 Nov 2021 13:20:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:45ec:8a15:a0bc:b1ed])
        by smtp.gmail.com with ESMTPSA id s17sm13773403pge.50.2021.11.01.13.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 13:20:20 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: initialize cmd->cmnd before it is used
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        linux-scsi@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5516b30f5401d4dcbcae@syzkaller.appspotmail.com,
        Doug Gilbert <dgilbert@interlog.com>
References: <20211101192417.324799-1-tadeusz.struk@linaro.org>
 <4cfa4049-aae5-51db-4ad2-b4c9db996525@acm.org>
 <0024e0e1-589c-e2cd-2468-f4af8ec1cb95@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <da8d3418-b95c-203d-16c3-8c4086ceaf73@acm.org>
Date:   Mon, 1 Nov 2021 13:20:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0024e0e1-589c-e2cd-2468-f4af8ec1cb95@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 1:13 PM, Tadeusz Struk wrote:
> On 11/1/21 13:06, Bart Van Assche wrote:
>> This patch is a duplicate and has been posted before.
>>
>> Please take a look at https://lore.kernel.org/linux-scsi/20210904064534.1919476-1-qiulaibin@huawei.com/.
>>  From the replies to that email:
>> "> Thinking further about this: is there any code left that depends on
>>  > scsi_setup_scsi_cmnd() setting cmd->cmd_len? Can the cmd->cmd_len
>>  > assignment be removed from scsi_setup_scsi_cmnd()?
>>
>> cmd_len should never be 0 now, so I think we can remove it."
> 
> Thanks for quick response, but I'm not sure if statement
> "cmd_len should never be 0 now" is correct, because the cmd_len is
> in fact equal to 0 here and this BUG can be triggered on mainline, 5.14,
> and 5.10 stable kernels.

(+Doug Gilbert)

One of the functions in the call stack in the first message of this email
thread is sg_io(). I am not aware of any documentation that specifies whether
it is valid to set cmd_len in the sg_io header to zero. My opinion is that
the SG_IO implementation should either reject cmd_len == 0 or set cmd_len
to a valid value if it is zero.

Bart.


