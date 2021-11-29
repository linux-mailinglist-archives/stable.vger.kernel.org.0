Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01898461F5B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380151AbhK2Sq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:46:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57270 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380551AbhK2SoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:44:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C924CCE13DB;
        Mon, 29 Nov 2021 18:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D36FC53FC7;
        Mon, 29 Nov 2021 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211262;
        bh=MEsVMJrgzWsHuzRRDcG4epjHq1J+cnUh/emRdk2oLJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxanMJ7FHx7TxxS49j7UDU+jrmIs9uEpEkEnImPPuPc4Ud0WNjqDEGEZp+a8JXnUg
         Mr7+EQEtIGLVUmP4E1n3r1lgqPfE1QqKggmZGo+O7BoY+4W+viMHzU6GCSmaTtxUCb
         WQOHSs4BYdzy0B8XoE1tYoKubxA9zFuPImC3j+WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/179] net: mscc: ocelot: dont downgrade timestamping RX filters in SIOCSHWTSTAMP
Date:   Mon, 29 Nov 2021 19:19:07 +0100
Message-Id: <20211129181723.989246763@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index a08e4f530c1c1..08fafc4a7e813 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1175,12 +1175,6 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
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



