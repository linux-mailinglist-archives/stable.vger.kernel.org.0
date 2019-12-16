Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F355112160C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfLPS0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731618AbfLPSRB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:17:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12A33206E0;
        Mon, 16 Dec 2019 18:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520220;
        bh=PwdgbR5BzzcUXuLZZnz4X5SVfhL6xSdUlCGJ9zVV9Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0p4t7IedcG2GjtUKNXF65U3bTddws/lY6zlKwq33JRQape2Z8EeTbNDUAPPmYoy9
         tbsNPd3jfmO2ucsZr7l4D7YyKyx5JJKvTQHhUJCbB4p4ybiG3rjweFGpG6UpT83VyL
         iPTkU0SSNCXCVt/7Y+khtiBJwmvnYmuMeyWN9idE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 065/177] iwlwifi: pcie: fix support for transmitting SKBs with fraglist
Date:   Mon, 16 Dec 2019 18:48:41 +0100
Message-Id: <20191216174832.865784429@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 4f4925a7b23428d5719af5a2816586b2a0e6fd19 upstream.

When the implementation of SKBs with fraglist was sent upstream, a
merge-damage occurred and half the patch was not applied.

This causes problems in high-throughput situations with AX200 devices,
including low throughput and FW crashes.

Introduce the part that was missing from the original patch.

Fixes: 0044f1716c4d ("iwlwifi: pcie: support transmitting SKBs with fraglist")
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ This patch was created by me, but the original author of this code
  is Johannes, so his s-o-b is here and he's marked as the author of
  the patch. ]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -468,6 +468,7 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(stru
 	dma_addr_t tb_phys;
 	int len, tb1_len, tb2_len;
 	void *tb1_addr;
+	struct sk_buff *frag;
 
 	tb_phys = iwl_pcie_get_first_tb_dma(txq, idx);
 
@@ -516,6 +517,19 @@ iwl_tfh_tfd *iwl_pcie_gen2_build_tx(stru
 	if (iwl_pcie_gen2_tx_add_frags(trans, skb, tfd, out_meta))
 		goto out_err;
 
+	skb_walk_frags(skb, frag) {
+		tb_phys = dma_map_single(trans->dev, frag->data,
+					 skb_headlen(frag), DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(trans->dev, tb_phys)))
+			goto out_err;
+		iwl_pcie_gen2_set_tb(trans, tfd, tb_phys, skb_headlen(frag));
+		trace_iwlwifi_dev_tx_tb(trans->dev, skb,
+					frag->data,
+					skb_headlen(frag));
+		if (iwl_pcie_gen2_tx_add_frags(trans, frag, tfd, out_meta))
+			goto out_err;
+	}
+
 	return tfd;
 
 out_err:


