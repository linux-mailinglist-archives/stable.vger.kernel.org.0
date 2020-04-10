Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C126B1A4392
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgDJIfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 04:35:40 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:59961 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725858AbgDJIfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 04:35:40 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20860556-1500050 
        for multiple; Fri, 10 Apr 2020 09:35:38 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] agp/intel: Reinforce the barrier after GTT updates
Date:   Fri, 10 Apr 2020 09:35:35 +0100
Message-Id: <20200410083535.25464-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410083347.25128-1-chris@chris-wilson.co.uk>
References: <20200410083347.25128-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After changing the timing between GTT updates and execution on the GPU,
we started seeing sporadic failures on Ironlake. These were narrowed
down to being an insufficiently strong enough barrier/delay after
updating the GTT and scheduling execution on the GPU. By forcing the
uncached read, and adding the missing barrier for the singular
insert_page (relocation paths), the sporadic failures go away.

Fixes: 983d308cb8f6 ("agp/intel: Serialise after GTT updates")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org # v4.0+
---
 drivers/char/agp/intel-gtt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 66a62d17a3f5..3d42fc4290bc 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -846,6 +846,7 @@ void intel_gtt_insert_page(dma_addr_t addr,
 			   unsigned int flags)
 {
 	intel_private.driver->write_entry(addr, pg, flags);
+	readl(intel_private.gtt + pg);
 	if (intel_private.driver->chipset_flush)
 		intel_private.driver->chipset_flush();
 }
@@ -871,7 +872,7 @@ void intel_gtt_insert_sg_entries(struct sg_table *st,
 			j++;
 		}
 	}
-	wmb();
+	readl(intel_private.gtt + j - 1);
 	if (intel_private.driver->chipset_flush)
 		intel_private.driver->chipset_flush();
 }
@@ -1105,6 +1106,7 @@ static void i9xx_cleanup(void)
 
 static void i9xx_chipset_flush(void)
 {
+	wmb();
 	if (intel_private.i9xx_flush_page)
 		writel(1, intel_private.i9xx_flush_page);
 }
-- 
2.20.1

