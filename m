Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8811F1BCAF8
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgD1Sey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729675AbgD1Sev (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:34:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8075520B80;
        Tue, 28 Apr 2020 18:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098891;
        bh=+Kqz7iBDUfUsOPk7sYgADoGCWo1JAntG1JwD5JFUJFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usLUCMZoQIve7Eh8E8bvbe1IP/FGQ2ic0z9ZUXtVBWGi/hUF1EHDrQVuqhDuN/YpD
         hYkj4nfQwv+J0hua7yLgi0cbz9fmnbkmbPXSixMfNQ+8kB7J7wPkYnBBqWuLNNOQXA
         nOf+fI/TF+vSX+FFl/oabrsd1/Txk9txnsaQIeTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.6 125/167] iwlwifi: pcie: indicate correct RB size to device
Date:   Tue, 28 Apr 2020 20:25:01 +0200
Message-Id: <20200428182241.117194663@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit d8d663970234fe885f29edf4f06394d0928c89f4 upstream.

In the context info, we need to indicate the correct RB size
to the device so that it will not think we have 4k when we
only use 2k. This seems to not have caused any issues right
now, likely because the hardware no longer supports putting
multiple entries into a single RB, and practically all of
the entries should be smaller than 2k.

Nevertheless, it's a bug, and we must advertise the right
size to the device.

Note that right now we can only tell it 2k vs. 4k, so for
the cases where we have more, still use 4k. This needs to
be fixed by the firmware first.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: cfdc20efebdc ("iwlwifi: pcie: use partial pages if applicable")
Cc: stable@vger.kernel.org # v5.6
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200417100405.ae6cd345764f.I0985c55223decf70182b9ef1d8edf4179f537853@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |   18 +++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -129,6 +129,18 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 	int cmdq_size = max_t(u32, IWL_CMD_QUEUE_SIZE,
 			      trans->cfg->min_txq_size);
 
+	switch (trans_pcie->rx_buf_size) {
+	case IWL_AMSDU_DEF:
+		return -EINVAL;
+	case IWL_AMSDU_2K:
+		break;
+	case IWL_AMSDU_4K:
+	case IWL_AMSDU_8K:
+	case IWL_AMSDU_12K:
+		control_flags |= IWL_PRPH_SCRATCH_RB_SIZE_4K;
+		break;
+	}
+
 	/* Allocate prph scratch */
 	prph_scratch = dma_alloc_coherent(trans->dev, sizeof(*prph_scratch),
 					  &trans_pcie->prph_scratch_dma_addr,
@@ -143,10 +155,8 @@ int iwl_pcie_ctxt_info_gen3_init(struct
 		cpu_to_le16((u16)iwl_read32(trans, CSR_HW_REV));
 	prph_sc_ctrl->version.size = cpu_to_le16(sizeof(*prph_scratch) / 4);
 
-	control_flags = IWL_PRPH_SCRATCH_RB_SIZE_4K |
-			IWL_PRPH_SCRATCH_MTR_MODE |
-			(IWL_PRPH_MTR_FORMAT_256B &
-			 IWL_PRPH_SCRATCH_MTR_FORMAT);
+	control_flags |= IWL_PRPH_SCRATCH_MTR_MODE;
+	control_flags |= IWL_PRPH_MTR_FORMAT_256B & IWL_PRPH_SCRATCH_MTR_FORMAT;
 
 	/* initialize RX default queue */
 	prph_sc_ctrl->rbd_cfg.free_rbd_addr =


