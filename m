Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4736F55746D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 09:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiFWHsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 03:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiFWHso (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 03:48:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5940A2BB3D;
        Thu, 23 Jun 2022 00:48:42 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 171DD1FD39;
        Thu, 23 Jun 2022 07:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655970521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GtdTaFjqWCSCe1yaSCiZGssqCXgG5Q79Oqlpz7qVDg4=;
        b=z3sftmOXa8+4Wp6CcqcekDvq/mXI/k1vhvU697LNBTVyCxrPjC5X1Fo/CAzCcJXCaal8WW
        EPx2hzPlbwi6EP0vm1mu9bDOXqk+ShpRTXyBzhgbYF3dvW0BdAXe8OoWCYHgLLOQvuA1XK
        VjkJLVXC3Fcuza7AMfsgF7j5C1drxg4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655970521;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GtdTaFjqWCSCe1yaSCiZGssqCXgG5Q79Oqlpz7qVDg4=;
        b=UgRVohwe42EARuwopRiapyQJVfTf/D0LVxYurSvMiDews+z4b+oxS4ySV/HJgr+50TT0B4
        HSSP+zODo1YTU3Bw==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 68EA22C14F;
        Thu, 23 Jun 2022 07:48:35 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id B0DE9A0638; Thu, 23 Jun 2022 09:48:40 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     <linux-block@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/9] block: fix default IO priority handling again
Date:   Thu, 23 Jun 2022 09:48:26 +0200
Message-Id: <20220623074840.5960-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220623074450.30550-1-jack@suse.cz>
References: <20220623074450.30550-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3417; h=from:subject; bh=r9iLhnVzNhOEfGHjVQ85hsfk7zhW/kHTRg4ZxFaWAvY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBitBrK+weyWxyVqCcz47tvDyJwY53WZgb4OadrTp/U nYQmP1aJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYrQaygAKCRCcnaoHP2RA2ZZ/B/ 9Q0tU999QCIlBcqvLmWCGHSZt/sryoccdj9h9ZPNCtK9su6kNTpHpUrB4/2iIZhiM4U4G0ZvvCw5n/ LhROVhnm4RGm2gaausInYd5XM6AmKfTnGIX2Z8w4lRsYbV3HTUx+EDQzzArjw39m09G2H3ql3kF+/S Y6o4wwsesLtrR/2hFvTugrO54ikmUgqEboc2dKJN5XxCfyPz3O7ka8R4HZ7Hs5mQH84tBQLnQTYDlY uwPs4sLDMRb3ug4Qctu32or9+2ZZ/9VsTEzfJ8npQjHByCm3rd5vD7krSix9MOeHK1MBWRN5IKeq10 5q2Pc+dKvr5VV74ZdVYMa6XUVZ9QwD
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit e70344c05995 ("block: fix default IO priority handling")
introduced an inconsistency in get_current_ioprio() that tasks without
IO context return IOPRIO_DEFAULT priority while tasks with freshly
allocated IO context will return 0 (IOPRIO_CLASS_NONE/0) IO priority.
Tasks without IO context used to be rare before 5a9d041ba2f6 ("block:
move io_context creation into where it's needed") but after this commit
they became common because now only BFQ IO scheduler setups task's IO
context. Similar inconsistency is there for get_task_ioprio() so this
inconsistency is now exposed to userspace and userspace will see
different IO priority for tasks operating on devices with BFQ compared
to devices without BFQ. Furthemore the changes done by commit
e70344c05995 change the behavior when no IO priority is set for BFQ IO
scheduler which is also documented in ioprio_set(2) manpage:

"If no I/O scheduler has been set for a thread, then by default the I/O
priority will follow the CPU nice value (setpriority(2)).  In Linux
kernels before version 2.6.24, once an I/O priority had been set using
ioprio_set(), there was no way to reset the I/O scheduling behavior to
the default. Since Linux 2.6.24, specifying ioprio as 0 can be used to
reset to the default I/O scheduling behavior."

So make sure we default to IOPRIO_CLASS_NONE as used to be the case
before commit e70344c05995. Also cleanup alloc_io_context() to
explicitely set this IO priority for the allocated IO context to avoid
future surprises. Note that we tweak ioprio_best() to maintain
ioprio_get(2) behavior and make this commit easily backportable.

CC: stable@vger.kernel.org
Fixes: e70344c05995 ("block: fix default IO priority handling")
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/blk-ioc.c        | 2 ++
 block/ioprio.c         | 4 ++--
 include/linux/ioprio.h | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index df9cfe4ca532..63fc02042408 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -247,6 +247,8 @@ static struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 	INIT_HLIST_HEAD(&ioc->icq_list);
 	INIT_WORK(&ioc->release_work, ioc_release_fn);
 #endif
+	ioc->ioprio = IOPRIO_DEFAULT;
+
 	return ioc;
 }
 
diff --git a/block/ioprio.c b/block/ioprio.c
index 2fe068fcaad5..2a34cbca18ae 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -157,9 +157,9 @@ static int get_task_ioprio(struct task_struct *p)
 int ioprio_best(unsigned short aprio, unsigned short bprio)
 {
 	if (!ioprio_valid(aprio))
-		aprio = IOPRIO_DEFAULT;
+		aprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NORM);
 	if (!ioprio_valid(bprio))
-		bprio = IOPRIO_DEFAULT;
+		bprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NORM);
 
 	return min(aprio, bprio);
 }
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index 3f53bc27a19b..3d088a88f832 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -11,7 +11,7 @@
 /*
  * Default IO priority.
  */
-#define IOPRIO_DEFAULT	IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_BE_NORM)
+#define IOPRIO_DEFAULT	IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0)
 
 /*
  * Check that a priority value has a valid class.
-- 
2.35.3

