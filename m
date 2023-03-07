Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778A06AE8A0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCGRSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjCGRRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:17:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EAE311FB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43537614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EF8C433EF;
        Tue,  7 Mar 2023 17:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209194;
        bh=Km3x74RAdPb7cr59q6J6/jndvbDg9bTdVNF4Cx6YDk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5LGL10GT4FLaNM/djtJTkWLD5HoI83D0izVysYAWcE3Pzz6bTb6mks8/fYgW+PkM
         y/azLpX0YG5lg7fpuUfOaFnI8tbKA9rB4kP9eOqufannvxWWXYVzCS/2rfgtCKEGi/
         D2lv+5PeEg/JPZpRJqWRqKcu7FrkWjRYV41iIH1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0140/1001] wifi: mt76: mt7915: drop always true condition of __mt7915_reg_addr()
Date:   Tue,  7 Mar 2023 17:48:32 +0100
Message-Id: <20230307170028.133196121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit b0f7b9563358493dfe70d3e4c3ebeffc92d4b494 ]

smatch warnings:
addr <= MT_CBTOP2_PHY_END(0xffffffff) is always true (<= u32max),
so drop it.

Fixes: cd4c314a65d3 ("mt76: mt7915: refine register definition")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index 8388e2a658535..afa558c9a9302 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -495,7 +495,7 @@ static u32 __mt7915_reg_addr(struct mt7915_dev *dev, u32 addr)
 
 	if (dev_is_pci(dev->mt76.dev) &&
 	    ((addr >= MT_CBTOP1_PHY_START && addr <= MT_CBTOP1_PHY_END) ||
-	     (addr >= MT_CBTOP2_PHY_START && addr <= MT_CBTOP2_PHY_END)))
+	    addr >= MT_CBTOP2_PHY_START))
 		return mt7915_reg_map_l1(dev, addr);
 
 	/* CONN_INFRA: covert to phyiscal addr and use layer 1 remap */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index aca1b2f1e9e3b..7e0d86366c778 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -803,7 +803,6 @@ enum offs_rev {
 #define MT_CBTOP1_PHY_START		0x70000000
 #define MT_CBTOP1_PHY_END		__REG(CBTOP1_PHY_END)
 #define MT_CBTOP2_PHY_START		0xf0000000
-#define MT_CBTOP2_PHY_END		0xffffffff
 #define MT_INFRA_MCU_START		0x7c000000
 #define MT_INFRA_MCU_END		__REG(INFRA_MCU_ADDR_END)
 #define MT_CONN_INFRA_OFFSET(p)		((p) - MT_INFRA_BASE)
-- 
2.39.2



