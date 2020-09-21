Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC277272DD7
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgIUQnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729635AbgIUQno (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A0C9238E6;
        Mon, 21 Sep 2020 16:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706622;
        bh=42fnfEc8RLB+21VT9GxDtA29pgj9XX4YzmOC2aE1PTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujO9qxJDHxKjNvkik09zLNZg8DzRzBe2SwFQtmA5+X/nYo9MCMzuN9KDfe74e4QLa
         j6IO7hBCdmvEKr9pSHgKK3a5JMyuKvcll0r0T33eDHTLMTkWTZvhlvwGjXaxN9jL9+
         eOYxEPEl6+As7Lehv4bAis57/GO3aWcQwENeDEPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lennart Poettering <mzxreary@0pointer.de>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        Martijn Coenen <maco@android.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 007/118] loop: Set correct device size when using LOOP_CONFIGURE
Date:   Mon, 21 Sep 2020 18:26:59 +0200
Message-Id: <20200921162036.684858019@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martijn Coenen <maco@android.com>

commit 79e5dc59e2974a48764269fa9ff544ae8ffe3338 upstream.

The device size calculation was done before processing the loop
configuration, which meant that the we set the size on the underlying
block device incorrectly in case lo_offset/lo_sizelimit were set in the
configuration. Delay computing the size until we've setup the device
parameters correctly.

Fixes: 3448914e8cc5("loop: Add LOOP_CONFIGURE ioctl")
Reported-by: Lennart Poettering <mzxreary@0pointer.de>
Tested-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Signed-off-by: Martijn Coenen <maco@android.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1114,8 +1114,6 @@ static int loop_configure(struct loop_de
 	mapping = file->f_mapping;
 	inode = mapping->host;
 
-	size = get_loop_size(lo, file);
-
 	if ((config->info.lo_flags & ~LOOP_CONFIGURE_SETTABLE_FLAGS) != 0) {
 		error = -EINVAL;
 		goto out_unlock;
@@ -1165,6 +1163,8 @@ static int loop_configure(struct loop_de
 	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
+
+	size = get_loop_size(lo, file);
 	loop_set_size(lo, size);
 
 	set_blocksize(bdev, S_ISBLK(inode->i_mode) ?


