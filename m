Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B60E4627A5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhK2XIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbhK2XHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:07:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C23C144FC9;
        Mon, 29 Nov 2021 10:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80A82B815E9;
        Mon, 29 Nov 2021 18:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF22CC53FC7;
        Mon, 29 Nov 2021 18:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210807;
        bh=dXwL+KZUJLNq67RsrgodKutK0UwcXmaUAs43jPKkUO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOjjofQRwxnPW0h976bxlbrZi74HUEF8l4N/Ti0cAysIlx+OjM0RHWR48DfkRCkUx
         LLFhgHoLKgHRi50qqPYW96LBMCdqMKubH/8fnQ9vYm9pNU51B4xQX0ZSnKq22YWoQJ
         sRrBV9IReLDIYfeuArS1Yps29CdN7kmtW8+g/vg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/121] net: mscc: ocelot: dont downgrade timestamping RX filters in SIOCSHWTSTAMP
Date:   Mon, 29 Nov 2021 19:18:50 +0100
Message-Id: <20211129181714.996998915@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 8c45b236649a9..154d67066d012 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -811,12 +811,6 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
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



