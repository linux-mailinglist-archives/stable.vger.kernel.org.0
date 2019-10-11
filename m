Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111EBD4061
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 15:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfJKND7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 09:03:59 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43966 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbfJKND7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 09:03:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id h126so8747557qke.10
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 06:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sIeAmoQ1tf95dhIrbjTVNmGzOt/oM6I621aHd+sITPA=;
        b=RSb4qOCFYMqJZc2GceDsE6jeyyA8lgB79phjXK80dJNwSCrOqr5m90tvUHEDn7PfFi
         2ykYUWZ8j9dyCwg5RsNjSmOUwMubc/LftHnUvE5AJFZEtdLRe855rZnSuKwOXP8gN9PY
         VFGpPfRgSoJGOVdnJjnKnQrjunv/wZkRZdf1m9vwSbuWfC8Ue7XCCJ7addPQszYDVQh5
         nHce5IKPe85kE3evPEFtEn+WABZDoUWEAxUfGxAgJU/P1lG6dxkb3W7ORemnMxr4Yey6
         3A+EZ/PGHG/tuWrQP+L4yLszYCaL9KTwDIPseMr3j1qD3sXRRheXMw6wEPSj2NhesseH
         MH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sIeAmoQ1tf95dhIrbjTVNmGzOt/oM6I621aHd+sITPA=;
        b=itirfdfMpCg69QQc7UYoZ9ugVw5YJSiOV5KRH9TbbRcXTF7BPMwZOv6H0gZtw53Jf7
         IBQ2hpPnWzwkWSOwMrSMc3WDFvQKHsAuzNbikE1t89lgcCYzVbL9eO2JS+vbxEcljIg1
         i8aukwyQqlfYFbMYTiH8rQVt7GLDzGcmrBUaymxewEd4JMT0JG4DMgOQcLkXj7cGs7/Q
         2XGSJ5CB7OhC2iOH6la4Yw4SmGfIYBwMEBkyHpyccRyeExN8hCESnpbEkf5S76nD515j
         nB7+eU0xpNykLSoF39e70l2K7GWUgp7W2/iWO/NogdHsfIfngCC5WSYTpPwOwbhyExuO
         n0bw==
X-Gm-Message-State: APjAAAWe4LbtXr3uBnDsxhPgWf0/6OK+U2UcYCGn1mZbLXRoU8SIs1So
        wRGlUNzUSIisxBcxxkunjsV1uw==
X-Google-Smtp-Source: APXvYqyj41wFAHlG0lp1iJLbAS8PUasmYyLU8N65mCVeUn/X4FQRRm88MXMwPLzX9uh70bztZpCLOg==
X-Received: by 2002:a05:620a:20da:: with SMTP id f26mr14928343qka.255.1570799036794;
        Fri, 11 Oct 2019 06:03:56 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o52sm5721226qtf.56.2019.10.11.06.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 06:03:55 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: save i_size in compress_file_range
Date:   Fri, 11 Oct 2019 09:03:54 -0400
Message-Id: <20191011130354.8232-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We hit a regression while rolling out 5.2 internally where we were
hitting the following panic

kernel BUG at mm/page-writeback.c:2659!
RIP: 0010:clear_page_dirty_for_io+0xe6/0x1f0
Call Trace:
 __process_pages_contig+0x25a/0x350
 ? extent_clear_unlock_delalloc+0x43/0x70
 submit_compressed_extents+0x359/0x4d0
 normal_work_helper+0x15a/0x330
 process_one_work+0x1f5/0x3f0
 worker_thread+0x2d/0x3d0
 ? rescuer_thread+0x340/0x340
 kthread+0x111/0x130
 ? kthread_create_on_node+0x60/0x60
 ret_from_fork+0x1f/0x30

this is happening because the page is not locked when doing
clear_page_dirty_for_io.  Looking at the core dump it was because our
async_extent had a ram_size of 24576 but our async_chunk range only
spanned 20480, so we had a whole extra page in our ram_size for our
async_extent.

This happened because we try not to compress pages outside of our
i_size, however a cleanup patch changed us to do

actual_end = min_t(u64, i_size_read(inode), end + 1);

which is problematic because i_size_read() can evaluate to different
values in between checking and assigning.  So either a expanding
truncate or a fallocate could increase our i_size while we're doing
writeout and actual_end would end up being past the range we have
locked.

I confirmed this was what was happening by installing a debug kernel
that had

actual_end = min_t(u64, i_size_read(inode), end + 1);
if (actual_end > end + 1) {
	printk(KERN_ERR "WE GOT FUCKED\n");
	actual_end = end + 1;
}

and installing it onto 500 boxes of the tier that had been seeing the
problem regularly.  Last night I got my debug message and no panic,
confirming what I expected.

Fixes: 62b37622718c ("btrfs: Remove isize local variable in compress_file_range")
cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2eb1d7249f83..9a483d1f61f8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -474,6 +474,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 	u64 start = async_chunk->start;
 	u64 end = async_chunk->end;
 	u64 actual_end;
+	loff_t i_size = i_size_read(inode);
 	int ret = 0;
 	struct page **pages = NULL;
 	unsigned long nr_pages;
@@ -488,7 +489,13 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
 			SZ_16K);
 
-	actual_end = min_t(u64, i_size_read(inode), end + 1);
+	/*
+	 * We need to save i_size before now because it could change in between
+	 * us evaluating the size and assigning it.  This is because we lock and
+	 * unlock the page in truncate and fallocate, and then modify the i_size
+	 * later on.
+	 */
+	actual_end = min_t(u64, i_size, end + 1);
 again:
 	will_compress = 0;
 	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
-- 
2.21.0

