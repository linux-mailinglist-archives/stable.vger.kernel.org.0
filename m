Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897F63AEF64
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhFUQiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232391AbhFUQgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:36:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A6E561423;
        Mon, 21 Jun 2021 16:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292901;
        bh=p0DFBrSnvxVD4MSeELjn0doLekILJPIc78yHqPnq5xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qGgC1ysTFC8JrY1X9Nwsz0A0ehKIxn/bm5ZONBAsqZYIx4eo65AMT/WjWpMHXHgsm
         HrVKrQotrYRARKYmDib5mR4nbwkMc+RzP4Wemmvby/rEv/wXeIOigG8EGpCp0PySmL
         jLmhfjpaFw2jDbdoA/fv0hHhPwHf9cuCxPIXAuw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 009/178] afs: Fix an IS_ERR() vs NULL check
Date:   Mon, 21 Jun 2021 18:13:43 +0200
Message-Id: <20210621154921.805442499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b2975256dadb..179004b15566 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -203,8 +203,8 @@ static int __init afs_init(void)
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



