Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490D858DE23
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345384AbiHISMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345867AbiHISLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:11:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDCB2B263;
        Tue,  9 Aug 2022 11:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1D7E61139;
        Tue,  9 Aug 2022 18:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C028C43141;
        Tue,  9 Aug 2022 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068297;
        bh=eZWrVdJWq375kXAsIUU8k4S8P/O7f2H0xgz4sXsXJrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M99R9irRchQ3ZbjVVXO2qlHc1rAugBrBJBGyu3x0YYTrL+0jTK7loODSAu+5s8+3i
         YXck3mjcqywzo/G/Kj8vIYK+XoYdKGUXY4Wngif3rZY0Q7wILquET8otOgbyWh9ANA
         BrGq4A9nNOG1RgGVASokdpSYfEBXsjwyISYdrhoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 04/30] block: fix default IO priority handling again
Date:   Tue,  9 Aug 2022 20:00:29 +0200
Message-Id: <20220809175514.433647534@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175514.276643253@linuxfoundation.org>
References: <20220809175514.276643253@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit e589f46445960c274cc813a1cc8e2fc73b2a1849 upstream.

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220623074840.5960-1-jack@suse.cz
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-ioc.c        |    1 +
 block/ioprio.c         |    4 ++--
 include/linux/ioprio.h |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -265,6 +265,7 @@ int create_task_io_context(struct task_s
 	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC);
 	INIT_HLIST_HEAD(&ioc->icq_list);
 	INIT_WORK(&ioc->release_work, ioc_release_fn);
+	ioc->ioprio = IOPRIO_DEFAULT;
 
 	/*
 	 * Try to install.  ioc shouldn't be installed if someone else
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -189,9 +189,9 @@ out:
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


