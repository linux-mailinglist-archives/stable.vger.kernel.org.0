Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC693C46B1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhGLG1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234367AbhGLG0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:26:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9078611CB;
        Mon, 12 Jul 2021 06:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071018;
        bh=722EzPcliDfEDdsA4lBTSNcWkxlQt+1A4GuAFFDs4oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M58Mu2sonH5LcUi9M1gjHxQnvR6/dpIpE6QZxcPfCDpJk9GPfVS2JRX3wjg20aP9r
         /WUGOjcjXvm4u1SXjylYnsdDlPYT6asq9qeb+nbZoZzaLn0X/2nBypdKH3N6s0ElWx
         3RlMXcTiqcjSfk0SqIqM+3MjENX3sspyIJsSBUbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 238/348] e1000e: Check the PCIm state
Date:   Mon, 12 Jul 2021 08:10:22 +0200
Message-Id: <20210712060734.100182248@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index c2feedfd321d..a06d514215ed 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5199,18 +5199,20 @@ static void e1000_watchdog_task(struct work_struct *work)
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



