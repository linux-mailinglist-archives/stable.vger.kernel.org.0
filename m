Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF9937CE3F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238605AbhELREH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:04:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236856AbhELQnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E018361E5D;
        Wed, 12 May 2021 16:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835997;
        bh=3rP5GZ9KfuY0RU6GdNtSVd62DEl4wDHLOHCR6SLI2Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APeC+ZjM0XpTTPS0BQ/NMFKSIrB9/k45Z6ubmdDjVZoK0yHWQ8oofB69bkodsTALR
         rDEr4b8X5+HjwKRUo/TBXH5Y8Gju1cT2GGpnLeYmicbXzGrOQ0Kq+nY/f2rAvjRUTU
         MezuSQA/3gScvNAsF1St2byHMicrJWfHpSgtDKEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 533/677] mt76: mt7921: fix the base of the dynamic remap
Date:   Wed, 12 May 2021 16:49:39 +0200
Message-Id: <20210512144855.083597384@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 53a8fb4afdc877f8f2d5e1e15cc5ad66155987a6 ]

We should change the base for the dynamic remap into another one, because
the current base (0xe0000) have been the one used to operate the device
ownership.

Fixes: 163f4d22c118 ("mt76: mt7921: add MAC support")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index e7bb918446ee..73878d3e2495 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -362,11 +362,11 @@
 #define MT_INFRA_CFG_BASE		0xfe000
 #define MT_INFRA(ofs)			(MT_INFRA_CFG_BASE + (ofs))
 
-#define MT_HIF_REMAP_L1			MT_INFRA(0x260)
+#define MT_HIF_REMAP_L1			MT_INFRA(0x24c)
 #define MT_HIF_REMAP_L1_MASK		GENMASK(15, 0)
 #define MT_HIF_REMAP_L1_OFFSET		GENMASK(15, 0)
 #define MT_HIF_REMAP_L1_BASE		GENMASK(31, 16)
-#define MT_HIF_REMAP_BASE_L1		0xe0000
+#define MT_HIF_REMAP_BASE_L1		0x40000
 
 #define MT_SWDEF_BASE			0x41f200
 #define MT_SWDEF(ofs)			(MT_SWDEF_BASE + (ofs))
-- 
2.30.2



