Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641B41FE707
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgFRCiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbgFRBN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DD621924;
        Thu, 18 Jun 2020 01:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442805;
        bh=v5N8waNpxM9QaHC/q6Kemel3FYBJtDE1nisF7iGPgM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlWjOVNZL6EeKIznO1W2kjm7X78GuMhCyAvBUnNipXU4gGOg2nWJy86wXhE0JkPmy
         wHzxOuBLNaXB1KMpZ6rmOgnlc7dkY/DxZx4/9OgtzauyknLNz2eLmQfwUa1ywqv1yr
         t1qSmeEC6Jvov53GjX4U0ZaxAoVid6OgDYrY0Dbo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 245/388] fuse: fix copy_file_range cache issues
Date:   Wed, 17 Jun 2020 21:05:42 -0400
Message-Id: <20200618010805.600873-245-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d400b71b98d5..d58324198b7a 100644
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

