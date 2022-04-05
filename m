Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE904F2B39
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355626AbiDEKVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242674AbiDEJ0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:26:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A6CDE917;
        Tue,  5 Apr 2022 02:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32737B81A12;
        Tue,  5 Apr 2022 09:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858E3C385A0;
        Tue,  5 Apr 2022 09:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150096;
        bh=sbnwdoSVqLGy+sxt29AUW1vGB75AYvZ5+OBYERYQW0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfwL0cc1pU9skU86pxUi4ICN2+TDnRVpABKXSRqAe0w21bM8QDqNydRZIoTySHX2H
         9qPWxDd0DnBHoPSTnVvxps2ZxXB+R4WvMHAWWXTtpHE1T1P68TNGNzVdu6HohgSEH4
         ND837U7vDixpsy+Sdr1DTi+ZaFV+7GNPZA2coHAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.16 0952/1017] virtio: use virtio_device_ready() in virtio_device_restore()
Date:   Tue,  5 Apr 2022 09:31:05 +0200
Message-Id: <20220405070422.470327478@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit 8d65bc9a5be3f23c5e2ab36b6b8ef40095165b18 upstream.

After waking up a suspended VM, the kernel prints the following trace
for virtio drivers which do not directly call virtio_device_ready() in
the .restore:

    PM: suspend exit
    irq 22: nobody cared (try booting with the "irqpoll" option)
    Call Trace:
     <IRQ>
     dump_stack_lvl+0x38/0x49
     dump_stack+0x10/0x12
     __report_bad_irq+0x3a/0xaf
     note_interrupt.cold+0xb/0x60
     handle_irq_event+0x71/0x80
     handle_fasteoi_irq+0x95/0x1e0
     __common_interrupt+0x6b/0x110
     common_interrupt+0x63/0xe0
     asm_common_interrupt+0x1e/0x40
     ? __do_softirq+0x75/0x2f3
     irq_exit_rcu+0x93/0xe0
     sysvec_apic_timer_interrupt+0xac/0xd0
     </IRQ>
     <TASK>
     asm_sysvec_apic_timer_interrupt+0x12/0x20
     arch_cpu_idle+0x12/0x20
     default_idle_call+0x39/0xf0
     do_idle+0x1b5/0x210
     cpu_startup_entry+0x20/0x30
     start_secondary+0xf3/0x100
     secondary_startup_64_no_verify+0xc3/0xcb
     </TASK>
    handlers:
    [<000000008f9bac49>] vp_interrupt
    [<000000008f9bac49>] vp_interrupt
    Disabling IRQ #22

This happens because we don't invoke .enable_cbs callback in
virtio_device_restore(). That callback is used by some transports
(e.g. virtio-pci) to enable interrupts.

Let's fix it, by calling virtio_device_ready() as we do in
virtio_dev_probe(). This function calls .enable_cts callback and sets
DRIVER_OK status bit.

This fix also avoids setting DRIVER_OK twice for those drivers that
call virtio_device_ready() in the .restore.

Fixes: d50497eb4e55 ("virtio_config: introduce a new .enable_cbs method")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20220322114313.116516-1-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -504,8 +504,9 @@ int virtio_device_restore(struct virtio_
 			goto err;
 	}
 
-	/* Finally, tell the device we're all set */
-	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK);
+	/* If restore didn't do it, mark device DRIVER_OK ourselves. */
+	if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
+		virtio_device_ready(dev);
 
 	virtio_config_enable(dev);
 


