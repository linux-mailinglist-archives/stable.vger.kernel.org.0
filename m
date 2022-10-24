Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE2860A4C5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiJXMPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbiJXMO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4BD7963A;
        Mon, 24 Oct 2022 04:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F6BA612FE;
        Mon, 24 Oct 2022 11:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45502C433D7;
        Mon, 24 Oct 2022 11:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612539;
        bh=AtPuK4+6wjQ0bpEyIlTUi6fm79RRmk4Cm/SAy7YgL4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKSG+gyFPC1GvqnUUe0SgPNnyrP5UrcMMRF/liRRU1sgP7IzXbUWhx8yZ4D5JASY1
         PBuifkj6Og4st26s9lVfJP4AkNA2K9zXH9DS48/BPu4W8/fDhgjW8FppoQchrH6ZXA
         zGWzLmAk/jv600ClA/IfGzmt8fis2PgzKgFUyMxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guozihua <guozihua@huawei.com>,
        Zhongguohua <zhongguohua1@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Lutomirski <luto@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 026/229] random: restore O_NONBLOCK support
Date:   Mon, 24 Oct 2022 13:29:05 +0200
Message-Id: <20221024112959.982158381@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit cd4f24ae9404fd31fc461066e57889be3b68641b upstream.

Prior to 5.6, when /dev/random was opened with O_NONBLOCK, it would
return -EAGAIN if there was no entropy. When the pools were unified in
5.6, this was lost. The post 5.6 behavior of blocking until the pool is
initialized, and ignoring O_NONBLOCK in the process, went unnoticed,
with no reports about the regression received for two and a half years.
However, eventually this indeed did break somebody's userspace.

So we restore the old behavior, by returning -EAGAIN if the pool is not
initialized. Unlike the old /dev/random, this can only occur during
early boot, after which it never blocks again.

In order to make this O_NONBLOCK behavior consistent with other
expectations, also respect users reading with preadv2(RWF_NOWAIT) and
similar.

Fixes: 30c08efec888 ("random: make /dev/random be almost like /dev/urandom")
Reported-by: Guozihua <guozihua@huawei.com>
Reported-by: Zhongguohua <zhongguohua1@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andrew Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/mem.c    |    4 ++--
 drivers/char/random.c |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -893,8 +893,8 @@ static const struct memdev {
 #endif
 	 [5] = { "zero", 0666, &zero_fops, 0 },
 	 [7] = { "full", 0666, &full_fops, 0 },
-	 [8] = { "random", 0666, &random_fops, 0 },
-	 [9] = { "urandom", 0666, &urandom_fops, 0 },
+	 [8] = { "random", 0666, &random_fops, FMODE_NOWAIT },
+	 [9] = { "urandom", 0666, &urandom_fops, FMODE_NOWAIT },
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, 0 },
 #endif
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1294,6 +1294,11 @@ static ssize_t random_read_iter(struct k
 {
 	int ret;
 
+	if (!crng_ready() &&
+	    ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	     (kiocb->ki_filp->f_flags & O_NONBLOCK)))
+		return -EAGAIN;
+
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;


