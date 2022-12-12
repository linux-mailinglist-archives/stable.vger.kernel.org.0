Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C6164A196
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiLLNm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbiLLNmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:42:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2434F15831
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:41:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36428B80D4D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619C7C433D2;
        Mon, 12 Dec 2022 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852483;
        bh=Z6pnowHrYCT+Jh0WOGu9d7nkhVF1yZnL/CMcIrhqkSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUSfbeuhIR3OcNolO9pDB5cISiwY5QqOmtJdhgGu2+/gvmFFkCnmz0d3RiU69fVKy
         PZe3Xwqg3/iuqFu8k7ZYaHDM59h7xj2ia6yn4g9pcesDV3vZcxJxMtcE+Shkft3nAv
         rYPu6c7yK5ECX7F2sPJrf6Lii76KZKnM+gncR64o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        =?UTF-8?q?Leonardo=20Eug=C3=AAnio?= <lelgenio@disroot.org>
Subject: [PATCH 6.0 063/157] Bluetooth: Fix crash when replugging CSR fake controllers
Date:   Mon, 12 Dec 2022 14:16:51 +0100
Message-Id: <20221212130937.104981275@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit b5ca338751ad4783ec8d37b5d99c3e37b7813e59 upstream.

It seems fake CSR 5.0 clones can cause the suspend notifier to be
registered twice causing the following kernel panic:

[   71.986122] Call Trace:
[   71.986124]  <TASK>
[   71.986125]  blocking_notifier_chain_register+0x33/0x60
[   71.986130]  hci_register_dev+0x316/0x3d0 [bluetooth 99b5497ea3d09708fa1366c1dc03288bf3cca8da]
[   71.986154]  btusb_probe+0x979/0xd85 [btusb e1e0605a4f4c01984a4b9c8ac58c3666ae287477]
[   71.986159]  ? __pm_runtime_set_status+0x1a9/0x300
[   71.986162]  ? ktime_get_mono_fast_ns+0x3e/0x90
[   71.986167]  usb_probe_interface+0xe3/0x2b0
[   71.986171]  really_probe+0xdb/0x380
[   71.986174]  ? pm_runtime_barrier+0x54/0x90
[   71.986177]  __driver_probe_device+0x78/0x170
[   71.986180]  driver_probe_device+0x1f/0x90
[   71.986183]  __device_attach_driver+0x89/0x110
[   71.986186]  ? driver_allows_async_probing+0x70/0x70
[   71.986189]  bus_for_each_drv+0x8c/0xe0
[   71.986192]  __device_attach+0xb2/0x1e0
[   71.986195]  bus_probe_device+0x92/0xb0
[   71.986198]  device_add+0x422/0x9a0
[   71.986201]  ? sysfs_merge_group+0xd4/0x110
[   71.986205]  usb_set_configuration+0x57a/0x820
[   71.986208]  usb_generic_driver_probe+0x4f/0x70
[   71.986211]  usb_probe_device+0x3a/0x110
[   71.986213]  really_probe+0xdb/0x380
[   71.986216]  ? pm_runtime_barrier+0x54/0x90
[   71.986219]  __driver_probe_device+0x78/0x170
[   71.986221]  driver_probe_device+0x1f/0x90
[   71.986224]  __device_attach_driver+0x89/0x110
[   71.986227]  ? driver_allows_async_probing+0x70/0x70
[   71.986230]  bus_for_each_drv+0x8c/0xe0
[   71.986232]  __device_attach+0xb2/0x1e0
[   71.986235]  bus_probe_device+0x92/0xb0
[   71.986237]  device_add+0x422/0x9a0
[   71.986239]  ? _dev_info+0x7d/0x98
[   71.986242]  ? blake2s_update+0x4c/0xc0
[   71.986246]  usb_new_device.cold+0x148/0x36d
[   71.986250]  hub_event+0xa8a/0x1910
[   71.986255]  process_one_work+0x1c4/0x380
[   71.986259]  worker_thread+0x51/0x390
[   71.986262]  ? rescuer_thread+0x3b0/0x3b0
[   71.986264]  kthread+0xdb/0x110
[   71.986266]  ? kthread_complete_and_exit+0x20/0x20
[   71.986268]  ret_from_fork+0x1f/0x30
[   71.986273]  </TASK>
[   71.986274] ---[ end trace 0000000000000000 ]---
[   71.986284] btusb: probe of 2-1.6:1.0 failed with error -17

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216683
Cc: stable@vger.kernel.org
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Leonardo Eugênio <lelgenio@disroot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2757,7 +2757,8 @@ int hci_register_suspend_notifier(struct
 {
 	int ret = 0;
 
-	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
+	if (!hdev->suspend_notifier.notifier_call &&
+	    !test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
 		hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
 		ret = register_pm_notifier(&hdev->suspend_notifier);
 	}
@@ -2769,8 +2770,11 @@ int hci_unregister_suspend_notifier(stru
 {
 	int ret = 0;
 
-	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks))
+	if (hdev->suspend_notifier.notifier_call) {
 		ret = unregister_pm_notifier(&hdev->suspend_notifier);
+		if (!ret)
+			hdev->suspend_notifier.notifier_call = NULL;
+	}
 
 	return ret;
 }


