Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F65012C885
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbfL2Rzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732972AbfL2Rzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:55:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99262206DB;
        Sun, 29 Dec 2019 17:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642144;
        bh=u53Zuqm+MdMRAsLTirKk63Da+BvkVOKaahC09Hyss4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=je7fUUOL+uIGIMLEJfibyb9zecGsXhW1h+qzAdBzjgmqOn3YKlQo2C7MzLEyoYfLe
         dEs9Ap/AYjBTZtUKGziy1yDOWdUWALcBzhxgr/GZdlJ/lP56XWuGvIak/uSCQacLDK
         woa+MrXtUCFCTThk7/WDd+jdqwdYcemMzWch1OAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>,
        Luca Coelho <luciano.coelho@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 359/434] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling
Date:   Sun, 29 Dec 2019 18:26:52 +0100
Message-Id: <20191229172725.816512424@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

[ Upstream commit b167191e2a851cb2e4c6ef8b91c83ff73ef41872 ]

Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
napi_gro_receive()") has applied batched GRO_NORMAL packets processing
to all napi_gro_receive() users, including mac80211-based drivers.

However, this change has led to a regression in iwlwifi driver [1][2] as
it is required for NAPI users to call napi_complete_done() or
napi_complete() and the end of every polling iteration, whilst iwlwifi
doesn't use NAPI scheduling at all and just calls napi_gro_flush().
In that particular case, packets which have not been already flushed
from napi->rx_list stall in it until at least next Rx cycle.

Fix this by adding a manual flushing of the list to iwlwifi driver right
before napi_gro_flush() call to mimic napi_complete() logics.

I prefer to open-code gro_normal_list() rather than exporting it for 2
reasons:
* to prevent from using it and napi_gro_flush() in any new drivers,
  as it is the *really* bad way to use NAPI that should be avoided;
* to keep gro_normal_list() static and don't lose any CC optimizations.

I also don't add the "Fixes:" tag as the mentioned commit was only a
trigger that only exposed an improper usage of NAPI in this particular
driver.

[1] https://lore.kernel.org/netdev/PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
[2] https://bugzilla.kernel.org/show_bug.cgi?id=205647

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Acked-by: Luca Coelho <luciano.coelho@intel.com>
Reported-by: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Tested-by: Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Reviewed-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 19dd075f2f63..041dd75ac72b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1429,6 +1429,7 @@ out_err:
 static void iwl_pcie_rx_handle(struct iwl_trans *trans, int queue)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct napi_struct *napi;
 	struct iwl_rxq *rxq;
 	u32 r, i, count = 0;
 	bool emergency = false;
@@ -1534,8 +1535,16 @@ out:
 	if (unlikely(emergency && count))
 		iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
 
-	if (rxq->napi.poll)
-		napi_gro_flush(&rxq->napi, false);
+	napi = &rxq->napi;
+	if (napi->poll) {
+		if (napi->rx_count) {
+			netif_receive_skb_list(&napi->rx_list);
+			INIT_LIST_HEAD(&napi->rx_list);
+			napi->rx_count = 0;
+		}
+
+		napi_gro_flush(napi, false);
+	}
 
 	iwl_pcie_rxq_restock(trans, rxq);
 }
-- 
2.20.1



