Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F665DBB4
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfGCCRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbfGCCQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC8D221880;
        Wed,  3 Jul 2019 02:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120207;
        bh=7NiTt5czzUH551Nzj8LZqum/G+FC9dq30qWS4x1U9kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArZs3jdXXUupmbULP0h9BR2bRDgccGB0Yt5rGZjkcSzONYUM7LTKRkCURjrg0lsGn
         l8uYDWHROPQtzs96K9+661KPLC3HrSQnkzDllFd2y+e7/MZ2EkUKqE023/CQeVb2Al
         RldlclbKvMxZ3klfsrXKj7SdUjky/JcmCfuierjQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Marchand <jmarchan@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 17/26] dm table: don't copy from a NULL pointer in realloc_argv()
Date:   Tue,  2 Jul 2019 22:16:16 -0400
Message-Id: <20190703021625.18116-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021625.18116-1-sashal@kernel.org>
References: <20190703021625.18116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Marchand <jmarchan@redhat.com>

[ Upstream commit a0651926553cfe7992166432e418987760882652 ]

For the first call to realloc_argv() in dm_split_args(), old_argv is
NULL and size is zero. Then memcpy is called, with the NULL old_argv
as the source argument and a zero size argument. AFAIK, this is
undefined behavior and generates the following warning when compiled
with UBSAN on ppc64le:

In file included from ./arch/powerpc/include/asm/paca.h:19,
                 from ./arch/powerpc/include/asm/current.h:16,
                 from ./include/linux/sched.h:12,
                 from ./include/linux/kthread.h:6,
                 from drivers/md/dm-core.h:12,
                 from drivers/md/dm-table.c:8:
In function 'memcpy',
    inlined from 'realloc_argv' at drivers/md/dm-table.c:565:3,
    inlined from 'dm_split_args' at drivers/md/dm-table.c:588:9:
./include/linux/string.h:345:9: error: argument 2 null where non-null expected [-Werror=nonnull]
  return __builtin_memcpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/md/dm-table.c: In function 'dm_split_args':
./include/linux/string.h:345:9: note: in a call to built-in function '__builtin_memcpy'

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index c7fe4789c40e..34ab30dd5de9 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -562,7 +562,7 @@ static char **realloc_argv(unsigned *size, char **old_argv)
 		gfp = GFP_NOIO;
 	}
 	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
-	if (argv) {
+	if (argv && old_argv) {
 		memcpy(argv, old_argv, *size * sizeof(*argv));
 		*size = new_size;
 	}
-- 
2.20.1

