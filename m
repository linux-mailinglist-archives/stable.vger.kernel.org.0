Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED722C9C05
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbgLAJOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390163AbgLAJNv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D0B22210;
        Tue,  1 Dec 2020 09:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813984;
        bh=ZTzkVEYoopztrzG8S+k6U0HDmbUwN0WFALg73bJfVOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n71YzJbJtCIoU8OIoKKjSlFNQe4VtxFwjbs1NpguVvU4Np5ctDn2NA86djog8/25Y
         gZ3cNQITUcv3TbNFh3y6Kpqvn3V+3vD4Zc7y5MV/Um7bYxs4WSFd5jdZ8IH1Rtqojx
         wYt7fXNu0o7lhuIww9rZZpMImY2cRbP0/XXAYf6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 127/152] enetc: Let the hardware auto-advance the taprio base-time of 0
Date:   Tue,  1 Dec 2020 09:54:02 +0100
Message-Id: <20201201084728.444083960@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 90cf87d16bd566cff40c2bc8e32e6d4cd3af23f0 ]

The tc-taprio base time indicates the beginning of the tc-taprio
schedule, which is cyclic by definition (where the length of the cycle
in nanoseconds is called the cycle time). The base time is a 64-bit PTP
time in the TAI domain.

Logically, the base-time should be a future time. But that imposes some
restrictions to user space, which has to retrieve the current PTP time
from the NIC first, then calculate a base time that will still be larger
than the base time by the time the kernel driver programs this value
into the hardware. Actually ensuring that the programmed base time is in
the future is still a problem even if the kernel alone deals with this.

Luckily, the enetc hardware already advances a base-time that is in the
past into a congruent time in the immediate future, according to the
same formula that can be found in the software implementation of taprio
(in taprio_get_start_time):

	/* Schedule the start time for the beginning of the next
	 * cycle.
	 */
	n = div64_s64(ktime_sub_ns(now, base), cycle);
	*start = ktime_add_ns(base, (n + 1) * cycle);

There's only one problem: the driver doesn't let the hardware do that.
It interferes with the base-time passed from user space, by special-casing
the situation when the base-time is zero, and replaces that with the
current PTP time. This changes the intended effective base-time of the
schedule, which will in the end have a different phase offset than if
the base-time of 0.000000000 was to be advanced by an integer multiple
of the cycle-time.

Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20201124220259.3027991-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 1c4a535890dac..9a91e3568adbf 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -95,18 +95,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	gcl_config->atc = 0xff;
 	gcl_config->acl_len = cpu_to_le16(gcl_len);
 
-	if (!admin_conf->base_time) {
-		gcl_data->btl =
-			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
-		gcl_data->bth =
-			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));
-	} else {
-		gcl_data->btl =
-			cpu_to_le32(lower_32_bits(admin_conf->base_time));
-		gcl_data->bth =
-			cpu_to_le32(upper_32_bits(admin_conf->base_time));
-	}
-
+	gcl_data->btl = cpu_to_le32(lower_32_bits(admin_conf->base_time));
+	gcl_data->bth = cpu_to_le32(upper_32_bits(admin_conf->base_time));
 	gcl_data->ct = cpu_to_le32(admin_conf->cycle_time);
 	gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);
 
-- 
2.27.0



