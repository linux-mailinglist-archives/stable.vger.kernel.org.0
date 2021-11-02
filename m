Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04373443871
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 23:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhKBW3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 18:29:44 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:43654 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhKBW3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 18:29:42 -0400
Received: by mail-pg1-f182.google.com with SMTP id b4so620101pgh.10;
        Tue, 02 Nov 2021 15:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LPagmY9ax5jGwuuYaLAQO2StTmpuEoeH5CDXl+WMcP0=;
        b=mzdk7bA0Tzx2fOS9H/zthww5CmGblzRU04TxVH1RbXpuSR4fGwcI0G+pOUbY5JTtYN
         DPrqXwv7tOKikYpy0lOitY+f9JHAwDJSiwdUlBb7OovXT44plkz1FCQ3iWx/ms8Cq1RP
         OUsBJh4KsTGmL0Tl5jgTe1ZkyjnyuImE7dnZeygVQ8dShKxEHlnA2VDJSkQ3mhGaZVU0
         PnosyalokxEOxFZ/KUwDbiWTmoe6lqsJEBQU0a5rcd+k4NjooRuvxCVCDMZGoEiKJuhN
         mPn6/01+7FscaEe0hdsOvyrDujh5wHOBQhDwa61vG2h4R1Eh+mYO/fcgZLZOaymZLEfF
         6Dqw==
X-Gm-Message-State: AOAM530UkzUplXnZcn9AdJTzaXNf85nPuiaYeHoxOcK8UYkUHA7kVT8r
        bQ2t5Re8uJMypR4dax6lOV0=
X-Google-Smtp-Source: ABdhPJyj7hc3qRc+L8ZUozDCjohl33jRvYGbO4S0ha0Ex/fT1ibQcpQs4rSMq4fAuqpnUDiF39UpnQ==
X-Received: by 2002:a63:9f1a:: with SMTP id g26mr29819553pge.170.1635892027169;
        Tue, 02 Nov 2021 15:27:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:55da:34a:7577:bc7])
        by smtp.gmail.com with ESMTPSA id y7sm101248pge.44.2021.11.02.15.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 15:27:06 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: initialize cmd->cmnd before it is used
To:     Tadeusz Struk <tadeusz.struk@linaro.org>, dgilbert@interlog.com,
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
 <17a1b72e-2c2a-8492-cb92-4dec36a6531d@acm.org>
 <cad499a9-7587-1fa9-9f7d-223e66a18efa@interlog.com>
 <f80fd188-a0e5-2e75-506c-3e82d138fe28@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9115c893-3fcd-ae81-7422-723ae5370319@acm.org>
Date:   Tue, 2 Nov 2021 15:27:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f80fd188-a0e5-2e75-506c-3e82d138fe28@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/2/21 3:22 PM, Tadeusz Struk wrote:
> Do you want me to send a patch with the check in scsi_fill_sghdr_rq()?
> I want to close the mentioned syzbot issue in 5.10. I can also do the
> back-porting if anything will be required.

Hi Tadeusz,

I think we need two patches: one for the SG_IO code that rejects SG_IO
requests if the CDB length is not valid and a second patch that removes
the code from scsi_lib.c for assigning the CDB length. Please let me
know if you would not have the time to work on this.

Bart.


