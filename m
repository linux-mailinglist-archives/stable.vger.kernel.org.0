Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C592404F1D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245618AbhIIMRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350923AbhIIMOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F3EB61A62;
        Thu,  9 Sep 2021 11:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188153;
        bh=CtX/yPRZcRIVIBZ1kDR812ScIe02+qvh++rMn6IRlyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FegP1XOOJdekaDIhATlPRxl+l8fNU+zOeYlvRNsup3RqFN8YCrjmXhAoOISkdJRnI
         F09GGJt1g/jU9Gw8jqzDt1YJwDbM+mlDTXQpKBR32LDcZ+K7cvn4dvGGyonjxf1yt2
         pzigpnhQIvIhX5RgO6hoZgKd+DzNiBevgeaFR8Bzst4+c/R36e79EE2Lxnom/0Eo02
         rK+dcoJkV0A6n3Dl9VbwlR/p1cqln0+OtgVyCtrbHtxC8BBua8kI2UslFCohqVxct2
         TX/eDNIava6BWN/IHEqkp2MgfkkwUQdnOyPrsl+j1HBNS+afbWS/fSzsV0JuST06cj
         YufzQNAHJnQ6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabio Aiuto <fabioaiuto83@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.13 122/219] staging: rtl8723bs: fix right side of condition
Date:   Thu,  9 Sep 2021 07:44:58 -0400
Message-Id: <20210909114635.143983-122-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit e3678dc1ea40425b7218c20e2fe7b00a72f23a41 ]

TxNum value is compared against ODM_RF_PATH_D,
which is inconsistent. Compare it against
RF_MAX_TX_NUM, as in other places in the same file.

Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/147631fe6f4f5de84cc54a62ba71d739b92697be.1628329348.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/hal/hal_com_phycfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
index 94d11689b4ac..33ff80da3277 100644
--- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
+++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
@@ -707,7 +707,7 @@ static void PHY_StoreTxPowerByRateNew(
 	if (RfPath > ODM_RF_PATH_D)
 		return;
 
-	if (TxNum > ODM_RF_PATH_D)
+	if (TxNum > RF_MAX_TX_NUM)
 		return;
 
 	for (i = 0; i < rateNum; ++i) {
-- 
2.30.2

