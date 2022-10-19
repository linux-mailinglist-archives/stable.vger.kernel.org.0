Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94189604171
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiJSKop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbiJSKne (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:43:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7248EACF44;
        Wed, 19 Oct 2022 03:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EB0BB82336;
        Wed, 19 Oct 2022 08:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B09C433D6;
        Wed, 19 Oct 2022 08:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169514;
        bh=r7arRSQHyneX+YQtZan5pfZMFZYfLBwooiTK+ip3S0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGJdSBgPoapChdlaZ8OiRORfL8CqPDhzs4ev8VJy4Fh0k6v8NvtGkKQZaBjxjy+vq
         Gf7QfqCdmRtzVMUu7/VWdbkFC1MIwKaWHz+um2sCJbqce3WmZhQFJf47ptfhS5eTTI
         YIQdsrBfI1UgDsyddSKaa1/PoyMhoVjyc6RSnrnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 272/862] wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration
Date:   Wed, 19 Oct 2022 10:25:59 +0200
Message-Id: <20221019083302.050234305@linuxfoundation.org>
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

[ Upstream commit e963a19c64ac0d2f8785d36a27391abd91ac77aa ]

Found by comparing with the vendor driver. Currently this affects
only the RTL8192EU, which is the only gen2 chip with 2 TX paths
supported by this driver. It's unclear what kind of effect the
mistake had in practice, since I don't have any RTL8192EU devices
to test it.

Fixes: e1547c535ede ("rtl8xxxu: First stab at adding IQK calibration for 8723bu parts")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/30a59f3a-cfa9-8379-7af0-78a8f4c77cfd@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 02b7bc57d217..7a1ea4a59569 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -2929,12 +2929,12 @@ bool rtl8xxxu_gen2_simularity_compare(struct rtl8xxxu_priv *priv,
 		}
 
 		if (!(simubitmap & 0x30) && priv->tx_paths > 1) {
-			/* path B RX OK */
+			/* path B TX OK */
 			for (i = 4; i < 6; i++)
 				result[3][i] = result[c1][i];
 		}
 
-		if (!(simubitmap & 0x30) && priv->tx_paths > 1) {
+		if (!(simubitmap & 0xc0) && priv->tx_paths > 1) {
 			/* path B RX OK */
 			for (i = 6; i < 8; i++)
 				result[3][i] = result[c1][i];
-- 
2.35.1



