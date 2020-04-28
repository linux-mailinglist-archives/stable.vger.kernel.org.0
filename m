Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7C91BCA72
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgD1Skb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730935AbgD1Ska (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:40:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 107AB20575;
        Tue, 28 Apr 2020 18:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099229;
        bh=/VeN2kseMO/vJvvp+SL1s1O6roY4rfv52qyfjitNZjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEMg1Ehbybj2xwRnEihaVOYGV4YDvZeUsbvKzZRCmKLlrRykYLi5KxSi6AhTWgzlm
         Ref750pprdMeP4KZRstvGMm4B+6xTam0FHKlj8Lf/5M67mwzb9miDITjDi2DaGxrSn
         IjfVcK8wxUXT1zyXZGfjOgTSCY19YIC596njl2Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4.19 118/131] staging: vt6656: Fix calling conditions of vnt_set_bss_mode
Date:   Tue, 28 Apr 2020 20:25:30 +0200
Message-Id: <20200428182240.071527366@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 664ba5180234593b4b8517530e8198bf2f7359e2 upstream.

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
 drivers/staging/vt6656/main_usb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -595,8 +595,6 @@ static int vnt_add_interface(struct ieee
 
 	priv->op_mode = vif->type;
 
-	vnt_set_bss_mode(priv);
-
 	/* LED blink on TX */
 	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_INTER);
 
@@ -683,7 +681,6 @@ static void vnt_bss_info_changed(struct
 		priv->basic_rates = conf->basic_rates;
 
 		vnt_update_top_rates(priv);
-		vnt_set_bss_mode(priv);
 
 		dev_dbg(&priv->usb->dev, "basic rates %x\n", conf->basic_rates);
 	}
@@ -712,11 +709,14 @@ static void vnt_bss_info_changed(struct
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


