Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797EE2EC48
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbfE3DTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731998AbfE3DTm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 007CD248BF;
        Thu, 30 May 2019 03:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186381;
        bh=i9B/8ceSCq/Q0VAcxh70eldNKqX3tSQ6M0gc50JqHCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gp1YphL4pA53ZREXJtePmCh6QpOVRIShq8Qa/oQQ59rdqxGchQxkOlwyg10tXWSvZ
         o4CvNv4nyFW30+YbpWq0LJo/RXp/0/vYCu7eWG/QtuwrTBgPjOmQOnlmXN6j4Ay+kv
         2G7OVhXChNndbtX8eN683Tvn9Vvu3XzQcrSs7gU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Piotr Figiel <p.figiel@camlintechnologies.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 145/193] brcmfmac: fix race during disconnect when USB completion is in progress
Date:   Wed, 29 May 2019 20:06:39 -0700
Message-Id: <20190530030508.547568823@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit db3b9e2e1d58080d0754bdf9293dabf8c6491b67 ]

It was observed that rarely during USB disconnect happening shortly after
connect (before full initialization completes) usb_hub_wq would wait
forever for the dev_init_lock to be unlocked. dev_init_lock would remain
locked though because of infinite wait during usb_kill_urb:

[ 2730.656472] kworker/0:2     D    0   260      2 0x00000000
[ 2730.660700] Workqueue: events request_firmware_work_func
[ 2730.664807] [<809dca20>] (__schedule) from [<809dd164>] (schedule+0x4c/0xac)
[ 2730.670587] [<809dd164>] (schedule) from [<8069af44>] (usb_kill_urb+0xdc/0x114)
[ 2730.676815] [<8069af44>] (usb_kill_urb) from [<7f258b50>] (brcmf_usb_free_q+0x34/0xa8 [brcmfmac])
[ 2730.684833] [<7f258b50>] (brcmf_usb_free_q [brcmfmac]) from [<7f2517d4>] (brcmf_detach+0xa0/0xb8 [brcmfmac])
[ 2730.693557] [<7f2517d4>] (brcmf_detach [brcmfmac]) from [<7f251a34>] (brcmf_attach+0xac/0x3d8 [brcmfmac])
[ 2730.702094] [<7f251a34>] (brcmf_attach [brcmfmac]) from [<7f2587ac>] (brcmf_usb_probe_phase2+0x468/0x4a0 [brcmfmac])
[ 2730.711601] [<7f2587ac>] (brcmf_usb_probe_phase2 [brcmfmac]) from [<7f252888>] (brcmf_fw_request_done+0x194/0x220 [brcmfmac])
[ 2730.721795] [<7f252888>] (brcmf_fw_request_done [brcmfmac]) from [<805748e4>] (request_firmware_work_func+0x4c/0x88)
[ 2730.731125] [<805748e4>] (request_firmware_work_func) from [<80141474>] (process_one_work+0x228/0x808)
[ 2730.739223] [<80141474>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564)
[ 2730.746105] [<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
[ 2730.752227] [<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)

[ 2733.099695] kworker/0:3     D    0  1065      2 0x00000000
[ 2733.103926] Workqueue: usb_hub_wq hub_event
[ 2733.106914] [<809dca20>] (__schedule) from [<809dd164>] (schedule+0x4c/0xac)
[ 2733.112693] [<809dd164>] (schedule) from [<809e2a8c>] (schedule_timeout+0x214/0x3e4)
[ 2733.119621] [<809e2a8c>] (schedule_timeout) from [<809dde2c>] (wait_for_common+0xc4/0x1c0)
[ 2733.126810] [<809dde2c>] (wait_for_common) from [<7f258d00>] (brcmf_usb_disconnect+0x1c/0x4c [brcmfmac])
[ 2733.135206] [<7f258d00>] (brcmf_usb_disconnect [brcmfmac]) from [<8069e0c8>] (usb_unbind_interface+0x5c/0x1e4)
[ 2733.143943] [<8069e0c8>] (usb_unbind_interface) from [<8056d3e8>] (device_release_driver_internal+0x164/0x1fc)
[ 2733.152769] [<8056d3e8>] (device_release_driver_internal) from [<8056c078>] (bus_remove_device+0xd0/0xfc)
[ 2733.161138] [<8056c078>] (bus_remove_device) from [<8056977c>] (device_del+0x11c/0x310)
[ 2733.167939] [<8056977c>] (device_del) from [<8069cba8>] (usb_disable_device+0xa0/0x1cc)
[ 2733.174743] [<8069cba8>] (usb_disable_device) from [<8069507c>] (usb_disconnect+0x74/0x1dc)
[ 2733.181823] [<8069507c>] (usb_disconnect) from [<80695e88>] (hub_event+0x478/0xf88)
[ 2733.188278] [<80695e88>] (hub_event) from [<80141474>] (process_one_work+0x228/0x808)
[ 2733.194905] [<80141474>] (process_one_work) from [<80141a80>] (worker_thread+0x2c/0x564)
[ 2733.201724] [<80141a80>] (worker_thread) from [<80147bcc>] (kthread+0x13c/0x16c)
[ 2733.207913] [<80147bcc>] (kthread) from [<801010b4>] (ret_from_fork+0x14/0x20)

It was traced down to a case where usb_kill_urb would be called on an URB
structure containing more or less random data, including large number in
its use_count. During the debugging it appeared that in brcmf_usb_free_q()
the traversal over URBs' lists is not synchronized with operations on those
lists in brcmf_usb_rx_complete() leading to handling
brcmf_usbdev_info structure (holding lists' head) as lists' element and in
result causing above problem.

Fix it by walking through all URBs during brcmf_cancel_all_urbs using the
arrays of requests instead of linked lists.

Signed-off-by: Piotr Figiel <p.figiel@camlintechnologies.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 267dcefdacb29..be855aa32154d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -684,12 +684,18 @@ static int brcmf_usb_up(struct device *dev)
 
 static void brcmf_cancel_all_urbs(struct brcmf_usbdev_info *devinfo)
 {
+	int i;
+
 	if (devinfo->ctl_urb)
 		usb_kill_urb(devinfo->ctl_urb);
 	if (devinfo->bulk_urb)
 		usb_kill_urb(devinfo->bulk_urb);
-	brcmf_usb_free_q(&devinfo->tx_postq, true);
-	brcmf_usb_free_q(&devinfo->rx_postq, true);
+	if (devinfo->tx_reqs)
+		for (i = 0; i < devinfo->bus_pub.ntxq; i++)
+			usb_kill_urb(devinfo->tx_reqs[i].urb);
+	if (devinfo->rx_reqs)
+		for (i = 0; i < devinfo->bus_pub.nrxq; i++)
+			usb_kill_urb(devinfo->rx_reqs[i].urb);
 }
 
 static void brcmf_usb_down(struct device *dev)
-- 
2.20.1



