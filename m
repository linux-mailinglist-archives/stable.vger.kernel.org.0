Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DF965D6A9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbjADO4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239526AbjADO4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:56:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFF2BF49
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:56:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB3EC6137A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE94C433F0;
        Wed,  4 Jan 2023 14:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844181;
        bh=qa+lC2RasvE+A8ZMEchwj5sTJrEtXHjbCgeDEk9ZeaM=;
        h=Subject:To:Cc:From:Date:From;
        b=DJmjTooirUuQiQQ9aTvGVfUeFtUmx/A9EEtPP+m84hiymPMXmtbWVbC6N3k7DnzF7
         KgNyb06Z90LQ0ABr+MkjruPg1t4a6HSE1wGcV4CCtOf7zgqe7uB6ZsT1YUPtc2KvCq
         CZSWDwn0h0VT71XZ9CZb5oRJ2ep2IgbCfrvINLn0=
Subject: FAILED: patch "[PATCH] fs: ext4: initialize fsdata in pagecache_write()" failed to apply to 5.10-stable tree
To:     glider@google.com, ebiggers@google.com, ebiggers@kernel.org,
        tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:55:02 +0100
Message-ID: <1672844102105235@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

956510c0c743 ("fs: ext4: initialize fsdata in pagecache_write()")
bd256fda92ef ("ext4: use memcpy_to_page() in pagecache_write()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 956510c0c7439e90b8103aaeaf4da92878c622f0 Mon Sep 17 00:00:00 2001
From: Alexander Potapenko <glider@google.com>
Date: Mon, 21 Nov 2022 12:21:30 +0100
Subject: [PATCH] fs: ext4: initialize fsdata in pagecache_write()

When aops->write_begin() does not initialize fsdata, KMSAN reports
an error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Cc: Eric Biggers <ebiggers@kernel.org>
Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
Reported-by: syzbot+9767be679ef5016b6082@syzkaller.appspotmail.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221121112134.407362-1-glider@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 3c640bd7ecae..30e3b65798b5 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -79,7 +79,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		int res;
 
 		res = aops->write_begin(NULL, mapping, pos, n, &page, &fsdata);

