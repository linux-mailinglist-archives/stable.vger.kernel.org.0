Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BE23C5449
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348361AbhGLH5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350648AbhGLHyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C73613F7;
        Mon, 12 Jul 2021 07:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076272;
        bh=oP4csMx2f2zVIELXXu7xNQJfze6/Q7wJ0PwSf8vt4yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9bD8G0c88nQ18typ6CnvERhObdHXZikFd9tm+2XSDtk7pxz/K8YMH6A+eHiSBIig
         KZ2MkIUErFpn9RM1M75cQepc5kS0YSui5xX+qrJZlJdxs4kJcnw60/yRh03jOomtq4
         zwQPoywFpZAW9fO2FP7tlQ2QeHBj9Ju3Tm5KNu2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 573/800] e1000e: Check the PCIm state
Date:   Mon, 12 Jul 2021 08:09:56 +0200
Message-Id: <20210712061028.345358086@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 2e7256f12cdb16eaa2515b6231d665044a07c51a ]

Complete to commit def4ec6dce393e ("e1000e: PCIm function state support")
Check the PCIm state only on CSME systems. There is no point to do this
check on non CSME systems.
This patch fixes a generation a false-positive warning:
"Error in exiting dmoff"

Fixes: def4ec6dce39 ("e1000e: PCIm function state support")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 24 ++++++++++++----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 88e9035b75cf..dc0ded7e5e61 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5223,18 +5223,20 @@ static void e1000_watchdog_task(struct work_struct *work)
 			pm_runtime_resume(netdev->dev.parent);
 
 			/* Checking if MAC is in DMoff state*/
-			pcim_state = er32(STATUS);
-			while (pcim_state & E1000_STATUS_PCIM_STATE) {
-				if (tries++ == dmoff_exit_timeout) {
-					e_dbg("Error in exiting dmoff\n");
-					break;
-				}
-				usleep_range(10000, 20000);
+			if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
 				pcim_state = er32(STATUS);
-
-				/* Checking if MAC exited DMoff state */
-				if (!(pcim_state & E1000_STATUS_PCIM_STATE))
-					e1000_phy_hw_reset(&adapter->hw);
+				while (pcim_state & E1000_STATUS_PCIM_STATE) {
+					if (tries++ == dmoff_exit_timeout) {
+						e_dbg("Error in exiting dmoff\n");
+						break;
+					}
+					usleep_range(10000, 20000);
+					pcim_state = er32(STATUS);
+
+					/* Checking if MAC exited DMoff state */
+					if (!(pcim_state & E1000_STATUS_PCIM_STATE))
+						e1000_phy_hw_reset(&adapter->hw);
+				}
 			}
 
 			/* update snapshot of PHY registers on LSC */
-- 
2.30.2



