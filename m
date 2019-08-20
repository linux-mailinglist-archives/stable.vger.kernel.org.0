Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5723A96188
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbfHTNkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730117AbfHTNkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:35 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40BC722DA7;
        Tue, 20 Aug 2019 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308434;
        bh=yFL7ImAVG37bqNXnvntkZhTZPNTbT1g7r5HC8Hs6xr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y45aG5zWjtJzlrSneK2kRWnAYlAvbgpK9Xnp3QUDhTiGxQvHzukhCrAeooLq9tG2f
         VKRr+iMWVlrUTM9q7MiiNAndRi+bgk3mBeIytppPYr+8o8oXrh3z99VuOwDeOuSbz5
         5KGNFT0LkMllFTNpTYMFom/NwSUJhjPkiGyIo4xY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 06/44] afs: Fix off-by-one in afs_rename() expected data version calculation
Date:   Tue, 20 Aug 2019 09:39:50 -0400
Message-Id: <20190820134028.10829-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 37c0bbb3326674940e657118306ac52364314523 ]

When afs_rename() calculates the expected data version of the target
directory in a cross-directory rename, it doesn't increment it as it
should, so it always thinks that the target inode is unexpectedly modified
on the server.

Fixes: a58823ac4589 ("afs: Fix application of status and callback to be under same lock")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index da9563d62b327..9750ac70f8ffb 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1807,7 +1807,7 @@ static int afs_rename(struct inode *old_dir, struct dentry *old_dentry,
 				afs_end_vnode_operation(&fc);
 				goto error_rehash;
 			}
-			new_data_version = new_dvnode->status.data_version;
+			new_data_version = new_dvnode->status.data_version + 1;
 		} else {
 			new_data_version = orig_data_version;
 			new_scb = &scb[0];
-- 
2.20.1

