Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6324E12C701
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbfL2Rws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731770AbfL2Rwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4434020748;
        Sun, 29 Dec 2019 17:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641966;
        bh=ny3FOPKwe+oyzpG9YmcV/3mbjPsP6yMi/PFrkWTyqvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iD/C9x0C63kjTEmdY3TtVkNH7C2aV2OtUwjCP83WJTkMBx9IKQEZ51Gt6+DuT70vv
         DL8mm2qWpvr3QTDtRV+DDLKrhGqpSL6dR6MNQMB1zGfaBabaYSXjDo/UEWgU/qEFQT
         BKv0uknXnppEWKwknVNNgiDNNY6QxJz+6nCHnbUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 279/434] ice: delay less
Date:   Sun, 29 Dec 2019 18:25:32 +0100
Message-Id: <20191229172720.475752151@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

[ Upstream commit 88bb432a55de8ae62106305083a8bfbb23b01ad2 ]

Shorten the delay for SQ responses, but increase the number of loops.
Max delay time is unchanged, but some operations complete much more
quickly.

In the process, add a new define to make the delay count and delay time
more explicit. Add comments to make things more explicit.

This fixes a problem with VF resets failing on with many VFs.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 2 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 2353166c654e..c68709c7ef81 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -948,7 +948,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		if (ice_sq_done(hw, cq))
 			break;
 
-		mdelay(1);
+		udelay(ICE_CTL_Q_SQ_CMD_USEC);
 		total_delay++;
 	} while (total_delay < cq->sq_cmd_timeout);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index 44945c2165d8..4df9da359135 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -31,8 +31,9 @@ enum ice_ctl_q {
 	ICE_CTL_Q_MAILBOX,
 };
 
-/* Control Queue default settings */
-#define ICE_CTL_Q_SQ_CMD_TIMEOUT	250  /* msecs */
+/* Control Queue timeout settings - max delay 250ms */
+#define ICE_CTL_Q_SQ_CMD_TIMEOUT	2500  /* Count 2500 times */
+#define ICE_CTL_Q_SQ_CMD_USEC		100   /* Check every 100usec */
 
 struct ice_ctl_q_ring {
 	void *dma_head;			/* Virtual address to DMA head */
-- 
2.20.1



