Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6F23C55A1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhGLILW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353831AbhGLIDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FFE361D0F;
        Mon, 12 Jul 2021 07:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076670;
        bh=KAKAfrjbgm4LtpuO+1fIvwfG6BFIeqJY3E0kkZXwdVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8H85t2h9gMqX00dOXBogyP6Vmu8zNcdPVOQlECjbOAYh2kttHmVx7JCQSc7D631d
         Uu7W9yBs4w15TVE7yhQGdqnmDN9aZtiAJ3P4RwAYzFoJdQKZr6sy/TTHd26aT7iDwe
         0U5Gd7yQKH0rkKCYQOPQIYbuPCHqoPmGlYXQdnR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chung-Chiang Cheng <cccheng@synology.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 741/800] configfs: fix memleak in configfs_release_bin_file
Date:   Mon, 12 Jul 2021 08:12:44 +0200
Message-Id: <20210712061045.602540729@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chung-Chiang Cheng <shepjeng@gmail.com>

[ Upstream commit 3c252b087de08d3cb32468b54a158bd7ad0ae2f7 ]

When reading binary attributes in progress, buffer->bin_buffer is setup in
configfs_read_bin_file() but never freed.

Fixes: 03607ace807b4 ("configfs: implement binary attributes")
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
[hch: move the vfree rather than duplicating it]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index e26060dae70a..b4b0fbabd62e 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -480,13 +480,13 @@ static int configfs_release_bin_file(struct inode *inode, struct file *file)
 					buffer->bin_buffer_size);
 		}
 		up_read(&frag->frag_sem);
-		/* vfree on NULL is safe */
-		vfree(buffer->bin_buffer);
-		buffer->bin_buffer = NULL;
-		buffer->bin_buffer_size = 0;
-		buffer->needs_read_fill = 1;
 	}
 
+	vfree(buffer->bin_buffer);
+	buffer->bin_buffer = NULL;
+	buffer->bin_buffer_size = 0;
+	buffer->needs_read_fill = 1;
+
 	configfs_release(inode, file);
 	return 0;
 }
-- 
2.30.2



