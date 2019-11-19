Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CFF101564
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbfKSFnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbfKSFnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 308B6208C3;
        Tue, 19 Nov 2019 05:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142220;
        bh=anNXDwU1QQ1P75e5uA1Vk4W6iUlx6TtteWrqSceTEdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tD+53Rt6u4zfSyF+vTiY5xrZT9UI1IgEHnWoKry9TDMu1xgyH9IvDj8Z3/kRbxiTP
         Ct1VtrSisJznlvhfd9uvqJfvJtHSU+wCGQ/Y73fLyerEA9cDHUHfvUBauK5PurZIRg
         P5oyj82YMSrrfARG2t1D0fLHmpcn2UgxUICg1rT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 396/422] iwlwifi: pcie: fit reclaim msg to MAX_MSG_LEN
Date:   Tue, 19 Nov 2019 06:19:53 +0100
Message-Id: <20191119051424.792804627@linuxfoundation.org>
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

From: Golan Ben Ami <golan.ben.ami@intel.com>

[ Upstream commit 81f0c66187e1ebb7b63529d82faf7ff1e0ef428a ]

Today, the length of a debug message in iwl_trans_pcie_reclaim
may pass the MAX_MSG_LEN, which is 110.
An example for this kind of message is:

'iwl_trans_pcie_reclaim: Read index for DMA queue txq id (2),
last_to_free 65535 is out of range [0-65536] 2 2.'

Cut the message a bit so it will fit the allowed MAX_MSG_LEN.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 42fdb7970cfdc..2fec394a988c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1103,7 +1103,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	if (!iwl_queue_used(txq, last_to_free)) {
 		IWL_ERR(trans,
-			"%s: Read index for DMA queue txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
+			"%s: Read index for txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
 			__func__, txq_id, last_to_free,
 			trans->cfg->base_params->max_tfd_queue_size,
 			txq->write_ptr, txq->read_ptr);
-- 
2.20.1



