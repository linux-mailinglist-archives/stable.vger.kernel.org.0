Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789711775CC
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 13:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgCCMRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 07:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbgCCMRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 07:17:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE48D20857;
        Tue,  3 Mar 2020 12:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583237864;
        bh=bGDhSMpentb/CS0Z5q0Vy2Srh3hd9Nhsd7cOo4HUUGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vWlwnhpJP4pIASHyHiZEQHUXCfZuyK9QsH/xDvUWz12jN5xqXIVYEk78Sw7hnFVbd
         78Eqil+1qQg9bU96pArvTLT7/EA9cfFRrxxCDFrq3qlINzYoUQJjU30T/uNTtgJQes
         enfbi37Bq6i5uY5kzIo5tRLA+9KEPB87CPLF29So=
Date:   Tue, 3 Mar 2020 13:17:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cengiz Can <cengiz@kernel.wtf>
Cc:     kbusch@kernel.org, Chaitanya.Kulkarni@wdc.com, axboe@kernel.dk,
        helgaas@kernel.org, jack@suse.cz, linux-block@vger.kernel.org,
        stable@vger.kernel.org, tristmd@gmail.com
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
Message-ID: <20200303121741.GA2021063@kroah.com>
References: <20200302220639.GA2393@dhcp-10-100-145-180.wdl.wdc.com>
 <20200303110731.65552-1-cengiz@kernel.wtf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303110731.65552-1-cengiz@kernel.wtf>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 02:07:32PM +0300, Cengiz Can wrote:
> Added a reassignment into the NULL check block to fix the issue.
> 
> Fixes: c780e86dd48 ("blktrace: Protect q->blk_trace with RCU")
> 
> Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
> ---
>  kernel/trace/blktrace.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 4560878f0bac..29ea88f10b87 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1896,8 +1896,10 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
>  	}
> 
>  	ret = 0;
> -	if (bt == NULL)
> +	if (bt == NULL) {
>  		ret = blk_trace_setup_queue(q, bdev);
> +		bt = q->blk_trace;
> +	}
> 
>  	if (ret == 0) {
>  		if (attr == &dev_attr_act_mask)
> --
> 2.25.1
>

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
