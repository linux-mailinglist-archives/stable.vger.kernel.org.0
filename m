Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC893D1DB
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 18:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389804AbfFKQJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 12:09:56 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41911 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387814AbfFKQJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 12:09:55 -0400
Received: by mail-qt1-f196.google.com with SMTP id 33so7030922qtr.8
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 09:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3hSlsAiA/hDUqHiRtfh2cpeKlg/PwN4WvDHlolf/AOI=;
        b=Db2yvx3YXP6UuCGmniyKf+PFxhHroMwyT7YK5KTiH1ccD1Cs8+HOdfg64N5wLaakY7
         QrNC8UQXLAm+6TOGzysWg6EP5h8uKOCnjUUBRF5APZS5o5nI8WwS0QQ4Zv6lktdH1XeM
         O5oMTfY4re5ccZ1SuITPVRBWlfxyGWpUK0EWtJb8B6ZriwZbfeud5z3P/h3ooo092ORw
         /eDZaZ0e+fXFm75teuKF8oVHITASuUKXRSXHLyOaopfgTyEnaPMi0MgEJDGri2wWGI4H
         KL0XwK6lEnIP0isYs4ibFSODW7Qr+HthMM5wb0tvxzDYmkqs1uFHPXfDZAYG0HjZiFOF
         Jxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3hSlsAiA/hDUqHiRtfh2cpeKlg/PwN4WvDHlolf/AOI=;
        b=Z11CFdte6aubAJeupTPvyoDJAYxneIwA2Cl2BxG6FExj8AlK/lRnRGNLi8f3IZr62h
         Xz1QF960KJZZCimeDHQIY9h5ZmAiNPW8LJx1GnerI7uHXk8bNwKXzEJ++ipOnjNmSVYb
         C2HIYDh7JNoGJdNBBmnK5zN7NGZypwqdOZwR88kyNrYi6Kt4aqHjsh2sDT2uuU5ZclQq
         Vh20WAq/xUhhbi5BNc0q1uDOHiFuLWs6v6Cye/C+HqixfkJXNT4Gv85lNfotUSv8wJsl
         LWynFaVTQ7N5Srt/T70i6d2XmDmwLFM7ePyvHggufmYzdNNGlFxanDy5DZtMK8ty5qiP
         1kGQ==
X-Gm-Message-State: APjAAAUe6lS2Ikrp3fnGih5r73I5/QbRSz02W1ATBY1O1Ob7WYCRBPmq
        0/9up0VWtlTZa+D6vhqBo0jchg==
X-Google-Smtp-Source: APXvYqySxNeFQLolYkYidFXc6FTUp2Gff/U9Q/sFv1z+7kpIPiksTjRwOYozBy20ZoFzSS4C1wREmg==
X-Received: by 2002:ac8:21f2:: with SMTP id 47mr51673974qtz.38.1560269394894;
        Tue, 11 Jun 2019 09:09:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id m6sm6851775qte.17.2019.06.11.09.09.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Jun 2019 09:09:54 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hajLN-000624-LS; Tue, 11 Jun 2019 13:09:53 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>, stable@vger.kernel.org
Subject: [PATCH] RDMA/odp: Fix missed unlock in non-blocking invalidate_start
Date:   Tue, 11 Jun 2019 13:09:51 -0300
Message-Id: <20190611160951.23135-1-jgg@ziepe.ca>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

If invalidate_start returns with EAGAIN then the umem_rwsem needs to be
unlocked as no invalidate_end will be called.

Cc: <stable@vger.kernel.org>
Fixes: ca748c39ea3f ("RDMA/umem: Get rid of per_mm->notifier_count")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/umem_odp.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index f962b5bbfa40e4..e4b13a32692a97 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -151,6 +151,7 @@ static int ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
 {
 	struct ib_ucontext_per_mm *per_mm =
 		container_of(mn, struct ib_ucontext_per_mm, mn);
+	int rc;
 
 	if (mmu_notifier_range_blockable(range))
 		down_read(&per_mm->umem_rwsem);
@@ -167,11 +168,14 @@ static int ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		return 0;
 	}
 
-	return rbt_ib_umem_for_each_in_range(&per_mm->umem_tree, range->start,
-					     range->end,
-					     invalidate_range_start_trampoline,
-					     mmu_notifier_range_blockable(range),
-					     NULL);
+	rc = rbt_ib_umem_for_each_in_range(&per_mm->umem_tree, range->start,
+					   range->end,
+					   invalidate_range_start_trampoline,
+					   mmu_notifier_range_blockable(range),
+					   NULL);
+	if (rc)
+		up_read(&per_mm->umem_rwsem);
+	return rc;
 }
 
 static int invalidate_range_end_trampoline(struct ib_umem_odp *item, u64 start,
-- 
2.21.0

