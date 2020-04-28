Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1CA1BC8AE
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgD1Seh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbgD1Seg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:34:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F932085B;
        Tue, 28 Apr 2020 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098876;
        bh=rHeOJyYXcfmyyj7FAJKTI/g4L1nchU3r4O9a39+OQCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eY/Tv0LwsPXGl46QzDAs65RmeXg6X3/hLn7IAoiZC4gTXdyUdNikKFtgW4KOmPXT1
         +GRv2DbsHBwQ44ZjkcKVcbYJhSkKT1hKdfoZiPk8KQ4Ufm93mixE5/EJ4ozdAUEa+1
         7a5QP2M8t5opQy+aHv31jk8m0u3JWLseD9WdLl10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.6 123/167] iwlwifi: pcie: actually release queue memory in TVQM
Date:   Tue, 28 Apr 2020 20:24:59 +0200
Message-Id: <20200428182240.835995469@linuxfoundation.org>
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

commit b98b33d5560a2d940f3b80f6768a6177bf3dfbc0 upstream.

The iwl_trans_pcie_dyn_txq_free() function only releases the frames
that may be left on the queue by calling iwl_pcie_gen2_txq_unmap(),
but doesn't actually free the DMA ring or byte-count tables for the
queue. This leads to pretty large memory leaks (at least before my
queue size improvements), in particular in monitor/sniffer mode on
channel hopping since this happens on every channel change.

This was also now more evident after the move to a DMA pool for the
byte count tables, showing messages such as

  BUG iwlwifi:bc (...): Objects remaining in iwlwifi:bc on __kmem_cache_shutdown()

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=206811.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 6b35ff91572f ("iwlwifi: pcie: introduce a000 TX queues management")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200417100405.f5f4c4193ec1.Id5feebc9b4318041913a9c89fc1378bb5454292c@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1418,6 +1418,9 @@ void iwl_trans_pcie_dyn_txq_free(struct
 
 	iwl_pcie_gen2_txq_unmap(trans, queue);
 
+	iwl_pcie_gen2_txq_free_memory(trans, trans_pcie->txq[queue]);
+	trans_pcie->txq[queue] = NULL;
+
 	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", queue);
 }
 


