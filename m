Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7032C0BDE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgKWNcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:32:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730179AbgKWM0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:26:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EB9A2076E;
        Mon, 23 Nov 2020 12:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134401;
        bh=6Dcwo4OSCRn0tLFb05dYVmqq8EyU5c8u391HU+6KyMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mH9Kct5aw+A1bedmJFTvxD0kHwq+vrs31VPxmm1yFQvJFb9DEG3jz6rptJQguejmq
         b+FPULyZnDAHiFG3IDe9nIg7IYFgi3QHZbrBb8G3s1Lc2riNpG4pkmVc+DANdMzQ1F
         VoZ0DAPsZKc0C1GcLtAKB7TotHLl50ApUEUNGn1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/47] can: peak_usb: fix potential integer overflow on shift of a int
Date:   Mon, 23 Nov 2020 13:22:14 +0100
Message-Id: <20201123121806.909374940@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
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
index 74b37309efab7..2e316228aa1e8 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -178,7 +178,7 @@ void peak_usb_get_ts_tv(struct peak_time_ref *time_ref, u32 ts,
 		if (time_ref->ts_dev_1 < time_ref->ts_dev_2) {
 			/* case when event time (tsw) wraps */
 			if (ts < time_ref->ts_dev_1)
-				delta_ts = 1 << time_ref->adapter->ts_used_bits;
+				delta_ts = BIT_ULL(time_ref->adapter->ts_used_bits);
 
 		/* Otherwise, sync time counter (ts_dev_2) has wrapped:
 		 * handle case when event time (tsn) hasn't.
@@ -190,7 +190,7 @@ void peak_usb_get_ts_tv(struct peak_time_ref *time_ref, u32 ts,
 		 *              tsn            ts
 		 */
 		} else if (time_ref->ts_dev_1 < ts) {
-			delta_ts = -(1 << time_ref->adapter->ts_used_bits);
+			delta_ts = -BIT_ULL(time_ref->adapter->ts_used_bits);
 		}
 
 		/* add delay between last sync and event timestamps */
-- 
2.27.0



