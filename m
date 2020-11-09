Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866FC2ABBFD
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbgKINGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:06:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730267AbgKINGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:06:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1766206B2;
        Mon,  9 Nov 2020 13:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927204;
        bh=ty+LZl1GuBJXF9yOCsQgd9ui0krDLdNuoQ0ysKss+yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTbZrU/ZHpts1HOMIqVDqlYwVD9JOzDdMK3L/z+EeHqHwIjURRDY8PC+X6SHzEsEV
         Z42ObAT/ysAdGmVj9c0ow0O0nT68ss55XgM3UBF42NilVPSQ1A9s7yPIRE60hnj2JC
         TXc+oEbTWnBQEXrw8MXuc+1/DuZ6eDn32HAvdPI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Bo <bo.liu@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 09/48] Blktrace: bail out early if block debugfs is not configured
Date:   Mon,  9 Nov 2020 13:55:18 +0100
Message-Id: <20201109125017.198494084@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Bo <bo.liu@linux.alibaba.com>

commit e1a413245a564683697a3d02ec197b72cf009b89 upstream.

Since @blk_debugfs_root couldn't be configured dynamically, we can
save a few memory allocation if it's not there.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Cherry-picked for 4.14 to ease backporting a later fix]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/blktrace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -498,6 +498,9 @@ static int do_blk_trace_setup(struct req
 	if (!buts->buf_size || !buts->buf_nr)
 		return -EINVAL;
 
+	if (!blk_debugfs_root)
+		return -ENOENT;
+
 	strncpy(buts->name, name, BLKTRACE_BDEV_SIZE);
 	buts->name[BLKTRACE_BDEV_SIZE - 1] = '\0';
 
@@ -532,9 +535,6 @@ static int do_blk_trace_setup(struct req
 
 	ret = -ENOENT;
 
-	if (!blk_debugfs_root)
-		goto err;
-
 	dir = debugfs_lookup(buts->name, blk_debugfs_root);
 	if (!dir)
 		bt->dir = dir = debugfs_create_dir(buts->name, blk_debugfs_root);


