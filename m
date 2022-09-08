Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852CF5B2085
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 16:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbiIHO0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 10:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiIHO0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 10:26:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924FFFB8C6;
        Thu,  8 Sep 2022 07:26:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C15261D2E;
        Thu,  8 Sep 2022 14:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C666C433D6;
        Thu,  8 Sep 2022 14:26:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kTlTPKqb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662647195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tiDiqwWP8LXWHrwhahDSsAig51VVDPd45ZIiXF6w6yk=;
        b=kTlTPKqbw78HR6NYkp+aosPtLtoFplLAWPRDHp9faSihIFAlZqZxGoDuaCm1iP1gUozW72
        rtMvop1KaPkxBP8Cy2dlO84kZ3drMWNGI6VZlmnBhmyyMWqRc5IX4/stXcurS7siw6PUYD
        YXp+46jhb3LmQBlP63hlqx5D2yeIR4w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id abb9b42c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 8 Sep 2022 14:26:35 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-fsdevel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Guozihua <guozihua@huawei.com>,
        Zhongguohua <zhongguohua1@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Theodore Ts'o <tytso@mit.edu>,
        Andrew Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] random: restore O_NONBLOCK support
Date:   Thu,  8 Sep 2022 16:26:13 +0200
Message-Id: <20220908142613.341294-1-Jason@zx2c4.com>
In-Reply-To: <YxnGjppJ7ayDD/dQ@zx2c4.com>
References: <YxnGjppJ7ayDD/dQ@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/char/mem.c    | 4 ++--
 drivers/char/random.c | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 84ca98ed1dad..c2b37009b11e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -706,8 +706,8 @@ static const struct memdev {
 #endif
 	 [5] = { "zero", 0666, &zero_fops, FMODE_NOWAIT },
 	 [7] = { "full", 0666, &full_fops, 0 },
-	 [8] = { "random", 0666, &random_fops, 0 },
-	 [9] = { "urandom", 0666, &urandom_fops, 0 },
+	 [8] = { "random", 0666, &random_fops, FMODE_NOWAIT },
+	 [9] = { "urandom", 0666, &urandom_fops, FMODE_NOWAIT },
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, 0 },
 #endif
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 79d7d4e4e582..c8cc23515568 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1347,6 +1347,11 @@ static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
 	int ret;
 
+	if (!crng_ready() &&
+	    ((kiocb->ki_flags & (IOCB_NOWAIT | IOCB_NOIO)) ||
+	     (kiocb->ki_filp->f_flags & O_NONBLOCK)))
+		return -EAGAIN;
+
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;
-- 
2.37.3

