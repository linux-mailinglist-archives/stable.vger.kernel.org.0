Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556F34095E3
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345782AbhIMOqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345656AbhIMOoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:44:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A166D6197A;
        Mon, 13 Sep 2021 13:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541451;
        bh=E06wNBVbgXrk6fcNCYy3JSYoTP/BLRNj1KcnM5hMNzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mkq77YQCknazCkWgYxsYbKrE6KlEe9YvcJFEHzaNnvEPq2jjiDLPzNODKDw1swZSD
         LmZ1LajbpjSZb6R2FCvQnKu54vLtXMmRap1rFrgPZoNmj/ZqDaQ/J5+i9YW6Etdqw6
         qgaFuYq5BxDYusvez3mRqYQ9/yu5R5a5afQy5qig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 275/334] ice: add lock around Tx timestamp tracker flush
Date:   Mon, 13 Sep 2021 15:15:29 +0200
Message-Id: <20210913131122.723500884@linuxfoundation.org>
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

[ Upstream commit 4dd0d5c33c3ebf24a07cae6141648aeb7ba56072 ]

The driver didn't take the lock while flushing the Tx tracker, which
could cause a race where one thread is trying to read timestamps out
while another thread is trying to read the tracker to check the
timestamps.

Avoid this by ensuring that flushing is locked against read accesses.

Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index f54148fb0e21..8970037177fe 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1278,6 +1278,8 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
 	u8 idx;
 
+	spin_lock(&tx->lock);
+
 	for (idx = 0; idx < tx->len; idx++) {
 		u8 phy_idx = idx + tx->quad_offset;
 
@@ -1290,6 +1292,8 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 			tx->tstamps[idx].skb = NULL;
 		}
 	}
+
+	spin_unlock(&tx->lock);
 }
 
 /**
-- 
2.30.2



