Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4D243A142
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbhJYTh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236647AbhJYTfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E00A7604DA;
        Mon, 25 Oct 2021 19:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190325;
        bh=4s8x3QIwL0X0dMs+ax1CtcTi+h0wytlsX3jvRk0xS4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPX7P2YTaEkOhMfQTVT4N98/4IVLVAVQ1RYMAOYNAqtGo/hfBOGfcRXgCDrkXtZeC
         ZNt09ljrqqH7sq5F02gjCPwW7iVu4JRy+Nmu/i/a6BltNQNxVnoqD4u38w5nh/hzjJ
         f8/pf4zzIZ29kIQqOr6MCgJITsdGyjLtKuiPLv+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/95] net: stmmac: Fix E2E delay mechanism
Date:   Mon, 25 Oct 2021 21:14:26 +0200
Message-Id: <20211025191001.120487468@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 3cb958027cb8b78d3ee639ce9af54c2ef1bf964f ]

When utilizing End to End delay mechanism, the following error messages show up:

|root@ehl1:~# ptp4l --tx_timestamp_timeout=50 -H -i eno2 -E -m
|ptp4l[950.573]: selected /dev/ptp3 as PTP clock
|ptp4l[950.586]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
|ptp4l[950.586]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
|ptp4l[952.879]: port 1: new foreign master 001395.fffe.4897b4-1
|ptp4l[956.879]: selected best master clock 001395.fffe.4897b4
|ptp4l[956.879]: port 1: assuming the grand master role
|ptp4l[956.879]: port 1: LISTENING to GRAND_MASTER on RS_GRAND_MASTER
|ptp4l[962.017]: port 1: received DELAY_REQ without timestamp
|ptp4l[962.273]: port 1: received DELAY_REQ without timestamp
|ptp4l[963.090]: port 1: received DELAY_REQ without timestamp

Commit f2fb6b6275eb ("net: stmmac: enable timestamp snapshot for required PTP
packets in dwmac v5.10a") already addresses this problem for the dwmac
v5.10. However, same holds true for all dwmacs above version v4.10. Correct the
check accordingly. Afterwards everything works as expected.

Tested on Intel Atom(R) x6414RE Processor.

Fixes: 14f347334bf2 ("net: stmmac: Correctly take timestamp for PTPv2")
Fixes: f2fb6b6275eb ("net: stmmac: enable timestamp snapshot for required PTP packets in dwmac v5.10a")
Suggested-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6133b2fe8a78..0ac61e7ab43c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -605,7 +605,7 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
 			ptp_v2 = PTP_TCR_TSVER2ENA;
 			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
-			if (priv->synopsys_id != DWMAC_CORE_5_10)
+			if (priv->synopsys_id < DWMAC_CORE_4_10)
 				ts_event_en = PTP_TCR_TSEVNTENA;
 			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
 			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
-- 
2.33.0



