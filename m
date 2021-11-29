Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938D9461704
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 14:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbhK2Nx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 08:53:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39528 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhK2Nv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 08:51:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACD72B8118D
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9A5C53FAD;
        Mon, 29 Nov 2021 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638193613;
        bh=Xgn5Fo4u1q0QnGppli8z++Go03rrj/cbq1qkxUo2zcM=;
        h=Subject:To:Cc:From:Date:From;
        b=C/xRMxPTSdu7UAWwLOUclh2BnbVOU0hd+dYnLuXYQblt4V4YfbcHG5cp+tjv+xNGm
         wdoHu0AzZmLUc4XqF94oS70ELSIRAWNi/3HhYXmD+6NmSPemCS92e5t9xjDjXXVgsT
         68QG8N37sBUt3zqXm5UJQ6ykmkJ+QE9wjbfpcD/I=
Subject: FAILED: patch "[PATCH] iavf: Fix deadlock occurrence during resetting VF interface" failed to apply to 5.15-stable tree
To:     jedrzej.jagielski@intel.com, anthony.l.nguyen@intel.com,
        jaroslawx.gawin@intel.com, konrad0.jankowski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Nov 2021 14:46:36 +0100
Message-ID: <1638193596106226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0cc318d2e8408bc0ffb4662a0c3e5e57005ac6ff Mon Sep 17 00:00:00 2001
From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Date: Tue, 7 Sep 2021 09:25:40 +0000
Subject: [PATCH] iavf: Fix deadlock occurrence during resetting VF interface

System hangs if close the interface is called from the kernel during
the interface is in resetting state.
During resetting operation the link is closing but kernel didn't
know it and it tried to close this interface again what sometimes
led to deadlock.
Inform kernel about current state of interface
and turn off the flag IFF_UP when interface is closing until reset
is finished.
Previously it was most likely to hang the system when kernel
(network manager) tried to close the interface in the same time
when interface was in resetting state because of deadlock.

Fixes: 3c8e0b989aa1 ("i40vf: don't stop me now")
Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 336e6bf95e48..84680777ac12 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2254,6 +2254,7 @@ static void iavf_reset_task(struct work_struct *work)
 		   (adapter->state == __IAVF_RESETTING));
 
 	if (running) {
+		netdev->flags &= ~IFF_UP;
 		netif_carrier_off(netdev);
 		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
@@ -2365,7 +2366,7 @@ static void iavf_reset_task(struct work_struct *work)
 		 * to __IAVF_RUNNING
 		 */
 		iavf_up_complete(adapter);
-
+		netdev->flags |= IFF_UP;
 		iavf_irq_enable(adapter, true);
 	} else {
 		iavf_change_state(adapter, __IAVF_DOWN);
@@ -2378,8 +2379,10 @@ static void iavf_reset_task(struct work_struct *work)
 reset_err:
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
-	if (running)
+	if (running) {
 		iavf_change_state(adapter, __IAVF_RUNNING);
+		netdev->flags |= IFF_UP;
+	}
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 	iavf_close(netdev);
 }

