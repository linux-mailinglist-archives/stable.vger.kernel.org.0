Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8992B3A6010
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhFNKbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232868AbhFNKbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:31:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65F30611C1;
        Mon, 14 Jun 2021 10:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666528;
        bh=xAu6IeufdyirXUfJdU9QGi4qi+C5ycFaQoyNAW7BKWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WDHc5Ax79WJTdLkmXCQKu4Uim5b0JVn/kYm1fh97Q7uetjTFeRCsGWpLS+q3/sTL
         xcQfAqscg1FOj2R+cVdeuQlxdpmoR1B1c33izTvs3s1Za3p5+QRFkhchkUgKoadoJg
         b7oZ5CAOIBFaZxX16LyUYBzMY9Q7/BHBTz8CIJKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zong Li <zong.li@sifive.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/34] net: macb: ensure the device is available before accessing GEMGXL control registers
Date:   Mon, 14 Jun 2021 12:27:02 +0200
Message-Id: <20210614102641.956618743@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong Li <zong.li@sifive.com>

[ Upstream commit 5eff1461a6dec84f04fafa9128548bad51d96147 ]

If runtime power menagement is enabled, the gigabit ethernet PLL would
be disabled after macb_probe(). During this period of time, the system
would hang up if we try to access GEMGXL control registers.

We can't put runtime_pm_get/runtime_pm_put/ there due to the issue of
sleep inside atomic section (7fa2955ff70ce453 ("sh_eth: Fix sleeping
function called from invalid context"). Add netif_running checking to
ensure the device is available before accessing GEMGXL device.

Changed in v2:
 - Use netif_running instead of its own flag

Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 78803e7de360..d1cdb8540e12 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1955,6 +1955,9 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 	struct gem_stats *hwstat = &bp->hw_stats.gem;
 	struct net_device_stats *nstat = &bp->stats;
 
+	if (!netif_running(bp->dev))
+		return nstat;
+
 	gem_update_stats(bp);
 
 	nstat->rx_errors = (hwstat->rx_frame_check_sequence_errors +
-- 
2.30.2



