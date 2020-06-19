Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A6D201757
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395317AbgFSQhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389108AbgFSOsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:48:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E015B217A0;
        Fri, 19 Jun 2020 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578118;
        bh=cjTG8DZanHLJn8Ouy222cBDOskh+NdXspoaCIR6/oiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnMdjiPtJndMmFPLjIjqB6NaQ6IkKnO77atPrdvEfMN2GdGNqDuVtfet3j92sQwea
         B/UpClC23t6Lo2Jm9leHlXHOuW1wzbF/EkwytxiJTGYFkgdg+EkDYBVnutEO1Mt0kw
         wQCf+zwZ5v+NfniH2Iu/tAxjvMqtYlDuMMCXjV/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        syzbot+5d338854440137ea0fef@syzkaller.appspotmail.com
Subject: [PATCH 4.14 062/190] ath9k: Fix use-after-free Read in ath9k_wmi_ctrl_rx
Date:   Fri, 19 Jun 2020 16:31:47 +0200
Message-Id: <20200619141636.679439810@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit abeaa85054ff8cfe8b99aafc5c70ea067e5d0908 upstream.

Free wmi later after cmd urb has been killed, as urb cb will access wmi.

the case reported by syzbot:
https://lore.kernel.org/linux-usb/0000000000000002fc05a1d61a68@google.com
BUG: KASAN: use-after-free in ath9k_wmi_ctrl_rx+0x416/0x500
drivers/net/wireless/ath/ath9k/wmi.c:215
Read of size 1 at addr ffff8881cef1417c by task swapper/1/0

Call Trace:
<IRQ>
ath9k_wmi_ctrl_rx+0x416/0x500 drivers/net/wireless/ath/ath9k/wmi.c:215
ath9k_htc_rx_msg+0x2da/0xaf0
drivers/net/wireless/ath/ath9k/htc_hst.c:459
ath9k_hif_usb_reg_in_cb+0x1ba/0x630
drivers/net/wireless/ath/ath9k/hif_usb.c:718
__usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786

Reported-and-tested-by: syzbot+5d338854440137ea0fef@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200404041838.10426-3-hqjagain@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |    5 +++--
 drivers/net/wireless/ath/ath9k/hif_usb.h      |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   10 +++++++---
 drivers/net/wireless/ath/ath9k/wmi.c          |    5 ++++-
 drivers/net/wireless/ath/ath9k/wmi.h          |    3 ++-
 5 files changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -971,7 +971,7 @@ err:
 	return -ENOMEM;
 }
 
-static void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
+void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
 {
 	usb_kill_anchored_urbs(&hif_dev->regout_submitted);
 	ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
@@ -1339,8 +1339,9 @@ static void ath9k_hif_usb_disconnect(str
 
 	if (hif_dev->flags & HIF_USB_READY) {
 		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
-		ath9k_htc_hw_free(hif_dev->htc_handle);
 		ath9k_hif_usb_dev_deinit(hif_dev);
+		ath9k_destoy_wmi(hif_dev->htc_handle->drv_priv);
+		ath9k_htc_hw_free(hif_dev->htc_handle);
 	}
 
 	usb_set_intfdata(interface, NULL);
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -133,5 +133,6 @@ struct hif_device_usb {
 
 int ath9k_hif_usb_init(void);
 void ath9k_hif_usb_exit(void);
+void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev);
 
 #endif /* HTC_USB_H */
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -933,8 +933,9 @@ err_init:
 int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 			   u16 devid, char *product, u32 drv_info)
 {
-	struct ieee80211_hw *hw;
+	struct hif_device_usb *hif_dev;
 	struct ath9k_htc_priv *priv;
+	struct ieee80211_hw *hw;
 	int ret;
 
 	hw = ieee80211_alloc_hw(sizeof(struct ath9k_htc_priv), &ath9k_htc_ops);
@@ -969,7 +970,10 @@ int ath9k_htc_probe_device(struct htc_ta
 	return 0;
 
 err_init:
-	ath9k_deinit_wmi(priv);
+	ath9k_stop_wmi(priv);
+	hif_dev = (struct hif_device_usb *)htc_handle->hif_dev;
+	ath9k_hif_usb_dealloc_urbs(hif_dev);
+	ath9k_destoy_wmi(priv);
 err_free:
 	ieee80211_free_hw(hw);
 	return ret;
@@ -984,7 +988,7 @@ void ath9k_htc_disconnect_device(struct
 			htc_handle->drv_priv->ah->ah_flags |= AH_UNPLUGGED;
 
 		ath9k_deinit_device(htc_handle->drv_priv);
-		ath9k_deinit_wmi(htc_handle->drv_priv);
+		ath9k_stop_wmi(htc_handle->drv_priv);
 		ieee80211_free_hw(htc_handle->drv_priv->hw);
 	}
 }
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -112,14 +112,17 @@ struct wmi *ath9k_init_wmi(struct ath9k_
 	return wmi;
 }
 
-void ath9k_deinit_wmi(struct ath9k_htc_priv *priv)
+void ath9k_stop_wmi(struct ath9k_htc_priv *priv)
 {
 	struct wmi *wmi = priv->wmi;
 
 	mutex_lock(&wmi->op_mutex);
 	wmi->stopped = true;
 	mutex_unlock(&wmi->op_mutex);
+}
 
+void ath9k_destoy_wmi(struct ath9k_htc_priv *priv)
+{
 	kfree(priv->wmi);
 }
 
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -179,7 +179,6 @@ struct wmi {
 };
 
 struct wmi *ath9k_init_wmi(struct ath9k_htc_priv *priv);
-void ath9k_deinit_wmi(struct ath9k_htc_priv *priv);
 int ath9k_wmi_connect(struct htc_target *htc, struct wmi *wmi,
 		      enum htc_endpoint_id *wmi_ctrl_epid);
 int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
@@ -189,6 +188,8 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum
 void ath9k_wmi_event_tasklet(unsigned long data);
 void ath9k_fatal_work(struct work_struct *work);
 void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv);
+void ath9k_stop_wmi(struct ath9k_htc_priv *priv);
+void ath9k_destoy_wmi(struct ath9k_htc_priv *priv);
 
 #define WMI_CMD(_wmi_cmd)						\
 	do {								\


