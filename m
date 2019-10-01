Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE26C3AC3
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfJAQjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbfJAQjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:39:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4235521855;
        Tue,  1 Oct 2019 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569947978;
        bh=RZ+WOcSOBvQdQXPYEN1ohKIQpxofeW8IA32kr+1bOQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9Mu1ozBPB4Px8QjS+lSQFVGyKHWvCuEp1jIUlb/xrS97DCtMVt2GjxAJ3MuyvaEZ
         A88cSNuR3Cp/Qc9COHfIp4MdWzICZZIU6rj5Vqbv3VMXPyNrZnQTaWvFuDg80xoUjv
         QedyPrSzjwcOxkbfkUEfzN5XNlrttrw25WReAuUk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 11/71] fuse: fix request limit
Date:   Tue,  1 Oct 2019 12:38:21 -0400
Message-Id: <20191001163922.14735-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit f22f812d5ce75a18b56073a7a63862e6ea764070 ]

The size of struct fuse_req was reduced from 392B to 144B on a non-debug
config, thus the sanitize_global_limit() helper was setting a larger
default limit.  This doesn't really reflect reduction in the memory used by
requests, since the fields removed from fuse_req were added to fuse_args
derived structs; e.g. sizeof(struct fuse_writepages_args) is 248B, thus
resulting in slightly more memory being used for writepage requests
overalll (due to using 256B slabs).

Make the calculatation ignore the size of fuse_req and use the old 392B
value.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 4bb885b0f0322..04b10b3b8741b 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -822,9 +822,12 @@ static const struct super_operations fuse_super_operations = {
 
 static void sanitize_global_limit(unsigned *limit)
 {
+	/*
+	 * The default maximum number of async requests is calculated to consume
+	 * 1/2^13 of the total memory, assuming 392 bytes per request.
+	 */
 	if (*limit == 0)
-		*limit = ((totalram_pages() << PAGE_SHIFT) >> 13) /
-			 sizeof(struct fuse_req);
+		*limit = ((totalram_pages() << PAGE_SHIFT) >> 13) / 392;
 
 	if (*limit >= 1 << 16)
 		*limit = (1 << 16) - 1;
-- 
2.20.1

