Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA01103F39
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732125AbfKTPlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:41:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52866 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730104AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004ag-Bf; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004LP-Rq; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Bogendoerfer" <tbogendoerfer@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Date:   Wed, 20 Nov 2019 15:38:12 +0000
Message-ID: <lsq.1574264230.571603722@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 62/83] net: seeq: Fix the function used to release
 some memory in an error handling path
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit e1e54ec7fb55501c33b117c111cb0a045b8eded2 upstream.

In commit 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv"),
a call to 'get_zeroed_page()' has been turned into a call to
'dma_alloc_coherent()'. Only the remove function has been updated to turn
the corresponding 'free_page()' into 'dma_free_attrs()'.
The error hndling path of the probe function has not been updated.

Fix it now.

Rename the corresponding label to something more in line.

Fixes: 99cd149efe82 ("sgiseeq: replace use of dma_cache_wback_inv")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/seeq/sgiseeq.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -792,15 +792,16 @@ static int sgiseeq_probe(struct platform
 		printk(KERN_ERR "Sgiseeq: Cannot register net device, "
 		       "aborting.\n");
 		err = -ENODEV;
-		goto err_out_free_page;
+		goto err_out_free_attrs;
 	}
 
 	printk(KERN_INFO "%s: %s %pM\n", dev->name, sgiseeqstr, dev->dev_addr);
 
 	return 0;
 
-err_out_free_page:
-	free_page((unsigned long) sp->srings);
+err_out_free_attrs:
+	dma_free_attrs(&pdev->dev, sizeof(*sp->srings), sp->srings,
+		       sp->srings_dma, DMA_ATTR_NON_CONSISTENT);
 err_out_free_dev:
 	free_netdev(dev);
 

