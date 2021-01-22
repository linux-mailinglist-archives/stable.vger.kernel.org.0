Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F65300638
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbhAVOyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbhAVOYb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EF1423BAB;
        Fri, 22 Jan 2021 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325137;
        bh=O78ukoxeG0IaNGNpHDKfzfTczag+olgjsCE1ncOn/90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cokGubv8uOGurMkLwz0SDL2SDV6RY7Guq07iT/KGOQqSKiC2hJtn163vYiF/i+1Iu
         lO67TzZYQLRTKOrHFimSX6/YByYDp+FMbm1FGON5NOr1ThsPdlRQP6HylBgTbkyvRw
         OkvCOSD9nX4NkYpRrEPSBGa6AskfG5BPlpDcj/28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yannick Vignon <yannick.vignon@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 29/43] net: stmmac: fix taprio configuration when base_time is in the past
Date:   Fri, 22 Jan 2021 15:12:45 +0100
Message-Id: <20210122135736.834753723@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

[ Upstream commit fe28c53ed71d463e187748b6b10e1130dd72ceeb ]

The Synopsys TSN MAC supports Qbv base times in the past, but only up to a
certain limit. As a result, a taprio qdisc configuration with a small
base time (for example when treating the base time as a simple phase
offset) is not applied by the hardware and silently ignored.

This was observed on an NXP i.MX8MPlus device, but likely affects all
TSN-variants of the MAC.

Fix the issue by making sure the base time is in the future, pushing it by
an integer amount of cycle times if needed. (a similar check is already
done in several other taprio implementations, see for example
drivers/net/ethernet/intel/igc/igc_tsn.c#L116 or
drivers/net/dsa/sja1105/sja1105_ptp.h#L39).

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
Link: https://lore.kernel.org/r/20210113131557.24651-2-yannick.vignon@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -605,7 +605,8 @@ static int tc_setup_taprio(struct stmmac
 {
 	u32 size, wid = priv->dma_cap.estwid, dep = priv->dma_cap.estdep;
 	struct plat_stmmacenet_data *plat = priv->plat;
-	struct timespec64 time;
+	struct timespec64 time, current_time;
+	ktime_t current_time_ns;
 	bool fpe = false;
 	int i, ret = 0;
 	u64 ctr;
@@ -700,7 +701,22 @@ static int tc_setup_taprio(struct stmmac
 	}
 
 	/* Adjust for real system time */
-	time = ktime_to_timespec64(qopt->base_time);
+	priv->ptp_clock_ops.gettime64(&priv->ptp_clock_ops, &current_time);
+	current_time_ns = timespec64_to_ktime(current_time);
+	if (ktime_after(qopt->base_time, current_time_ns)) {
+		time = ktime_to_timespec64(qopt->base_time);
+	} else {
+		ktime_t base_time;
+		s64 n;
+
+		n = div64_s64(ktime_sub_ns(current_time_ns, qopt->base_time),
+			      qopt->cycle_time);
+		base_time = ktime_add_ns(qopt->base_time,
+					 (n + 1) * qopt->cycle_time);
+
+		time = ktime_to_timespec64(base_time);
+	}
+
 	priv->plat->est->btr[0] = (u32)time.tv_nsec;
 	priv->plat->est->btr[1] = (u32)time.tv_sec;
 


