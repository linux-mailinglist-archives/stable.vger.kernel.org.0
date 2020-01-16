Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FC013EAB4
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406321AbgAPRpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406125AbgAPRpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0A0924765;
        Thu, 16 Jan 2020 17:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196737;
        bh=terYlf6LZ4zVfnn7QrhYUSK0XOj0A4n4+/9JO6jJDuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKK7SfuCJ/wI+AbwvdSt+hhWD0dUKhcTctEnnNpdUONQ2S6JEyoNeAzWXyCN9Va6I
         nfy7iP2sNKfxNO4+Daxd6sDMIMDta1TLKHBLpRL0S+8BKqGVo1Q7VHtlX38+ZX+N8R
         PBlH+b/iZTl8rt1KOs/wPgUEhvmemuYsumPXBRgo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 119/174] ext4: set error return correctly when ext4_htree_store_dirent fails
Date:   Thu, 16 Jan 2020 12:41:56 -0500
Message-Id: <20200116174251.24326-119-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 7a14826ede1d714f0bb56de8167c0e519041eeda ]

Currently when the call to ext4_htree_store_dirent fails the error return
variable 'ret' is is not being set to the error code and variable count is
instead, hence the error code is not being returned.  Fix this by assigning
ret to the error return code.

Addresses-Coverity: ("Unused value")
Fixes: 8af0f0822797 ("ext4: fix readdir error in the case of inline_data+dir_index")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 0dcd33f62637..00f9433eea23 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1418,7 +1418,7 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 		err = ext4_htree_store_dirent(dir_file, hinfo->hash,
 					      hinfo->minor_hash, de, &tmp_str);
 		if (err) {
-			count = err;
+			ret = err;
 			goto out;
 		}
 		count++;
-- 
2.20.1

