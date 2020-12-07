Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8119E2D0E68
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 11:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgLGKt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 05:49:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8718 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgLGKt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 05:49:28 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CqKln337PzkmXD;
        Mon,  7 Dec 2020 18:48:05 +0800 (CST)
Received: from [10.67.102.197] (10.67.102.197) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Dec 2020 18:48:33 +0800
Subject: ping // [PATCH] mtd:cfi_cmdset_0002: fix atomic sleep bug when
 CONFIG_MTD_XIP=y
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <tudor.ambarus@microchip.com>, <tpoynor@mvista.com>,
        <tglx@linutronix.de>, <vwool@ru.mvista.com>
CC:     <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wangle6@huawei.com>
References: <20201127130731.99270-1-nixiaoming@huawei.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <a02e1364-3b82-039a-4b65-e2a216663dd4@huawei.com>
Date:   Mon, 7 Dec 2020 18:48:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20201127130731.99270-1-nixiaoming@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.197]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping

On 2020/11/27 21:07, Xiaoming Ni wrote:
> When CONFIG_MTD_XIP=y, local_irq_disable() is called in xip_disable().
> To avoid sleep in interrupt context, we need to call local_irq_enable()
> before schedule().
> 
> The problem call stack is as follows:
> bug1:
> 	do_write_oneword_retry()
> 		xip_disable()
> 			local_irq_disable()
> 		do_write_oneword_once()
> 			schedule()
> bug2:
> 	do_write_buffer()
> 		xip_disable()
> 			local_irq_disable()
> 		do_write_buffer_wait()
> 			schedule()
> bug3:
> 	do_erase_chip()
> 		xip_disable()
> 			local_irq_disable()
> 		schedule()
> bug4:
> 	do_erase_oneblock()
> 		xip_disable()
> 			local_irq_disable()
> 		schedule()
> 
> Fixes: 02b15e343aee ("[MTD] XIP for AMD CFI flash.")
> Cc: stable@vger.kernel.org # v2.6.13
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> ---
>   drivers/mtd/chips/cfi_cmdset_0002.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> index a1f3e1031c3d..12c3776f093a 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -1682,7 +1682,11 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>   			set_current_state(TASK_UNINTERRUPTIBLE);
>   			add_wait_queue(&chip->wq, &wait);
>   			mutex_unlock(&chip->mutex);
> +			if (IS_ENABLED(CONFIG_MTD_XIP))
> +				local_irq_enable();
>   			schedule();
> +			if (IS_ENABLED(CONFIG_MTD_XIP))
> +				local_irq_disable();
>   			remove_wait_queue(&chip->wq, &wait);
>   			timeo = jiffies + (HZ / 2); /* FIXME */
>   			mutex_lock(&chip->mutex);
> @@ -1962,7 +1966,11 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
>   			set_current_state(TASK_UNINTERRUPTIBLE);
>   			add_wait_queue(&chip->wq, &wait);
>   			mutex_unlock(&chip->mutex);
> +			if (IS_ENABLED(CONFIG_MTD_XIP))
> +				local_irq_enable();
>   			schedule();
> +			if (IS_ENABLED(CONFIG_MTD_XIP))
> +				local_irq_disable();
>   			remove_wait_queue(&chip->wq, &wait);
>   			timeo = jiffies + (HZ / 2); /* FIXME */
>   			mutex_lock(&chip->mutex);
> @@ -2461,7 +2469,11 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
>   			set_current_state(TASK_UNINTERRUPTIBLE);
>   			add_wait_queue(&chip->wq, &wait);
>   			mutex_unlock(&chip->mutex);
> +			if (IS_ENABLED(CONFIG_MTD_XIP))
> +				local_irq_enable();
>   			schedule();
> +			if (IS_ENABLED(CONFIG_MTD_XIP))
> +				local_irq_disable();
>   			remove_wait_queue(&chip->wq, &wait);
>   			mutex_lock(&chip->mutex);
>   			continue;
> @@ -2560,7 +2572,11 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
>   			set_current_state(TASK_UNINTERRUPTIBLE);
>   			add_wait_queue(&chip->wq, &wait);
>   			mutex_unlock(&chip->mutex);
> +			if (IS_ENABLED(CONFIG_MTD_XIP))
> +				local_irq_enable();
>   			schedule();
> +			if (IS_ENABLED(CONFIG_MTD_XIP))
> +				local_irq_disable();
>   			remove_wait_queue(&chip->wq, &wait);
>   			mutex_lock(&chip->mutex);
>   			continue;
> 

