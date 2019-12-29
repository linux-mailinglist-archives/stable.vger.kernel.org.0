Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873B612C50D
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfL2Rd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729447AbfL2Rd0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:33:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F06E20722;
        Sun, 29 Dec 2019 17:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640806;
        bh=9i1Jr+SvpKUsKxC8Rk9QFn7n63t/QgZ4Xh1bVFlNJec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLHybNG5EzzXwZzHQqFKR+NQCyIMEsLlq6b2/s0JuXa1gHOHhWPwWfxNfdU65ZQDm
         s8upNUdAHKnv/K0+pPx4BWFBCq/VTHMG/sh/Xib37HfgJJJBevRvsYxZdXIzJKIix5
         6lqKJygJ7l1lncomwdfY1wKXzDNXTpBbto3PKzh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/219] ice: delay less
Date:   Sun, 29 Dec 2019 18:19:09 +0100
Message-Id: <20191229162530.604506591@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
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
index 89f18fe18fe3..921cc0c9a30d 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -911,7 +911,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		if (ice_sq_done(hw, cq))
 			break;
 
-		mdelay(1);
+		udelay(ICE_CTL_Q_SQ_CMD_USEC);
 		total_delay++;
 	} while (total_delay < cq->sq_cmd_timeout);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index ea02b89243e2..0f2cdb06e6ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -30,8 +30,9 @@ enum ice_ctl_q {
 	ICE_CTL_Q_ADMIN,
 };
 
-/* Control Queue default settings */
-#define ICE_CTL_Q_SQ_CMD_TIMEOUT	250  /* msecs */
+/* Control Queue timeout settings - max delay 250ms */
+#define ICE_CTL_Q_SQ_CMD_TIMEOUT	2500  /* Count 2500 times */
+#define ICE_CTL_Q_SQ_CMD_USEC		100   /* Check every 100usec */
 
 struct ice_ctl_q_ring {
 	void *dma_head;			/* Virtual address to dma head */
-- 
2.20.1



