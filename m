Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716523242E5
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 18:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbhBXRGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 12:06:06 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:57594 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbhBXRFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 12:05:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614186329; x=1645722329;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=7efuOY6eV7n2cvDRZrMNmGQwX2mKdfck1CHsRrIusQs=;
  b=QwLs/VmiCHMberwFAEq8rue08I6df4tiK3cxVsJpphsTzEPJ/+46SEP9
   VP4ZBhvqsRqFCYTggyAjCAP7kbCroLROFEmz2x3w7PADhIaZaicd0fjqt
   k55MD59SFACspxNEp15aom0fkd8qB14Rtt15H7h2Qp6pkRX2ER4WAlmiS
   c=;
X-IronPort-AV: E=Sophos;i="5.81,203,1610409600"; 
   d="scan'208";a="87698189"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 24 Feb 2021 17:04:38 +0000
Received: from EX13D31EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 84828A1CC3;
        Wed, 24 Feb 2021 17:04:35 +0000 (UTC)
Received: from u3f2cd687b01c55.ant.amazon.com (10.43.161.244) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 24 Feb 2021 17:04:29 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>
CC:     <aams@amazon.com>, <markubo@amazon.com>,
        <linux-kernel@vger.kernel.org>,
        "# 4 . 4 . y" <stable@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Please apply "xen-netback: delete NAPI instance when queue fails to initialize" to v4.4.y
Date:   Wed, 24 Feb 2021 18:03:56 +0100
Message-ID: <20210224170356.20697-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D34UWC002.ant.amazon.com (10.43.162.137) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a request for merge of upstream commit 4a658527271b ("xen-netback:
delete NAPI instance when queue fails to initialize") on v4.4.y tree.

If 'xenvif_connect()' fails after successful 'netif_napi_add()', the napi is
not cleaned up.  Because 'create_queues()' frees the queues in its error
handling code, if the 'xenvif_free()' is called for the vif, use-after-free
occurs. The upstream commit fixes the problem by cleaning up the napi in the
'xenvif_connect()'.

Attaching the original patch below for your convenience.

Tested-by: Markus Boehme <markubo@amazon.de>


Thanks,
SeongJae Park

==================================== >8 =======================================
From 4a658527271bce43afb1cf4feec89afe6716ca59 Mon Sep 17 00:00:00 2001
From: David Vrabel <david.vrabel@citrix.com>
Date: Fri, 15 Jan 2016 14:55:35 +0000
Subject: [PATCH] xen-netback: delete NAPI instance when queue fails to
 initialize

When xenvif_connect() fails it may leave a stale NAPI instance added to
the device.  Make sure we delete it in the error path.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/xen-netback/interface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index e7bd63eb2876..3bba6ceee132 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -615,6 +615,7 @@ int xenvif_connect(struct xenvif_queue *queue, unsigned long tx_ring_ref,
 	queue->tx_irq = 0;
 err_unmap:
 	xenvif_unmap_frontend_rings(queue);
+	netif_napi_del(&queue->napi);
 err:
 	module_put(THIS_MODULE);
 	return err;
-- 
2.17.1

