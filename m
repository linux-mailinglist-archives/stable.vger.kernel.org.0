Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16144461B30
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 16:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345353AbhK2Pnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 10:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343529AbhK2Plx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 10:41:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC221C09CE43
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 05:46:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D7E8B8118A
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 13:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74D8C004E1;
        Mon, 29 Nov 2021 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638193604;
        bh=qs7ejLLSrZfxMp98dfPB46lUUmPDUq1H1uPgwPlP+Yw=;
        h=Subject:To:Cc:From:Date:From;
        b=AgcDiMgwCeVw2BLg8JHGELOAI1UBnv+DTBXZMUOI+DHrDTZTdXWDsbm/3vnUSn7P2
         kjIqDJvRCd+iHf/sAXadhuh62NMRbq5q8R9UH9YUG2HundKEB0Z8z11L65FUBgfYoD
         yf5bMXeZVqL9xrsQOpswlIZRmcdz4BvVW1X1sEm0=
Subject: FAILED: patch "[PATCH] iavf: Fix deadlock occurrence during resetting VF interface" failed to apply to 5.4-stable tree
To:     jedrzej.jagielski@intel.com, anthony.l.nguyen@intel.com,
        jaroslawx.gawin@intel.com, konrad0.jankowski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Nov 2021 14:46:34 +0100
Message-ID: <1638193594177169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

