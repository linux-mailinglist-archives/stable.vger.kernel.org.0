Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8EB5B71B2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiIMOwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbiIMOuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57E1719BA;
        Tue, 13 Sep 2022 07:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D9F4614E1;
        Tue, 13 Sep 2022 14:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83821C433C1;
        Tue, 13 Sep 2022 14:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079171;
        bh=rKsgwpHVAPGnJosQ4zpxRH1u6Gw29hTCSspdyRstV6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6lQSlZ0OZtGviG+NSNjEKIXFGpsIa3keo5BEeFgSL9ZJy7UifSA8CsTVlyHCE/Gl
         CpVd8100YNRG79yTVscecCJkNUFKGKP4gb3RE5NG85iOg+5L2b6aMUFKE5+uAIIY3j
         g5D9QiTBYFo63PJVVscuVp0n+43lOXycHu8ZW3Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/108] platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask
Date:   Tue, 13 Sep 2022 16:05:40 +0200
Message-Id: <20220913140353.955416151@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0a90ed8d0cfa29735a221eba14d9cb6c735d35b6 ]

On Intel hardware the SLP_TYPx bitfield occupies bits 10-12 as per ACPI
specification (see Table 4.13 "PM1 Control Registers Fixed Hardware
Feature Control Bits" for the details).

Fix the mask and other related definitions accordingly.

Fixes: 93e5eadd1f6e ("x86/platform: New Intel Atom SOC power management controller driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220801113734.36131-1-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pmc_atom.c            | 2 +-
 include/linux/platform_data/x86/pmc_atom.h | 6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index 597cfabc0967c..ee349a16b73a4 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -244,7 +244,7 @@ static void pmc_power_off(void)
 	pm1_cnt_port = acpi_base_addr + PM1_CNT;
 
 	pm1_cnt_value = inl(pm1_cnt_port);
-	pm1_cnt_value &= SLEEP_TYPE_MASK;
+	pm1_cnt_value &= ~SLEEP_TYPE_MASK;
 	pm1_cnt_value |= SLEEP_TYPE_S5;
 	pm1_cnt_value |= SLEEP_ENABLE;
 
diff --git a/include/linux/platform_data/x86/pmc_atom.h b/include/linux/platform_data/x86/pmc_atom.h
index 022bcea9edec5..99a9b09dc839d 100644
--- a/include/linux/platform_data/x86/pmc_atom.h
+++ b/include/linux/platform_data/x86/pmc_atom.h
@@ -7,6 +7,8 @@
 #ifndef PMC_ATOM_H
 #define PMC_ATOM_H
 
+#include <linux/bits.h>
+
 /* ValleyView Power Control Unit PCI Device ID */
 #define	PCI_DEVICE_ID_VLV_PMC	0x0F1C
 /* CherryTrail Power Control Unit PCI Device ID */
@@ -139,9 +141,9 @@
 #define	ACPI_MMIO_REG_LEN	0x100
 
 #define	PM1_CNT			0x4
-#define	SLEEP_TYPE_MASK		0xFFFFECFF
+#define	SLEEP_TYPE_MASK		GENMASK(12, 10)
 #define	SLEEP_TYPE_S5		0x1C00
-#define	SLEEP_ENABLE		0x2000
+#define	SLEEP_ENABLE		BIT(13)
 
 extern int pmc_atom_read(int offset, u32 *value);
 extern int pmc_atom_write(int offset, u32 value);
-- 
2.35.1



