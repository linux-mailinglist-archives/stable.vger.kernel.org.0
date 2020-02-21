Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6F01673D6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbgBUIQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:16:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733143AbgBUIP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:15:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7B672467B;
        Fri, 21 Feb 2020 08:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272959;
        bh=xMt+/WZJ7JX4l2wXXyGzZfDgtpkGtXEWwqSlZvxiJAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQFJ7Zp9wVecj4XjvebzxDFdR9UjwrJEihfWrS1aF6S5BV1AtJhYgmYzUKNkjsBIz
         0k9TUvFQaMsdvMjq0w/PFAnc/jkujaLwuGi7Qe8a/YfXAE1drIX3yqREB88vBHcHpQ
         L2BB5Yw/6TsQFlcG6KCZ14NS8PUyyE8Sn8DObRz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <ice_yangxiao@163.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 340/344] fuse: dont overflow LLONG_MAX with end offset
Date:   Fri, 21 Feb 2020 08:42:19 +0100
Message-Id: <20200221072421.321737639@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 2f1398291bf35fe027914ae7a9610d8e601fbfde ]

Handle the special case of fuse_readpages() wanting to read the last page
of a hugest file possible and overflowing the end offset in the process.

This is basically to unbreak xfstests:generic/525 and prevent filesystems
from doing bad things with an overflowing offset.

Reported-by: Xiao Yang <ice_yangxiao@163.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 695369f46f92d..3dd37a998ea93 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -803,6 +803,10 @@ static int fuse_do_readpage(struct file *file, struct page *page)
 
 	attr_ver = fuse_get_attr_version(fc);
 
+	/* Don't overflow end offset */
+	if (pos + (desc.length - 1) == LLONG_MAX)
+		desc.length--;
+
 	fuse_read_args_fill(&ia, file, pos, desc.length, FUSE_READ);
 	res = fuse_simple_request(fc, &ia.ap.args);
 	if (res < 0)
@@ -888,6 +892,14 @@ static void fuse_send_readpages(struct fuse_io_args *ia, struct file *file)
 	ap->args.out_pages = true;
 	ap->args.page_zeroing = true;
 	ap->args.page_replace = true;
+
+	/* Don't overflow end offset */
+	if (pos + (count - 1) == LLONG_MAX) {
+		count--;
+		ap->descs[ap->num_pages - 1].length--;
+	}
+	WARN_ON((loff_t) (pos + count) < 0);
+
 	fuse_read_args_fill(ia, file, pos, count, FUSE_READ);
 	ia->read.attr_ver = fuse_get_attr_version(fc);
 	if (fc->async_read) {
-- 
2.20.1



