Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5A32C0AA7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgKWMYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:24:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgKWMYU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:24:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA54520888;
        Mon, 23 Nov 2020 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134260;
        bh=NhW2l7iFTdAxLHami2bE1HItPltCxtUxuNThYSVGZXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiAfg3suuvk0tEURHRjva/Ruv0oq8uQHKs9p0zLxNxz7R5EmonaOduFRC9nUotFKE
         aFocgNWHAlOaYma3Jx5fT7SkRAVB/NwXogwRKTVeDmf2K5DSHMAoKVqQ6YkBWf/mmM
         blk5C6AgxNM0idiXhEc9Ao2QWVYtLbQ6SVWZ3i/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 21/38] can: peak_usb: fix potential integer overflow on shift of a int
Date:   Mon, 23 Nov 2020 13:22:07 +0100
Message-Id: <20201123121805.325118365@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
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
index 22deddb2dbf5a..7b148174eb760 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -176,7 +176,7 @@ void peak_usb_get_ts_tv(struct peak_time_ref *time_ref, u32 ts,
 		if (time_ref->ts_dev_1 < time_ref->ts_dev_2) {
 			/* case when event time (tsw) wraps */
 			if (ts < time_ref->ts_dev_1)
-				delta_ts = 1 << time_ref->adapter->ts_used_bits;
+				delta_ts = BIT_ULL(time_ref->adapter->ts_used_bits);
 
 		/* Otherwise, sync time counter (ts_dev_2) has wrapped:
 		 * handle case when event time (tsn) hasn't.
@@ -188,7 +188,7 @@ void peak_usb_get_ts_tv(struct peak_time_ref *time_ref, u32 ts,
 		 *              tsn            ts
 		 */
 		} else if (time_ref->ts_dev_1 < ts) {
-			delta_ts = -(1 << time_ref->adapter->ts_used_bits);
+			delta_ts = -BIT_ULL(time_ref->adapter->ts_used_bits);
 		}
 
 		/* add delay between last sync and event timestamps */
-- 
2.27.0



