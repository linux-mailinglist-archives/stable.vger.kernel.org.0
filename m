Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1951676EA7
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjAVPMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjAVPMx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:12:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C656FF07
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:12:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5B0FB80B0E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0B6C433EF;
        Sun, 22 Jan 2023 15:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400369;
        bh=I8oOSimr4+ysP6xybRG9DsYdNbQ2RtTorlznGM111Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zmq563O94K6w900VETh0cRVXLCMrYLKJAtH2XFcUSXLH+rVue4ujB/jO/D7salUU1
         Np7iOILoGqMvLyWwbwUxnMwpq7fNnSZZVHIG56CmJM22No5wAY7OuKmN2OCt4N8Bpn
         Obyg4xr8pAAxzSdHcAi+EnazaokQKQ/6puv2SHOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/98] Bluetooth: hci_qca: Fix driver shutdown on closed serdev
Date:   Sun, 22 Jan 2023 16:03:35 +0100
Message-Id: <20230122150230.263081391@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 272970be3dabd24cbe50e393ffee8f04aec3b9a8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 652290425028..096a604ef47f 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2064,10 +2064,17 @@ static void qca_serdev_shutdown(struct device *dev)
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
-- 
2.39.0



