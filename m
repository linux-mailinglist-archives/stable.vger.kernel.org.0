Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88284105983
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 19:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfKUS3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 13:29:18 -0500
Received: from mga18.intel.com ([134.134.136.126]:31604 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKUS3S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 13:29:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 10:29:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="381823367"
Received: from tthayer-hp-z620.an.intel.com ([10.122.105.146])
  by orsmga005.jf.intel.com with ESMTP; 21 Nov 2019 10:29:16 -0800
From:   thor.thayer@linux.intel.com
To:     bp@alien8.de, mchehab@kernel.org, tony.luck@intel.com,
        james.morse@arm.com, rrichter@marvell.com
Cc:     Meng.Li@windriver.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCHv2 1/3] EDAC/altera: Use fast register IO for S10 IRQs
Date:   Thu, 21 Nov 2019 12:30:46 -0600
Message-Id: <1574361048-17572-2-git-send-email-thor.thayer@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574361048-17572-1-git-send-email-thor.thayer@linux.intel.com>
References: <1574361048-17572-1-git-send-email-thor.thayer@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

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
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
---
v2 Change Author to Meng Li & Reviewed-by: Thor Thayer
---
 drivers/edac/altera_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index fbda4b876afd..0be3d1b17f03 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -560,6 +560,7 @@ static const struct regmap_config s10_sdram_regmap_cfg = {
 	.reg_write = s10_protected_reg_write,
 	.use_single_read = true,
 	.use_single_write = true,
+	.fast_io = true,
 };
 
 /************** </Stratix10 EDAC Memory Controller Functions> ***********/
-- 
2.7.4

