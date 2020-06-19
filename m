Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0309200D1C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389309AbgFSOxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389722AbgFSOxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:53:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B858D21852;
        Fri, 19 Jun 2020 14:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578395;
        bh=se+Q4k5Btw+HJigqqx9lLs6qFSbEWJIzh+4yhN0UvOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLa1JPYg2hT5eO6xjRgWjp6STpljnqCjbM7qbCec/+kKaDwQEMNcs7oGGeFQmvaAs
         ex3T1IE1Ro/HAOYHPWPguPkQS99n4YwcuEf+SYP4YX2+Tykksf+FUsiKoULfFG/xSY
         pG+X0J/8WUcxVIg0HrWDNqzcK0cQRp2rRZwU+o/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 165/190] carl9170: remove P2P_GO support
Date:   Fri, 19 Jun 2020 16:33:30 +0200
Message-Id: <20200619141642.010554389@linuxfoundation.org>
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

From: Christian Lamparter <chunkeey@gmail.com>

commit b14fba7ebd04082f7767a11daea7f12f3593de22 upstream.

This patch follows up on a bug-report by Frank Schäfer that
discovered P2P GO wasn't working with wpa_supplicant.
This patch removes part of the broken P2P GO support but
keeps the vif switchover code in place.

Cc: <stable@vger.kernel.org>
Link: <https://lkml.kernel.org/r/3a9d86b6-744f-e670-8792-9167257edef8@googlemail.com>
Reported-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200425092811.9494-1-chunkeey@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/carl9170/fw.c   |    4 +---
 drivers/net/wireless/ath/carl9170/main.c |   21 ++++-----------------
 2 files changed, 5 insertions(+), 20 deletions(-)

--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -351,9 +351,7 @@ static int carl9170_fw(struct ar9170 *ar
 		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
 
 		if (SUPP(CARL9170FW_WLANTX_CAB)) {
-			if_comb_types |=
-				BIT(NL80211_IFTYPE_AP) |
-				BIT(NL80211_IFTYPE_P2P_GO);
+			if_comb_types |= BIT(NL80211_IFTYPE_AP);
 
 #ifdef CONFIG_MAC80211_MESH
 			if_comb_types |=
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -582,11 +582,10 @@ static int carl9170_init_interface(struc
 	ar->disable_offload |= ((vif->type != NL80211_IFTYPE_STATION) &&
 	    (vif->type != NL80211_IFTYPE_AP));
 
-	/* While the driver supports HW offload in a single
-	 * P2P client configuration, it doesn't support HW
-	 * offload in the favourit, concurrent P2P GO+CLIENT
-	 * configuration. Hence, HW offload will always be
-	 * disabled for P2P.
+	/* The driver used to have P2P GO+CLIENT support,
+	 * but since this was dropped and we don't know if
+	 * there are any gremlins lurking in the shadows,
+	 * so best we keep HW offload disabled for P2P.
 	 */
 	ar->disable_offload |= vif->p2p;
 
@@ -639,18 +638,6 @@ static int carl9170_op_add_interface(str
 			if (vif->type == NL80211_IFTYPE_STATION)
 				break;
 
-			/* P2P GO [master] use-case
-			 * Because the P2P GO station is selected dynamically
-			 * by all participating peers of a WIFI Direct network,
-			 * the driver has be able to change the main interface
-			 * operating mode on the fly.
-			 */
-			if (main_vif->p2p && vif->p2p &&
-			    vif->type == NL80211_IFTYPE_AP) {
-				old_main = main_vif;
-				break;
-			}
-
 			err = -EBUSY;
 			rcu_read_unlock();
 


