Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA85E3C5077
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242811AbhGLHdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245683AbhGLH2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:28:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1D8A61245;
        Mon, 12 Jul 2021 07:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074633;
        bh=4Jr3p/RqNI6ZrnEMGC0lFoTUS4xbl6iXLvrxf8vMD2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuemxJ9iVKY19ML38B966LHSyOQetNk0eoJoUaWmae8JpWsoRwJBTq1y4qW2fY7c9
         k6CizD2zOHo7UWFIUabpXZ6BKzUSP2Nl7LFqRIRZhG1MyLPZGgNSFYYMdf1WyPWKhZ
         KXZXB7Oqj5PtHL5GgYI/AyWJoeoxEU1K2vdePrjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chung-Chiang Cheng <cccheng@synology.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 645/700] configfs: fix memleak in configfs_release_bin_file
Date:   Mon, 12 Jul 2021 08:12:08 +0200
Message-Id: <20210712061044.491288794@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index da8351d1e455..4d0825213116 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -482,13 +482,13 @@ static int configfs_release_bin_file(struct inode *inode, struct file *file)
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



