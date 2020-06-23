Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F18620653C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388952AbgFWUMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388456AbgFWUML (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:12:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 320DA206C3;
        Tue, 23 Jun 2020 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943130;
        bh=aLWt/8UxmqPo2Cj3Qzb8QZkcV8GFh12eDwf4SwQizXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lllSONkkCgY88yeoLI2TTZBEY5OO3cvKnrZMvHnn7I9owfdSrf2PXlUdtvzeax6Rn
         n+fKzH6Li6fmpCX7phfrjt5vR0Si+Uc3Wf6Bsvjcfre3XjNyPeOs4w/c6PlRppYV+m
         +pWxat7gfT/HAx9U+ivgA7LL7cZ+zz/pinjqz/co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 241/477] fuse: fix copy_file_range cache issues
Date:   Tue, 23 Jun 2020 21:53:58 +0200
Message-Id: <20200623195418.968225015@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 2c4656dfd994538176db30ce09c02cc0dfc361ae ]

a) Dirty cache needs to be written back not just in the writeback_cache
case, since the dirty pages may come from memory maps.

b) The fuse_writeback_range() helper takes an inclusive interval, so the
end position needs to be pos+len-1 instead of pos+len.

Fixes: 88bc7d5097a1 ("fuse: add support for copy_file_range()")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d400b71b98d55..d58324198b7a7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3280,13 +3280,11 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
 		return -EXDEV;
 
-	if (fc->writeback_cache) {
-		inode_lock(inode_in);
-		err = fuse_writeback_range(inode_in, pos_in, pos_in + len);
-		inode_unlock(inode_in);
-		if (err)
-			return err;
-	}
+	inode_lock(inode_in);
+	err = fuse_writeback_range(inode_in, pos_in, pos_in + len - 1);
+	inode_unlock(inode_in);
+	if (err)
+		return err;
 
 	inode_lock(inode_out);
 
@@ -3294,11 +3292,9 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (err)
 		goto out;
 
-	if (fc->writeback_cache) {
-		err = fuse_writeback_range(inode_out, pos_out, pos_out + len);
-		if (err)
-			goto out;
-	}
+	err = fuse_writeback_range(inode_out, pos_out, pos_out + len - 1);
+	if (err)
+		goto out;
 
 	if (is_unstable)
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi_out->state);
-- 
2.25.1



