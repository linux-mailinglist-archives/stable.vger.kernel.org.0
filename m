Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF633B6247
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhF1Onu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234286AbhF1Olk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:41:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE94B61CD7;
        Mon, 28 Jun 2021 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890808;
        bh=mIphc923MT/SJC4o6GY1cJZr2BKPwWjDg4vObfGIzbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6Dq7A6CYUXOQtaPv7TXiYdVu15bsoBrOYcfglba1Ou8nsAaAVdvOzB8sufJsmUbd
         d5VMwL4NUEm6i1EzT4Sx+aqQnam39nvq/Rxu84a2Pjs3Z6b8k4Up1gWDNhhH7VDRoj
         FZ8yDStfxcHjeu71V1Csi9D7VFSuzD9Sk/P331u+gwEg1EXit3fZ0NIjVcOvMQH8TK
         I56Vw6KG/WUL43coTRkJELUJ+zZaA/px7ce1l2nylDL3ti+Xfmhk5KenOEVB6oDbw4
         Vl+Q+HmNa3je/1xQGS1pJ/jsL2gTC98dFb5Ufukg2umn8EHrEI2copjYOPvuGtCf3C
         HB7YFLn65XPxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/109] afs: Fix an IS_ERR() vs NULL check
Date:   Mon, 28 Jun 2021 10:31:40 -0400
Message-Id: <20210628143305.32978-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a33d62662d275cee22888fa7760fe09d5b9cd1f9 ]

The proc_symlink() function returns NULL on error, it doesn't return
error pointers.

Fixes: 5b86d4ff5dce ("afs: Implement network namespacing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/YLjMRKX40pTrJvgf@mwanda/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/main.c b/fs/afs/main.c
index 8ecb127be63f..2eecb2c0a3c0 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -200,8 +200,8 @@ static int __init afs_init(void)
 		goto error_fs;
 
 	afs_proc_symlink = proc_symlink("fs/afs", NULL, "../self/net/afs");
-	if (IS_ERR(afs_proc_symlink)) {
-		ret = PTR_ERR(afs_proc_symlink);
+	if (!afs_proc_symlink) {
+		ret = -ENOMEM;
 		goto error_proc;
 	}
 
-- 
2.30.2

