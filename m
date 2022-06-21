Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7BF552FAA
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbiFUKZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346086AbiFUKY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:24:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6859E2898F;
        Tue, 21 Jun 2022 03:24:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 287E021DE0;
        Tue, 21 Jun 2022 10:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655807097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+LL1dq+apRByD46C4qt8iyxS+9kz4FX5965o6Hrr9kI=;
        b=aHBePNtYp/dfR3sfYIr0qzyQOZiSnLsaIrrQLFFKP0++ROHz4OMWG02IvT8L4YF8DbTUJL
        6oRN7cntcTpKeEPakIhoqxZGEqtpHOQbzhWpS/DR6/b/6A8+WivwRf/O4UDFG+wqVpVDSZ
        9If7qhn3HvUa3wMvUyPBWyk11A8Nabw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655807097;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+LL1dq+apRByD46C4qt8iyxS+9kz4FX5965o6Hrr9kI=;
        b=iwfaTRWJz4JJ7spVJ9vo0wxLmsYxO0e67XZiYuYKgmDAs1OcrF4lTVy94Ulxs5gAYZABAJ
        WSHvwYSllt6Ng0Bg==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AEF5F2C141;
        Tue, 21 Jun 2022 10:24:56 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id CE5C3A03DF; Tue, 21 Jun 2022 12:24:55 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     <linux-block@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/9] block: fix default IO priority handling again
Date:   Tue, 21 Jun 2022 12:24:38 +0200
Message-Id: <20220621102455.13183-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621102201.26337-1-jack@suse.cz>
References: <20220621102201.26337-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3355; h=from:subject; bh=5Ogre5KU1EfoWt3GA/j6Xv+dEaBz2FnoJscfrVh0sr4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBisZxmoyWjApEg1smue+DzBMpbA8NBsL+z2EMCkCzG i4BMSB6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYrGcZgAKCRCcnaoHP2RA2UKJCA C7cQqOQK2/oXPwq5YrSXmvn19b794aXzfOSm35wb8GGxWtJudKYEumlMw1FNY0K/KAAYQXIUN17gw3 Q3uwqP5Qwfvk2cOLdU1J02G7qPDAOcHUAPIP3Lo2XJq2zBAT565Itfe/naUukv/K7Oxfk8hrc2unR8 UcXW8SrsvJ+FO1mNqqJ4gJ5VzPI+/Wr1mfxjSsq6ZEI3/p8x0kj766JyqRHvattwXazcSGPJOu8z2L /RZGoSzRz1HglD6Vs69RcFVZ0CeernhkFryTOqsrwn597jjAgBLlASn1cSmzcVAbm3SdCKzkPCoRbI ATf+4aMhl9vlM7BJLu+7KbqHXQOwU6
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

