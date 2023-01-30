Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E1C68114B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237229AbjA3OLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbjA3OLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:11:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63B23B3D7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87337B8117E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E003AC433D2;
        Mon, 30 Jan 2023 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087903;
        bh=/r1LgOhluFdjuWRaxZm+M0GIqbrzfIL4wSBOR8/wNMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+nNxOuYcWYfPCgYfRlP9ekgwpFf3QXmotDmpGsTncixmuf8bn+duyuiKyzp39IHD
         pLrcphwRp64TfhgBEKYpVcb/DSOWkH0n7OpPQdeg65sTDzf8DJkmfBtzxcUjGwa85S
         AKMrGBfUYdrDvgr+RzcFrY7p1dkk2SC+XaJIz4Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kurt Kanzenbach <kurt@linutronix.de>,
        Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/204] net: stmmac: Fix queue statistics reading
Date:   Mon, 30 Jan 2023 14:50:14 +0100
Message-Id: <20230130134318.472744881@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit c296c77efb66994d94d9f706446a115581226550 ]

Correct queue statistics reading. All queue statistics are stored as unsigned
long values. The retrieval for ethtool fetches these values as u64. However, on
some systems the size of the counters are 32 bit. That yields wrong queue
statistic counters e.g., on arm32 systems such as the stm32mp157. Fix it by
using the correct data type.

Tested on Olimex STMP157-OLinuXino-LIME2 by simple running linuxptp for a short
period of time:

Non-patched kernel:
|root@st1:~# ethtool -S eth0 | grep q0
|     q0_tx_pkt_n: 3775276254951 # ???
|     q0_tx_irq_n: 879
|     q0_rx_pkt_n: 1194000908909 # ???
|     q0_rx_irq_n: 278

Patched kernel:
|root@st1:~# ethtool -S eth0 | grep q0
|     q0_tx_pkt_n: 2434
|     q0_tx_irq_n: 1274
|     q0_rx_pkt_n: 1604
|     q0_rx_irq_n: 846

Fixes: 68e9c5dee1cf ("net: stmmac: add ethtool per-queue statistic framework")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Cc: Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
Cc: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index dc31501fec8f..9e8ae4384e4f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -548,16 +548,16 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
 		p = (char *)priv + offsetof(struct stmmac_priv,
 					    xstats.txq_stats[q].tx_pkt_n);
 		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
-			*data++ = (*(u64 *)p);
-			p += sizeof(u64 *);
+			*data++ = (*(unsigned long *)p);
+			p += sizeof(unsigned long);
 		}
 	}
 	for (q = 0; q < rx_cnt; q++) {
 		p = (char *)priv + offsetof(struct stmmac_priv,
 					    xstats.rxq_stats[q].rx_pkt_n);
 		for (stat = 0; stat < STMMAC_RXQ_STATS; stat++) {
-			*data++ = (*(u64 *)p);
-			p += sizeof(u64 *);
+			*data++ = (*(unsigned long *)p);
+			p += sizeof(unsigned long);
 		}
 	}
 }
-- 
2.39.0



