Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB2629BA44
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368833AbgJ0P7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804270AbgJ0PyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:54:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1EA320678;
        Tue, 27 Oct 2020 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814039;
        bh=yGlL5yF+WD8O/0Z+AfgUsvEMjHTHbGbPjF4R4wv//Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9hXfFx04//GGKTrUd2HWRBb+FuDBB8dVY3bukkzsSTU3NxiKc/HJ9nJzLxW/8mjT
         s0U8IdV/MQajAbzxoK8CZH03yIom64RayaGOQf49iqD+cqIGz9TCKg0VUoXqZL5gRD
         pXD6LKBwQScrrSbcH1wCIGDG5ZEo32S78G47drmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.9 755/757] usb: cdns3: gadget: free interrupt after gadget has deleted
Date:   Tue, 27 Oct 2020 14:56:45 +0100
Message-Id: <20201027135525.911705890@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 98df91f8840cf750a0bc7c4c5d6b6085bac945b3 upstream.

The interrupt may occur during the gadget deletion, it fixes the
below oops.

[ 2394.974604] configfs-gadget gadget: suspend
[ 2395.042578] configfs-gadget 5b130000.usb: unregistering UDC driver [g1]
[ 2395.382562] irq 229: nobody cared (try booting with the "irqpoll" option)
[ 2395.389362] CPU: 0 PID: 301 Comm: kworker/u12:6 Not tainted 5.8.0-rc3-next-20200703-00060-g2f13b83cbf30-dirty #456
[ 2395.399712] Hardware name: Freescale i.MX8QM MEK (DT)
[ 2395.404782] Workqueue: 2-0051 tcpm_state_machine_work
[ 2395.409832] Call trace:
[ 2395.412289]  dump_backtrace+0x0/0x1d0
[ 2395.415950]  show_stack+0x1c/0x28
[ 2395.419271]  dump_stack+0xbc/0x118
[ 2395.422678]  __report_bad_irq+0x50/0xe0
[ 2395.426513]  note_interrupt+0x2cc/0x38c
[ 2395.430355]  handle_irq_event_percpu+0x88/0x90
[ 2395.434800]  handle_irq_event+0x4c/0xe8
[ 2395.438640]  handle_fasteoi_irq+0xbc/0x168
[ 2395.442740]  generic_handle_irq+0x34/0x48
[ 2395.446752]  __handle_domain_irq+0x68/0xc0
[ 2395.450846]  gic_handle_irq+0x64/0x150
[ 2395.454596]  el1_irq+0xb8/0x180
[ 2395.457733]  __do_softirq+0xac/0x3b8
[ 2395.461310]  irq_exit+0xc0/0xe0
[ 2395.464448]  __handle_domain_irq+0x6c/0xc0
[ 2395.468540]  gic_handle_irq+0x64/0x150
[ 2395.472295]  el1_irq+0xb8/0x180
[ 2395.475436]  _raw_spin_unlock_irqrestore+0x14/0x48
[ 2395.480232]  usb_gadget_disconnect+0x120/0x140
[ 2395.484678]  usb_gadget_remove_driver+0xb4/0xd0
[ 2395.489208]  usb_del_gadget+0x6c/0xc8
[ 2395.492872]  cdns3_gadget_exit+0x5c/0x120
[ 2395.496882]  cdns3_role_stop+0x60/0x90
[ 2395.500634]  cdns3_role_set+0x64/0xd8
[ 2395.504301]  usb_role_switch_set_role.part.0+0x3c/0x90
[ 2395.509444]  usb_role_switch_set_role+0x20/0x30
[ 2395.513978]  tcpm_mux_set+0x60/0xf8
[ 2395.517470]  tcpm_reset_port+0xa4/0xf0
[ 2395.521222]  tcpm_detach.part.0+0x44/0x50
[ 2395.525227]  tcpm_state_machine_work+0x8b0/0x2360
[ 2395.529932]  process_one_work+0x1c8/0x470
[ 2395.533939]  worker_thread+0x50/0x420
[ 2395.537603]  kthread+0x148/0x168
[ 2395.540830]  ret_from_fork+0x10/0x18
[ 2395.544399] handlers:
[ 2395.546671] [<000000008dea28da>] cdns3_wakeup_irq
[ 2395.551375] [<000000009fee5c61>] cdns3_drd_irq threaded [<000000005148eaec>] cdns3_drd_thread_irq
[ 2395.560255] Disabling IRQ #229
[ 2395.563454] configfs-gadget gadget: unbind function 'Mass Storage Function'/000000000132f835
[ 2395.563657] configfs-gadget gadget: unbind
[ 2395.563917] udc 5b130000.usb: releasing '5b130000.usb'

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Acked-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/cdns3/gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2990,12 +2990,12 @@ void cdns3_gadget_exit(struct cdns3 *cdn
 
 	priv_dev = cdns->gadget_dev;
 
-	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
 	pm_runtime_mark_last_busy(cdns->dev);
 	pm_runtime_put_autosuspend(cdns->dev);
 
 	usb_del_gadget_udc(&priv_dev->gadget);
+	devm_free_irq(cdns->dev, cdns->dev_irq, priv_dev);
 
 	cdns3_free_all_eps(priv_dev);
 


