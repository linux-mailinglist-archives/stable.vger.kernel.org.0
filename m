Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD2A6765C1
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 11:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjAUKfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 05:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjAUKfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 05:35:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B235418A87
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 02:35:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5025860B54
        for <stable@vger.kernel.org>; Sat, 21 Jan 2023 10:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9A4C433D2;
        Sat, 21 Jan 2023 10:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674297312;
        bh=WQloFwdSwE4OHPX3rCRTcJeHe5SdjgaHq610HqyNCXM=;
        h=Subject:To:Cc:From:Date:From;
        b=mvrGIIeT/Tfk0eU7fdcAxKrthnT7eCz1LtAtJgI5l29w5//izRQu2RuYg4H7/3/6W
         4d/t1TXHWCSHDiqJzvL25BL5sqfaVkL8Rz3nG9Zz82lQPjkXsedWEmcrc/uKNd/sZP
         KGILcw/nEc1f4UP/5P691fHp47veoO7t1RH/3UXA=
Subject: FAILED: patch "[PATCH] Bluetooth: hci_qca: Fix driver shutdown on closed serdev" failed to apply to 5.10-stable tree
To:     krzysztof.kozlowski@linaro.org, luiz.von.dentz@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 21 Jan 2023 11:33:23 +0100
Message-ID: <167429720372200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

272970be3dab ("Bluetooth: hci_qca: Fix driver shutdown on closed serdev")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 272970be3dabd24cbe50e393ffee8f04aec3b9a8 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 29 Dec 2022 11:28:29 +0100
Subject: [PATCH] Bluetooth: hci_qca: Fix driver shutdown on closed serdev

The driver shutdown callback (which sends EDL_SOC_RESET to the device
over serdev) should not be invoked when HCI device is not open (e.g. if
hci_dev_open_sync() failed), because the serdev and its TTY are not open
either.  Also skip this step if device is powered off
(qca_power_shutdown()).

The shutdown callback causes use-after-free during system reboot with
Qualcomm Atheros Bluetooth:

  Unable to handle kernel paging request at virtual address
  0072662f67726fd7
  ...
  CPU: 6 PID: 1 Comm: systemd-shutdow Tainted: G        W
  6.1.0-rt5-00325-g8a5f56bcfcca #8
  Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
  Call trace:
   tty_driver_flush_buffer+0x4/0x30
   serdev_device_write_flush+0x24/0x34
   qca_serdev_shutdown+0x80/0x130 [hci_uart]
   device_shutdown+0x15c/0x260
   kernel_restart+0x48/0xac

KASAN report:

  BUG: KASAN: use-after-free in tty_driver_flush_buffer+0x1c/0x50
  Read of size 8 at addr ffff16270c2e0018 by task systemd-shutdow/1

  CPU: 7 PID: 1 Comm: systemd-shutdow Not tainted
  6.1.0-next-20221220-00014-gb85aaf97fb01-dirty #28
  Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
  Call trace:
   dump_backtrace.part.0+0xdc/0xf0
   show_stack+0x18/0x30
   dump_stack_lvl+0x68/0x84
   print_report+0x188/0x488
   kasan_report+0xa4/0xf0
   __asan_load8+0x80/0xac
   tty_driver_flush_buffer+0x1c/0x50
   ttyport_write_flush+0x34/0x44
   serdev_device_write_flush+0x48/0x60
   qca_serdev_shutdown+0x124/0x274
   device_shutdown+0x1e8/0x350
   kernel_restart+0x48/0xb0
   __do_sys_reboot+0x244/0x2d0
   __arm64_sys_reboot+0x54/0x70
   invoke_syscall+0x60/0x190
   el0_svc_common.constprop.0+0x7c/0x160
   do_el0_svc+0x44/0xf0
   el0_svc+0x2c/0x6c
   el0t_64_sync_handler+0xbc/0x140
   el0t_64_sync+0x190/0x194

Fixes: 7e7bbddd029b ("Bluetooth: hci_qca: Fix qca6390 enable failure after warm reboot")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 6eddc23e49d9..bbe9cf1cae27 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2164,10 +2164,17 @@ static void qca_serdev_shutdown(struct device *dev)
 	int timeout = msecs_to_jiffies(CMD_TRANS_TIMEOUT_MS);
 	struct serdev_device *serdev = to_serdev_device(dev);
 	struct qca_serdev *qcadev = serdev_device_get_drvdata(serdev);
+	struct hci_uart *hu = &qcadev->serdev_hu;
+	struct hci_dev *hdev = hu->hdev;
+	struct qca_data *qca = hu->priv;
 	const u8 ibs_wake_cmd[] = { 0xFD };
 	const u8 edl_reset_soc_cmd[] = { 0x01, 0x00, 0xFC, 0x01, 0x05 };
 
 	if (qcadev->btsoc_type == QCA_QCA6390) {
+		if (test_bit(QCA_BT_OFF, &qca->flags) ||
+		    !test_bit(HCI_RUNNING, &hdev->flags))
+			return;
+
 		serdev_device_write_flush(serdev);
 		ret = serdev_device_write_buf(serdev, ibs_wake_cmd,
 					      sizeof(ibs_wake_cmd));

