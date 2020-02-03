Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736A4150B75
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgBCQ1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:27:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728541AbgBCQ1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:27:41 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C30C2080C;
        Mon,  3 Feb 2020 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747260;
        bh=AZea3sgVucUEl9+ZbT7c0X9WcUjnpgL4fkil0oRHA68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aX8zuBIswgO9DV21cLylX04/UjdO3WnbYIk9hz1Hx/UY0bGkboMIC59PPcZZFzhQ+
         cxC7jjnOp1mLOAO3dHixPjsM5rLeme6uEBMygXGdfI2o7/0GgdlZLa+NAXVDIxaIoT
         IRrtFRWDKDAeCbk2QHdWggnlXQ8vt2RygiVJiCBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4.14 10/89] staging: vt6656: use NULLFUCTION stack on mac80211
Date:   Mon,  3 Feb 2020 16:18:55 +0000
Message-Id: <20200203161918.221446466@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit d579c43c82f093e63639151625b2139166c730fd upstream.

It appears that the drivers does not go into power save correctly the
NULL data packets are not being transmitted because it not enabled
in mac80211.

The driver needs to capture ieee80211_is_nullfunc headers and
copy the duration_id to it's own duration data header.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/610971ae-555b-a6c3-61b3-444a0c1e35b4@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/main_usb.c |    1 +
 drivers/staging/vt6656/rxtx.c     |   14 +++++---------
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -977,6 +977,7 @@ vt6656_probe(struct usb_interface *intf,
 	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(priv->hw, REPORTS_TX_ACK_STATUS);
 	ieee80211_hw_set(priv->hw, SUPPORTS_PS);
+	ieee80211_hw_set(priv->hw, PS_NULLFUNC_STACK);
 
 	priv->hw->max_signal = 100;
 
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -288,11 +288,9 @@ static u16 vnt_rxtx_datahead_g(struct vn
 			  PK_TYPE_11B, &buf->b);
 
 	/* Get Duration and TimeStamp */
-	if (ieee80211_is_pspoll(hdr->frame_control)) {
-		__le16 dur = cpu_to_le16(priv->current_aid | BIT(14) | BIT(15));
-
-		buf->duration_a = dur;
-		buf->duration_b = dur;
+	if (ieee80211_is_nullfunc(hdr->frame_control)) {
+		buf->duration_a = hdr->duration_id;
+		buf->duration_b = hdr->duration_id;
 	} else {
 		buf->duration_a = vnt_get_duration_le(priv,
 						tx_context->pkt_type, need_ack);
@@ -381,10 +379,8 @@ static u16 vnt_rxtx_datahead_ab(struct v
 			  tx_context->pkt_type, &buf->ab);
 
 	/* Get Duration and TimeStampOff */
-	if (ieee80211_is_pspoll(hdr->frame_control)) {
-		__le16 dur = cpu_to_le16(priv->current_aid | BIT(14) | BIT(15));
-
-		buf->duration = dur;
+	if (ieee80211_is_nullfunc(hdr->frame_control)) {
+		buf->duration = hdr->duration_id;
 	} else {
 		buf->duration = vnt_get_duration_le(priv, tx_context->pkt_type,
 						    need_ack);


