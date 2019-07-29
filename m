Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E079826
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388336AbfG2TpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389905AbfG2TpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:45:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F3DA20C01;
        Mon, 29 Jul 2019 19:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429507;
        bh=RZdOQBgOVa+INT8RKCIJ+QGpFkoab41V+bkvHbBKjfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iLdrhlU82p39ATzWWV6tWQmUmW525b+kPiOuPi2exS+Qi0rMaDucDJ62YZbNMwMb
         epCTbGcNA1bi1pQHP9Jvhw/6fS8ULTNbhAF61Wuk+XC8iKddjpd1Utmqi3heMOiXhK
         U1eClSAOzH6BAPIUEsFJXz780DAGoVnTZBnZbTRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Wenwen Wang <wenwen@cs.uga.edu>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/113] block/bio-integrity: fix a memory leak bug
Date:   Mon, 29 Jul 2019 21:22:48 +0200
Message-Id: <20190729190714.983355258@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



