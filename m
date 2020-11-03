Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0D2A53F2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388117AbgKCVGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388109AbgKCVGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29797206B5;
        Tue,  3 Nov 2020 21:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437568;
        bh=h4131RUf+Q4hXM1qSEf0WumYcMJdY0zfofruLlAEoXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pcu+qDB/Tvk0FCVNSfFi2PXPexFk58oAlsxzU+c9GO+Pue7mvWEP6RXy2G6nEbv81
         Si+ccu5KE3pgbp6OtI7AXI7Q84kJBQz+EJc+Gp5Ex9pd+dxFYaajkAUaMjPsnpse+7
         fLYQWkLlzamEyZG9jiSVIrrJv5oi+rYwF3IiXL80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhao Heming <heming.zhao@suse.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/191] md/bitmap: md_bitmap_get_counter returns wrong blocks
Date:   Tue,  3 Nov 2020 21:36:26 +0100
Message-Id: <20201103203242.679798798@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fd8607124bdbb..503f5e06fa86f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1371,7 +1371,7 @@ __acquires(bitmap->lock)
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
 		csize = ((sector_t)1) << (bitmap->chunkshift +
-					  PAGE_COUNTER_SHIFT - 1);
+					  PAGE_COUNTER_SHIFT);
 	else
 		csize = ((sector_t)1) << bitmap->chunkshift;
 	*blocks = csize - (offset & (csize - 1));
-- 
2.27.0



