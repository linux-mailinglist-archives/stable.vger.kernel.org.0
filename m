Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD35E3DD97F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhHBOAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236286AbhHBN7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 130D961154;
        Mon,  2 Aug 2021 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912537;
        bh=oX4bt3aMhM2CYDvV680uKXCAwQn1fcA/pgcZgVoIkMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlpI2+yfiMTz8wD8aYjmMhix4TkoqpQiIFZ48kOCFBukdjne0S3hJRqfuVhjo2r+X
         Qszvmmzdi3/tgamzMpzuN8HeIQYBXX5RXBj3N6Kb/1b8yTYsMjhlHldOVb7jsxAoT6
         gIPFHeN5f3H0vgI4vfGNx26r0lQprjMqB448XPbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 037/104] platform/x86: amd-pmc: Fix SMU firmware reporting mechanism
Date:   Mon,  2 Aug 2021 15:44:34 +0200
Message-Id: <20210802134345.240210722@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 4c06d35dfedf4c1fd03702e0f05292a69d020e21 ]

It was lately understood that the current mechanism available in the
driver to get SMU firmware info works only on internal SMU builds and
there is a separate way to get all the SMU logging counters (addressed
in the next patch). Hence remove all the smu info shown via debugfs as it
is no more useful.

Fixes: 156ec4731cb2 ("platform/x86: amd-pmc: Add AMD platform support for S2Idle")
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210629084803.248498-3-Shyam-sundar.S-k@amd.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd-pmc.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/platform/x86/amd-pmc.c b/drivers/platform/x86/amd-pmc.c
index 1b5f149932c1..b1d6175a13b2 100644
--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -52,7 +52,6 @@
 #define AMD_CPU_ID_PCO			AMD_CPU_ID_RV
 #define AMD_CPU_ID_CZN			AMD_CPU_ID_RN
 
-#define AMD_SMU_FW_VERSION		0x0
 #define PMC_MSG_DELAY_MIN_US		100
 #define RESPONSE_REGISTER_LOOP_MAX	200
 
@@ -89,11 +88,6 @@ static inline void amd_pmc_reg_write(struct amd_pmc_dev *dev, int reg_offset, u3
 #ifdef CONFIG_DEBUG_FS
 static int smu_fw_info_show(struct seq_file *s, void *unused)
 {
-	struct amd_pmc_dev *dev = s->private;
-	u32 value;
-
-	value = ioread32(dev->smu_base + AMD_SMU_FW_VERSION);
-	seq_printf(s, "SMU FW Info: %x\n", value);
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(smu_fw_info);
@@ -280,10 +274,6 @@ static int amd_pmc_probe(struct platform_device *pdev)
 	pci_dev_put(rdev);
 	base_addr = ((u64)base_addr_hi << 32 | base_addr_lo);
 
-	dev->smu_base = devm_ioremap(dev->dev, base_addr, AMD_PMC_MAPPING_SIZE);
-	if (!dev->smu_base)
-		return -ENOMEM;
-
 	dev->regbase = devm_ioremap(dev->dev, base_addr + AMD_PMC_BASE_ADDR_OFFSET,
 				    AMD_PMC_MAPPING_SIZE);
 	if (!dev->regbase)
-- 
2.30.2



