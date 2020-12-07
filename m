Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7862D0E79
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 11:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgLGKyP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 7 Dec 2020 05:54:15 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:34161 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgLGKyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 05:54:14 -0500
X-Originating-IP: 109.220.208.103
Received: from xps13 (lfbn-tou-1-1617-103.w109-220.abo.wanadoo.fr [109.220.208.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 30BCA1BF20E;
        Mon,  7 Dec 2020 10:53:31 +0000 (UTC)
Date:   Mon, 7 Dec 2020 11:53:30 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     <richard@nod.at>, <vigneshr@ti.com>, <tudor.ambarus@microchip.com>,
        <tglx@linutronix.de>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <wangle6@huawei.com>
Subject: Re: ping // [PATCH] mtd:cfi_cmdset_0002: fix atomic sleep bug when
 CONFIG_MTD_XIP=y
Message-ID: <20201207115228.0a6de398@xps13>
In-Reply-To: <a02e1364-3b82-039a-4b65-e2a216663dd4@huawei.com>
References: <20201127130731.99270-1-nixiaoming@huawei.com>
        <a02e1364-3b82-039a-4b65-e2a216663dd4@huawei.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Xiaoming,

Xiaoming Ni <nixiaoming@huawei.com> wrote on Mon, 7 Dec 2020 18:48:33
+0800:

> ping
> 
> On 2020/11/27 21:07, Xiaoming Ni wrote:
> > When CONFIG_MTD_XIP=y, local_irq_disable() is called in xip_disable().
> > To avoid sleep in interrupt context, we need to call local_irq_enable()
> > before schedule().
> > 
> > The problem call stack is as follows:
> > bug1:
> > 	do_write_oneword_retry()
> > 		xip_disable()
> > 			local_irq_disable()
> > 		do_write_oneword_once()
> > 			schedule()
> > bug2:
> > 	do_write_buffer()
> > 		xip_disable()
> > 			local_irq_disable()
> > 		do_write_buffer_wait()
> > 			schedule()
> > bug3:
> > 	do_erase_chip()
> > 		xip_disable()
> > 			local_irq_disable()
> > 		schedule()
> > bug4:
> > 	do_erase_oneblock()
> > 		xip_disable()
> > 			local_irq_disable()
> > 		schedule()
> > 
> > Fixes: 02b15e343aee ("[MTD] XIP for AMD CFI flash.")
> > Cc: stable@vger.kernel.org # v2.6.13
> > Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> > ---
> >   drivers/mtd/chips/cfi_cmdset_0002.c | 16 ++++++++++++++++
> >   1 file changed, 16 insertions(+)
> > 
> > diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
> > index a1f3e1031c3d..12c3776f093a 100644
> > --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> > +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> > @@ -1682,7 +1682,11 @@ static int __xipram do_write_oneword_once(struct map_info *map,
> >   			set_current_state(TASK_UNINTERRUPTIBLE);
> >   			add_wait_queue(&chip->wq, &wait);
> >   			mutex_unlock(&chip->mutex);
> > +			if (IS_ENABLED(CONFIG_MTD_XIP))
> > +				local_irq_enable();
> >   			schedule();
> > +			if (IS_ENABLED(CONFIG_MTD_XIP))
> > +				local_irq_disable();

The fix really seems strange to me. I will let Vignesh decide but I
think we should consider updating/fixing xip_disable instead.

> >   			remove_wait_queue(&chip->wq, &wait);
> >   			timeo = jiffies + (HZ / 2); /* FIXME */
> >   			mutex_lock(&chip->mutex);
> > @@ -1962,7 +1966,11 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
> >   			set_current_state(TASK_UNINTERRUPTIBLE);
> >   			add_wait_queue(&chip->wq, &wait);
> >   			mutex_unlock(&chip->mutex);
> > +			if (IS_ENABLED(CONFIG_MTD_XIP))
> > +				local_irq_enable();
> >   			schedule();
> > +			if (IS_ENABLED(CONFIG_MTD_XIP))
> > +				local_irq_disable();
> >   			remove_wait_queue(&chip->wq, &wait);
> >   			timeo = jiffies + (HZ / 2); /* FIXME */
> >   			mutex_lock(&chip->mutex);
> > @@ -2461,7 +2469,11 @@ static int __xipram do_erase_chip(struct map_info *map, struct flchip *chip)
> >   			set_current_state(TASK_UNINTERRUPTIBLE);
> >   			add_wait_queue(&chip->wq, &wait);
> >   			mutex_unlock(&chip->mutex);
> > +			if (IS_ENABLED(CONFIG_MTD_XIP))
> > +				local_irq_enable();
> >   			schedule();
> > +			if (IS_ENABLED(CONFIG_MTD_XIP))
> > +				local_irq_disable();
> >   			remove_wait_queue(&chip->wq, &wait);
> >   			mutex_lock(&chip->mutex);
> >   			continue;
> > @@ -2560,7 +2572,11 @@ static int __xipram do_erase_oneblock(struct map_info *map, struct flchip *chip,
> >   			set_current_state(TASK_UNINTERRUPTIBLE);
> >   			add_wait_queue(&chip->wq, &wait);
> >   			mutex_unlock(&chip->mutex);
> > +			if (IS_ENABLED(CONFIG_MTD_XIP))
> > +				local_irq_enable();
> >   			schedule();
> > +			if (IS_ENABLED(CONFIG_MTD_XIP))
> > +				local_irq_disable();
> >   			remove_wait_queue(&chip->wq, &wait);
> >   			mutex_lock(&chip->mutex);
> >   			continue;
> >   
> 

Thanks,
Miquèl
