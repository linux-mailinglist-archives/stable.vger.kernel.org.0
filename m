Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFA5104236
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 18:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfKTRgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 12:36:45 -0500
Received: from mga17.intel.com ([192.55.52.151]:7732 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbfKTRgp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 12:36:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 09:36:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,222,1571727600"; 
   d="scan'208";a="259103050"
Received: from tthayer-hp-z620.an.intel.com ([10.122.105.146])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Nov 2019 09:36:32 -0800
From:   thor.thayer@linux.intel.com
To:     stable@vger.kernel.org, bp@alien8.de, mchehab@kernel.org
Cc:     tony.luck@intel.com, james.morse@arm.com, rrichter@marvell.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        Meng Li <Meng.Li@windriver.com>
Subject: [PATCH] EDAC/altera: Use fast register IO for S10 IRQs
Date:   Wed, 20 Nov 2019 11:38:01 -0600
Message-Id: <1574271481-9310-1-git-send-email-thor.thayer@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thor Thayer <thor.thayer@linux.intel.com>

When an irq occurs in altera edac driver, regmap_xxx() is invoked
in atomic context. Regmap must indicate register IO is fast so
that a spinlock is used instead of a mutex to avoid sleeping
in atomic context.

Fixes mutex-lock error
   lock_acquire+0xfc/0x288
   __mutex_lock+0x8c/0x808
   mutex_lock_nested+0x3c/0x50
   regmap_lock_mutex+0x24/0x30
   regmap_write+0x40/0x78
   a10_eccmgr_irq_unmask+0x34/0x40
   unmask_irq.part.0+0x30/0x50
   irq_enable+0x74/0x80
   __irq_startup+0x80/0xa8
   irq_startup+0x70/0x150
   __setup_irq+0x650/0x6d0
   request_threaded_irq+0xe4/0x180
   devm_request_threaded_irq+0x7c/0xf0
   altr_sdram_probe+0x2c4/0x600
<snip>

Upstream fix pending [1] (common code uses fast mode)
[1] https://lkml.org/lkml/2019/11/7/1014

Fixes: 3dab6bd52687 ("EDAC, altera: Add support for Stratix10 SDRAM EDAC")
Cc: stable@vger.kernel.org
Reported-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Thor Thayer <thor.thayer@linux.intel.com>
---
 drivers/edac/altera_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index 59319f0c873b..647b3a5ef095 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -561,6 +561,7 @@ static const struct regmap_config s10_sdram_regmap_cfg = {
 	.reg_write = s10_protected_reg_write,
 	.use_single_read = true,
 	.use_single_write = true,
+	.fast_io = true,
 };
 
 /************** </Stratix10 EDAC Memory Controller Functions> ***********/
-- 
2.7.4

