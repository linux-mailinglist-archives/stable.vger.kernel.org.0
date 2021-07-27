Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44383D75A6
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhG0NPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232123AbhG0NPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:15:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3777C619FA;
        Tue, 27 Jul 2021 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627391736;
        bh=i44hdvMYroqkU+K1Y69oCzymfSOqZYyh4ZZ1O7XIZv8=;
        h=Subject:To:From:Date:From;
        b=b7LR6D8orPih1AxH3mQuxkbG5XjRL8yT3J2Q4wrfh2YQmG/VHj71i0zWOvkDMDxHg
         unu5BKWHnxotwPv6yJSFso1ATlfhoSz6KIAbJJ5stj8MsdOWtSoYl3MwcCFmqwF5uu
         twncsaWrzTlIWNXnOHKuwKnAFeR096r8pe/ZlTCI=
Subject: patch "staging: rtl8712: get rid of flush_scheduled_work" added to staging-linus
To:     paskripkin@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Jul 2021 15:15:33 +0200
Message-ID: <16273917337623@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8712: get rid of flush_scheduled_work

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9be550ee43919b070bcd77f9228bdbbbc073245b Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Wed, 21 Jul 2021 22:34:36 +0300
Subject: staging: rtl8712: get rid of flush_scheduled_work

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
 drivers/staging/rtl8712/rtl8712_led.c     | 8 ++++++++
 drivers/staging/rtl8712/rtl871x_led.h     | 1 +
 drivers/staging/rtl8712/rtl871x_pwrctrl.c | 8 ++++++++
 drivers/staging/rtl8712/rtl871x_pwrctrl.h | 1 +
 drivers/staging/rtl8712/usb_intf.c        | 3 ++-
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl8712_led.c b/drivers/staging/rtl8712/rtl8712_led.c
index 5901026949f2..d5fc9026b036 100644
--- a/drivers/staging/rtl8712/rtl8712_led.c
+++ b/drivers/staging/rtl8712/rtl8712_led.c
@@ -1820,3 +1820,11 @@ void LedControl871x(struct _adapter *padapter, enum LED_CTL_MODE LedAction)
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
diff --git a/drivers/staging/rtl8712/rtl871x_led.h b/drivers/staging/rtl8712/rtl871x_led.h
index ee19c873cf01..2f0768132ad8 100644
--- a/drivers/staging/rtl8712/rtl871x_led.h
+++ b/drivers/staging/rtl8712/rtl871x_led.h
@@ -112,6 +112,7 @@ struct led_priv {
 void r8712_InitSwLeds(struct _adapter *padapter);
 void r8712_DeInitSwLeds(struct _adapter *padapter);
 void LedControl871x(struct _adapter *padapter, enum LED_CTL_MODE LedAction);
+void r8712_flush_led_works(struct _adapter *padapter);
 
 #endif
 
diff --git a/drivers/staging/rtl8712/rtl871x_pwrctrl.c b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
index 23cff43437e2..cd6d9ff0bebc 100644
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.c
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.c
@@ -224,3 +224,11 @@ void r8712_unregister_cmd_alive(struct _adapter *padapter)
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
diff --git a/drivers/staging/rtl8712/rtl871x_pwrctrl.h b/drivers/staging/rtl8712/rtl871x_pwrctrl.h
index bf6623cfaf27..b35b9c7920eb 100644
--- a/drivers/staging/rtl8712/rtl871x_pwrctrl.h
+++ b/drivers/staging/rtl8712/rtl871x_pwrctrl.h
@@ -108,5 +108,6 @@ void r8712_cpwm_int_hdl(struct _adapter *padapter,
 void r8712_set_ps_mode(struct _adapter *padapter, uint ps_mode,
 			uint smart_ps);
 void r8712_set_rpwm(struct _adapter *padapter, u8 val8);
+void r8712_flush_rwctrl_works(struct _adapter *padapter);
 
 #endif  /* __RTL871X_PWRCTRL_H_ */
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 2434b13c8b12..643f21eb1128 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -606,7 +606,8 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 			padapter->surprise_removed = true;
 		if (pnetdev->reg_state != NETREG_UNINITIALIZED)
 			unregister_netdev(pnetdev); /* will call netdev_close() */
-		flush_scheduled_work();
+		r8712_flush_rwctrl_works(padapter);
+		r8712_flush_led_works(padapter);
 		udelay(1);
 		/* Stop driver mlme relation timer */
 		r8712_stop_drv_timers(padapter);
-- 
2.32.0


