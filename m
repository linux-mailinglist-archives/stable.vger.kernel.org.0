Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F61C8422
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 10:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgEGICG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 04:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgEGICG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 04:02:06 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 789012083B;
        Thu,  7 May 2020 08:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588838525;
        bh=5KW/p1GbhRBZezjeN6Jxtl3o/jDLJ8jnDdhbn7WS9zI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUI0uGI4UpXv2rTaeWxVIAmqMXoCfCwc+fCMmUclotlv9JZ167jjDT8HxOo4WNyGT
         WaZijTF07p1quUYHyyg8X5af/6RawBkPjtrC5l97K0yz7hZW0CZMn6ChGBhKpHVyrR
         r80zLDH/MSgNwOLAUJahxyoPU5u6SKiElgcwXrgo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] f2fs: don't leak filename in f2fs_try_convert_inline_dir()
Date:   Thu,  7 May 2020 00:59:02 -0700
Message-Id: <20200507075905.953777-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507075905.953777-1-ebiggers@kernel.org>
References: <20200507075905.953777-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

We need to call fscrypt_free_filename() to free the memory allocated by
fscrypt_setup_filename().

Fixes: b06af2aff28b ("f2fs: convert inline_dir early before starting rename")
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/inline.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 4167e540815185..59a4b7ff11e17a 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -559,12 +559,12 @@ int f2fs_try_convert_inline_dir(struct inode *dir, struct dentry *dentry)
 	ipage = f2fs_get_node_page(sbi, dir->i_ino);
 	if (IS_ERR(ipage)) {
 		err = PTR_ERR(ipage);
-		goto out;
+		goto out_fname;
 	}
 
 	if (f2fs_has_enough_room(dir, ipage, &fname)) {
 		f2fs_put_page(ipage, 1);
-		goto out;
+		goto out_fname;
 	}
 
 	inline_dentry = inline_data_addr(dir, ipage);
@@ -572,6 +572,8 @@ int f2fs_try_convert_inline_dir(struct inode *dir, struct dentry *dentry)
 	err = do_convert_inline_dir(dir, ipage, inline_dentry);
 	if (!err)
 		f2fs_put_page(ipage, 1);
+out_fname:
+	fscrypt_free_filename(&fname);
 out:
 	f2fs_unlock_op(sbi);
 	return err;
-- 
2.26.2

