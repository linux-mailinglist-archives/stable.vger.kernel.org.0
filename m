Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D39937704C
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 09:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhEHHSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 03:18:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:47276 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEHHSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 03:18:51 -0400
IronPort-SDR: yBdZ75bIQn1Hl26P6QEmxPRyaOpaNBUAURl3mCe3XKGVYegBtTeaphoSZt9mwfNRqkxWn29/AP
 BIPgzQcMuoFg==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="262816443"
X-IronPort-AV: E=Sophos;i="5.82,283,1613462400"; 
   d="scan'208";a="262816443"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2021 00:17:48 -0700
IronPort-SDR: tsgzUZs8tvIizuU72JMmEcN+UYuWGP/CHbcmGM8z+23NbbZK5biOyHJbY9Jc5+K3XprAjh2AvC
 lg6GkNlVctWg==
X-IronPort-AV: E=Sophos;i="5.82,283,1613462400"; 
   d="scan'208";a="435267317"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2021 00:17:45 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, maz@kernel.org,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, cohuck@redhat.com,
        stable@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH] Revert "irqbypass: do not start cons/prod when failed connect"
Date:   Sat,  8 May 2021 15:11:52 +0800
Message-Id: <20210508071152.722425-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.

The reverted commit may cause VM freeze on arm64 platform.
Because on arm64 platform, stop a consumer will suspend the VM,
the VM will freeze without a start consumer

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 virt/lib/irqbypass.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index c9bb3957f58a..28fda42e471b 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -40,21 +40,17 @@ static int __connect(struct irq_bypass_producer *prod,
 	if (prod->add_consumer)
 		ret = prod->add_consumer(prod, cons);
 
-	if (ret)
-		goto err_add_consumer;
-
-	ret = cons->add_producer(cons, prod);
-	if (ret)
-		goto err_add_producer;
+	if (!ret) {
+		ret = cons->add_producer(cons, prod);
+		if (ret && prod->del_consumer)
+			prod->del_consumer(prod, cons);
+	}
 
 	if (cons->start)
 		cons->start(cons);
 	if (prod->start)
 		prod->start(prod);
-err_add_producer:
-	if (prod->del_consumer)
-		prod->del_consumer(prod, cons);
-err_add_consumer:
+
 	return ret;
 }
 
-- 
2.27.0

