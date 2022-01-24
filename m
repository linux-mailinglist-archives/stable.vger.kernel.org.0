Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C1449975C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448574AbiAXVNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32998 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446653AbiAXVI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A11C61469;
        Mon, 24 Jan 2022 21:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645FBC340E7;
        Mon, 24 Jan 2022 21:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058538;
        bh=uQrGCGdoQ9qxoCu/WNLQXqQtn31mcFA9j1l2DQzKAps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9Gz0LJdhpUTgV6PGbPuLXM1K3WBCluAHJ2lpTr9swKgF0bTpYXoA4ZCYq63QFok2
         dwBA8qXtpxtyIYGZJiqa4atT5d5lzBQhamVMVMwcQRZbo+9RVSGKo62HgpHiv47576
         CrX3E0thVWcX6dQtsQap/sK6DSNr8bJtE4uMFvkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0321/1039] mt76: connac: remove MCU_FW_PREFIX bit
Date:   Mon, 24 Jan 2022 19:35:10 +0100
Message-Id: <20220124184136.091870192@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 7159eb828d21ad8fb3c1c1782a286a658ba6bf66 ]

Get rid of MCU_FW_PREFIX bit since it is no longer used

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 9dbb6ae9f21da..b3cd6ca815278 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -496,11 +496,9 @@ enum {
 #define MCU_CMD_UNI_EXT_ACK			(MCU_CMD_ACK | MCU_CMD_UNI | \
 						 MCU_CMD_QUERY)
 
-#define MCU_FW_PREFIX				BIT(31)
 #define MCU_UNI_PREFIX				BIT(30)
 #define MCU_CE_PREFIX				BIT(29)
-#define MCU_CMD_MASK				~(MCU_FW_PREFIX | MCU_UNI_PREFIX |	\
-						  MCU_CE_PREFIX)
+#define MCU_CMD_MASK				~(MCU_UNI_PREFIX | MCU_CE_PREFIX)
 
 #define __MCU_CMD_FIELD_ID			GENMASK(7, 0)
 #define __MCU_CMD_FIELD_EXT_ID			GENMASK(15, 8)
@@ -573,17 +571,17 @@ enum {
 };
 
 enum {
-	MCU_CMD_TARGET_ADDRESS_LEN_REQ = MCU_FW_PREFIX | 0x01,
-	MCU_CMD_FW_START_REQ = MCU_FW_PREFIX | 0x02,
+	MCU_CMD_TARGET_ADDRESS_LEN_REQ = 0x01,
+	MCU_CMD_FW_START_REQ = 0x02,
 	MCU_CMD_INIT_ACCESS_REG = 0x3,
-	MCU_CMD_NIC_POWER_CTRL = MCU_FW_PREFIX | 0x4,
-	MCU_CMD_PATCH_START_REQ = MCU_FW_PREFIX | 0x05,
-	MCU_CMD_PATCH_FINISH_REQ = MCU_FW_PREFIX | 0x07,
-	MCU_CMD_PATCH_SEM_CONTROL = MCU_FW_PREFIX | 0x10,
+	MCU_CMD_NIC_POWER_CTRL = 0x4,
+	MCU_CMD_PATCH_START_REQ = 0x05,
+	MCU_CMD_PATCH_FINISH_REQ = 0x07,
+	MCU_CMD_PATCH_SEM_CONTROL = 0x10,
 	MCU_CMD_WA_PARAM = 0xc4,
 	MCU_CMD_EXT_CID = 0xed,
-	MCU_CMD_FW_SCATTER = MCU_FW_PREFIX | 0xee,
-	MCU_CMD_RESTART_DL_REQ = MCU_FW_PREFIX | 0xef,
+	MCU_CMD_FW_SCATTER = 0xee,
+	MCU_CMD_RESTART_DL_REQ = 0xef,
 };
 
 /* offload mcu commands */
-- 
2.34.1



