Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD0F582D0D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240073AbiG0QxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240517AbiG0QwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3B84F188;
        Wed, 27 Jul 2022 09:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84774B821BA;
        Wed, 27 Jul 2022 16:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE717C433D6;
        Wed, 27 Jul 2022 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939658;
        bh=Y6eKHf7YnFlT7L+au4LdTlAYiMv2LAqvSJSkWSCCpZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0G1QmdYPbAz0WVvUlw3yhtr7t+itKU4fH79RHU2gPyepyFJJoqs46EVm7ta8p31J
         FNW4bGZYJhfKxYZQO0Er9ex64co3t8cvV92DpVW71oAYGO634OaPFVu18YjV4B21ku
         P+hRdfmpnkKh4Yy4mvS93G3CNjgUg/ElHkpWMswk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lennert Buytenhek <buytenh@arista.com>,
        Naama Meir <naamax.meir@linux.intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/105] igc: Reinstate IGC_REMOVED logic and implement it properly
Date:   Wed, 27 Jul 2022 18:10:13 +0200
Message-Id: <20220727161013.192674456@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lennert Buytenhek <buytenh@wantstofly.org>

[ Upstream commit 7c1ddcee5311f3315096217881d2dbe47cc683f9 ]

The initially merged version of the igc driver code (via commit
146740f9abc4, "igc: Add support for PF") contained the following
IGC_REMOVED checks in the igc_rd32/wr32() MMIO accessors:

	u32 igc_rd32(struct igc_hw *hw, u32 reg)
	{
		u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
		u32 value = 0;

		if (IGC_REMOVED(hw_addr))
			return ~value;

		value = readl(&hw_addr[reg]);

		/* reads should not return all F's */
		if (!(~value) && (!reg || !(~readl(hw_addr))))
			hw->hw_addr = NULL;

		return value;
	}

And:

	#define wr32(reg, val) \
	do { \
		u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
		if (!IGC_REMOVED(hw_addr)) \
			writel((val), &hw_addr[(reg)]); \
	} while (0)

E.g. igb has similar checks in its MMIO accessors, and has a similar
macro E1000_REMOVED, which is implemented as follows:

	#define E1000_REMOVED(h) unlikely(!(h))

These checks serve to detect and take note of an 0xffffffff MMIO read
return from the device, which can be caused by a PCIe link flap or some
other kind of PCI bus error, and to avoid performing MMIO reads and
writes from that point onwards.

However, the IGC_REMOVED macro was not originally implemented:

	#ifndef IGC_REMOVED
	#define IGC_REMOVED(a) (0)
	#endif /* IGC_REMOVED */

This led to the IGC_REMOVED logic to be removed entirely in a
subsequent commit (commit 3c215fb18e70, "igc: remove IGC_REMOVED
function"), with the rationale that such checks matter only for
virtualization and that igc does not support virtualization -- but a
PCIe device can become detached even without virtualization being in
use, and without proper checks, a PCIe bus error affecting an igc
adapter will lead to various NULL pointer dereferences, as the first
access after the error will set hw->hw_addr to NULL, and subsequent
accesses will blindly dereference this now-NULL pointer.

This patch reinstates the IGC_REMOVED checks in igc_rd32/wr32(), and
implements IGC_REMOVED the way it is done for igb, by checking for the
unlikely() case of hw_addr being NULL.  This change prevents the oopses
seen when a PCIe link flap occurs on an igc adapter.

Fixes: 146740f9abc4 ("igc: Add support for PF")
Signed-off-by: Lennert Buytenhek <buytenh@arista.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
 drivers/net/ethernet/intel/igc/igc_regs.h | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 53e31002ce52..e7ffe63925fd 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4933,6 +4933,9 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
 	u32 value = 0;
 
+	if (IGC_REMOVED(hw_addr))
+		return ~value;
+
 	value = readl(&hw_addr[reg]);
 
 	/* reads should not return all F's */
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index b52dd9d737e8..a273e1c33b3f 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -252,7 +252,8 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg);
 #define wr32(reg, val) \
 do { \
 	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
-	writel((val), &hw_addr[(reg)]); \
+	if (!IGC_REMOVED(hw_addr)) \
+		writel((val), &hw_addr[(reg)]); \
 } while (0)
 
 #define rd32(reg) (igc_rd32(hw, reg))
@@ -264,4 +265,6 @@ do { \
 
 #define array_rd32(reg, offset) (igc_rd32(hw, (reg) + ((offset) << 2)))
 
+#define IGC_REMOVED(h) unlikely(!(h))
+
 #endif
-- 
2.35.1



