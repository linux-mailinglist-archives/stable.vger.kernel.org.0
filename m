Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B985912212C
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfLQBBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:01:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34518 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfLQAva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:30 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0003It-UI; Tue, 17 Dec 2019 00:51:28 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0005S2-5W; Tue, 17 Dec 2019 00:51:28 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jose Abreu" <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 17 Dec 2019 00:45:44 +0000
Message-ID: <lsq.1576543535.621480799@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 010/136] net: stmmac: Correctly take timestamp for PTPv2
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Abreu <Jose.Abreu@synopsys.com>

commit 14f347334bf232074616e29e29103dd0c7c54dec upstream.

The case for PTPV2_EVENT requires event packets to be captured so add
this setting to the list of enabled captures.

Fixes: 891434b18ec0 ("stmmac: add IEEE PTPv1 and PTPv2 support.")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -539,6 +539,7 @@ static int stmmac_hwtstamp_ioctl(struct
 			ptp_v2 = PTP_TCR_TSVER2ENA;
 			/* take time stamp for all event messages */
 			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
+			ts_event_en = PTP_TCR_TSEVNTENA;
 
 			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
 			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;

