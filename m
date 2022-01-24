Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EECE499978
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455466AbiAXVf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:35:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42586 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452970AbiAXV1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FCA2B81218;
        Mon, 24 Jan 2022 21:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6292C340E4;
        Mon, 24 Jan 2022 21:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059648;
        bh=t24xaTbX/YPgqubRwPSZulUBEsrmp1dBDxvvqQabvmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tg4X64ZC96dazK6u20I8v7YGFaxr/eyAldXPyzavse1p7mth+gc9hK/behkJ9xZCd
         fhTYm1mKFMqflsLDf+WcVpvrB2qPzAyVw6cw9JjQlanoKjV84Y3PefhTYApsTXL0wz
         ZlJAcwQbRo8M3ersHzwhujodAI+KI255FpmRyxt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0685/1039] iwlwifi: pcie: make sure prph_info is set when treating wakeup IRQ
Date:   Mon, 24 Jan 2022 19:41:14 +0100
Message-Id: <20220124184148.376711013@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 14602d6d6699f..8247014278f30 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -2266,7 +2266,12 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
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



