Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983771BCAD4
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgD1SwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729579AbgD1SgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:36:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBD24214D8;
        Tue, 28 Apr 2020 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098981;
        bh=Z+aGTiu/MMYd7+T5Sgdgb3SXYjm2IMEzxJTGQBgbQDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0kGEeltTUeSdPR7ICYJHogwZG8FBe38jlUM+iet3qfqgOQ2CK5DAmlbKGep6rCAw
         1DNWm8cVlPHJTdd5rpzE58ZnZxKLQSyynaqCltEE5Znk3cdJS6jr+EHQYjntsEXNfq
         CGeyAfWRMUngc6RfFkXywj8D3FY+cBLzClOyBzkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.6 140/167] staging: vt6656: Fix drivers TBTT timing counter.
Date:   Tue, 28 Apr 2020 20:25:16 +0200
Message-Id: <20200428182243.325768141@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 09057742af98a39ebffa27fac4f889dc873132de upstream.

The drivers TBTT counter is not synchronized with mac80211 timestamp.

Reorder the functions and use vnt_update_next_tbtt to do the final
synchronize.

Fixes: c15158797df6 ("staging: vt6656: implement TSF counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/375d0b25-e8bc-c8f7-9b10-6cc705d486ee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/main_usb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -777,12 +777,15 @@ static void vnt_bss_info_changed(struct
 			vnt_mac_reg_bits_on(priv, MAC_REG_TFTCTL,
 					    TFTCTL_TSFCNTREN);
 
-			vnt_adjust_tsf(priv, conf->beacon_rate->hw_value,
-				       conf->sync_tsf, priv->current_tsf);
-
 			vnt_mac_set_beacon_interval(priv, conf->beacon_int);
 
 			vnt_reset_next_tbtt(priv, conf->beacon_int);
+
+			vnt_adjust_tsf(priv, conf->beacon_rate->hw_value,
+				       conf->sync_tsf, priv->current_tsf);
+
+			vnt_update_next_tbtt(priv,
+					     conf->sync_tsf, conf->beacon_int);
 		} else {
 			vnt_clear_current_tsf(priv);
 


