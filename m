Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393CB96159
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbfHTNqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbfHTNlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:41:45 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB73B2087E;
        Tue, 20 Aug 2019 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308504;
        bh=iDD40kvBDaWUwYrHhhS3QcnGpCBQmHUNgN2uM+gM11M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbWwRaudrgbm2Lbh0Z7UQlx4X6ked7rscRfAi88XGMYzu/u7sDCgncnkNdTWtB726
         sta/vNhDCcsbtjUAkD3mWizbou0Cld6VWuXRyIhRfWbX5oh/0AB8AIlo2NnuDP7n7O
         yGvoGk2bOWuYhJg85jY4nXtS3PMipzqeSY6xQtX4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 35/44] xen/blkback: fix memory leaks
Date:   Tue, 20 Aug 2019 09:40:19 -0400
Message-Id: <20190820134028.10829-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit ae78ca3cf3d9e9f914bfcd0bc5c389ff18b9c2e0 ]

In read_per_ring_refs(), after 'req' and related memory regions are
allocated, xen_blkif_map() is invoked to map the shared frame, irq, and
etc. However, if this mapping process fails, no cleanup is performed,
leading to memory leaks. To fix this issue, invoke the cleanup before
returning the error.

Acked-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkback/xenbus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 3ac6a5d180717..b90dbcd99c03e 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -965,6 +965,7 @@ static int read_per_ring_refs(struct xen_blkif_ring *ring, const char *dir)
 		}
 	}
 
+	err = -ENOMEM;
 	for (i = 0; i < nr_grefs * XEN_BLKIF_REQS_PER_PAGE; i++) {
 		req = kzalloc(sizeof(*req), GFP_KERNEL);
 		if (!req)
@@ -987,7 +988,7 @@ static int read_per_ring_refs(struct xen_blkif_ring *ring, const char *dir)
 	err = xen_blkif_map(ring, ring_ref, nr_grefs, evtchn);
 	if (err) {
 		xenbus_dev_fatal(dev, err, "mapping ring-ref port %u", evtchn);
-		return err;
+		goto fail;
 	}
 
 	return 0;
@@ -1007,8 +1008,7 @@ static int read_per_ring_refs(struct xen_blkif_ring *ring, const char *dir)
 		}
 		kfree(req);
 	}
-	return -ENOMEM;
-
+	return err;
 }
 
 static int connect_ring(struct backend_info *be)
-- 
2.20.1

