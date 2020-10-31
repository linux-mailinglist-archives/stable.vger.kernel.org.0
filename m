Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F123D2A1608
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgJaLlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbgJaLlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD80920739;
        Sat, 31 Oct 2020 11:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144463;
        bh=hDsSuFOiU2bx7zeexXPGlU3WmkPNixaSJZu5uAMn42s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fG9ClcpIg3NA+ZoFY/WwYHH08JXtmpcIZIE6FQKfo3O0nzQYHoIiM6+ztiBEdxE/Q
         Zs+rbOtmM3yU5+kUeRstWBYQUilgspKuRBXQFafotlzuHxgi/dEiIpU2V0aG3pYd6c
         5NzrUgWNWR/SZgwkUVVsJ9ioIRug0RjyAItWuH8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 28/70] bnxt_en: Fix regression in workqueue cleanup logic in bnxt_remove_one().
Date:   Sat, 31 Oct 2020 12:36:00 +0100
Message-Id: <20201031113500.852416396@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 21d6a11e2cadfb8446265a3efff0e2aad206e15e ]

A recent patch has moved the workqueue cleanup logic before
calling unregister_netdev() in bnxt_remove_one().  This caused a
regression because the workqueue can be restarted if the device is
still open.  Workqueue cleanup must be done after unregister_netdev().
The workqueue will not restart itself after the device is closed.

Call bnxt_cancel_sp_work() after unregister_netdev() and
call bnxt_dl_fw_reporters_destroy() after that.  This fixes the
regession and the original NULL ptr dereference issue.

Fixes: b16939b59cc0 ("bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11508,15 +11508,16 @@ static void bnxt_remove_one(struct pci_d
 	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
 
+	if (BNXT_PF(bp))
+		devlink_port_type_clear(&bp->dl_port);
+	pci_disable_pcie_error_reporting(pdev);
+	unregister_netdev(dev);
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	/* Flush any pending tasks */
 	bnxt_cancel_sp_work(bp);
 	bp->sp_event = 0;
 
 	bnxt_dl_fw_reporters_destroy(bp, true);
-	if (BNXT_PF(bp))
-		devlink_port_type_clear(&bp->dl_port);
-	pci_disable_pcie_error_reporting(pdev);
-	unregister_netdev(dev);
 	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
 


