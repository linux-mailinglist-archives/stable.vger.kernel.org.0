Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC40F111D0B
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfLCWtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729465AbfLCWto (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A9C22084B;
        Tue,  3 Dec 2019 22:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413384;
        bh=2wvUj49ZIRmza/y1ZEGqSzpK0Pxrfhripv45JXUZfLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcDWgfMTeXbuTWc0meYwaCZizPvWuXSKHkwlMrhV7g3DGwIMeu5cr/xdWxfWuL/TQ
         Z81wOFMYV0kHsigSnb6lBxMHdS6FoS+OyCyeWXeXyChbHOWJ91OR/VKI3koeU+uT/I
         Vd1ZFKfvslVIRmTRkAlcJGGpW0x9gtvNLkTrfG+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/321] iwlwifi: pcie: fix erroneous print
Date:   Tue,  3 Dec 2019 23:32:53 +0100
Message-Id: <20191203223432.718134926@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 0916224eaa77bff0fbbc747961d550ff8db45457 ]

When removing the driver, the following flow can happen:
1. host command is in progress, for example at index 68.
2. RX interrupt is received with the response.
3. Before it is processed, the remove flow kicks in, and
   calls iwl_pcie_txq_unmap. The function cleans all DMA,
   and promotes the read pointer to 69.
4. RX thread proceeds with the processing, and is calling
   iwl_pcie_cmdq_reclaim, which will print this error:
   iwl_pcie_cmdq_reclaim: Read index for DMA queue txq id (0),
   index 4 is out of range [0-256] 69 69.

Detect this situation, and avoid the print. Change it to
warning while at it, to make such issues more noticeable
in the future.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 2fec394a988c1..b73582ec03a08 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1247,11 +1247,11 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 
 	if (idx >= trans->cfg->base_params->max_tfd_queue_size ||
 	    (!iwl_queue_used(txq, idx))) {
-		IWL_ERR(trans,
-			"%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
-			__func__, txq_id, idx,
-			trans->cfg->base_params->max_tfd_queue_size,
-			txq->write_ptr, txq->read_ptr);
+		WARN_ONCE(test_bit(txq_id, trans_pcie->queue_used),
+			  "%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
+			  __func__, txq_id, idx,
+			  trans->cfg->base_params->max_tfd_queue_size,
+			  txq->write_ptr, txq->read_ptr);
 		return;
 	}
 
-- 
2.20.1



