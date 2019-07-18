Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B15A6C798
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389682AbfGRDZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389491AbfGRDFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:05:43 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DA05204EC;
        Thu, 18 Jul 2019 03:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419143;
        bh=STu5mrw5Db9c2jV+T8+Ud0rGngMeFFfl1sy7OsYWEI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o14IyDr7Rhato862eMSfNx3gauM/6LFTQBcDRppo8tdW6y2RsJPhodo7f6V4JaN88
         RFaIzUzsudvQiN4LobexI1tXGl/oWd87sriHjftI9/dAhqFNbtxeMBupf5iMK26f13
         l7+0ioFnVtdxL48IH699T81gUNJBxXSfxI20wAUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Marchand <jmarchan@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 28/54] dm table: dont copy from a NULL pointer in realloc_argv()
Date:   Thu, 18 Jul 2019 12:01:23 +0900
Message-Id: <20190718030055.544898115@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030053.287374640@linuxfoundation.org>
References: <20190718030053.287374640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 350cf0451456..ec8b27e20de3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -561,7 +561,7 @@ static char **realloc_argv(unsigned *size, char **old_argv)
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



