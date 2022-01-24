Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A67A499495
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359008AbiAXUnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:43:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35354 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389010AbiAXUkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:40:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C771961372;
        Mon, 24 Jan 2022 20:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A91C340E5;
        Mon, 24 Jan 2022 20:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056821;
        bh=+2CGRR58hyrC+e0/rwMd7vvHpmue7xOZCLaTjHMreKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HowtncY5Wvn2XYoLYcUTR93HuOQXzuxp4HmNpYnkxAyjlr9sA9w7wEPkNgTRZSe1Q
         PSFVLH3Szc1Vv+WivTgPQ8JpoEjABKqHmcgdzZNxt8e5D0XfaQ3U6VWiczKKZuD6Xn
         vypnePK1SX1v3o14ne2zdalEoqDjhW9B0MgLq3HM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 579/846] iwlwifi: pcie: make sure prph_info is set when treating wakeup IRQ
Date:   Mon, 24 Jan 2022 19:41:36 +0100
Message-Id: <20220124184121.016112149@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 459fc0f2c6b0f6e280bfa0f230c100c9dfe3a199 ]

In some rare cases when the HW is in a bad state, we may get this
interrupt when prph_info is not set yet.  Then we will try to
dereference it to check the sleep_notif element, which will cause an
oops.

Fix that by ignoring the interrupt if prph_info is not set yet.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219132536.0537aa562313.I183bb336345b9b3da196ba9e596a6f189fbcbd09@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 8e45eb38304b2..fea89330f692c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -2261,7 +2261,12 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 		}
 	}
 
-	if (inta_hw & MSIX_HW_INT_CAUSES_REG_WAKEUP) {
+	/*
+	 * In some rare cases when the HW is in a bad state, we may
+	 * get this interrupt too early, when prph_info is still NULL.
+	 * So make sure that it's not NULL to prevent crashing.
+	 */
+	if (inta_hw & MSIX_HW_INT_CAUSES_REG_WAKEUP && trans_pcie->prph_info) {
 		u32 sleep_notif =
 			le32_to_cpu(trans_pcie->prph_info->sleep_notif);
 		if (sleep_notif == IWL_D3_SLEEP_STATUS_SUSPEND ||
-- 
2.34.1



