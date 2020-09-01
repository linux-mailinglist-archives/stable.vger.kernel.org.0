Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1165258D4E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 13:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgIALTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 07:19:50 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:45980 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgIALTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 07:19:49 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 081BGfS0065377;
        Tue, 1 Sep 2020 06:16:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598959001;
        bh=0xkhvtopn5GYo5K0PIkM4dY7RDKHAZPwVyHf0UbdFsA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=E1ULFpEBI8SY4gG2c1BPXmq3qDUNrEhgrTkB6Kvui+mGH6go5f0OOY2YWr3+1gq1M
         o5OYpaOclKxwoT8BAhnGbkC4Xal7dqsqTjf8ROU2JIkco/CK6+x+fWaQwVdvx8LY+t
         D+KSM5TH7/eMVQwJdLF2KVurK5RdCARllMF48JKQ=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 081BGfiB045630;
        Tue, 1 Sep 2020 06:16:41 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 1 Sep
 2020 06:16:40 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 1 Sep 2020 06:16:40 -0500
Received: from [192.168.2.14] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 081BGcNF114027;
        Tue, 1 Sep 2020 06:16:39 -0500
Subject: Re: [PATCH 1/1] usb: cdns3: gadget: free interrupt after gadget has
 deleted
To:     Peter Chen <peter.chen@nxp.com>, <balbi@kernel.org>
CC:     <linux-usb@vger.kernel.org>, <linux-imx@nxp.com>,
        <pawell@cadence.com>, <gregkh@linuxfoundation.org>,
        <jun.li@nxp.com>, <stable@vger.kernel.org>
References: <20200901023549.25688-1-peter.chen@nxp.com>
From:   Roger Quadros <rogerq@ti.com>
Message-ID: <5309d0fd-23d0-a91b-e8f0-ed20411319c8@ti.com>
Date:   Tue, 1 Sep 2020 14:16:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901023549.25688-1-peter.chen@nxp.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 01/09/2020 05:35, Peter Chen wrote:
> The interrupt may occur during the gadget deletion, it fixes the
> below oops.
> 
> [ 2394.974604] configfs-gadget gadget: suspend
> [ 2395.042578] configfs-gadget 5b130000.usb: unregistering UDC driver [g1]
> [ 2395.382562] irq 229: nobody cared (try booting with the "irqpoll" option)
> [ 2395.389362] CPU: 0 PID: 301 Comm: kworker/u12:6 Not tainted 5.8.0-rc3-next-20200703-00060-g2f13b83cbf30-dirty #456
> [ 2395.399712] Hardware name: Freescale i.MX8QM MEK (DT)
> [ 2395.404782] Workqueue: 2-0051 tcpm_state_machine_work
> [ 2395.409832] Call trace:
> [ 2395.412289]  dump_backtrace+0x0/0x1d0
> [ 2395.415950]  show_stack+0x1c/0x28
> [ 2395.419271]  dump_stack+0xbc/0x118
> [ 2395.422678]  __report_bad_irq+0x50/0xe0
> [ 2395.426513]  note_interrupt+0x2cc/0x38c
> [ 2395.430355]  handle_irq_event_percpu+0x88/0x90
> [ 2395.434800]  handle_irq_event+0x4c/0xe8
> [ 2395.438640]  handle_fasteoi_irq+0xbc/0x168
> [ 2395.442740]  generic_handle_irq+0x34/0x48
> [ 2395.446752]  __handle_domain_irq+0x68/0xc0
> [ 2395.450846]  gic_handle_irq+0x64/0x150
> [ 2395.454596]  el1_irq+0xb8/0x180
> [ 2395.457733]  __do_softirq+0xac/0x3b8
> [ 2395.461310]  irq_exit+0xc0/0xe0
> [ 2395.464448]  __handle_domain_irq+0x6c/0xc0
> [ 2395.468540]  gic_handle_irq+0x64/0x150
> [ 2395.472295]  el1_irq+0xb8/0x180
> [ 2395.475436]  _raw_spin_unlock_irqrestore+0x14/0x48
> [ 2395.480232]  usb_gadget_disconnect+0x120/0x140
> [ 2395.484678]  usb_gadget_remove_driver+0xb4/0xd0
> [ 2395.489208]  usb_del_gadget+0x6c/0xc8
> [ 2395.492872]  cdns3_gadget_exit+0x5c/0x120
> [ 2395.496882]  cdns3_role_stop+0x60/0x90
> [ 2395.500634]  cdns3_role_set+0x64/0xd8
> [ 2395.504301]  usb_role_switch_set_role.part.0+0x3c/0x90
> [ 2395.509444]  usb_role_switch_set_role+0x20/0x30
> [ 2395.513978]  tcpm_mux_set+0x60/0xf8
> [ 2395.517470]  tcpm_reset_port+0xa4/0xf0
> [ 2395.521222]  tcpm_detach.part.0+0x44/0x50
> [ 2395.525227]  tcpm_state_machine_work+0x8b0/0x2360
> [ 2395.529932]  process_one_work+0x1c8/0x470
> [ 2395.533939]  worker_thread+0x50/0x420
> [ 2395.537603]  kthread+0x148/0x168
> [ 2395.540830]  ret_from_fork+0x10/0x18
> [ 2395.544399] handlers:
> [ 2395.546671] [<000000008dea28da>] cdns3_wakeup_irq
> [ 2395.551375] [<000000009fee5c61>] cdns3_drd_irq threaded [<000000005148eaec>] cdns3_drd_thread_irq
> [ 2395.560255] Disabling IRQ #229
> [ 2395.563454] configfs-gadget gadget: unbind function 'Mass Storage Function'/000000000132f835
> [ 2395.563657] configfs-gadget gadget: unbind
> [ 2395.563917] udc 5b130000.usb: releasing '5b130000.usb'
> 
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Peter Chen <peter.chen@nxp.com>

Acked-by: Roger Quadros <rogerq@ti.com>

> ---
>   drivers/usb/cdns3/gadget.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
> index fe6738ac0498..1b2027ec68a5 100644
> --- a/drivers/usb/cdns3/gadget.c
> +++ b/drivers/usb/cdns3/gadget.c
> @@ -3074,12 +3074,12 @@ void cdns3_gadget_exit(struct cdns3 *cdns)
>   
>   	priv_dev = cdns->gadget_dev;
>   
> -	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
>   
>   	pm_runtime_mark_last_busy(cdns->dev);
>   	pm_runtime_put_autosuspend(cdns->dev);
>   
>   	usb_del_gadget_udc(&priv_dev->gadget);
> +	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
>   
>   	cdns3_free_all_eps(priv_dev);
>   
> 

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
