Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546F066CA60
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjAPRCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbjAPRCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCE1279A6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:44:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11DDCB80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D51C433EF;
        Mon, 16 Jan 2023 16:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887446;
        bh=SzvOZOsv+Tki7k2ryQ/+xS6ElmkPUmsiGhMjiXyLDU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4kzPpSQAED8JTQHD3+4ZjIHBo94z1er8Ir47+Ox4fvRaaJFJSZ+7omZ0gohcDPky
         rrVbvvNV7KYawfRYKtZJdLvPE66o8DgvEs2Cs07z/AoqhSzQuxhoJTNAisXCSslRSm
         EmrFsk44MhtBdfX4rlYjDu0lLkxKPbY5vvSFuSfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Chiu <chiu@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 152/521] rtl8xxxu: add enumeration for channel bandwidth
Date:   Mon, 16 Jan 2023 16:46:54 +0100
Message-Id: <20230116154854.060973045@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessm.com>

[ Upstream commit a66b8b4108f178f34394681232c7df07e9b0f6be ]

There's a data field in H2C and C2H commands which is used to
carry channel bandwidth information. Add enumeration to make it
more descriptive in code.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200320063833.1058-2-chiu@endlessm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 9 +++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 7eef3f7c36ad..921a226b18f8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1136,6 +1136,15 @@ enum bt_mp_oper_opcode_8723b {
 	BT_MP_OP_ENABLE_CFO_TRACKING = 0x24,
 };
 
+enum rtl8xxxu_bw_mode {
+	RTL8XXXU_CHANNEL_WIDTH_20 = 0,
+	RTL8XXXU_CHANNEL_WIDTH_40 = 1,
+	RTL8XXXU_CHANNEL_WIDTH_80 = 2,
+	RTL8XXXU_CHANNEL_WIDTH_160 = 3,
+	RTL8XXXU_CHANNEL_WIDTH_80_80 = 4,
+	RTL8XXXU_CHANNEL_WIDTH_MAX = 5,
+};
+
 struct rtl8723bu_c2h {
 	u8 id;
 	u8 seq;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index fb8545f79fa6..c3c8382dd0ba 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4333,7 +4333,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 				    u32 ramask, int sgi)
 {
 	struct h2c_cmd h2c;
-	u8 bw = 0;
+	u8 bw = RTL8XXXU_CHANNEL_WIDTH_20;
 
 	memset(&h2c, 0, sizeof(struct h2c_cmd));
 
-- 
2.35.1



