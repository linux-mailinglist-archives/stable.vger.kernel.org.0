Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325B5462523
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhK2Wfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbhK2WfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:35:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0BAC144FD1;
        Mon, 29 Nov 2021 10:33:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DCD2FCE13D4;
        Mon, 29 Nov 2021 18:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864C6C53FAD;
        Mon, 29 Nov 2021 18:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210810;
        bh=wDig7KI5q10NxnEk8AcE7/YTCXtSU6rvWGz+ABK7GVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTP14kBeoFlk5hjFMVm0+Bx/rSnJEyH+jDmH51vWkOgCVO3j1zwei5p7fSM7PgqMZ
         078U/GMJ0zihRSrzmX8Q0h/xQvoslYJBBgetdykpXMqtEBkrvzFwLrkKLbLuoENdse
         oMcaaA5hz54cSEZ6cNgm99TARUCYvVQHyEBDalyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/121] net: mscc: ocelot: correctly report the timestamping RX filters in ethtool
Date:   Mon, 29 Nov 2021 19:18:51 +0100
Message-Id: <20211129181715.033539991@linuxfoundation.org>
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

[ Upstream commit c49a35eedfef08bffd46b53c25dbf9d6016a86ff ]

The driver doesn't support RX timestamping for non-PTP packets, but it
declares that it does. Restrict the reported RX filters to PTP v2 over
L2 and over L4.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 154d67066d012..52401915828a1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -929,7 +929,10 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 				 SOF_TIMESTAMPING_RAW_HARDWARE;
 	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
 			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
-	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			   BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
 
 	return 0;
 }
-- 
2.33.0



