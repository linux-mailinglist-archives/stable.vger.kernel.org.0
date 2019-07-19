Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5587A6DD7F
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733011AbfGSEXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:23:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388044AbfGSEKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:10:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 438CC218B6;
        Fri, 19 Jul 2019 04:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509424;
        bh=Squpm5wiFhJ7jYX3tobIsYEcUfe7On3sn+I53JoOGrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UQJzw86fxWVI85OcqdNdbY67V6uZZmqcw5uqIPs320oyG0F3TKuL+dlV4eGT0sw4
         HGlyz3ObNOlq2V8EVNOffiDgyMdZjuJq/J4WbSlLrN7vxic9ZJYbkKVyA0kPISPiGk
         b2RQVa8GRiOaCGuBhL9amJ/pVaYIij/wStcvMPfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>, Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 086/101] block/bio-integrity: fix a memory leak bug
Date:   Fri, 19 Jul 2019 00:07:17 -0400
Message-Id: <20190719040732.17285-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit e7bf90e5afe3aa1d1282c1635a49e17a32c4ecec ]

In bio_integrity_prep(), a kernel buffer is allocated through kmalloc() to
hold integrity metadata. Later on, the buffer will be attached to the bio
structure through bio_integrity_add_page(), which returns the number of
bytes of integrity metadata attached. Due to unexpected situations,
bio_integrity_add_page() may return 0. As a result, bio_integrity_prep()
needs to be terminated with 'false' returned to indicate this error.
However, the allocated kernel buffer is not freed on this execution path,
leading to a memory leak.

To fix this issue, free the allocated buffer before returning from
bio_integrity_prep().

Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 67b5fb861a51..5bd90cd4b51e 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -291,8 +291,12 @@ bool bio_integrity_prep(struct bio *bio)
 		ret = bio_integrity_add_page(bio, virt_to_page(buf),
 					     bytes, offset);
 
-		if (ret == 0)
-			return false;
+		if (ret == 0) {
+			printk(KERN_ERR "could not attach integrity payload\n");
+			kfree(buf);
+			status = BLK_STS_RESOURCE;
+			goto err_end_io;
+		}
 
 		if (ret < bytes)
 			break;
-- 
2.20.1

