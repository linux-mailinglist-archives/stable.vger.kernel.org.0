Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA75F12203B
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfLQAxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:53:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35550 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727201AbfLQAvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15O-0003Pg-Ij; Tue, 17 Dec 2019 00:51:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0005gK-RW; Tue, 17 Dec 2019 00:51:35 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Martin Habets" <mhabets@solarflare.com>
Date:   Tue, 17 Dec 2019 00:47:48 +0000
Message-ID: <lsq.1576543535.512120867@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 134/136] sfc: Only cancel the PPS workqueue if it exists
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

From: Martin Habets <mhabets@solarflare.com>

commit 723eb53690041740a13ac78efeaf6804f5d684c9 upstream.

The workqueue only exists for the primary PF. For other functions
we hit a WARN_ON in kernel/workqueue.c.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Martin Habets <mhabets@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/ptp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1310,7 +1310,8 @@ void efx_ptp_remove(struct efx_nic *efx)
 	(void)efx_ptp_disable(efx);
 
 	cancel_work_sync(&efx->ptp_data->work);
-	cancel_work_sync(&efx->ptp_data->pps_work);
+	if (efx->ptp_data->pps_workwq)
+		cancel_work_sync(&efx->ptp_data->pps_work);
 
 	skb_queue_purge(&efx->ptp_data->rxq);
 	skb_queue_purge(&efx->ptp_data->txq);

