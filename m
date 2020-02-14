Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20FC15EBA8
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390070AbgBNQKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391399AbgBNQKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1277124699;
        Fri, 14 Feb 2020 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696604;
        bh=2spouiENZlNYp3MJcPrlIyDeaNk6twYapLciEAA6zdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXatV/Uhq4vJqzIW8RTuYC7wfVyKSxj1obImsHHYEPQgSqd27W0L3kxubaNkzBUB1
         nLwi+wUTKE8LQZr8SIBwNVPmAXC5+AZpunUm9F3tB0xbN1ZwK+VikzbNqQmm6y2rVe
         6gLQM8pkYMtDg1jR1VznrZxtKBaleIEB1M/Mz11Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang Chen <liangchen.linux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 389/459] bcache: cached_dev_free needs to put the sb page
Date:   Fri, 14 Feb 2020 11:00:39 -0500
Message-Id: <20200214160149.11681-389-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang Chen <liangchen.linux@gmail.com>

[ Upstream commit e8547d42095e58bee658f00fef8e33d2a185c927 ]

Same as cache device, the buffer page needs to be put while
freeing cached_dev.  Otherwise a page would be leaked every
time a cached_dev is stopped.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 64999c7a8033f..b86cf72033401 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1274,6 +1274,9 @@ static void cached_dev_free(struct closure *cl)
 
 	mutex_unlock(&bch_register_lock);
 
+	if (dc->sb_bio.bi_inline_vecs[0].bv_page)
+		put_page(bio_first_page_all(&dc->sb_bio));
+
 	if (!IS_ERR_OR_NULL(dc->bdev))
 		blkdev_put(dc->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 
-- 
2.20.1

