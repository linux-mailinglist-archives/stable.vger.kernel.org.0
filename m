Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C64205F13
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390953AbgFWU3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390950AbgFWU3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:29:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 026A82064B;
        Tue, 23 Jun 2020 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944148;
        bh=jmvRr5VE/7svdxfMGpur8aOFx0Tgio38UxgeRewNTzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETtiHWKJSs+D0nP6LgjWd2tfxTgDNw2guXjvatrNTKjQ/DjLPfsP6W/kI49LTQwLU
         hycUMHCdA2K1D/zx5GrDlitJCzNqqZkYTd5ZVz7XVnvh9tUoQC994O3CeIlNZ+TT1O
         1PCwnfXX/L/olN3iffy/bvjNqRjlgSywfEIPomWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/314] fuse: fix copy_file_range cache issues
Date:   Tue, 23 Jun 2020 21:55:59 +0200
Message-Id: <20200623195346.695517678@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
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
index 713d55a61890e..e730e3d8ad996 100644
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



