Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7FD91A9A
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 03:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfHSBPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 21:15:20 -0400
Received: from mail-m975.mail.163.com ([123.126.97.5]:43174 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHSBPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 21:15:19 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Aug 2019 21:15:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=/7j5TCVh3LyFbojbI4
        zNhdc3Dow0JvOr+GRNkDNVxl8=; b=kQznfR5YSJzolkAfLVeQQ1cW4idq5qSjkO
        fq9sNlZqNk2dTpYeS8RoTSXNMyAvTY7enb0Mjt0XZOkrKU0gH3XKCB+G9inbziIQ
        XNJSmMPaBKs/UbpSzmBL0Ryx7L9XpgZzgtqgVK3noBpiPws0xd9rgN1MfIMEVGbM
        xfxzAeZ+8=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp5 (Coremail) with SMTP id HdxpCgB3jbRn9FldfQ_WAg--.240S3;
        Mon, 19 Aug 2019 09:00:07 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>, stable@vger.kernel.org
Subject: [PATCH V2] block/bio-integrity: fix mismatched alloc free
Date:   Mon, 19 Aug 2019 08:59:13 +0800
Message-Id: <1566176353-20157-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: HdxpCgB3jbRn9FldfQ_WAg--.240S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr1UuFyUuw15CF1kZFyUGFg_yoWDZFc_Ka
        yv9r93ArnYvF4xCw12yFy7Ar4vvr4fXF1rXFyaqrWaqFyxAry3A3s7Xr95XFs7Wr97urnx
        uryvqwnFqw17KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUb8wIPUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBzwkWclaD4ImCBQABsY
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function kmalloc rather than mempool_alloc is called to allocate
memory when the memory pool is unavailable. However, mempool_alloc is
used to release the memory chunck in both cases when error occurs. This
patch fixes the bug.

Fixes: 9f060e2231c ("block: Convert integrity to bvec_alloc_bs()")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Cc: stable@vger.kernel.org
---
V2: add Fixes and CC tags
---
 block/bio-integrity.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index fb95dbb..011dfc8 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -75,7 +75,10 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 
 	return bip;
 err:
-	mempool_free(bip, &bs->bio_integrity_pool);
+	if (!bs || !mempool_initialized(&bs->bio_integrity_pool))
+		kfree(bip);
+	else
+		mempool_free(bip, &bs->bio_integrity_pool);
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
-- 
2.7.4

