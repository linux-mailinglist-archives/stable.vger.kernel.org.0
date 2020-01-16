Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 093AE13E7E0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392636AbgAPR2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392630AbgAPR2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5422324701;
        Thu, 16 Jan 2020 17:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195722;
        bh=Upsc8dUypMFUiVc2zLPLgZ8S5/S1QGnMtIRlKiGu8eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzcYygeydtBBdaNvgnOaN7BcpUf0yJXxbyvYJO6ewccwrd+viV+somMa40q8AkQij
         shBshPQqU7s6RDLH/dmJeW6asGpegO+RinnmViqg+C2LC4r0hxCiSQW5AcE+RL6aP+
         zoS7RTYNX1kHQkn4Ovlmt8qIEGpAm72V0I1BazEE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 264/371] ext4: set error return correctly when ext4_htree_store_dirent fails
Date:   Thu, 16 Jan 2020 12:22:16 -0500
Message-Id: <20200116172403.18149-207-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
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
index 137c752ab985..6064bcb8572b 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1425,7 +1425,7 @@ int htree_inlinedir_to_tree(struct file *dir_file,
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

