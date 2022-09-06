Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39655AED14
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiIFOAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240996AbiIFN7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD5081B0C;
        Tue,  6 Sep 2022 06:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72B52B8162F;
        Tue,  6 Sep 2022 13:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9915C433D7;
        Tue,  6 Sep 2022 13:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471782;
        bh=ZUeFA3lxFmVxi0w/jhimiRYvlLExLzNc113cBPzsRbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oIf5mE96QJRAHQVh/kf0f2T9UGuetAY1mWKkQz29VIwzHxVYoIDoeMn9nT+qbaZ1
         Toonh6FPPg5Hsm8AaNo9lg9c7VAuDbH0LO5RmzwHnEtuxkmdrLjvjx3I9m4HZ+pJMV
         zlTOpRKBUeuPVt+ktFsfr3wIWtGpHCXGfzUsawJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 007/155] platform/x86: pmc_atom: Fix SLP_TYPx bitfield mask
Date:   Tue,  6 Sep 2022 15:29:15 +0200
Message-Id: <20220906132829.717050642@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
index 154317e9910d2..5c757c7f64dee 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -232,7 +232,7 @@ static void pmc_power_off(void)
 	pm1_cnt_port = acpi_base_addr + PM1_CNT;
 
 	pm1_cnt_value = inl(pm1_cnt_port);
-	pm1_cnt_value &= SLEEP_TYPE_MASK;
+	pm1_cnt_value &= ~SLEEP_TYPE_MASK;
 	pm1_cnt_value |= SLEEP_TYPE_S5;
 	pm1_cnt_value |= SLEEP_ENABLE;
 
diff --git a/include/linux/platform_data/x86/pmc_atom.h b/include/linux/platform_data/x86/pmc_atom.h
index 6807839c718bd..ea01dd80153b3 100644
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
 
-- 
2.35.1



