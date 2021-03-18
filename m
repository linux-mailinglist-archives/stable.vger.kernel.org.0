Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A4034058F
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 13:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhCRMcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 08:32:21 -0400
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:39232 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhCRMbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 08:31:55 -0400
Received: from [0.0.0.0] (unknown [14.154.29.151])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id C37BD400325;
        Thu, 18 Mar 2021 20:31:49 +0800 (CST)
Subject: Re: [PATCH] scsi: ses: Fix crash caused by kfree an invalid pointer
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <20201128122302.9490-1-dinghui@sangfor.com.cn>
 <c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
Message-ID: <34c15b48-c131-abd5-d4a5-1c273d25c0bf@sangfor.com.cn>
Date:   Thu, 18 Mar 2021 20:31:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTUNIGhlJGBgaHUNCVkpNSk1LTEtMSktLQkpVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kzo6Lhw*Vj8SLU4yKAEzSxIO
        ShEKFEJVSlVKTUpNS0xLTEpLT0lNVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKT1VKTk9VSUJVSk5KWVdZCAFZQUlDTU43Bg++
X-HM-Tid: 0a7845521313d991kuwsc37bd400325
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/11/29 7:27, James Bottomley wrote:
> ---8>8>8><8<8<8--------
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Subject: [PATCH] scsi: ses: don't attach if enclosure has no components
> 
> An enclosure with no components can't usefully be operated by the
> driver (since effectively it has nothing to manage), so report the
> problem and don't attach.  Not attaching also fixes an oops which
> could occur if the driver tries to manage a zero component enclosure.
> 
> Reported-by: Ding Hui <dinghui@sangfor.com.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>   drivers/scsi/ses.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index c2afba2a5414..9624298b9c89 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -690,6 +690,11 @@ static int ses_intf_add(struct device *cdev,
>   		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
>   			components += type_ptr[1];
>   	}
> +	if (components == 0) {
> +		sdev_printk(KERN_ERR, sdev, "enclosure has no enumerated components\n");
> +		goto err_free;
> +	}
> +
>   	ses_dev->page1 = buf;
>   	ses_dev->page1_len = len;
>   	buf = NULL;
> 
Can I ask you to resubmit your patch ("scsi: ses: don't attach if 
enclosure has no components") to kernel, thanks

-- 
Thanks,
- Ding Hui
