Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCC82C0B13
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbgKWMhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:37:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731890AbgKWMhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:37:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F1D0208C3;
        Mon, 23 Nov 2020 12:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135034;
        bh=U3fYj2vHn0MagQMrtVBvn8uHOh9WjHxdDBl7aVj5zKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duMgYQxerpNk1PzwKW15MmHm0KlktBGYh3/R3riW9aK1z30mqVsKYOwWlnPe3Tzhd
         Ks0euSUe9tDM4xfMUmi3AAKzdbUSrF9mxn4xwudk1qcCJS4PwSc0avXWo9Ug+uWuj2
         0rE7nkUtO3HE8Ik3SjFYbsvu1kXrtoBecwj85FLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/158] can: peak_usb: fix potential integer overflow on shift of a int
Date:   Mon, 23 Nov 2020 13:21:48 +0100
Message-Id: <20201123121823.798746832@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 8a68cc0d690c9e5730d676b764c6f059343b842c ]

The left shift of int 32 bit integer constant 1 is evaluated using 32 bit
arithmetic and then assigned to a signed 64 bit variable. In the case where
time_ref->adapter->ts_used_bits is 32 or more this can lead to an oveflow.
Avoid this by shifting using the BIT_ULL macro instead.

Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20201105112427.40688-1-colin.king@canonical.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index c844c6abe5fcd..f22089101cdda 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -156,7 +156,7 @@ void peak_usb_get_ts_time(struct peak_time_ref *time_ref, u32 ts, ktime_t *time)
 		if (time_ref->ts_dev_1 < time_ref->ts_dev_2) {
 			/* case when event time (tsw) wraps */
 			if (ts < time_ref->ts_dev_1)
-				delta_ts = 1 << time_ref->adapter->ts_used_bits;
+				delta_ts = BIT_ULL(time_ref->adapter->ts_used_bits);
 
 		/* Otherwise, sync time counter (ts_dev_2) has wrapped:
 		 * handle case when event time (tsn) hasn't.
@@ -168,7 +168,7 @@ void peak_usb_get_ts_time(struct peak_time_ref *time_ref, u32 ts, ktime_t *time)
 		 *              tsn            ts
 		 */
 		} else if (time_ref->ts_dev_1 < ts) {
-			delta_ts = -(1 << time_ref->adapter->ts_used_bits);
+			delta_ts = -BIT_ULL(time_ref->adapter->ts_used_bits);
 		}
 
 		/* add delay between last sync and event timestamps */
-- 
2.27.0



