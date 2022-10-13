Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC7D5FDAF2
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 15:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJMNfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 09:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJMNfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 09:35:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3F325C6E
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 06:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA206B81E23
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 13:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F467C433C1;
        Thu, 13 Oct 2022 13:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665668101;
        bh=3ENtxothW8cx6meO2n96YmhRBVq/B1vRE/HHvm+m2GY=;
        h=Subject:To:Cc:From:Date:From;
        b=XRnLFH7efIsVsYDg2sWpxZQR7m8v5fr9szyFO6SSH9bdQEpH6gebWNNs1toZiOHbV
         rhN2VDZfAAElvBS0ubJ9mTA46cuX+J6JaX/M7/hyFIUTK66dnBAeqX4Z2KF4qMyUKX
         rozRLG6cAlVzD/llXNlDHPTqfIosOESJ2KNji6Yg=
Subject: FAILED: patch "[PATCH] random: restore O_NONBLOCK support" failed to apply to 4.19-stable tree
To:     Jason@zx2c4.com, guozihua@huawei.com, luto@kernel.org,
        tytso@mit.edu, viro@zeniv.linux.org.uk, zhongguohua1@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Oct 2022 15:35:43 +0200
Message-ID: <1665668143131156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.


thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cd4f24ae9404fd31fc461066e57889be3b68641b Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Sep 2022 16:14:00 +0200
Subject: [PATCH] random: restore O_NONBLOCK support

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

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 32a932a065a6..5611d127363e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -712,8 +712,8 @@ static const struct memdev {
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

