Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C13A40E3DE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344503AbhIPQwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345725AbhIPQuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE11361284;
        Thu, 16 Sep 2021 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809710;
        bh=CtX/yPRZcRIVIBZ1kDR812ScIe02+qvh++rMn6IRlyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un3by2Y6JQwpcR9bC46MbYce9ZovKJjN5Z0gbBA9qeOpts0BhLOi9YM//DiAFD7b1
         6js2Vz2KK2ehXyzEh8mWHY2Y8Nw3n0tvIIP07j9KNlQeKstglP3zeSpUn641WLGh3w
         VOTKNdvf1+XZDNVpSGAUB5g3QK8FH6Odnawxuu0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Aiuto <fabioaiuto83@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 255/380] staging: rtl8723bs: fix right side of condition
Date:   Thu, 16 Sep 2021 18:00:12 +0200
Message-Id: <20210916155812.754094176@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



