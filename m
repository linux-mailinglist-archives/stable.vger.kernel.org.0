Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CD63E7F59
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhHJRkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235065AbhHJRjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC43361078;
        Tue, 10 Aug 2021 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617009;
        bh=RSFUk0SyUBYNXUSC8fFEz0LAoNdQpRTXjd2SH2P5zTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cf8vjDb+QA+wj83BhMSJz+QUOmvXXJItDGa1NAr0rAQdmmyJ+UZFJQIDBkWpCV23f
         +PCZvqt97BFyoIlwlAJdG/dat1+rCo2neWmS7sMZA46R69Xxxi9OMzfUtb1AsKEl+G
         Du6mm9cB4E/JuiwsaT9Cb1m2FXTdgd3dU8eolsZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 5.4 57/85] staging: rtl8712: get rid of flush_scheduled_work
Date:   Tue, 10 Aug 2021 19:30:30 +0200
Message-Id: <20210810172950.163412621@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 9be550ee43919b070bcd77f9228bdbbbc073245b upstream.

This patch is preparation for following patch for error handling
refactoring.

flush_scheduled_work() takes (wq_completion)events lock and
it can lead to deadlock when r871xu_dev_remove() is called from workqueue.
To avoid deadlock sutiation we can change flush_scheduled_work() call to
flush_work() call for all possibly scheduled works in this driver,
since next patch adds device_release_driver() in case of fw load failure.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/6e028b4c457eeb7156c76c6ea3cdb3cb0207c7e1.1626895918.git.paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8712/rtl8712_led.c     |    8 ++++++++
 drivers/staging/rtl8712/rtl871x_led.h     |    1 +
 drivers/staging/rtl8712/rtl871x_pwrctrl.c |    8 ++++++++
 drivers/staging/rtl8712/rtl871x_pwrctrl.h |    1 +
 drivers/staging/rtl8712/usb_intf.c        |    3 ++-
 5 files changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8712/rtl8712_led.c
+++ b/drivers/staging/rtl8712/rtl8712_led.c
@@ -1820,3 +1820,11 @@ void LedControl871x(struct _adapter *pad
 		break;
 	}
 }
+
+void r8712_flush_led_works(struct _adapter *padapter)
+{
+	struct led_priv *pledpriv = &padapter->ledpriv;
+
+	flush_work(&pledpriv->SwLed0.BlinkWorkItem);
+	flush_work(&pledpriv->SwLed1.BlinkWorkItem);
+}
--- a/drivers/staging/rtl8712/rtl871x_led.h
+++ b/drivers/staging/rtl8712/rtl871x_led.h
@@ -112,6 +112,7 @@ struct led_priv {
 void r8712_InitSwLeds(struct _adapter *padapter);
 void r8712_DeInitSwLeds(struct _adapter *padapter);
 void LedControl871x(struct _adapter *padapter, enum LED_CTL_MODE LedAction);
+void r8712_flush_led_works(struct _adapter *padapter);
 
 #endif
 
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.c
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
@@ -224,3 +224,11 @@ void r8712_unregister_cmd_alive(struct _
 	}
 	mutex_unlock(&pwrctrl->mutex_lock);
 }
+
+void r8712_flush_rwctrl_works(struct _adapter *padapter)
+{
+	struct pwrctrl_priv *pwrctrl = &padapter->pwrctrlpriv;
+
+	flush_work(&pwrctrl->SetPSModeWorkItem);
+	flush_work(&pwrctrl->rpwm_workitem);
+}
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.h
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.h
@@ -111,5 +111,6 @@ void r8712_cpwm_int_hdl(struct _adapter
 void r8712_set_ps_mode(struct _adapter *padapter, uint ps_mode,
 			uint smart_ps);
 void r8712_set_rpwm(struct _adapter *padapter, u8 val8);
+void r8712_flush_rwctrl_works(struct _adapter *padapter);
 
 #endif  /* __RTL871X_PWRCTRL_H_ */
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -604,7 +604,8 @@ static void r871xu_dev_remove(struct usb
 			padapter->surprise_removed = true;
 		if (pnetdev->reg_state != NETREG_UNINITIALIZED)
 			unregister_netdev(pnetdev); /* will call netdev_close() */
-		flush_scheduled_work();
+		r8712_flush_rwctrl_works(padapter);
+		r8712_flush_led_works(padapter);
 		udelay(1);
 		/* Stop driver mlme relation timer */
 		r8712_stop_drv_timers(padapter);


