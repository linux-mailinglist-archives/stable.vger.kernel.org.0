Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF28D1BCAC3
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbgD1SgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbgD1SgH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:36:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C90208E0;
        Tue, 28 Apr 2020 18:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098966;
        bh=pPWSAVZuifoUZ2jm5X/KEw5fQZuk+oSpyd1hqiwzJmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fASaxovU7S81jfrAfOYQcDVGzIS4kUNRVg5sG7lOFq+1vSfKjgma0PPdaKb2iNjx7
         RSKyf5mBm2LqFG9uwJMbnahHXxMWApg9ivlkerN7ir9cpxUXb6fJrvMldHNCY/HG49
         E646biUcgrvI1ox487Hm/1C+tr7Getdsa7Hv5WPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.6 138/167] staging: vt6656: Dont set RCR_MULTICAST or RCR_BROADCAST by default.
Date:   Tue, 28 Apr 2020 20:25:14 +0200
Message-Id: <20200428182242.988631767@linuxfoundation.org>
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

commit 0f8240bfc070033a4823b19883efd3d38c7735cc upstream.

mac80211/users control whether multicast is on or off don't enable it by default.

Fixes an issue when multicast/broadcast is always on allowing other beacons through
in power save.

Fixes: db8f37fa3355 ("staging: vt6656: mac80211 conversion: main_usb add functions...")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/2c24c33d-68c4-f343-bd62-105422418eac@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/main_usb.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -817,15 +817,11 @@ static void vnt_configure(struct ieee802
 {
 	struct vnt_private *priv = hw->priv;
 	u8 rx_mode = 0;
-	int rc;
 
 	*total_flags &= FIF_ALLMULTI | FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC;
 
-	rc = vnt_control_in(priv, MESSAGE_TYPE_READ, MAC_REG_RCR,
-			    MESSAGE_REQUEST_MACREG, sizeof(u8), &rx_mode);
-
-	if (!rc)
-		rx_mode = RCR_MULTICAST | RCR_BROADCAST;
+	vnt_control_in(priv, MESSAGE_TYPE_READ, MAC_REG_RCR,
+		       MESSAGE_REQUEST_MACREG, sizeof(u8), &rx_mode);
 
 	dev_dbg(&priv->usb->dev, "rx mode in = %x\n", rx_mode);
 


