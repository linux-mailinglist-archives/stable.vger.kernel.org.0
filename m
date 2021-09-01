Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D215C3FDB68
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343650AbhIAMli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344628AbhIAMjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93D1161027;
        Wed,  1 Sep 2021 12:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499733;
        bh=7jMIjn6s+IhzSVUWGhybjNp62m+Hdg9IPQqugU2pdj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzehQues9inovEMpCB+OTM/qTY5/c40/rDNFNxwyBVUkb2IA4aYZpOtn3k4qe0vnF
         3CXmd+m8V0WH0G8v7P+XXZmZVfR7HjBpjkXKA0j+aeeXeVpiBrCcnKFTbEXylBb8K1
         HOXfxsI1X4mn6y93euxAA9BEeG4dDL+QtrRCPJ1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/103] e1000e: Do not take care about recovery NVM checksum
Date:   Wed,  1 Sep 2021 14:27:41 +0200
Message-Id: <20210901122301.600906392@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

[ Upstream commit 4051f68318ca9f3d3becef3b54e70ad2c146df97 ]

On new platforms, the NVM is read-only. Attempting to update the NVM
is causing a lockup to occur. Do not attempt to write to the NVM
on platforms where it's not supported.
Emit an error message when the NVM checksum is invalid.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213667
Fixes: fb776f5d57ee ("e1000e: Add support for Tiger Lake")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Suggested-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 5f0f1bd522f0..854c585de2e1 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4134,13 +4134,17 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 		return ret_val;
 
 	if (!(data & valid_csum_mask)) {
-		data |= valid_csum_mask;
-		ret_val = e1000_write_nvm(hw, word, 1, &data);
-		if (ret_val)
-			return ret_val;
-		ret_val = e1000e_update_nvm_checksum(hw);
-		if (ret_val)
-			return ret_val;
+		e_dbg("NVM Checksum Invalid\n");
+
+		if (hw->mac.type < e1000_pch_cnp) {
+			data |= valid_csum_mask;
+			ret_val = e1000_write_nvm(hw, word, 1, &data);
+			if (ret_val)
+				return ret_val;
+			ret_val = e1000e_update_nvm_checksum(hw);
+			if (ret_val)
+				return ret_val;
+		}
 	}
 
 	return e1000e_validate_nvm_checksum_generic(hw);
-- 
2.30.2



