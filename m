Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B93101796
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbfKSFmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728932AbfKSFmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95D8621939;
        Tue, 19 Nov 2019 05:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142127;
        bh=1NofNetifklNsULoKa8iBoNhHM8w7x2djmZ0FjMFPW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EA6W8iDXVufqUyMfGF16Q1SwCBxo3Fyx6Ro38Dva5NPFvEFmqOdEdbwMJHcYHpsat
         mrrhva8FhwXJePE9ahjzSZzfD260kqHzzDC3ozN0haFMTdQvfLbAsJcu6dtzA20ovG
         lqleTvtlNrvFpgrZaF9tRVQ3s+FR4Qcg3zrrxuFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 395/422] iwlwifi: pcie: gen2: build A-MSDU only for GSO
Date:   Tue, 19 Nov 2019 06:19:52 +0100
Message-Id: <20191119051424.726667744@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 53f474e6a8d74d5dc0c3a015d889471f9a157685 ]

If the incoming frame should be an A-MSDU, it may already be one,
for example in the case of NAN multicast being encapsulated in an
A-MSDU. Thus, use the GSO algorithm to build A-MSDU only if the
skb actually contains GSO data.

Fixes: 6ffe5de35b05 ("iwlwifi: pcie: add AMSDU to gen2")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b99f33ff91230..61ffa1d1a00d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -526,7 +526,12 @@ struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
 
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
-	if (amsdu)
+	/*
+	 * Only build A-MSDUs here if doing so by GSO, otherwise it may be
+	 * an A-MSDU for other reasons, e.g. NAN or an A-MSDU having been
+	 * built in the higher layers already.
+	 */
+	if (amsdu && skb_shinfo(skb)->gso_size)
 		return iwl_pcie_gen2_build_tx_amsdu(trans, txq, dev_cmd, skb,
 						    out_meta, hdr_len, len);
 
-- 
2.20.1



