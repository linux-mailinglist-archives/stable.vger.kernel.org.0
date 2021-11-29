Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EF2462551
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhK2Whw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbhK2Wh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:37:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C58AC125337;
        Mon, 29 Nov 2021 10:27:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65A15B815CF;
        Mon, 29 Nov 2021 18:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906A0C53FD1;
        Mon, 29 Nov 2021 18:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210449;
        bh=XiaDc96Djn4JiH1UgQ4/+1EwcPjmRtWUYBQdH534Pv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iW+HcPSyv4iktfkBGS94W5ehNrDYClgz52PIRiwqDxVM8p5+IaAlKyR2UEOJLoydL
         oAWgl/4U1zUjLskk3+iJeeGpTVASJzuXxUmkitgUVrDrAN7meMNZhkonabKmkhBGMx
         Fk99nUnXwpPh0fjtKltXzoAZO/0e1O3A+cNSCC+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 74/92] net: mscc: ocelot: dont downgrade timestamping RX filters in SIOCSHWTSTAMP
Date:   Mon, 29 Nov 2021 19:18:43 +0100
Message-Id: <20211129181709.879516153@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8a075464d1e9317ffae0973dfe538a7511291a06 ]

The ocelot driver, when asked to timestamp all receiving packets, 1588
v1 or NTP, says "nah, here's 1588 v2 for you".

According to this discussion:
https://patchwork.kernel.org/project/netdevbpf/patch/20211104133204.19757-8-martin.kaistra@linutronix.de/#24577647
drivers that downgrade from a wider request to a narrower response (or
even a response where the intersection with the request is empty) are
buggy, and should return -ERANGE instead. This patch fixes that.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Suggested-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 6030c90d50ccb..3f83647c5802e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1024,12 +1024,6 @@ static int ocelot_hwstamp_set(struct ocelot_port *port, struct ifreq *ifr)
 	switch (cfg.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
 		break;
-	case HWTSTAMP_FILTER_ALL:
-	case HWTSTAMP_FILTER_SOME:
-	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
-	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
-	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
-	case HWTSTAMP_FILTER_NTP_ALL:
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
-- 
2.33.0



