Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1462E148281
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391707AbgAXL2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391703AbgAXL2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:28:41 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091C6206D4;
        Fri, 24 Jan 2020 11:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865320;
        bh=zmOC4M/Wl5ibF14B6bnHfbXoKU5KEmJxJ6MwADDoRQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QckKBe3YBoLfYLEezR8QwPNnAnK1+arV68j8B48NZY8JrDixclQOvwbhZ25GXvHoe
         uSQp4YUs8Fl4p2stUM0yh743sCW3Tc/3iOeiGWkTneH/uFy1AmoEtVfv85gF66fzS4
         1q+JXvIYztL94WP0ifkB60U1mLfcz1i8O2KVdRAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 501/639] ext4: set error return correctly when ext4_htree_store_dirent fails
Date:   Fri, 24 Jan 2020 10:31:11 +0100
Message-Id: <20200124093151.547582834@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 56f6e1782d5f7..4572cb0579518 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1419,7 +1419,7 @@ int htree_inlinedir_to_tree(struct file *dir_file,
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



