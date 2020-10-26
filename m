Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646DF299FAB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439261AbgJ0AXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410298AbgJZXyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:54:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF2021655;
        Mon, 26 Oct 2020 23:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756444;
        bh=vl6O4oqa8oou/C33lhU3F45BLVant7tmaE2Yu+Cjurw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQ/YDg89Yp8bezeQCGq6KsKlVJUZpi4gPXR7BipP/3CgYrCOAv6liLYiAKFuB5xfc
         GfTpbS0DdS4tsN+Z6+BZEqzN9ASLXkd/q+Y9pSTKIP58s99oYkjO1t7B4e6kJvqTQ1
         47GnZuYI+UsZpRyf0JuxLTU7Clq/cyMEGstR1Z6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 097/132] md/bitmap: md_bitmap_get_counter returns wrong blocks
Date:   Mon, 26 Oct 2020 19:51:29 -0400
Message-Id: <20201026235205.1023962-97-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Heming <heming.zhao@suse.com>

[ Upstream commit d837f7277f56e70d82b3a4a037d744854e62f387 ]

md_bitmap_get_counter() has code:

```
    if (bitmap->bp[page].hijacked ||
        bitmap->bp[page].map == NULL)
        csize = ((sector_t)1) << (bitmap->chunkshift +
                      PAGE_COUNTER_SHIFT - 1);
```

The minus 1 is wrong, this branch should report 2048 bits of space.
With "-1" action, this only report 1024 bit of space.

This bug code returns wrong blocks, but it doesn't inflence bitmap logic:
1. Most callers focus this function return value (the counter of offset),
   not the parameter blocks.
2. The bug is only triggered when hijacked is true or map is NULL.
   the hijacked true condition is very rare.
   the "map == null" only true when array is creating or resizing.
3. Even the caller gets wrong blocks, current code makes caller just to
   call md_bitmap_get_counter() one more time.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 95a5f3757fa30..32a96559cb366 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1367,7 +1367,7 @@ __acquires(bitmap->lock)
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
 		csize = ((sector_t)1) << (bitmap->chunkshift +
-					  PAGE_COUNTER_SHIFT - 1);
+					  PAGE_COUNTER_SHIFT);
 	else
 		csize = ((sector_t)1) << bitmap->chunkshift;
 	*blocks = csize - (offset & (csize - 1));
-- 
2.25.1

