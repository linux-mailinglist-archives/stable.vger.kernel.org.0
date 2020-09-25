Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065762788D5
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgIYMtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbgIYMtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CDA8221EC;
        Fri, 25 Sep 2020 12:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038182;
        bh=4MHrM7/pyh8clCP4om7T99RUlGr3I6ftn030uLE59SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPNHdW6mvqXWUXeU2XPJTxDSRZ1B9Yfsc4id+gqddSEbRDNlnmB6/r+pwUhM2PbhP
         IBb0dDioiT5z5M+e4R+MKI59X5tK7T7aHyq/13BMHHtxsv/7sDT5ZcWo6FtJXYVFWU
         9lISY/Gf1Vz0zP8/UvfOH6IpWFzBjrLzCeZ7GzaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 05/56] bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()
Date:   Fri, 25 Sep 2020 14:47:55 +0200
Message-Id: <20200925124728.652122352@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit b16939b59cc00231a75d224fd058d22c9d064976 ]

bnxt_fw_reset_task() which runs from a workqueue can race with
bnxt_remove_one().  For example, if firmware reset and VF FLR are
happening at about the same time.

bnxt_remove_one() already cancels the workqueue and waits for it
to finish, but we need to do this earlier before the devlink
reporters are destroyed.  This will guarantee that
the devlink reporters will always be valid when bnxt_fw_reset_task()
is still running.

Fixes: b148bb238c02 ("bnxt_en: Fix possible crash in bnxt_fw_reset_task().")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11498,6 +11498,10 @@ static void bnxt_remove_one(struct pci_d
 	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
 
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	bnxt_cancel_sp_work(bp);
+	bp->sp_event = 0;
+
 	bnxt_dl_fw_reporters_destroy(bp, true);
 	if (BNXT_PF(bp))
 		devlink_port_type_clear(&bp->dl_port);
@@ -11505,9 +11509,6 @@ static void bnxt_remove_one(struct pci_d
 	unregister_netdev(dev);
 	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
-	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-	bnxt_cancel_sp_work(bp);
-	bp->sp_event = 0;
 
 	bnxt_clear_int_mode(bp);
 	bnxt_hwrm_func_drv_unrgtr(bp);


