Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B275A6DA
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 00:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfF1WW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 18:22:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49960 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfF1WW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 18:22:29 -0400
Received: from mail-qt1-f200.google.com ([209.85.160.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gpiccoli@canonical.com>)
        id 1hgzC8-0004pq-Nr
        for stable@vger.kernel.org; Fri, 28 Jun 2019 22:18:13 +0000
Received: by mail-qt1-f200.google.com with SMTP id h47so7513716qtc.20
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 15:18:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n5bQiVrS+1LRta2NDI5p3A3SX0XhkU71NGdqYIImrSI=;
        b=BaXaW8uEDrFTZuYxbhuCkDMkTrlX0sIWsRIlgYjfAzw7dmJL3ZO/Sj1SbnkFbgq+st
         jZhSBBGljRIb8bLmY2TpZZDykQcl1DhVpTEYmcKWbT3cncCNAXg3N2Vywn8CfZJZQgN8
         YC/ws7MOWnMstulrdKtRpHLXeYbVt/uwVJh5PGBIhtPTdR3qKFNefITkGboHlGUNPUlf
         mk3+8zxppJElUPQNFHKhogzvgNQZZ4toqEfzUtvlmK5ZnRZ9OGUuhuN820S1Nen5EkgS
         d9lWA6awUm+cVrB4uPo2+NTDk7Y97CpFAh58J9cLkWFq8JtdSL9CWDEpAQuLhyvmznLt
         b7pg==
X-Gm-Message-State: APjAAAVxhwnDAdmQRpe195g7ZwrvAArPelOg49gmkUAvRcMr6NJBDoBv
        q966q8UaIO93svRYoBlH9aCeKoTGxRpo0tS/vECnvH1Y0qzuNNaR7zgejzwHCO6RGNCVz2OQ+9i
        JFWbIApJHij4TmLCRJffWYjyviV4OyTV20g==
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr10031490qty.59.1561760291612;
        Fri, 28 Jun 2019 15:18:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyJgNAetkfe3QWI0Qep3GxdX+hqWUv9mu+JZ5GT1MgRrTniaFvcZ50KaBzSf7+2mPVnA9WfLQ==
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr10031469qty.59.1561760291413;
        Fri, 28 Jun 2019 15:18:11 -0700 (PDT)
Received: from localhost ([179.110.97.158])
        by smtp.gmail.com with ESMTPSA id x205sm1627081qka.56.2019.06.28.15.18.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 15:18:10 -0700 (PDT)
From:   "Guilherme G. Piccoli" <gpiccoli@canonical.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        gpiccoli@canonical.com, jay.vosburgh@canonical.com,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <songliubraving@fb.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>
Subject: [4.19.y PATCH 1/2] block: Fix a NULL pointer dereference in generic_make_request()
Date:   Fri, 28 Jun 2019 19:17:58 -0300
Message-Id: <20190628221759.18274-1-gpiccoli@canonical.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----------------------------------------------------------------
This patch is not on mainline and is meant to 4.19 stable *only*.
After the patch description there's a reasoning about that.
-----------------------------------------------------------------

Commit 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently
with device removal triggers a crash") introduced a NULL pointer
dereference in generic_make_request(). The patch sets q to NULL and
enter_succeeded to false; right after, there's an 'if (enter_succeeded)'
which is not taken, and then the 'else' will dereference q in
blk_queue_dying(q).

This patch just moves the 'q = NULL' to a point in which it won't trigger
the oops, although the semantics of this NULLification remains untouched.

A simple test case/reproducer is as follows:
a) Build kernel v4.19.56-stable with CONFIG_BLK_CGROUP=n.

b) Create a raid0 md array with 2 NVMe devices as members, and mount
it with an ext4 filesystem.

c) Run the following oneliner (supposing the raid0 is mounted in /mnt):
(dd of=/mnt/tmp if=/dev/zero bs=1M count=999 &); sleep 0.3;
echo 1 > /sys/block/nvme1n1/device/device/remove
(whereas nvme1n1 is the 2nd array member)

This will trigger the following oops:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000078
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
RIP: 0010:generic_make_request+0x32b/0x400
Call Trace:
 submit_bio+0x73/0x140
 ext4_io_submit+0x4d/0x60
 ext4_writepages+0x626/0xe90
 do_writepages+0x4b/0xe0
[...]

This patch has no functional changes and preserves the md/raid0 behavior
when a member is removed before kernel v4.17.

----------------------------
Why this is not on mainline?
----------------------------

The patch was originally submitted upstream in linux-raid and
linux-block mailing-lists - it was initially accepted by Song Liu,
but Christoph Hellwig[0] observed that there was a clean-up series
ready to be accepted from Ming Lei[1] that fixed the same issue.

The accepted patches from Ming's series in upstream are: commit
47cdee29ef9d ("block: move blk_exit_queue into __blk_release_queue") and
commit fe2008640ae3 ("block: don't protect generic_make_request_checks
with blk_queue_enter"). Those patches basically do a clean-up in the
block layer involving:

1) Putting back blk_exit_queue() logic into __blk_release_queue(); that
path was changed in the past and the logic from blk_exit_queue() was
added to blk_cleanup_queue().

2) Removing the guard/protection in generic_make_request_checks() with
blk_queue_enter().

The problem with Ming's series for -stable is that it relies in the
legacy request IO path removal. So it's "backport-able" to v5.0+,
but doing that for early versions (like 4.19) would incur in complex
code changes. Hence, it was suggested by Christoph and Song Liu that
this patch was submitted to stable only; otherwise merging it upstream
would add code to fix a path removed in a subsequent commit.

[0] lore.kernel.org/linux-block/20190521172258.GA32702@infradead.org
[1] lore.kernel.org/linux-block/20190515030310.20393-1-ming.lei@redhat.com

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <songliubraving@fb.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Eric Ren <renzhengeek@gmail.com>
Fixes: 37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
---
 block/blk-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6eed5d84c2ef..682bc561b77b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2445,10 +2445,8 @@ blk_qc_t generic_make_request(struct bio *bio)
 			flags = 0;
 			if (bio->bi_opf & REQ_NOWAIT)
 				flags = BLK_MQ_REQ_NOWAIT;
-			if (blk_queue_enter(q, flags) < 0) {
+			if (blk_queue_enter(q, flags) < 0)
 				enter_succeeded = false;
-				q = NULL;
-			}
 		}
 
 		if (enter_succeeded) {
@@ -2479,6 +2477,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 				bio_wouldblock_error(bio);
 			else
 				bio_io_error(bio);
+			q = NULL;
 		}
 		bio = bio_list_pop(&bio_list_on_stack[0]);
 	} while (bio);
-- 
2.22.0

