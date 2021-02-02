Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD25230C045
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhBBNxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:53:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233129AbhBBNvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:51:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB5764FC1;
        Tue,  2 Feb 2021 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273421;
        bh=00jMgK71EBqH318TCdADuv/Lgi7WByMsOAr2jRw0HGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1Xqon1hIH7nOfggHKrFqovWd7IMfEdVhSYxj7ZSISorkyYiCmZydT6gFEIHJ9HR6
         /YEa90suN6DFphmNjtVnVzNJOr/4lxbQaWQBFvH1t1t5liTIrsf24KfQioZlg5L5oi
         VK3Ep7d2jLmFVsHxbdwQsa8qNdCmoxYtzAcM9cV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/142] iwlwifi: pcie: avoid potential PNVM leaks
Date:   Tue,  2 Feb 2021 14:37:43 +0100
Message-Id: <20210202133001.837635827@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 34b9434cd0d425330a0467e767f8d047ef62964d ]

If we erroneously try to set the PNVM data again after it has
already been set, we could leak the old DMA memory. Avoid that
and warn, we shouldn't be doing this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 6972592850c0 ("iwlwifi: read and parse PNVM file")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.929c2d680429.I086b9490e6c005f3bcaa881b617e9f61908160f3@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 5512e3c630c31..eeb87cf5ee857 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -341,6 +341,9 @@ int iwl_trans_pcie_ctx_info_gen3_set_pnvm(struct iwl_trans *trans,
 		return ret;
 	}
 
+	if (WARN_ON(prph_sc_ctrl->pnvm_cfg.pnvm_size))
+		return -EBUSY;
+
 	prph_sc_ctrl->pnvm_cfg.pnvm_base_addr =
 		cpu_to_le64(trans_pcie->pnvm_dram.physical);
 	prph_sc_ctrl->pnvm_cfg.pnvm_size =
-- 
2.27.0



