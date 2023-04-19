Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE896E82FC
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 23:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDSVDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 17:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjDSVDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 17:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712BA618D;
        Wed, 19 Apr 2023 14:03:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 099E8634B4;
        Wed, 19 Apr 2023 21:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624D6C433D2;
        Wed, 19 Apr 2023 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681938217;
        bh=yogn+9PYSPxenmE3XWIOpB3TJhYbCs7RmCF72lQOlh0=;
        h=Date:To:From:Subject:From;
        b=xdpgEpNkmCxQpQDCOvAoPAHNyU2ykJ8LZ3j7GuF5Doeeu/c3ZhNMtziX6Uv9U6laj
         lIHMJxLzsMLg+wioJOFwzBbcvNaN+NYJcjrPUBDLMtiQ2aE2JaPzSX1IZ0itMQd4Je
         1+eVZKf3rbFts0R9v33piiKwWy12hU1SED5iAU1k=
Date:   Wed, 19 Apr 2023 14:03:36 -0700
To:     mm-commits@vger.kernel.org, zhou.kete@h3c.com,
        zhao_lei1@hoperun.com, yangpc@wangsu.com, stable@vger.kernel.org,
        axboe@kernel.dk, zhang.zhengming@h3c.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + relayfs-fix-out-of-bounds-access-in-relay_file_read.patch added to mm-hotfixes-unstable branch
Message-Id: <20230419210337.624D6C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: relayfs: fix out-of-bounds access in relay_file_read
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     relayfs-fix-out-of-bounds-access-in-relay_file_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/relayfs-fix-out-of-bounds-access-in-relay_file_read.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zhang Zhengming <zhang.zhengming@h3c.com>
Subject: relayfs: fix out-of-bounds access in relay_file_read
Date: Wed, 19 Apr 2023 12:02:03 +0800

There is a crash in relay_file_read, as the var from
point to the end of last subbuf.

The oops looks something like:
pc : __arch_copy_to_user+0x180/0x310
lr : relay_file_read+0x20c/0x2c8
Call trace:
 __arch_copy_to_user+0x180/0x310
 full_proxy_read+0x68/0x98
 vfs_read+0xb0/0x1d0
 ksys_read+0x6c/0xf0
 __arm64_sys_read+0x20/0x28
 el0_svc_common.constprop.3+0x84/0x108
 do_el0_svc+0x74/0x90
 el0_svc+0x1c/0x28
 el0_sync_handler+0x88/0xb0
 el0_sync+0x148/0x180

We get the condition by analyzing the vmcore:

1). The last produced byte and last consumed byte
    both at the end of the last subbuf

2). A softirq calls function(e.g __blk_add_trace)
    to write relay buffer occurs when an program is calling
    relay_file_read_avail().

        relay_file_read
                relay_file_read_avail
                        relay_file_read_consume(buf, 0, 0);
                        //interrupted by softirq who will write subbuf
                        ....
                        return 1;
                //read_start point to the end of the last subbuf
                read_start = relay_file_read_start_pos
                //avail is equal to subsize
                avail = relay_file_read_subbuf_avail
                //from  points to an invalid memory address
                from = buf->start + read_start
                //system is crashed
                copy_to_user(buffer, from, avail)

Link: https://lkml.kernel.org/r/20230419040203.37676-1-zhang.zhengming@h3c.com
Fixes: 341a7213e5c1 ("kernel/relay.c: fix read_pos error when multiple readers")
Signed-off-by: Zhang Zhengming <zhang.zhengming@h3c.com>
Reviewed-by: Zhao Lei <zhao_lei1@hoperun.com>
Reviewed-by: Zhou Kete <zhou.kete@h3c.com>
Cc: Pengcheng Yang <yangpc@wangsu.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/relay.c~relayfs-fix-out-of-bounds-access-in-relay_file_read
+++ a/kernel/relay.c
@@ -989,7 +989,8 @@ static size_t relay_file_read_start_pos(
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t consumed = buf->subbufs_consumed % n_subbufs;
-	size_t read_pos = consumed * subbuf_size + buf->bytes_consumed;
+	size_t read_pos = (consumed * subbuf_size + buf->bytes_consumed)
+			% (n_subbufs * subbuf_size);
 
 	read_subbuf = read_pos / subbuf_size;
 	padding = buf->padding[read_subbuf];
_

Patches currently in -mm which might be from zhang.zhengming@h3c.com are

relayfs-fix-out-of-bounds-access-in-relay_file_read.patch

