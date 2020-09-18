Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13E727044B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 20:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIRSq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 14:46:26 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34583 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgIRSq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 14:46:26 -0400
Received: by mail-pl1-f196.google.com with SMTP id r19so3454805pls.1;
        Fri, 18 Sep 2020 11:46:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZxDJV2fJCIDNTsf7R64Vg/QpDh1T7h9NcEj6xPqhZnM=;
        b=HkA6F4WXX9RfqnKCDglnDEximKIhdQLGPrQGKy1Ah8iw22ktluFUnPmgXCnkU/+OGc
         ih0Bazk+4w/uuD6aEiW7+REidkPEaC24ptQsddmdnYo/FhJVW5YXA3RGZb1AAySh9jV7
         2pIMvT0n+B6fk7IWLSCeiY2IMfqV2Ge+u5s6e8B1EIQfFWEtZTQBGHJTAPI5MzeAqS0X
         VdkIRE06jw0TkFWoJFJRIhF8r0Dput8sAEU4kz6wzYxYPMv1iqmvv+hPaR2ofVBo90/y
         bjKavLGSYuA/pGURcBVwjMpI2AKkkz2zoS/mv5xmuN/qHF/nhid24hDqhrH01Gtt8E7q
         tD6A==
X-Gm-Message-State: AOAM532D5tPZJXB3GCm+aO4wEbYnw5/hp1OeB++uyjwAHprLz7AmDNz7
        yuSRwpgD5z8fACpTaqsLSE0=
X-Google-Smtp-Source: ABdhPJxBg2A1FGDoSmleWQDmynLttpWsBXjCNrvlj6E6Zdj78d20Ir7/SLYdsxm5CRO3teA3ZbNS7A==
X-Received: by 2002:a17:90b:1487:: with SMTP id js7mr13919908pjb.187.1600454785353;
        Fri, 18 Sep 2020 11:46:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:c1f8:eff6:9706:30c? ([2601:647:4802:9070:c1f8:eff6:9706:30c])
        by smtp.gmail.com with ESMTPSA id gg19sm3424923pjb.49.2020.09.18.11.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 11:46:24 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 4.19 127/206] nvme: Fix controller creation races
 with teardown flow
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Israel Rukshin <israelr@mellanox.com>,
        linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200918020802.2065198-1-sashal@kernel.org>
 <20200918020802.2065198-127-sashal@kernel.org>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <47a9f0da-9fcd-ad17-d2bf-f79767745a39@grimberg.me>
Date:   Fri, 18 Sep 2020 11:46:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200918020802.2065198-127-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This causes a regression and was reverted upstream, just FYI.

On 9/17/20 7:06 PM, Sasha Levin wrote:
> From: Israel Rukshin <israelr@mellanox.com>
> 
> [ Upstream commit ce1518139e6976cf19c133b555083354fdb629b8 ]
> 
> Calling nvme_sysfs_delete() when the controller is in the middle of
> creation may cause several bugs. If the controller is in NEW state we
> remove delete_controller file and don't delete the controller. The user
> will not be able to use nvme disconnect command on that controller again,
> although the controller may be active. Other bugs may happen if the
> controller is in the middle of create_ctrl callback and
> nvme_do_delete_ctrl() starts. For example, freeing I/O tagset at
> nvme_do_delete_ctrl() before it was allocated at create_ctrl callback.
> 
> To fix all those races don't allow the user to delete the controller
> before it was fully created.
> 
> Signed-off-by: Israel Rukshin <israelr@mellanox.com>
> Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/nvme/host/core.c | 5 +++++
>   drivers/nvme/host/nvme.h | 1 +
>   2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 4b182ac15687e..faa7feebb6095 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2856,6 +2856,10 @@ static ssize_t nvme_sysfs_delete(struct device *dev,
>   {
>   	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
>   
> +	/* Can't delete non-created controllers */
> +	if (!ctrl->created)
> +		return -EBUSY;
> +
>   	if (device_remove_file_self(dev, attr))
>   		nvme_delete_ctrl_sync(ctrl);
>   	return count;
> @@ -3576,6 +3580,7 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
>   		queue_work(nvme_wq, &ctrl->async_event_work);
>   		nvme_start_queues(ctrl);
>   	}
> +	ctrl->created = true;
>   }
>   EXPORT_SYMBOL_GPL(nvme_start_ctrl);
>   
> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index 31c1496f938fb..a70b997060e68 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -206,6 +206,7 @@ struct nvme_ctrl {
>   	struct nvme_command ka_cmd;
>   	struct work_struct fw_act_work;
>   	unsigned long events;
> +	bool created;
>   
>   #ifdef CONFIG_NVME_MULTIPATH
>   	/* asymmetric namespace access: */
> 
