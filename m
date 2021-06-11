Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714EA3A403C
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 12:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhFKKg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 06:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230321AbhFKKgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 06:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FD6E61029;
        Fri, 11 Jun 2021 10:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623407664;
        bh=ZXETRPrXDcpX13uuRTqpJEx6v6g80uzKbRYgTxBI+3U=;
        h=Subject:To:From:Date:From;
        b=ibGSgOcCv2sPnERXowFNTGhgHXAFCXdQ98L9+0w9jpepYc2MnUsLHKRrO0NTwQWkT
         LJfGrLul2TA9MmnfEiG5ZNNwaA/gwX9MU2ejWZM0Qk4NTMGJJMDOCWXUCMOfzbHhbh
         IpmAGMWRAEuETYB0ZvRQa75558rnKg1oO66Tt/40=
Subject: patch "nvmem: core: add a missing of_node_put" added to char-misc-testing
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Jun 2021 12:34:22 +0200
Message-ID: <1623407662242235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    nvmem: core: add a missing of_node_put

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 63879e2964bceee2aa5bbe8b99ea58bba28bb64f Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Fri, 11 Jun 2021 11:23:21 +0100
Subject: nvmem: core: add a missing of_node_put

'for_each_child_of_node' performs an of_node_get on each iteration, so a
return from the middle of the loop requires an of_node_put.

Fixes: e888d445ac33 ("nvmem: resolve cells from DT at registration time")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210611102321.11509-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 4d1c4f83b22f..20799e622b5b 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -690,15 +690,17 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 			continue;
 		if (len < 2 * sizeof(u32)) {
 			dev_err(dev, "nvmem: invalid reg on %pOF\n", child);
+			of_node_put(child);
 			return -EINVAL;
 		}
 
 		cell = kzalloc(sizeof(*cell), GFP_KERNEL);
-		if (!cell)
+		if (!cell) {
+			of_node_put(child);
 			return -ENOMEM;
+		}
 
 		cell->nvmem = nvmem;
-		cell->np = of_node_get(child);
 		cell->offset = be32_to_cpup(addr++);
 		cell->bytes = be32_to_cpup(addr);
 		cell->name = kasprintf(GFP_KERNEL, "%pOFn", child);
@@ -719,11 +721,12 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 				cell->name, nvmem->stride);
 			/* Cells already added will be freed later. */
 			kfree_const(cell->name);
-			of_node_put(cell->np);
 			kfree(cell);
+			of_node_put(child);
 			return -EINVAL;
 		}
 
+		cell->np = of_node_get(child);
 		nvmem_cell_add(cell);
 	}
 
-- 
2.32.0


