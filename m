Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7451C318E33
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhBKPWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhBKPRm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:17:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D241064EFE;
        Thu, 11 Feb 2021 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055913;
        bh=6PVh59eQu6Ub0inTYrwaAY4M1J0WXwtcGrWw2y8VC1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FvNNA4E1Xl6+r2CM2K9rx6WuzjApdEbjaU9xju42OVQoShZOMzuoFiJTdsN8CWnZq
         BDkfNs/MC5Bi4kzLveDqv/y9jmK8Fwpm/Zdi7iEMNvymPUmzahEXt9OvjnGEPK69WZ
         LZEWHwY32hYk4SfbO1l/3VdJwD1sk+FITmrTpNBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/54] iwlwifi: pcie: fix context info memory leak
Date:   Thu, 11 Feb 2021 16:02:18 +0100
Message-Id: <20210211150154.365563468@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2d6bc752cc2806366d9a4fd577b3f6c1f7a7e04e ]

If the image loader allocation fails, we leak all the previously
allocated memory. Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.97172cbaa67c.I3473233d0ad01a71aa9400832fb2b9f494d88a11@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c  | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index d719e433a59bf..2d43899fbdd7a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -245,8 +245,10 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 	/* Allocate IML */
 	iml_img = dma_alloc_coherent(trans->dev, trans->iml_len,
 				     &trans_pcie->iml_dma_addr, GFP_KERNEL);
-	if (!iml_img)
-		return -ENOMEM;
+	if (!iml_img) {
+		ret = -ENOMEM;
+		goto err_free_ctxt_info;
+	}
 
 	memcpy(iml_img, trans->iml, trans->iml_len);
 
@@ -284,6 +286,11 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 
 	return 0;
 
+err_free_ctxt_info:
+	dma_free_coherent(trans->dev, sizeof(*trans_pcie->ctxt_info_gen3),
+			  trans_pcie->ctxt_info_gen3,
+			  trans_pcie->ctxt_info_dma_addr);
+	trans_pcie->ctxt_info_gen3 = NULL;
 err_free_prph_info:
 	dma_free_coherent(trans->dev,
 			  sizeof(*prph_info),
-- 
2.27.0



