Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD14E31371B
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhBHPUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233436AbhBHPNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:13:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 149CE64EB1;
        Mon,  8 Feb 2021 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796989;
        bh=s8bD+ZVCd/i2AGX+NGj3E0iaY0z+0vYZgixPpuWEyOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBV7d7AGdlbhReCopV4u/nL8Jhqvwc5VJ/GEGtGAA7GLB6iCtDKQ7NPzHTgDEQgkj
         a6FmuGbv+T7NsTZD0dUFoc1eT1tUAH/VMUmOn1MmbULgegqvkhXN2MFSvZRbCq+pDU
         FOrcQ8Svz4mdw94wEungt1j2iHZkS8p1UQOQNzek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Lo <kevlo@kevlo.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/65] igc: set the default return value to -IGC_ERR_NVM in igc_write_nvm_srwr
Date:   Mon,  8 Feb 2021 16:00:45 +0100
Message-Id: <20210208145810.750953737@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Lo <kevlo@kevlo.org>

[ Upstream commit ebc8d125062e7dccb7922b2190b097c20d88ad96 ]

This patch sets the default return value to -IGC_ERR_NVM in
igc_write_nvm_srwr. Without this change it wouldn't lead to a shadow RAM
write EEWR timeout.

Fixes: ab4056126813 ("igc: Add NVM support")
Signed-off-by: Kevin Lo <kevlo@kevlo.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index c25f555aaf822..ed5d09c11c389 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -219,9 +219,9 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 			      u16 *data)
 {
 	struct igc_nvm_info *nvm = &hw->nvm;
+	s32 ret_val = -IGC_ERR_NVM;
 	u32 attempts = 100000;
 	u32 i, k, eewr = 0;
-	s32 ret_val = 0;
 
 	/* A check for invalid values:  offset too large, too many words,
 	 * too many words for the offset, and not enough words.
@@ -229,7 +229,6 @@ static s32 igc_write_nvm_srwr(struct igc_hw *hw, u16 offset, u16 words,
 	if (offset >= nvm->word_size || (words > (nvm->word_size - offset)) ||
 	    words == 0) {
 		hw_dbg("nvm parameter(s) out of bounds\n");
-		ret_val = -IGC_ERR_NVM;
 		goto out;
 	}
 
-- 
2.27.0



