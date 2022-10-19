Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA19603E98
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiJSJQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiJSJM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:12:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F78C97D9;
        Wed, 19 Oct 2022 02:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9052E617DF;
        Wed, 19 Oct 2022 08:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970FEC433C1;
        Wed, 19 Oct 2022 08:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169516;
        bh=Vhqc/iSSYlAG2gq4WdkPUvCQWXXp99Pauwt3oN6zyPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zR0Tt6N3Ep4KHyvI1fvvl2EvmcMa8V8KDgxScm6DMwHugTpeAL+5pCBhb8aZtpmw7
         kkbaMAqpapIEqqvKXp5+h2lgfWzofNDUhSxCW5hMmpyt8YnIPS5Utv0QsdtpTyWedY
         mtcc/VCWk3ZZUi2oOzTn1eR1eW4gIDyTOKqXkDOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 273/862] wifi: rtl8xxxu: Remove copy-paste leftover in gen2_update_rate_mask
Date:   Wed, 19 Oct 2022 10:26:00 +0200
Message-Id: <20221019083302.098577605@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit d5350756c03cdf18696295c6b11d7acc4dbf825c ]

It looks like a leftover from copying rtl8xxxu_update_rate_mask,
which is used with the gen1 chips.

It wasn't causing any problems for my RTL8188FU test device, but it's
clearly a mistake, so remove it.

Fixes: f653e69009c6 ("rtl8xxxu: Implement basic 8723b specific update_rate_mask() function")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/d5544fe8-9798-28f1-54bd-6839a1974b10@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 7a1ea4a59569..41d46c54444f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4353,15 +4353,14 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 	h2c.b_macid_cfg.ramask2 = (ramask >> 16) & 0xff;
 	h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
 
-	h2c.ramask.arg = 0x80;
 	h2c.b_macid_cfg.data1 = rateid;
 	if (sgi)
 		h2c.b_macid_cfg.data1 |= BIT(7);
 
 	h2c.b_macid_cfg.data2 = bw;
 
-	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x, size %zi\n",
-		__func__, ramask, h2c.ramask.arg, sizeof(h2c.b_macid_cfg));
+	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, rateid %02x, sgi %d, size %zi\n",
+		__func__, ramask, rateid, sgi, sizeof(h2c.b_macid_cfg));
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
 }
 
-- 
2.35.1



