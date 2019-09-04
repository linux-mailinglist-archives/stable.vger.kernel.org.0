Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3222A908D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389748AbfIDSKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390078AbfIDSKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11A0B23431;
        Wed,  4 Sep 2019 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620622;
        bh=Uj4/zuuUy7gzUV351Ru+jlh1oqGrMcztChpiXKLtlGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEBCCLj2ET8ZdvZW0vqFzH+86nZQhIY5NUeetQKR5doeJ0dxrO8iTqXNfYEaYkoCg
         z2DXdJdXAfqgCO4LTWqBVQPN+3sGhn8Va0auXbouMM8RkN/WMJs+y5GHgT5yPOX7iQ
         3JOlQV1dEL+1pAYWrycFpQdcyYUOKO1G91bUeG94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Wenwen Wang <wenwen@cs.uga.edu>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 033/143] xen/blkback: fix memory leaks
Date:   Wed,  4 Sep 2019 19:52:56 +0200
Message-Id: <20190904175315.347809559@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -1007,8 +1008,7 @@ fail:
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



