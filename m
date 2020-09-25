Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F3127887A
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgIYMww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728836AbgIYMwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:52:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59D1A2072E;
        Fri, 25 Sep 2020 12:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038368;
        bh=RnSiq0cNVDO4LQGLwpxpSIalJIe6dLxD9UaNZfL6S5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hy/t1MX3wQeIEdm1hEos7COHX5JmGE/BJneXX7DH91CZw95qk0Bqqu0pxKNphH5xp
         rEfjCRJUo+GOjt2V5MTTZKF5MGoL+TwDkKo6BaA09+t0gBJZ5/o8Fy5W7i9PMuEaAD
         td0LykNYso71sylIQy9ha3EYteZXe6DLiGPn3eOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 08/43] bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()
Date:   Fri, 25 Sep 2020 14:48:20 +0200
Message-Id: <20200925124724.804801430@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
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
@@ -11385,14 +11385,15 @@ static void bnxt_remove_one(struct pci_d
 	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
 
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	bnxt_cancel_sp_work(bp);
+	bp->sp_event = 0;
+
 	bnxt_dl_fw_reporters_destroy(bp, true);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
 	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
-	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
-	bnxt_cancel_sp_work(bp);
-	bp->sp_event = 0;
 
 	bnxt_clear_int_mode(bp);
 	bnxt_hwrm_func_drv_unrgtr(bp);


