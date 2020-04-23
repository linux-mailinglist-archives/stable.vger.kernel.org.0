Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369A71B5AAE
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 13:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgDWLoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 07:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgDWLoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 07:44:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C63AE2077D;
        Thu, 23 Apr 2020 11:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587642257;
        bh=40EkvDqL1BVVe0/49vmF7/Cok7tzzopXHFucHnknE5o=;
        h=Subject:To:From:Date:From;
        b=sxZKx1VKqH3cG/TuaMUgo3WffI3l9fGH61sRuGmoWKspVS3BaNI2bGMzg0UUacKX1
         Z1TqZsmOVX13MEXq3a5hK2qFejYUZBah7rhlUCpm/ZjDazYBaU7p8wWvVlqpZdkJmy
         /45JB+s23EI3lYrmyp4CXbPQBhz0wKnJx98eTiA0=
Subject: patch "staging: vt6656: Fix drivers TBTT timing counter." added to staging-linus
To:     tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 13:44:07 +0200
Message-ID: <158764224721548@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: vt6656: Fix drivers TBTT timing counter.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 09057742af98a39ebffa27fac4f889dc873132de Mon Sep 17 00:00:00 2001
From: Malcolm Priestley <tvboxspy@gmail.com>
Date: Sat, 18 Apr 2020 17:43:24 +0100
Subject: staging: vt6656: Fix drivers TBTT timing counter.

The drivers TBTT counter is not synchronized with mac80211 timestamp.

Reorder the functions and use vnt_update_next_tbtt to do the final
synchronize.

Fixes: c15158797df6 ("staging: vt6656: implement TSF counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/375d0b25-e8bc-c8f7-9b10-6cc705d486ee@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vt6656/main_usb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c9c9adf48115..752bb2e95321 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -770,12 +770,15 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
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
 
-- 
2.26.2


