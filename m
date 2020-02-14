Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929B815F90F
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388038AbgBNVyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387816AbgBNVyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:54:39 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B906222C4;
        Fri, 14 Feb 2020 21:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581717278;
        bh=+eWMM7ctfu02hztPUCLtJb+NQzqJb8ZnKTg9uTIDEvM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=feFDDORwRNtlPf6l+yk2KxujfVAMC7jLRn8y1SK5lZBzNpSevcw0GVs4n0r0GmDCH
         IX+Vdkgzn/bRCQMM060xMo6Dqju3sVNTuQvfC1bWnSd7SNC8u/dIWifaK8fYw80cOi
         Zkd5mX/9BhPvrjnMilMJHGrK9xdPT02yRPQNBA/s=
Date:   Fri, 14 Feb 2020 16:49:49 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hongbo Yao <yaohongbo@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH AUTOSEL 5.5 343/542] misc: genwqe: fix compile warnings
Message-ID: <20200214214949.GH4193448@kroah.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-343-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-343-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 10:45:35AM -0500, Sasha Levin wrote:
> From: Hongbo Yao <yaohongbo@huawei.com>
> 
> [ Upstream commit 8edf4cd193067ac5e03fd9580f1affbb6a3f729b ]
> 
> Using the following command will get compile warnings:
> make W=1 drivers/misc/genwqe/card_ddcb.o ARCH=x86_64
> 
> drivers/misc/genwqe/card_ddcb.c: In function setup_ddcb_queue:
> drivers/misc/genwqe/card_ddcb.c:1024:6: warning: variable rc set but not
> used [-Wunused-but-set-variable]
> drivers/misc/genwqe/card_ddcb.c: In function genwqe_card_thread:
> drivers/misc/genwqe/card_ddcb.c:1190:23: warning: variable rc set but
> not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
> Link: https://lore.kernel.org/r/20191205111655.170382-1-yaohongbo@huawei.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/misc/genwqe/card_ddcb.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
> index 026c6ca245408..905106579935a 100644
> --- a/drivers/misc/genwqe/card_ddcb.c
> +++ b/drivers/misc/genwqe/card_ddcb.c
> @@ -1084,7 +1084,7 @@ static int setup_ddcb_queue(struct genwqe_dev *cd, struct ddcb_queue *queue)
>  				queue->ddcb_daddr);
>  	queue->ddcb_vaddr = NULL;
>  	queue->ddcb_daddr = 0ull;
> -	return -ENODEV;
> +	return rc;
>  
>  }
>  
> @@ -1179,7 +1179,7 @@ static irqreturn_t genwqe_vf_isr(int irq, void *dev_id)
>   */
>  static int genwqe_card_thread(void *data)
>  {
> -	int should_stop = 0, rc = 0;
> +	int should_stop = 0;
>  	struct genwqe_dev *cd = (struct genwqe_dev *)data;
>  
>  	while (!kthread_should_stop()) {
> @@ -1187,12 +1187,12 @@ static int genwqe_card_thread(void *data)
>  		genwqe_check_ddcb_queue(cd, &cd->queue);
>  
>  		if (GENWQE_POLLING_ENABLED) {
> -			rc = wait_event_interruptible_timeout(
> +			wait_event_interruptible_timeout(
>  				cd->queue_waitq,
>  				genwqe_ddcbs_in_flight(cd) ||
>  				(should_stop = kthread_should_stop()), 1);
>  		} else {
> -			rc = wait_event_interruptible_timeout(
> +			wait_event_interruptible_timeout(
>  				cd->queue_waitq,
>  				genwqe_next_ddcb_ready(cd) ||
>  				(should_stop = kthread_should_stop()), HZ);
> -- 
> 2.20.1
> 

Again, please drop.
