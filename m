Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752DE18B68A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgCSN1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbgCSN1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:27:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB1A520B1F;
        Thu, 19 Mar 2020 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624465;
        bh=Dxey7Q8OdyIqif19MhI4LcJl0lda+wnDI72pKg7H+PI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzJ3+E33Y4nzD1tN8QB2ht6qFk1vSfCELhBmR/L7KUu6NM60kwqczBhisUKvz0qDy
         ROL85hiLkXTN+L3u+6hfAaVtssxE8vyTJZSIql7Z1+dcqecVjVE/r6yFdPrGzT9nR1
         lxCTlJ3lhBctpYLOUHMCeeIKWwR73NgzZs+DsB8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandru-Mihai Maftei <amaftei@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 54/65] sfc: fix timestamp reconstruction at 16-bit rollover points
Date:   Thu, 19 Mar 2020 14:04:36 +0100
Message-Id: <20200319123943.355676922@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Maftei (amaftei) <amaftei@solarflare.com>

[ Upstream commit 23797b98909f34b75fd130369bde86f760db69d0 ]

We can't just use the top bits of the last sync event as they could be
off-by-one every 65,536 seconds, giving an error in reconstruction of
65,536 seconds.

This patch uses the difference in the bottom 16 bits (mod 2^16) to
calculate an offset that needs to be applied to the last sync event to
get to the current time.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
Acked-by: Martin Habets <mhabets@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ptp.c | 38 +++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index af15a737c6756..59b4f16896a81 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -560,13 +560,45 @@ efx_ptp_mac_nic_to_ktime_correction(struct efx_nic *efx,
 				    u32 nic_major, u32 nic_minor,
 				    s32 correction)
 {
+	u32 sync_timestamp;
 	ktime_t kt = { 0 };
+	s16 delta;
 
 	if (!(nic_major & 0x80000000)) {
 		WARN_ON_ONCE(nic_major >> 16);
-		/* Use the top bits from the latest sync event. */
-		nic_major &= 0xffff;
-		nic_major |= (last_sync_timestamp_major(efx) & 0xffff0000);
+
+		/* Medford provides 48 bits of timestamp, so we must get the top
+		 * 16 bits from the timesync event state.
+		 *
+		 * We only have the lower 16 bits of the time now, but we do
+		 * have a full resolution timestamp at some point in past. As
+		 * long as the difference between the (real) now and the sync
+		 * is less than 2^15, then we can reconstruct the difference
+		 * between those two numbers using only the lower 16 bits of
+		 * each.
+		 *
+		 * Put another way
+		 *
+		 * a - b = ((a mod k) - b) mod k
+		 *
+		 * when -k/2 < (a-b) < k/2. In our case k is 2^16. We know
+		 * (a mod k) and b, so can calculate the delta, a - b.
+		 *
+		 */
+		sync_timestamp = last_sync_timestamp_major(efx);
+
+		/* Because delta is s16 this does an implicit mask down to
+		 * 16 bits which is what we need, assuming
+		 * MEDFORD_TX_SECS_EVENT_BITS is 16. delta is signed so that
+		 * we can deal with the (unlikely) case of sync timestamps
+		 * arriving from the future.
+		 */
+		delta = nic_major - sync_timestamp;
+
+		/* Recover the fully specified time now, by applying the offset
+		 * to the (fully specified) sync time.
+		 */
+		nic_major = sync_timestamp + delta;
 
 		kt = ptp->nic_to_kernel_time(nic_major, nic_minor,
 					     correction);
-- 
2.20.1



