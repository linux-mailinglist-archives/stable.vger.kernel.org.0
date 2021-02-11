Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F58318ED6
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhBKPfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231430AbhBKPb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:31:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE36264F16;
        Thu, 11 Feb 2021 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055938;
        bh=CTrKFKFw9wzgKDGrZqscRZtG58ni4CENVIvrkbvqplU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tACRwpJB+cSG20cNh/ExbHe8SYbsCbq5ioLZRNhN9DfbOtSH91Lbj35x52sQcEDUD
         PYD9QvFRUL2IecUU6x7lzGkM1BV0GKegUC3bqfKBWaaPn9RkO8Wpv42CkXUCeVQoZ1
         3WJntMUCvDa9LONrRzzCJN9oLM5UOIseOUE+8mwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/24] iwlwifi: pcie: fix context info memory leak
Date:   Thu, 11 Feb 2021 16:02:35 +0100
Message-Id: <20210211150149.054019804@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
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
index 7a5b024a6d384..eab159205e48b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -164,8 +164,10 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
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
 
@@ -207,6 +209,11 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 
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



