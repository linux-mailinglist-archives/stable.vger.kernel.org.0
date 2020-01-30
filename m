Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CB214E0EC
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgA3Sj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:39:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgA3Sj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:39:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBBBE214D8;
        Thu, 30 Jan 2020 18:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409597;
        bh=PcYjAsbCfzF+5dESTDBeoAdBwesnGNr/0H4djHcVYs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDUvCcCkLkRbdPluGqYI/q1EJZ6muIZhvZlQFIqWxUEI99UybSPxgb+8JO8ij9WQq
         vjJtOIQpdyOA4p0fE1dg9tpqiFvyvcL/vNVC8EvYO0gmUO/3m+FttMdpL1JZG+AwiO
         5XWjDowSQndlwZUUm6QHf0Fh7+3CqP5Rgv1nfUrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5.5 14/56] staging: vt6656: correct packet types for CTS protect, mode.
Date:   Thu, 30 Jan 2020 19:38:31 +0100
Message-Id: <20200130183611.888987584@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit d971fdd3412f8342747778fb59b8803720ed82b1 upstream.

It appears that the driver still transmits in CTS protect mode even
though it is not enabled in mac80211.

That is both packet types PK_TYPE_11GA and PK_TYPE_11GB both use CTS protect.
The only difference between them GA does not use B rates.

Find if only B rate in GB or GA in protect mode otherwise transmit packets
as PK_TYPE_11A.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/9c1323ff-dbb3-0eaa-43e1-9453f7390dc0@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/device.h |    2 ++
 drivers/staging/vt6656/rxtx.c   |   12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -52,6 +52,8 @@
 #define RATE_AUTO	12
 
 #define MAX_RATE			12
+#define VNT_B_RATES	(BIT(RATE_1M) | BIT(RATE_2M) |\
+			BIT(RATE_5M) | BIT(RATE_11M))
 
 /*
  * device specific
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -815,10 +815,14 @@ int vnt_tx_packet(struct vnt_private *pr
 		if (info->band == NL80211_BAND_5GHZ) {
 			pkt_type = PK_TYPE_11A;
 		} else {
-			if (tx_rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
-				pkt_type = PK_TYPE_11GB;
-			else
-				pkt_type = PK_TYPE_11GA;
+			if (tx_rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
+				if (priv->basic_rates & VNT_B_RATES)
+					pkt_type = PK_TYPE_11GB;
+				else
+					pkt_type = PK_TYPE_11GA;
+			} else {
+				pkt_type = PK_TYPE_11A;
+			}
 		}
 	} else {
 		pkt_type = PK_TYPE_11B;


