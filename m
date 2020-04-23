Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7332E1B5ABA
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 13:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgDWLru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 07:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbgDWLru (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 07:47:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DD6020787;
        Thu, 23 Apr 2020 11:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587642469;
        bh=r2aLn2Mdo2TDFOV27FFdrQ4yhIn6s2AYZkeNo7BtAQc=;
        h=Subject:To:From:Date:From;
        b=pGS+BUtjGiY4n7tOiRxh0XCtb6NpFAL12N2in4MCjDkJJo57/NhuAVPF9VAyXmwfg
         GndIZnqrF2hG+2aBLMoeIJili3AwkGGBk1v3u72el9B33LWFPx+mOv/DK8Emp8UBZ/
         VpkU0eWa+hFkLQRr2DliBp0ru+Zi6zUC5e/MbI8o=
Subject: patch "staging: vt6656: Fix calling conditions of vnt_set_bss_mode" added to staging-linus
To:     tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 13:47:47 +0200
Message-ID: <15876424671885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vt6656: Fix calling conditions of vnt_set_bss_mode

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 664ba5180234593b4b8517530e8198bf2f7359e2 Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Sat, 18 Apr 2020 18:37:18 +0100
Subject: staging: vt6656: Fix calling conditions of vnt_set_bss_mode

vnt_set_bss_mode needs to be called on all changes to BSS_CHANGED_BASIC_RATES,
BSS_CHANGED_ERP_PREAMBLE and BSS_CHANGED_ERP_SLOT

Remove all other calls and vnt_update_ifs which is called in vnt_set_bss_mode.

Fixes an issue that preamble mode is not being updated correctly.

Fixes: c12603576e06 ("staging: vt6656: Only call vnt_set_bss_mode on basic rates change.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/44110801-6234-50d8-c583-9388f04b486c@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index db310767a5c1..5f78cad3b647 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -625,8 +625,6 @@ static int vnt_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	priv->op_mode = vif->type;
 
-	vnt_set_bss_mode(priv);
-
 	/* LED blink on TX */
 	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_INTER);
 
@@ -713,7 +711,6 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		priv->basic_rates = conf->basic_rates;
 
 		vnt_update_top_rates(priv);
-		vnt_set_bss_mode(priv);
 
 		dev_dbg(&priv->usb->dev, "basic rates %x\n", conf->basic_rates);
 	}
@@ -742,11 +739,14 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 			priv->short_slot_time = false;
 
 		vnt_set_short_slot_time(priv);
-		vnt_update_ifs(priv);
 		vnt_set_vga_gain_offset(priv, priv->bb_vga[0]);
 		vnt_update_pre_ed_threshold(priv, false);
 	}
 
+	if (changed & (BSS_CHANGED_BASIC_RATES | BSS_CHANGED_ERP_PREAMBLE |
+		       BSS_CHANGED_ERP_SLOT))
+		vnt_set_bss_mode(priv);
+
 	if (changed & BSS_CHANGED_TXPOWER)
 		vnt_rf_setpower(priv, priv->current_rate,
 				conf->chandef.chan->hw_value);
-- 
2.26.2


