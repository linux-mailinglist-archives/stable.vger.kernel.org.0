Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D793CD9BA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244358AbhGSObZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244111AbhGSO3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A38C86138C;
        Mon, 19 Jul 2021 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707332;
        bh=+mr0Q12/HsfTHj3RrdpF01hzuwS04ZXkax8EBgThnG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aW7U+sgzt+zR0dqD83/QYkjwkIbNmPZWCS5c4DRMRVJFO1YNTYPNfld6vn/SrLbuL
         Zdq3nsO1O6tHUrwPx4QppIOyfy5rqF3CdMIzQuS5GKMUOtnYHZ3bQjnqVT8097aELs
         SyiKlccz5Qywrei462pkkBKdpM4UTFhSKL5z3Ui0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chung-Chiang Cheng <cccheng@synology.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 118/245] configfs: fix memleak in configfs_release_bin_file
Date:   Mon, 19 Jul 2021 16:51:00 +0200
Message-Id: <20210719144944.231184389@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
index 896e90dc9193..71f665eb0316 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -496,13 +496,13 @@ static int configfs_release_bin_file(struct inode *inode, struct file *file)
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



