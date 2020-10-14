Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A4A28DDB0
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgJNJbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:31:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:36476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgJNJbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 05:31:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602667894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7GJdUkkNqQ2hsV+7VTbAW0Sl7Mj8Z+r8+j0SbAK2XsE=;
        b=jOGl8uO+C+S92shJe4Hl83nEgGrTcaBhttCvtKfFG2c/AXBAI4EGJIVyBBIjwCOryFLHAv
        cFH7PZtPS02eUCfjHVthz4PYAiiC8TEDuMOA+z9CHreRK3dJ4bQiD5CnsT8ggqhs+L2WqU
        2TdyJJ00R+s6qoGMVD2lsc4wn0Oz7l0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D5C74AF55;
        Wed, 14 Oct 2020 09:31:34 +0000 (UTC)
Subject: Re: [PATCH] xen/events: don't use chip_data for legacy IRQs
To:     stable@vger.kernel.org
Cc:     Stefan Bader <stefan.bader@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20201005061957.13509-1-jgross@suse.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <f0b0b56e-512a-84ed-f03f-86ef54c10e96@suse.com>
Date:   Wed, 14 Oct 2020 11:31:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005061957.13509-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Any reason this has not made it into 5.4.y and older by now?

This patch is fixing a real problem...


Juergen

On 05.10.20 08:19, Juergen Gross wrote:
> Since commit c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
> Xen is using the chip_data pointer for storing IRQ specific data. When
> running as a HVM domain this can result in problems for legacy IRQs, as
> those might use chip_data for their own purposes.
> 
> Use a local array for this purpose in case of legacy IRQs, avoiding the
> double use.
> 
> Fixes: c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Tested-by: Stefan Bader <stefan.bader@canonical.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Link: https://lore.kernel.org/r/20200930091614.13660-1-jgross@suse.com
> ---
> This is a backport for stable kernel 5.4.y and older
> ---
>   drivers/xen/events/events_base.c | 29 +++++++++++++++++++++--------
>   1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index 55f2b834cf13..e402620b8920 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -91,6 +91,8 @@ static bool (*pirq_needs_eoi)(unsigned irq);
>   /* Xen will never allocate port zero for any purpose. */
>   #define VALID_EVTCHN(chn)	((chn) != 0)
>   
> +static struct irq_info *legacy_info_ptrs[NR_IRQS_LEGACY];
> +
>   static struct irq_chip xen_dynamic_chip;
>   static struct irq_chip xen_percpu_chip;
>   static struct irq_chip xen_pirq_chip;
> @@ -155,7 +157,18 @@ int get_evtchn_to_irq(unsigned evtchn)
>   /* Get info for IRQ */
>   struct irq_info *info_for_irq(unsigned irq)
>   {
> -	return irq_get_chip_data(irq);
> +	if (irq < nr_legacy_irqs())
> +		return legacy_info_ptrs[irq];
> +	else
> +		return irq_get_chip_data(irq);
> +}
> +
> +static void set_info_for_irq(unsigned int irq, struct irq_info *info)
> +{
> +	if (irq < nr_legacy_irqs())
> +		legacy_info_ptrs[irq] = info;
> +	else
> +		irq_set_chip_data(irq, info);
>   }
>   
>   /* Constructors for packed IRQ information. */
> @@ -376,7 +389,7 @@ static void xen_irq_init(unsigned irq)
>   	info->type = IRQT_UNBOUND;
>   	info->refcnt = -1;
>   
> -	irq_set_chip_data(irq, info);
> +	set_info_for_irq(irq, info);
>   
>   	list_add_tail(&info->list, &xen_irq_list_head);
>   }
> @@ -425,14 +438,14 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
>   
>   static void xen_free_irq(unsigned irq)
>   {
> -	struct irq_info *info = irq_get_chip_data(irq);
> +	struct irq_info *info = info_for_irq(irq);
>   
>   	if (WARN_ON(!info))
>   		return;
>   
>   	list_del(&info->list);
>   
> -	irq_set_chip_data(irq, NULL);
> +	set_info_for_irq(irq, NULL);
>   
>   	WARN_ON(info->refcnt > 0);
>   
> @@ -602,7 +615,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
>   static void __unbind_from_irq(unsigned int irq)
>   {
>   	int evtchn = evtchn_from_irq(irq);
> -	struct irq_info *info = irq_get_chip_data(irq);
> +	struct irq_info *info = info_for_irq(irq);
>   
>   	if (info->refcnt > 0) {
>   		info->refcnt--;
> @@ -1106,7 +1119,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
>   
>   void unbind_from_irqhandler(unsigned int irq, void *dev_id)
>   {
> -	struct irq_info *info = irq_get_chip_data(irq);
> +	struct irq_info *info = info_for_irq(irq);
>   
>   	if (WARN_ON(!info))
>   		return;
> @@ -1140,7 +1153,7 @@ int evtchn_make_refcounted(unsigned int evtchn)
>   	if (irq == -1)
>   		return -ENOENT;
>   
> -	info = irq_get_chip_data(irq);
> +	info = info_for_irq(irq);
>   
>   	if (!info)
>   		return -ENOENT;
> @@ -1168,7 +1181,7 @@ int evtchn_get(unsigned int evtchn)
>   	if (irq == -1)
>   		goto done;
>   
> -	info = irq_get_chip_data(irq);
> +	info = info_for_irq(irq);
>   
>   	if (!info)
>   		goto done;
> 

