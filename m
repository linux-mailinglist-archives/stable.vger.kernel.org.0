Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60CD09613B
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfHTNmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729956AbfHTNmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:19 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03C5422DD6;
        Tue, 20 Aug 2019 13:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308538;
        bh=QSnNxxMoohRzifLH0u+uYpnq0gUgkQHKqDHmE1Cvx4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gw6Y8jL731kSFpJycv4r3FgG6kdBAiv4N8nhSOqkE0JkT/kGSDlMLlN79+DwFTRrG
         AyUR0u4iR8FBDit7C0GJy3oIdJmTSPtrxMWfJAbX5AXu4oAadEEbC6+S+apG+auK2q
         zmXMXB6lV1iniqbw2dbw9dGHKryR2nWVcMYgNzbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 05/27] fs: afs: Fix a possible null-pointer dereference in afs_put_read()
Date:   Tue, 20 Aug 2019 09:41:51 -0400
Message-Id: <20190820134213.11279-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134213.11279-1-sashal@kernel.org>
References: <20190820134213.11279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit a6eed4ab5dd4bfb696c1a3f49742b8d1846a66a0 ]

In afs_read_dir(), there is an if statement on line 255 to check whether
req->pages is NULL:
	if (!req->pages)
		goto error;

If req->pages is NULL, afs_put_read() on line 337 is executed.
In afs_put_read(), req->pages[i] is used on line 195.
Thus, a possible null-pointer dereference may occur in this case.

To fix this possible bug, an if statement is added in afs_put_read() to
check req->pages.

This bug is found by a static analysis tool STCheck written by us.

Fixes: f3ddee8dc4e2 ("afs: Fix directory handling")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/file.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 7d4f26198573d..843d3b970b845 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -193,11 +193,13 @@ void afs_put_read(struct afs_read *req)
 	int i;
 
 	if (refcount_dec_and_test(&req->usage)) {
-		for (i = 0; i < req->nr_pages; i++)
-			if (req->pages[i])
-				put_page(req->pages[i]);
-		if (req->pages != req->array)
-			kfree(req->pages);
+		if (req->pages) {
+			for (i = 0; i < req->nr_pages; i++)
+				if (req->pages[i])
+					put_page(req->pages[i]);
+			if (req->pages != req->array)
+				kfree(req->pages);
+		}
 		kfree(req);
 	}
 }
-- 
2.20.1

