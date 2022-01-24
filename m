Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E308D499999
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357812AbiAXVga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448991AbiAXV16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:27:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E862C01D7EE;
        Mon, 24 Jan 2022 12:19:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B88E8B8121C;
        Mon, 24 Jan 2022 20:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CCFC340E5;
        Mon, 24 Jan 2022 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055539;
        bh=f4qv9+XoMJz7jvZPqwNvE9ROL1hpgoLQm93jE0hJKBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMSWFwYDe+uZrSplUuuqpxFvVc7wi5sTov2WuiYgzdnJ8reU0iw04CwpQHvYKc6d4
         ItPfvuj/Z5gYVDo/IeWCotp2nK+yVlRjuvtBUOjyG616VBc2Fw4QQkqu8LM+tkZHwC
         bA5lXuHi29aCV07Iey3rN6yFegKfOg5WpFjG+JOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anilkumar Kolli <akolli@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/846] ath11k: Use host CE parameters for CE interrupts configuration
Date:   Mon, 24 Jan 2022 19:34:29 +0100
Message-Id: <20220124184106.237408110@linuxfoundation.org>
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

From: Anilkumar Kolli <akolli@codeaurora.org>

[ Upstream commit b689f091aafd1a874b2f88137934276ab0fca480 ]

CE interrupt configuration uses host ce parameters to assign/free
interrupts. Use host ce parameters to enable/disable interrupts.
This patch fixes below BUG,

BUG: KASAN: global-out-of-bounds in 0xffffffbffdfb035c at addr
ffffffbffde6eeac
 Read of size 4 by task kworker/u8:2/132
 Address belongs to variable ath11k_core_qmi_firmware_ready+0x1b0/0x5bc [ath11k]

OOB is due to ath11k_ahb_ce_irqs_enable() iterates ce_count(which is 12)
times and accessing 12th element in target_ce_config
(which has only 11 elements) from ath11k_ahb_ce_irq_enable().

With this change host ce configs are used to enable/disable interrupts.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-00471-QCAHKSWPL_SILICONZ-1

Fixes: 967c1d1131fa ("ath11k: move target ce configs to hw_params")
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1637249558-12793-1-git-send-email-akolli@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 8c9c781afc3e5..096c502cce387 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -206,13 +206,13 @@ static void ath11k_ahb_clearbit32(struct ath11k_base *ab, u8 bit, u32 offset)
 
 static void ath11k_ahb_ce_irq_enable(struct ath11k_base *ab, u16 ce_id)
 {
-	const struct ce_pipe_config *ce_config;
+	const struct ce_attr *ce_attr;
 
-	ce_config = &ab->hw_params.target_ce_config[ce_id];
-	if (__le32_to_cpu(ce_config->pipedir) & PIPEDIR_OUT)
+	ce_attr = &ab->hw_params.host_ce_config[ce_id];
+	if (ce_attr->src_nentries)
 		ath11k_ahb_setbit32(ab, ce_id, CE_HOST_IE_ADDRESS);
 
-	if (__le32_to_cpu(ce_config->pipedir) & PIPEDIR_IN) {
+	if (ce_attr->dest_nentries) {
 		ath11k_ahb_setbit32(ab, ce_id, CE_HOST_IE_2_ADDRESS);
 		ath11k_ahb_setbit32(ab, ce_id + CE_HOST_IE_3_SHIFT,
 				    CE_HOST_IE_3_ADDRESS);
@@ -221,13 +221,13 @@ static void ath11k_ahb_ce_irq_enable(struct ath11k_base *ab, u16 ce_id)
 
 static void ath11k_ahb_ce_irq_disable(struct ath11k_base *ab, u16 ce_id)
 {
-	const struct ce_pipe_config *ce_config;
+	const struct ce_attr *ce_attr;
 
-	ce_config = &ab->hw_params.target_ce_config[ce_id];
-	if (__le32_to_cpu(ce_config->pipedir) & PIPEDIR_OUT)
+	ce_attr = &ab->hw_params.host_ce_config[ce_id];
+	if (ce_attr->src_nentries)
 		ath11k_ahb_clearbit32(ab, ce_id, CE_HOST_IE_ADDRESS);
 
-	if (__le32_to_cpu(ce_config->pipedir) & PIPEDIR_IN) {
+	if (ce_attr->dest_nentries) {
 		ath11k_ahb_clearbit32(ab, ce_id, CE_HOST_IE_2_ADDRESS);
 		ath11k_ahb_clearbit32(ab, ce_id + CE_HOST_IE_3_SHIFT,
 				      CE_HOST_IE_3_ADDRESS);
-- 
2.34.1



