Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086264095F3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346343AbhIMOq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347696AbhIMOmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591996320D;
        Mon, 13 Sep 2021 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541422;
        bh=dSlxYLHXLnrSxyri/2CQBJVQSOGx2GRAbEKW4oBNzhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VH3C0IvQl0jDSNOjHBZF4sUw7l8xOHzpOhDT167nfHphqWGMiyShtYb4N7Vd0hR2W
         mLBJu7/GkZCOazwrH/McQb2GLpujuiAPkMmtVfsC7seXEy+WrNWrefqaFQ7RZf5QHR
         CzlwozU2vsyA6oJDbIBpL0U/9KrBm84KMrVcj0w0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 274/334] ice: fix Tx queue iteration for Tx timestamp enablement
Date:   Mon, 13 Sep 2021 15:15:28 +0200
Message-Id: <20210913131122.690955606@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 84c5fb8c4264ec12ef9d21905c562d2297a0234e ]

The driver accidentally copied the ice_for_each_rxq iterator when
implementing enablement of the ptp_tx bit for the Tx rings. We still
load the Tx rings and set the ptp_tx field, but we iterate over the
count of the num_rxq.

If the number of Tx and Rx queues differ, this could either cause
a buffer overrun when accessing the tx_rings list if num_txq is greater
than num_rxq, or it could cause us to fail to enable Tx timestamps for
some rings.

This was not noticed originally as we generally have the same number of
Tx and Rx queues.

Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 9e3ddb9b8b51..f54148fb0e21 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -22,7 +22,7 @@ static void ice_set_tx_tstamp(struct ice_pf *pf, bool on)
 		return;
 
 	/* Set the timestamp enable flag for all the Tx rings */
-	ice_for_each_rxq(vsi, i) {
+	ice_for_each_txq(vsi, i) {
 		if (!vsi->tx_rings[i])
 			continue;
 		vsi->tx_rings[i]->ptp_tx = on;
-- 
2.30.2



