Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F1E10153D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbfKSFmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbfKSFmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAAC1208C3;
        Tue, 19 Nov 2019 05:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142121;
        bh=yN32PYfjsyUrcNe1jxL8v16H/2fHGlbsjA34/dPKFko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgrD16iq5Q9uN1lZdpw/ZlVXU+I7reWI9KnhBRCFGKkPRXE9lqRXsIRF/5EeLGhGi
         YFs0wn43rIVi8FbXMBNcAcUhQCc2Sw6FZ8gn2Goks/LMRrBeMjqU+58JHAXSKORns7
         o0WkHwdn5b2Ekg3Mjp4fGZWoAtCcAH7/t0aO5ve0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 393/422] iwlwifi: pcie: read correct prph address for newer devices
Date:   Tue, 19 Nov 2019 06:19:50 +0100
Message-Id: <20191119051424.594627397@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 84fb372c892e231e9a2ffdaa5c2df52d94aa536c ]

For newer devices we have higher range of periphery
addresses. Currently it is masked out, so we end up
reading another address.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7d319b6863feb..954f932e9c88e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1830,18 +1830,30 @@ static u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
 	return readl(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
+static u32 iwl_trans_pcie_prph_msk(struct iwl_trans *trans)
+{
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+		return 0x00FFFFFF;
+	else
+		return 0x000FFFFF;
+}
+
 static u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg)
 {
+	u32 mask = iwl_trans_pcie_prph_msk(trans);
+
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_RADDR,
-			       ((reg & 0x000FFFFF) | (3 << 24)));
+			       ((reg & mask) | (3 << 24)));
 	return iwl_trans_pcie_read32(trans, HBUS_TARG_PRPH_RDAT);
 }
 
 static void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr,
 				      u32 val)
 {
+	u32 mask = iwl_trans_pcie_prph_msk(trans);
+
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WADDR,
-			       ((addr & 0x000FFFFF) | (3 << 24)));
+			       ((addr & mask) | (3 << 24)));
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 }
 
-- 
2.20.1



