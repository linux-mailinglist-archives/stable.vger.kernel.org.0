Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36F820E4D1
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388330AbgF2V3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgF2SlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E480A23EB2;
        Mon, 29 Jun 2020 15:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443902;
        bh=NbIIanRtOQq4orleKOc5/qazWwvR7o3ndILm16qvPZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuSFTRLisUPRIUXTDV5FC38GvWGJw+cB9ajPAXEMT9xX6fx6de25/hsqQPjFwpKOo
         PTgfOl5otHJZdtqBQVr4rCcOFjJ61Y7J7XX1QUNrXn4hi/pskn45wQ13rwn8cz0DxU
         6PnD3xFsJYhumxYCfWUZYWn0dugJ1z0joOhRhXEM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Bob Liu <bob.liu@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 002/265] block/bio-integrity: don't free 'buf' if bio_integrity_add_page() failed
Date:   Mon, 29 Jun 2020 11:13:55 -0400
Message-Id: <20200629151818.2493727-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yu kuai <yukuai3@huawei.com>

commit a75ca9303175d36af93c0937dd9b1a6422908b8d upstream.

commit e7bf90e5afe3 ("block/bio-integrity: fix a memory leak bug") added
a kfree() for 'buf' if bio_integrity_add_page() returns '0'. However,
the object will be freed in bio_integrity_free() since 'bio->bi_opf' and
'bio->bi_integrity' were set previousy in bio_integrity_alloc().

Fixes: commit e7bf90e5afe3 ("block/bio-integrity: fix a memory leak bug")
Signed-off-by: yu kuai <yukuai3@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio-integrity.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index bf62c25cde8f4..ae07dd78e9518 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -278,7 +278,6 @@ bool bio_integrity_prep(struct bio *bio)
 
 		if (ret == 0) {
 			printk(KERN_ERR "could not attach integrity payload\n");
-			kfree(buf);
 			status = BLK_STS_RESOURCE;
 			goto err_end_io;
 		}
-- 
2.25.1

