Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C378821FA51
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbgGNSvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729346AbgGNSv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:51:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 328CC207F5;
        Tue, 14 Jul 2020 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752685;
        bh=8N8KSnGHvsmt4DlT8K/7s8+aOg80xit/1GhJqObhWvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwKebXkQpbyIKONLxPFjB8WSmCcMPoq66s2Md0EJmHMM4dO33XF+EFmud+p82TDrE
         cyuEPj21NeCZG2iu/vE33lVxX91gfUAUycbAr6C694byssvSXtKvlm/i61y6JiFFf5
         XDLKXg7v46oupMKWCKsGZwvlFIOpPXTqTi5DRpu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 071/109] IB/hfi1: Do not destroy link_wq when the device is shut down
Date:   Tue, 14 Jul 2020 20:44:14 +0200
Message-Id: <20200714184108.949399098@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

commit 2315ec12ee8e8257bb335654c62e0cae71dc278d upstream.

The workqueue link_wq should only be destroyed when the hfi1 driver is
unloaded, not when the device is shut down.

Fixes: 71d47008ca1b ("IB/hfi1: Create workqueue for link events")
Link: https://lore.kernel.org/r/20200623204053.107638.70315.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -860,6 +860,10 @@ static void destroy_workqueues(struct hf
 			destroy_workqueue(ppd->hfi1_wq);
 			ppd->hfi1_wq = NULL;
 		}
+		if (ppd->link_wq) {
+			destroy_workqueue(ppd->link_wq);
+			ppd->link_wq = NULL;
+		}
 	}
 }
 
@@ -1136,14 +1140,10 @@ static void shutdown_device(struct hfi1_
 		 * We can't count on interrupts since we are stopping.
 		 */
 		hfi1_quiet_serdes(ppd);
-
 		if (ppd->hfi1_wq)
 			flush_workqueue(ppd->hfi1_wq);
-		if (ppd->link_wq) {
+		if (ppd->link_wq)
 			flush_workqueue(ppd->link_wq);
-			destroy_workqueue(ppd->link_wq);
-			ppd->link_wq = NULL;
-		}
 	}
 	sdma_exit(dd);
 }


